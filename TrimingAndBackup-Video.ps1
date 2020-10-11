$outputRoot = Convert-Path "~backup"
$pwd = (Convert-Path .)

$path = $Args[0]
if ($path -eq $null) {
    $path = Read-Host "どの動画を"
}

$originalPathStr = (Convert-Path $path)
$original = Get-Item $originalPathStr
if (!$originalPathStr.Contains($pwd)) {
    Write-Error "ターゲット('$original')は '$pwd' より下の階層に存在しなければいけません"
    pause; throw
}
$relative = Resolve-Path -Relative $original
$relativeParent = Split-Path $relative -Parent
if ($relativeParent -eq ".") {
    Write-Error "ターゲット('$original')は '$pwd' より1層以上深いパスに存在しなければいけません"
    pause; throw
}
$baseName = $original.BaseName
$extension = $original.Extension
$outputParent = "$outputRoot\$relativeParent"
if (!(Test-Path $outputParent)) {
    New-Item $outputParent -ItemType Directory
}
$outputPath = "$outputParent\$baseName$extension"

echo "from: $original"
echo "to  : $outputPath"
$duration = Read-Host "いつから(hh:mm:ss)"

ffmpeg `
    -ss $duration `
    -i $original `
    -vcodec copy `
    -acodec copy `
    -map 0 `
    -map_metadata 0 `
    -map_metadata:s:v 0:s:v `
    -map_metadata:s:a 0:s:a `
    $outputPath

if ($?) {
    $parent = Split-Path $original -Parent
    $moveTo = "$parent\trimed\"
    if (!(Test-Path $moveTo)) {
        New-Item $moveTo -ItemType Directory
    }
    Move-Item $original "$parent\trimed\"
} else {
    pause; throw
}
