# Genera imagenes provisorias de marca para Calandra Moda.
# Reemplazar por fotografias reales autorizadas: mismo nombre de archivo en src/assets/images.
# Uso: npm run placeholders

Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$outDir = Join-Path $root 'src\assets\images\placeholders'
$publicDir = Join-Path $root 'public\images'
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
New-Item -ItemType Directory -Force -Path $publicDir | Out-Null

function New-Color([string]$hex, [int]$alpha = 255) {
  $h = $hex.TrimStart('#')
  return [System.Drawing.Color]::FromArgb(
    $alpha,
    [Convert]::ToInt32($h.Substring(0, 2), 16),
    [Convert]::ToInt32($h.Substring(2, 2), 16),
    [Convert]::ToInt32($h.Substring(4, 2), 16)
  )
}

function Draw-Tracked($g, [string]$text, $font, $color, [single]$x, [single]$y, [single]$tracking) {
  $brush = New-Object System.Drawing.SolidBrush($color)
  $cursor = $x
  foreach ($ch in $text.ToCharArray()) {
    $g.DrawString([string]$ch, $font, $brush, $cursor, $y)
    $w = $g.MeasureString([string]$ch, $font)
    $cursor += $w.Width - $w.Width * 0.28 + $tracking
  }
  $brush.Dispose()
}

function New-Placeholder {
  param(
    [string]$Name,
    [int]$Width,
    [int]$Height,
    [string]$From,
    [string]$To,
    [string]$Label,
    [switch]$Dark
  )

  $bmp = New-Object System.Drawing.Bitmap($Width, $Height)
  $bmp.SetResolution(96, 96)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

  $rect = New-Object System.Drawing.Rectangle(0, 0, $Width, $Height)
  $base = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, (New-Color $From), (New-Color $To), [single]62)
  $g.FillRectangle($base, $rect)
  $base.Dispose()

  # Luz suave
  $light = New-Object System.Drawing.SolidBrush((New-Color '#FFF9EE' 26))
  $glowW = $Width * 1.5
  $glowH = $Height * 1.1
  $g.FillEllipse($light, ($Width / 2 - $glowW / 2), (-$glowH * 0.45), $glowW, $glowH)
  $light.Dispose()
  $light2 = New-Object System.Drawing.SolidBrush((New-Color '#FFFDF7' 30))
  $g.FillEllipse($light2, ($Width * 0.1), ($Height * 0.32), ($Width * 0.8), ($Height * 0.55))
  $light2.Dispose()

  # Arco editorial
  $archW = [single]($Width * 0.56)
  $archH = [single]($Height * 0.74)
  $archX = [single](($Width - $archW) / 2)
  $archTop = [single]($Height * 0.13)
  $r = [single]($archW / 2)
  $archBottom = [single]($archTop + $archH)

  $arch = New-Object System.Drawing.Drawing2D.GraphicsPath
  $arch.AddArc($archX, $archTop, $archW, $archW, 180, 180)
  $arch.AddLine(($archX + $archW), ($archTop + $r), ($archX + $archW), $archBottom)
  $arch.AddLine(($archX + $archW), $archBottom, $archX, $archBottom)
  $arch.AddLine($archX, $archBottom, $archX, ($archTop + $r))
  $arch.CloseFigure()

  $veil = New-Object System.Drawing.SolidBrush((New-Color '#FFFCF4' 34))
  $g.FillPath($veil, $arch)
  $veil.Dispose()

  $lineColor = if ($Dark) { New-Color '#F6EEDF' 120 } else { New-Color '#8C7043' 130 }
  $pen = New-Object System.Drawing.Pen($lineColor, 1.6)
  $g.DrawPath($pen, $arch)
  $pen.Dispose()

  # Monograma
  $monoColor = if ($Dark) { New-Color '#F8F2E6' 92 } else { New-Color '#5C4728' 74 }
  $monoFont = New-Object System.Drawing.Font('Georgia', [single]($Width * 0.085), [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Pixel)
  $monoBrush = New-Object System.Drawing.SolidBrush($monoColor)
  $mono = 'CM'
  $monoSize = $g.MeasureString($mono, $monoFont)
  $g.DrawString($mono, $monoFont, $monoBrush, [single](($Width - $monoSize.Width) / 2), [single]($archTop + $archW * 0.42))
  $monoBrush.Dispose()
  $monoFont.Dispose()

  # Pie editorial
  $ink = if ($Dark) { New-Color '#F7F1E4' 230 } else { New-Color '#2A241C' 220 }
  $inkSoft = if ($Dark) { New-Color '#F7F1E4' 150 } else { New-Color '#3E3629' 150 }
  $ruleColor = if ($Dark) { New-Color '#F7F1E4' 90 } else { New-Color '#2A241C' 80 }

  $rulePen = New-Object System.Drawing.Pen($ruleColor, 1)
  $g.DrawLine($rulePen, [single]($Width * 0.09), [single]($Height * 0.9), [single]($Width * 0.19), [single]($Height * 0.9))
  $rulePen.Dispose()

  $brandFont = New-Object System.Drawing.Font('Georgia', [single]($Width * 0.017), [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
  Draw-Tracked $g 'CALANDRA MODA' $brandFont $ink ([single]($Width * 0.09)) ([single]($Height * 0.915)) ([single]($Width * 0.0035))
  $brandFont.Dispose()

  $labelFont = New-Object System.Drawing.Font('Segoe UI', [single]($Width * 0.012), [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
  Draw-Tracked $g ('FOTOGRAFIA PENDIENTE · ' + $Label.ToUpper()) $labelFont $inkSoft ([single]($Width * 0.09)) ([single]($Height * 0.945)) ([single]($Width * 0.0022))
  $labelFont.Dispose()

  # Marca de agua superior
  $markFont = New-Object System.Drawing.Font('Segoe UI', [single]($Width * 0.011), [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
  $markBrush = New-Object System.Drawing.SolidBrush($inkSoft)
  $g.DrawString('IMAGEN PROVISORIA', $markFont, $markBrush, [single]($Width * 0.74), [single]($Height * 0.055))
  $markBrush.Dispose()
  $markFont.Dispose()

  $path = Join-Path $outDir ($Name + '.jpg')
  $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
  $params = New-Object System.Drawing.Imaging.EncoderParameters(1)
  $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]86)
  $bmp.Save($path, $codec, $params)
  $params.Dispose()

  $g.Dispose()
  $arch.Dispose()
  $bmp.Dispose()
  Write-Host ("ok  " + $Name + ".jpg  " + $Width + "x" + $Height)
}

New-Placeholder -Name 'hero'                    -Width 1400 -Height 1750 -From '#F4EAD9' -To '#C6B295' -Label 'Hero'
New-Placeholder -Name 'category-novias'         -Width 900  -Height 1200 -From '#F6EFE3' -To '#D6C8B2' -Label 'Novias'
New-Placeholder -Name 'category-fiesta'         -Width 900  -Height 1200 -From '#EBDCC6' -To '#BCA688' -Label 'Fiesta'
New-Placeholder -Name 'category-celebraciones'  -Width 900  -Height 1200 -From '#E0D3C1' -To '#A99783' -Label 'Celebraciones'
New-Placeholder -Name 'experience'              -Width 1200 -Height 1500 -From '#F2E8D7' -To '#CDBEA6' -Label 'Asesoramiento'
New-Placeholder -Name 'story'                   -Width 1100 -Height 1375 -From '#E7DCC9' -To '#B3A188' -Label 'Boutique'
New-Placeholder -Name 'gallery-novias-01'       -Width 1000 -Height 1400 -From '#F5EDDF' -To '#D2C3AC' -Label 'Novias 01'
New-Placeholder -Name 'gallery-novias-02'       -Width 1000 -Height 1000 -From '#EFE4D2' -To '#C8B79C' -Label 'Novias 02'
New-Placeholder -Name 'gallery-novias-03'       -Width 800  -Height 1000 -From '#F8F2E7' -To '#DCCFB9' -Label 'Novias 03'
New-Placeholder -Name 'gallery-novias-04'       -Width 1000 -Height 750  -From '#E9DECC' -To '#BCAB92' -Label 'Novias 04'
New-Placeholder -Name 'gallery-fiesta-01'       -Width 1000 -Height 1250 -From '#E8D8C0' -To '#B49E80' -Label 'Fiesta 01'
New-Placeholder -Name 'gallery-fiesta-02'       -Width 900  -Height 1200 -From '#F1E7D6' -To '#CBBBA2' -Label 'Fiesta 02'
New-Placeholder -Name 'gallery-celebraciones-01'-Width 1000 -Height 1250 -From '#DCCFBE' -To '#A2907A' -Label 'Celebraciones 01' -Dark
New-Placeholder -Name 'gallery-celebraciones-02'-Width 1000 -Height 1000 -From '#E6DAC8' -To '#B8A78F' -Label 'Celebraciones 02'

# Portada Open Graph (1200x630)
$ogW = 1200; $ogH = 630
$og = New-Object System.Drawing.Bitmap($ogW, $ogH)
$og.SetResolution(96, 96)
$ogG = [System.Drawing.Graphics]::FromImage($og)
$ogG.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$ogG.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$ogRect = New-Object System.Drawing.Rectangle(0, 0, $ogW, $ogH)
$ogBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($ogRect, (New-Color '#F7F1E6'), (New-Color '#D9C9B0'), [single]35)
$ogG.FillRectangle($ogBrush, $ogRect)
$ogBrush.Dispose()

$ogPen = New-Object System.Drawing.Pen((New-Color '#8C7043' 110), 1.2)
$ogG.DrawLine($ogPen, 80, 120, 80, 510)
$ogG.DrawLine($ogPen, 1120, 120, 1120, 510)
$ogPen.Dispose()

$ogTitle = New-Object System.Drawing.Font('Georgia', 62, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$ogInk = New-Object System.Drawing.SolidBrush((New-Color '#211C16'))
$ogG.DrawString('Calandra Moda', $ogTitle, $ogInk, 120, 180)
$ogInk.Dispose()
$ogTitle.Dispose()

$ogSub = New-Object System.Drawing.Font('Segoe UI', 22, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$ogSubBrush = New-Object System.Drawing.SolidBrush((New-Color '#42392C' 235))
$ogG.DrawString('Tu vestido. Tu momento. Nuestra experiencia.', $ogSub, $ogSubBrush, 122, 300)
$ogG.DrawString('Boutique de vestidos · Lanús, Buenos Aires', $ogSub, $ogSubBrush, 122, 350)
$ogSubBrush.Dispose()
$ogSub.Dispose()

$ogBrand = New-Object System.Drawing.Font('Georgia', 15, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
Draw-Tracked $ogG 'NOVIAS · FIESTA · CASAMIENTO' $ogBrand (New-Color '#5C4728' 200) ([single]122) ([single]480) ([single]2.2)
$ogBrand.Dispose()

$ogG.Dispose()
$og.Save((Join-Path $publicDir 'og-cover.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$og.Dispose()
Write-Host 'ok  og-cover.png 1200x630'
