# https://pshell.hatenadiary.org/entry/20140511/1399840831

function Get-ScriptCommand {
	<#
	.SYNOPSIS
	コールスタック上にあるスクリプトコマンドを取得する。
	.DESCRIPTION
	このスクリプトの1つ前の実行コマンドを出力する。
    $level を指定すると、その分さらに前に戻る。
	#>
param(
    [int]$level
    )

	$calledScripts = (Get-PSCallStack) | ? {
		#if($_.Location -eq "<ファイルなし>"){ return $false; }
        $true
	}
    $script = $calledScripts[$level +1]
    $script.InvocationInfo.Line
}
class Script {
    [string] $Path
    [string[]]$Command
    Script($frame) {
        $this.Path = $frame.Position.File
        $this.Command = $frame.Arguments
    }
    [String] ToString() {
        return "Path=" + $this.Path
    }
}