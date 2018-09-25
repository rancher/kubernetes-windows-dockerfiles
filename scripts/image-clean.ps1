Write-Host ('Remove all Docker containers ...')
docker rm -f $(docker ps -aq);

Write-Host ('Remove none Docker images ...')
docker rmi $(docker images -f "dangling=true" -q);