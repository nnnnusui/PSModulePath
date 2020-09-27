function Request-Elevate {
param(
    $callStackBackDepth = 0
    )
    # 管理者権限が無ければ要求
    If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {   
        # $arguments = "& '" + $myinvocation.mycommand.definition + "'"
        # 自身を再起動
        $command = Get-ScriptCommand($callStackBackDepth + 1)
        Start-Process powershell -Verb runAs -ArgumentList $command
        $true
    } else {
        $false
    }
}