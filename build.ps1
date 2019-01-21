function Initialize-MSBuild {
   [CmdletBinding()]
   param ()

   # Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

   $vsPath = (@((Get-VSSetupInstance | Select-VSSetupInstance -Version 15.0 -Require Microsoft.Component.MSBuild).InstallationPath,
         (Get-VSSetupInstance | Select-VSSetupInstance -Version 15.0 -Product Microsoft.VisualStudio.Product.BuildTools).InstallationPath) -ne $null)[0]

   if (!$vsPath) {
      Write-Information 'VS 2017 not found.'
      return
   }

   if ([System.IntPtr]::Size -eq 8) {
      $msbuildPath = Join-Path $vsPath 'MSBuild\15.0\Bin\amd64'
   }
   else {
      $msbuildPath = Join-Path $vsPath 'MSBuild\15.0\Bin'
   }

   $env:Path = "$msbuildPath;$env:Path"
}

cls

Remove-Module [p]sake

# find psake's path
$psakeModule = (Get-ChildItem (".\packages\psake*\tools\psake\psake.psm1")).FullName | Sort-Object $_ | select -Last 1

Install-Module VSSetup -Scope CurrentUser 
Initialize-MSBuild
Import-Module $psakeModule

Invoke-psake -buildFile .\Build\psakefile.ps1 `
             -taskList Test `
             -framework 4.6.1 `
             -properties @{ 
                "buildConfiguration" = "Release"
                "buildPlatform" = "Any CPU" } `
             -parameters @{ "solutionFile" = "..\psake.sln" }

Write-Host "Build exit code: " $LASTEXITCODE

# Propagating the exit code so that builds actually fail when there isa problem
exit $LASTEXITCODE
