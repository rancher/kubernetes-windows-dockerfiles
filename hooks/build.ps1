param (
    [parameter(Mandatory = $false)] [switch]$ForceBuild = $false,
    [parameter(Mandatory = $false)] [switch]$PushAfterBuilt = $false,
    [parameter(Mandatory = $false)] [string]$PowerShellVersion = "nanoserver-1809",
    [parameter(Mandatory = $false)] [string]$PushImageToLibrary = "maiwj",
    [parameter(Mandatory = $false)] [string]$PushImageWithSuffix = "windows-1809"
)

$ErrorActionPreference = "Stop"

[System.Collections.ArrayList]$buildSuccQueue = @()
[System.Collections.ArrayList]$buildFailQueue = @()
[System.Collections.ArrayList]$pushWaitingQueue = @()

function push_conclude {
    if ($PushAfterBuilt) {
        foreach ($imageTag in $pushWaitingQueue) {
            Write-Host -ForegroundColor DarkCyan "PUSHING $imageTag to $PushImageToLibrary ..."

            $currentTag = $imageTag
            $pushTag = "$PushImageToLibrary/$imageTag"

            docker tag $currentTag $pushTag
            docker push $pushTag
            if ($?) {
                Write-Host "$imageTag is PUSHED"
            } else {
                Write-Host -ForegroundColor Red "$imageTag has something wrong for PUSHING"
            }
            docker rmi $pushTag
        }
    }
}

function build_result($ok, $imageTag) {
    if ($ok) {
        $null = $buildSuccQueue.Add("$imageTag")
        $null = $pushWaitingQueue.Add("$imageTag")
    } else {
        $null = $buildFailQueue.Add("$imageTag")
    }
}

function build_conclude {
    foreach ($r in $buildSuccQueue) {
        Write-Host -ForegroundColor DarkCyan "$r is BUILT"
    }

    foreach ($r in $buildFailQueue) {
        Write-Host -ForegroundColor Red "$r has something wrong for BUILDING"
    }
}

function get_release_id() {
    $currentVersion = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\')
    return $currentVersion.ReleaseId
}

$release_id = get_release_id

$psImg = "mcr.microsoft.com/powershell:$PowerShellVersion"
if (-not (docker images $psImg -q)) {
    docker pull $psImg
    if (-not $?) {
        throw "Can't find $psImg from Docker Hub !!!"
    }
}

$image_suffix = $PushImageWithSuffix
if (-not $image_suffix) {
    $image_suffix = $PowerShellVersion
}

$versionMap = cat VERSION | ConvertFrom-Json

foreach ($v in $versionMap.psobject.properties) {
    $with_version = $False
    $image_name = $v.Name
    if ($image_name -eq "hyperkube") {
        $with_version = $True
    }

    $versions = $v.Value
    $dockerfile = "Dockerfile.$image_name"
    foreach ($image_version in $versions) {
        $image_tag = "$($image_name):$($image_version)-$($image_suffix)"
        if ($ForceBuild -or (-not (docker images $image_tag -q))) {
            Write-Host -ForegroundColor DarkCyan "`nBUILDING $image_tag ..."

            if ($release_id -eq "1809") {
                if ($with_version) {
                    docker build `
                        --build-arg PS_VERSION=$PowerShellVersion `
                        --build-arg VERSION=$image_version `
                        -t $image_tag `
                        -f $dockerfile .
                } else {
                    docker build `
                        --build-arg PS_VERSION=$PowerShellVersion `
                        -t $image_tag `
                        -f $dockerfile .
                }
            } else {
                if ($with_version) {
                    docker build `
                        --isolation hyperv `
                        --build-arg PS_VERSION=$PowerShellVersion `
                        --build-arg VERSION=$image_version `
                        -t $image_tag `
                        -f $dockerfile .
                } else {
                    docker build `
                        --isolation hyperv `
                        --build-arg PS_VERSION=$PowerShellVersion `
                        -t $image_tag `
                        -f $dockerfile .
                }
            }
            build_result $? $image_tag
        } else {
            build_result $True $image_tag
        }
    }
}

build_conclude

push_conclude
