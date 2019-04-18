param (
    [parameter(Mandatory = $false)] [string]$PushImageWithSuffix = "windows-1809",
    [parameter(Mandatory = $false)] [string]$PullImageFromLibrary = "maiwj",
    [parameter(Mandatory = $false)] [string]$TagImageToLibrary = "rancher",
    [parameter(Mandatory = $false)] [string]$VersionFileURL = "https://raw.githubusercontent.com/thxCode/kubernetes-windows-dockerfiles/master/VERSION"
)

$ErrorActionPreference = "Stop"

$image_suffix = $PushImageWithSuffix

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$versionMapJson = (Invoke-WebRequest -UseBasicParsing -Uri $VersionFileURL -ErrorAction Stop).Content
$versionMap = $versionMapJson | ConvertFrom-Json

foreach ($v in $versionMap.psobject.properties) {
    $image_name = $v.Name
    $versions = $v.Value
    $dockerfile = "Dockerfile.$image_name"
    foreach ($image_version in $versions) {
        $image_tag = "$($image_name):$($image_version)-$($image_suffix)"
        Write-Host -ForegroundColor DarkCyan "`nPULLING $image_tag ..."

        $complete_image_tag = "$PullImageFromLibrary/$image_tag"
        docker pull $complete_image_tag
        if ($?) {
            Write-Host -ForegroundColor Green "$complete_image_tag was PULLED"

            if ($PullImageFromLibrary -ne $TagImageToLibrary) {
                $tag_image_tag = "$TagImageToLibrary/$image_tag"
                Write-Host -ForegroundColor DarkCyan "`TAGING $complete_image_tag to $tag_image_tag ..."

                docker tag $complete_image_tag $tag_image_tag
                if ($?) {
                    Write-Host -ForegroundColor Green "$tag_image_tag was TAGED"
                } else {
                    Write-Host -ForegroundColor Red "$tag_image_tag could not be TAGED"
                }
            }
        } else {
            Write-Host -ForegroundColor Red "$complete_image_tag could not be PULLED"
        }
    }
}