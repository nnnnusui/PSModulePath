function Add-Environment {
param(
    [string]$key,
    [string]$value,
    [string]$scope = "User"
    )
    $values = [System.Environment]::GetEnvironmentVariable($key, $scope)
    if([String]::IsNullOrEmpty($values)) {
        $values += $value
    } else {
        $values += ";"+ $value
    }
    [System.Environment]::SetEnvironmentVariable($key, $values, $scope)
}

$envDir = Convert-Path "..\..\winapp\~env"
$csvPath = "$envDir\env.csv"
echo "%Env%: $envDir"
echo "csv: $csvPath"
pause

# 環境変数を登録
Add-Environment -key "Env" -value $envDir
Import-Csv $csvPath -Encoding UTF8 | % {
    $key = $_.key
    $value = $_.value
    echo "adding...| $key : $value"
    Add-Environment -key $key -value $value
}