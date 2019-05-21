[CmdletBinding()]
param()

Trace-VstsEnteringInvocation $MyInvocation

try{
    # Get inputs.
    $containername = Get-VstsInput -Name 'containername' -Require
    $appfile = Get-VstsInput -Name 'appfile' -Default '*.app'
    $appfileexclude = Get-VstsInput -Name 'appfileexclude' -Default ''
    $pfxpassword = Get-VstsInput -Name 'pfxpassword' -Default ''
    $certfile = Get-VstsInput -Name 'certfile' -Require
    
    Write-Host "Importing module NVRAppDevOps"
    Import-Module NVRAppDevOps -DisableNameChecking

    $apps = Get-ChildItem $appfile -Recurse -Filter *.app -Exclude $appfileexclude 
    foreach ($app in $apps) {
        Write-Host "Signing $($app.FullName)"
        Sign-NAVContainerApp -containerName $containername -appFile $app.FullName -pfxFile $certfile -pfxPassword (ConvertTo-SecureString -String $pfxpassword -AsPlainText -Force)
    }

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}