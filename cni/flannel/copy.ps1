$ErrorActionPreference = "Stop"

function checkAndCopy($srcBinPath, $dstBinPath) {
    if (Test-Path $dstBinPath) {
        $dstBinHasher = Get-FileHash -Path $dstBinPath
        $srcBinHasher = Get-FileHash -Path $srcBinPath
        if ($dstBinHasher.Hash -ne $srcBinHasher.Hash) {
            $null = Copy-Item -Force -Path $srcBinPath -Destination $dstBinPath
        }
    } else {
        $null = Copy-Item -Force -Path $srcBinPath -Destination $dstBinPath
    }
}

if (-not (Test-Path "C:\cni")) {
    throw "Cannot find `"C:\cni`" to load the Flannel CNI binaries."
}

$dstBinDir = "C:\cni\bin"
$null = New-Item -Type Directory -Path $dstBinDir -ErrorAction Ignore

try {
    $srcBinDir = "$env:ProgramFiles\flannel\bin"
    $mode = $env:MODE

    checkAndCopy "$srcBinDir\flanneld.exe" "$dstBinDir\flanneld.exe"
    checkAndCopy "$srcBinDir\flannel.exe" "$dstBinDir\flannel.exe"
    checkAndCopy "$srcBinDir\host-local.exe" "$dstBinDir\host-local.exe"
    checkAndCopy "$srcBinDir\$mode.exe" "$dstBinDir\$mode.exe"
} catch {
    try {
        $null = New-Item -Type File -Path "$dstBinDir\need_clean.tip" -ErrorAction Ignore
    } catch {}

    throw $_
}
