## https://docs.docker.com/install/windows/docker-ee/

param (
    [parameter(Mandatory = $false)] [string]$Version = "17.06"
)

Write-Host 'Install NuGet package provider ...'
Install-PackageProvider -Name NuGet -Force -Verbose

Write-Host 'Install DockerMsftProvider module ...'
Install-Module -Name DockerMsftProvider -Repository PSGallery –Force –Verbose

Write-Host 'Update DockerMsftProvider module ...'
Update-Module DockerMsftProvider -Verbose

Write-Host ('Install Dokcer {0} package ...' -f $Version)
Install-Package -Name Docker -ProviderName DockerMsftProvider -RequiredVersion $Version -Update -Force -Verbose

if ((Install-WindowsFeature Containers).RestartNeeded) {
	Write-Host 'Restart computer after 10 seconds ...'

	Start-Sleep -Seconds 10

	Restart-Computer
}