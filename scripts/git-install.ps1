$GIT_VERSION="2.11.1"
$GIT_TAG="v${GIT_VERSION}.windows.1"
$GIT_DOWNLOAD_URL="https://github.com/git-for-windows/git/releases/download/${GIT_TAG}/MinGit-${GIT_VERSION}-64-bit.zip"
$GIT_DOWNLOAD_SHA256="668d16a799dd721ed126cc91bed49eb2c072ba1b25b50048280a4e2c5ed56e59"

# steps inspired by "chcolateyInstall.ps1" from "git.install" (https://chocolatey.org/packages/git.install)
Write-Host ('Downloading {0} ...' -f $GIT_DOWNLOAD_URL)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $GIT_DOWNLOAD_URL -OutFile 'git.zip'

Write-Host ('Verifying sha256 ({0}) ...' -f $GIT_DOWNLOAD_SHA256)
if ((Get-FileHash git.zip -Algorithm sha256).Hash -ne $GIT_DOWNLOAD_SHA256) {
    Write-Host 'FAILED!'
    exit 1
}

Write-Host 'Expanding ...'
Expand-Archive -Path git.zip -DestinationPath C:\git\.

Write-Host 'Removing ...'
Remove-Item git.zip -Force

Write-Host 'Updating PATH ...'
$env:PATH = 'C:\git\cmd;C:\git\mingw64\bin;C:\git\usr\bin;' + $env:PATH
[Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine)

Write-Host 'Verifying install ...'
Write-Host '  git --version'; git --version

Write-Host 'Complete.'