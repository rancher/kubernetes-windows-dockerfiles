$ErrorActionPreference = "Stop"

$servers = ""
$env:CP_HOSTS -split "," | % {
    $servers += ("server $_" + ":6443;`t")
}
if (-not $servers) {
    $servers = "server blank.cp_hosts.got:6443;"
}

$nginxConf = Get-Content -Path "$env:ProgramFiles\runtime\nginx.tmpl" -Raw
$nginxConf -replace "SERVERS","$servers" | Out-File -Encoding ascii -Force -FilePath "$env:ProgramFiles\nginx\conf\nginx.conf"

pushd "$env:ProgramFiles\nginx"
.\nginx.exe -g "daemon off;"
