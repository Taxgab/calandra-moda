# Descarga las fotografías de prueba (licencia CC0 de StockSnap) y las recorta
# a la proporción exacta de cada slot del sitio.
#
# Uso: npm run test-images
#
# Material de PRUEBA: no corresponde a productos de Calandra Moda. Se reemplaza
# por fotografías autorizadas del cliente conservando el mismo nombre de archivo.

$ProgressPreference = 'SilentlyContinue'
Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$outDir = Join-Path $root 'src\assets\images'
$tmpDir = Join-Path $env:TEMP 'calandra-test-images'
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null

# slot, id de StockSnap, ancho, alto, anclaje vertical del recorte (0 = arriba, 1 = abajo)
$slots = @(
  @('hero',                      'NRLASOVURK', 4, 5,  0.42),
  @('category-novias',           '0TGREM1T78', 3, 4,  0.5),
  @('category-fiesta',           '74IDEO5GDH', 3, 4,  0.42),
  @('category-celebraciones',    'VQIULCZOYZ', 3, 4,  0.45),
  @('experience',                '121CFQQ5ZM', 4, 5,  0.5),
  @('story',                     'LTQSRPX2A4', 4, 5,  0.5),
  @('gallery-novias-01',         'U4O6ICQKL1', 3, 4,  0.45),
  @('gallery-novias-02',         'X7QQCCGUTM', 4, 3,  0.5),
  @('gallery-novias-03',         'XGJM4CT1LT', 4, 5,  0.5),
  @('gallery-novias-04',         'ZBXM9AFY1J', 16, 11, 0.45),
  @('gallery-fiesta-01',         'AZOZVX9EEH', 4, 5,  0.38),
  @('gallery-fiesta-02',         'OO6YBBXJAB', 3, 4,  0.45),
  @('gallery-celebraciones-01',  'CRHFNXOZMG', 4, 5,  0.4),
  @('gallery-celebraciones-02',  'SKLXSX6JFN', 16, 10, 0.5)
)

$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$creditLines = @(
  '# Créditos de las imágenes de prueba',
  '',
  'Material provisorio para la maqueta. Licencia **CC0 / dominio público** (StockSnap.io,',
  'indexado por Openverse). No requiere atribución y no corresponde a productos de Calandra Moda.',
  '',
  '| Archivo | Origen | Licencia |',
  '| --- | --- | --- |'
)

foreach ($slot in $slots) {
  $name = $slot[0]
  $id = $slot[1]
  $aw = [int]$slot[2]
  $ah = [int]$slot[3]
  $anchor = [double]$slot[4]

  $src = Join-Path $tmpDir "$id.jpg"
  if (-not (Test-Path $src)) {
    try {
      Invoke-WebRequest -Uri "https://cdn.stocksnap.io/img-thumbs/960w/$id.jpg" -OutFile $src -UseBasicParsing -TimeoutSec 40
    } catch {
      Write-Host "ERROR descargando $id ($name): $($_.Exception.Message)"
      continue
    }
  }

  $img = [System.Drawing.Image]::FromFile($src)
  $ratio = $aw / $ah
  $srcRatio = $img.Width / $img.Height

  if ($srcRatio -gt $ratio) {
    $cropH = $img.Height
    $cropW = [int][Math]::Round($cropH * $ratio)
    $cropX = [int][Math]::Round(($img.Width - $cropW) / 2)
    $cropY = 0
  } else {
    $cropW = $img.Width
    $cropH = [int][Math]::Round($cropW / $ratio)
    $cropX = 0
    $maxY = $img.Height - $cropH
    $cropY = [int][Math]::Round($maxY * $anchor)
  }

  $bmp = New-Object System.Drawing.Bitmap($cropW, $cropH)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $srcRect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropW, $cropH)
  $dstRect = New-Object System.Drawing.Rectangle(0, 0, $cropW, $cropH)
  $g.DrawImage($img, $dstRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
  $g.Dispose()

  $dest = Join-Path $outDir "$name.jpg"
  $params = New-Object System.Drawing.Imaging.EncoderParameters(1)
  $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]90)
  $bmp.Save($dest, $codec, $params)
  $params.Dispose()
  $bmp.Dispose()
  $img.Dispose()

  Write-Host ("ok  {0}.jpg  {1}x{2}  ({3}/{4})" -f $name, $cropW, $cropH, $aw, $ah)
  $creditLines += "| ``$name.jpg`` | https://stocksnap.io/photo/$id | CC0 |"
}

$credits = Join-Path $outDir 'CREDITS.md'
[System.IO.File]::WriteAllLines($credits, $creditLines, (New-Object System.Text.UTF8Encoding($true)))
Write-Host "créditos: $credits"
