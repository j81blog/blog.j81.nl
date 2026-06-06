<#
.SYNOPSIS
    Converts WordPress XML export to Hugo Markdown content.
    - Posts with category "HowTo" go to content/howto/
    - All other posts go to content/posts/
    - Pages go to content/pages/
    - Each post gets aliases[] pointing to the original WordPress URL
    - HTML content is converted to Markdown via pandoc
#>

param(
    [string]$XmlPath   = "$PSScriptRoot\..\working_data\johnbillekens.WordPress.2026-05-19.xml",
    [string]$OutputDir = "$PSScriptRoot\.."
)

$ErrorActionPreference = 'Stop'

function ConvertTo-SafeSlug([string]$slug) {
    # Ensure slug is filesystem-safe
    $slug = $slug -replace '[^\w\-]', '-'
    $slug = $slug -replace '-{2,}', '-'
    return $slug.Trim('-').ToLower()
}

function ConvertTo-Markdown([string]$html) {
    if ([string]::IsNullOrWhiteSpace($html)) { return "" }

    # ── WordPress shortcode cleanup (before pandoc) ───────────────────────────
    # Remove poll shortcodes — poll data lives in the WP database, not in the XML
    $html = [regex]::Replace($html, '\[poll[^\]]*\]', '')
    # Replace table shortcodes — table data is not in the XML export
    $html = [regex]::Replace($html, '\[table[^\]]*\]',
        '<p><em>(Table removed during migration — content was stored in a WordPress plugin database.)</em></p>')

    # Pre-process: convert Crayon/tadv <pre class="lang:XX"> to standard <pre><code class="language-XX">
    # so pandoc generates proper fenced code blocks with language identifiers
    $langMap = @{
        'ps' = 'powershell'; 'ps1' = 'powershell'; 'powershell' = 'powershell'
        'bat' = 'batch'; 'cmd' = 'batch'
        'vbs' = 'vbscript'; 'vb' = 'vbscript'
        'xml' = 'xml'; 'html' = 'html'; 'css' = 'css'
        'js' = 'javascript'; 'sql' = 'sql'
        'py' = 'python'; 'python' = 'python'
        'sh' = 'bash'; 'bash' = 'bash'
        'cs' = 'csharp'; 'cpp' = 'cpp'; 'c' = 'c'
    }

    $html = [regex]::Replace($html,
        '<pre[^>]*\bclass="([^"]*)"[^>]*>([\s\S]*?)</pre>',
        {
            param($m)
            $class = $m.Groups[1].Value
            $code  = $m.Groups[2].Value
            # Extract lang:XX from class string
            $langMatch = [regex]::Match($class, '\blang:(\w+)')
            if ($langMatch.Success) {
                $raw  = $langMatch.Groups[1].Value.ToLower()
                $lang = if ($langMap.ContainsKey($raw)) { $langMap[$raw] } else { $raw }
            } else {
                $lang = 'text'
            }
            "<pre><code class=`"language-$lang`">$code</code></pre>"
        }
    )

    # Also handle bare <pre> without class (treat as shell/text)
    $html = $html -replace '<pre>(?!<code)', '<pre><code class="language-text">'
    $html = $html -replace '</pre>', '</code></pre>'
    # avoid double-wrapping from the above
    $html = $html -replace '<code class="language-text"></code></pre>', '</code></pre>'
    $html = $html -replace '<pre><code class="language-text"><code class="language-', '<pre><code class="language-'

    # Write to temp file — PowerShell piping strips newlines which breaks pandoc output
    $tmp = [System.IO.Path]::GetTempFileName() + ".html"
    [System.IO.File]::WriteAllText($tmp, $html, [System.Text.Encoding]::UTF8)
    # Join array output with newlines (PowerShell captures stdout as string[] — joining with space loses structure)
    $rawLines = pandoc --from=html --to=commonmark+raw_html --wrap=none $tmp 2>$null
    $md = $rawLines -join "`n"
    Remove-Item $tmp -Force -ErrorAction SilentlyContinue

    # Fix Crayon Syntax Highlighter code blocks:
    # Pattern: ``` lang:XX code ``` (single-line) → ```language\ncode\n```
    # Also handles toolbar:N prefix (language-agnostic block)
    $langMap = @{
        'ps'         = 'powershell'
        'ps1'        = 'powershell'
        'powershell' = 'powershell'
        'bat'        = 'batch'
        'cmd'        = 'batch'
        'vbs'        = 'vbscript'
        'vb'         = 'vbscript'
        'xml'        = 'xml'
        'html'       = 'html'
        'css'        = 'css'
        'js'         = 'javascript'
        'sql'        = 'sql'
        'py'         = 'python'
        'python'     = 'python'
        'sh'         = 'bash'
        'bash'       = 'bash'
        'cs'         = 'csharp'
    }

    # Fix single-line fenced blocks: ```lang:XX code``` or ```toolbar:N code```
    $md = [regex]::Replace($md, '(?m)^```\s*lang:(\w+)\s+(.+?)```\s*$', {
        param($m)
        $lang = $m.Groups[1].Value.ToLower()
        $code = $m.Groups[2].Value.Trim()
        $fence = if ($langMap.ContainsKey($lang)) { $langMap[$lang] } else { $lang }
        "``````$fence`n$code`n``````"
    })

    $md = [regex]::Replace($md, '(?m)^```\s*toolbar:\d+\s+(.+?)```\s*$', {
        param($m)
        $code = $m.Groups[1].Value.Trim()
        "``````shell`n$code`n``````"
    })

    # Fix multi-line fenced blocks with lang/toolbar on opening line
    $md = [regex]::Replace($md, '(?m)^```\s*lang:(\w+)\s*$', {
        param($m)
        $lang = $m.Groups[1].Value.ToLower()
        $fence = if ($langMap.ContainsKey($lang)) { $langMap[$lang] } else { $lang }
        "``````$fence"
    })

    $md = $md -replace '(?m)^```\s*toolbar:\d+\s*$', '```shell'

    # Fix inline code with lang prefix that ended up in backtick spans
    $md = [regex]::Replace($md, '`lang:(\w+)\s+([^`]+)`', {
        param($m)
        $lang = $m.Groups[1].Value.ToLower()
        $code = $m.Groups[2].Value.Trim()
        $fence = if ($langMap.ContainsKey($lang)) { $langMap[$lang] } else { $lang }
        "``````$fence`n$code`n``````"
    })

    return $md
}

function Get-XmlText([object]$node) {
    if ($null -eq $node) { return "" }
    if ($node -is [string]) { return $node }
    if ($node -is [System.Xml.XmlElement]) {
        # Try CDATA first, then InnerText
        $cdata = $node.'#cdata-section'
        if ($cdata) { return [string]$cdata }
        return $node.InnerText
    }
    return [string]$node
}

function Escape-YamlString([string]$s) {
    # Wrap in double quotes, escape internal quotes
    $s = $s -replace '"', '\"'
    return "`"$s`""
}

function Build-FrontMatter {
    param(
        [string]$title,
        [string]$date,       # ISO 8601
        [string]$lastmod,
        [string[]]$categories,
        [string[]]$tags,
        [string[]]$aliases,
        [string[]]$series,
        [string]$image = "",
        [bool]$draft = $false
    )
    $lines = @("---")
    $lines += "title: $(Escape-YamlString $title)"
    $lines += "date: $date"
    if ($lastmod -and $lastmod -ne $date) {
        $lines += "lastmod: $lastmod"
    }
    if ($draft) { $lines += "draft: true" }
    if ($image) {
        $lines += "featureimage: `"$image`""
    }
    if ($categories.Count -gt 0) {
        $lines += "categories:"
        foreach ($c in $categories) { $lines += "  - $(Escape-YamlString $c)" }
    }
    if ($tags.Count -gt 0) {
        $lines += "tags:"
        foreach ($t in $tags) { $lines += "  - $(Escape-YamlString $t)" }
    }
    if ($series.Count -gt 0) {
        $lines += "series:"
        foreach ($s in $series) { $lines += "  - $(Escape-YamlString $s)" }
    }
    if ($aliases.Count -gt 0) {
        $lines += "aliases:"
        foreach ($a in $aliases) { $lines += "  - `"$a`"" }
    }
    $lines += "---"
    return $lines -join "`n"
}

# ── Load XML ──────────────────────────────────────────────────────────────────
Write-Host "Loading XML..." -ForegroundColor Cyan
[xml]$xml = Get-Content $XmlPath -Encoding UTF8

$ns = @{
    wp      = "http://wordpress.org/export/1.2/"
    content = "http://purl.org/rss/1.0/modules/content/"
    dc      = "http://purl.org/dc/elements/1.1/"
    excerpt = "http://wordpress.org/export/1.2/excerpt/"
}

$items = $xml.rss.channel.item
Write-Host "Found $($items.Count) total items" -ForegroundColor Cyan

# Build attachment ID → root-relative URL map for featured image lookup
$attachMap = @{}
foreach ($item in $items) {
    $type = ($item | Select-Xml -XPath "wp:post_type" -Namespace $ns).Node.'#cdata-section'
    if ($type -ne 'attachment') { continue }
    $id  = ($item | Select-Xml -XPath "wp:post_id" -Namespace $ns).Node.InnerText
    $url = ($item | Select-Xml -XPath "wp:attachment_url" -Namespace $ns).Node.InnerText
    if ($id -and $url) {
        # Convert to root-relative (same rewrite as content images)
        $url = $url -replace 'https?://blog\.j81\.nl', ''
        $url = $url -replace '^//blog\.j81\.nl', ''
        $attachMap[$id] = $url
    }
}
Write-Host "Mapped $($attachMap.Count) media attachments" -ForegroundColor Cyan

$stats = @{ posts = 0; howto = 0; pages = 0; skipped = 0 }

foreach ($item in $items) {
    $postType = $item.'post_type'.'#cdata-section'
    if (-not $postType) {
        $postType = ($item | Select-Xml -XPath "wp:post_type" -Namespace $ns).Node.'#cdata-section'
    }
    $status = ($item | Select-Xml -XPath "wp:status" -Namespace $ns).Node.'#cdata-section'

    # Only process published posts and pages
    if ($status -ne 'publish') {
        $stats.skipped++
        continue
    }
    if ($postType -notin @('post', 'page')) {
        $stats.skipped++
        continue
    }

    # ── Extract fields ────────────────────────────────────────────────────────
    $title   = Get-XmlText $item.title
    $slug    = ($item | Select-Xml -XPath "wp:post_name" -Namespace $ns).Node.'#cdata-section'
    $pubDate = ($item | Select-Xml -XPath "wp:post_date_gmt" -Namespace $ns).Node.'#cdata-section'
    $modDate = ($item | Select-Xml -XPath "wp:post_modified_gmt" -Namespace $ns).Node.'#cdata-section'
    $link    = $item.link
    $htmlContent = ($item | Select-Xml -XPath "content:encoded" -Namespace $ns).Node.'#cdata-section'

    # Parse date to ISO 8601
    try {
        $dateObj = [datetime]::Parse($pubDate)
        $isoDate = $dateObj.ToString("yyyy-MM-ddTHH:mm:ssZ")
        $datePrefix = $dateObj.ToString("yyyy-MM-dd")
        $originalPath = "/" + $dateObj.ToString("yyyy/MM/dd") + "/$slug/"
    } catch {
        $isoDate = "2020-01-01T00:00:00Z"
        $datePrefix = "2020-01-01"
        $originalPath = "/$slug/"
    }

    try {
        $modObj = [datetime]::Parse($modDate)
        $isoMod = $modObj.ToString("yyyy-MM-ddTHH:mm:ssZ")
    } catch {
        $isoMod = $isoDate
    }

    # Categories and tags
    $categories = @()
    $tags       = @()
    foreach ($cat in $item.category) {
        $domain = $cat.domain
        $val    = $cat.'#cdata-section'
        if (-not $val) { continue }
        if ($domain -eq 'category') { $categories += $val }
        elseif ($domain -eq 'post_tag') { $tags += $val }
    }

    # Aliases: original WordPress permalink
    $aliases = @()
    if ($link -match 'blog\.j81\.nl(.+)') {
        $aliases += $Matches[1]
    } elseif ($originalPath -ne "/$slug/") {
        $aliases += $originalPath
    }

    # ── Convert HTML → Markdown ───────────────────────────────────────────────
    # Rewrite absolute WP image URLs to root-relative before pandoc so images
    # work on localhost:1313, GitHub Pages, and mijn.host alike.
    if ($htmlContent) {
        $htmlContent = $htmlContent -replace 'https?://blog\.j81\.nl/wp-content/', '/wp-content/'
        $htmlContent = $htmlContent -replace '//blog\.j81\.nl/wp-content/', '/wp-content/'
    }
    $mdContent = ConvertTo-Markdown $htmlContent

    # ── Determine output path ─────────────────────────────────────────────────
    $safeSlug = ConvertTo-SafeSlug $slug
    if (-not $safeSlug) { $safeSlug = "post-$($item.'post_id'.'#cdata-section')" }

    $isHowTo = ('HowTo' -in $categories) -or ($slug -match '\bhowto\b')
    if ($isHowTo) {
        $outDir   = Join-Path $OutputDir "content\howto"
        $section  = 'howto'
        $categories = $categories | Where-Object { $_ -ne 'HowTo' }
        $fileName = "$datePrefix-$safeSlug.md"
    } elseif ($postType -eq 'page' -and $slug -in @('about-me','about')) {
        # About page → content/about/index.md (leaf bundle = single-page template, served at /about/)
        $outDir   = Join-Path $OutputDir "content\about"
        $section  = 'pages'
        $fileName = "index.md"
    } elseif ($postType -eq 'page' -and $slug -eq 'contact') {
        # Contact page is maintained manually at content/contact/index.md — skip import
        $stats.skipped++
        continue
    } elseif ($postType -eq 'page') {
        $outDir   = Join-Path $OutputDir "content\pages"
        $section  = 'pages'
        $fileName = "$datePrefix-$safeSlug.md"
    } else {
        $outDir   = Join-Path $OutputDir "content\posts"
        $section  = 'posts'
        $fileName = "$datePrefix-$safeSlug.md"
    }

    $outPath  = Join-Path $outDir $fileName

    # Featured image: look up _thumbnail_id postmeta → attachment URL
    $featuredImage = ""
    $thumbId = ($item.postmeta | Where-Object {
        $_.'meta_key'.'#cdata-section' -eq '_thumbnail_id'
    }).'meta_value'.'#cdata-section'
    if ($thumbId -and $attachMap.ContainsKey($thumbId)) {
        $featuredImage = $attachMap[$thumbId]
    }

    # ── Write file ────────────────────────────────────────────────────────────
    $fm = Build-FrontMatter `
        -title      $title `
        -date       $isoDate `
        -lastmod    $isoMod `
        -categories $categories `
        -tags       $tags `
        -aliases    $aliases `
        -series     @() `
        -image      $featuredImage

    $fileContent = "$fm`n`n$mdContent"
    Set-Content -Path $outPath -Value $fileContent -Encoding UTF8

    $stats.$section++
    Write-Host "  [$section] $fileName" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Write-Host "  Posts  : $($stats.posts)" -ForegroundColor White
Write-Host "  HowTo  : $($stats.howto)" -ForegroundColor White
Write-Host "  Pages  : $($stats.pages)" -ForegroundColor White
Write-Host "  Skipped: $($stats.skipped) (drafts, attachments, etc.)" -ForegroundColor DarkGray
