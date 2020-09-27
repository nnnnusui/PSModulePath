function Set-LocationToScriptPath {
param(
    [int]$level
    )

	$calledScripts = (Get-PSCallStack) | ? {
		#if($_.Location -eq "<�t�@�C���Ȃ�>"){ return $false; }
        $true
	}
    $script = $calledScripts[$level +1]
    $scriptPath = $script.Position.File
    $parentDir = Split-Path $scriptPath -Parent
    Set-Location $parentDir
    $parentDir
}