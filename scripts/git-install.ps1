## https://chocolatey.org/packages/git.install

param (
    [parameter(Mandatory = $false)] [string]$Version = "2.21.0",
    [parameter(Mandatory = $false)] [string]$SHA256 = "bd91db55bd95eaa80687df28877e2df8c8858a0266e9c67331cfddba2735f25c"
)

$GIT_DOWNLOAD_URL="https://github.com/git-for-windows/git/releases/download/v${Version}.windows.1/MinGit-${Version}-64-bit.zip"

Write-Host ('Downloading {0} ...' -f $GIT_DOWNLOAD_URL)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $GIT_DOWNLOAD_URL -OutFile 'git.zip'

Write-Host ('Verifying sha256 ({0}) ...' -f $SHA256)
if ((Get-FileHash git.zip -Algorithm sha256).Hash -ne $SHA256) {
    Write-Host 'FAILED!'
    exit 1
}

Write-Host 'Expanding ...'
Expand-Archive -Force -Path git.zip -DestinationPath C:\git\.

Write-Host 'Removing ...'
Remove-Item git.zip -Force

Write-Host 'Updating PATH ...'
$env:PATH = 'C:\git\cmd;C:\git\mingw64\bin;C:\git\usr\bin;' + $env:PATH
[Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine)

Write-Host 'Verifying install ...'
Write-Host '  git --version'; git --version

Write-Host 'Complete.'