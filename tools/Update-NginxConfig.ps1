$nginxConf = "$env:NGINX_HOME\conf"
$backupDir = "$nginxConf-backup"
$vhostOutput = "$(Get-Location)\output"
$vhostDest = "$nginxConf\vhosts"

Write-Host "Backing up current NGINX configuration..."
Copy-Item -Path $nginxConf -Destination $backupDir -Recurse -Force

Write-Host "Generating NGINX configuration:"
Copy-Item -Path $vhostOutput\* -Destination $vhostDest -Recurse -Force

Write-Host "Reloading NGINX configuration..."
nginx -s reload
$exitCode = $LASTEXITCODE
Write-Host "NGINX reload exit code: $exitCode"

if ($exitCode -eq 0) {
    # Success: remove backup
    Remove-Item -Path $backupDir -Recurse -Force
    Write-Host "NGINX configuration updated successfully."
} else {
    # Failure: restore backup and remove backup
    Write-Host "NGINX configuration update failed. Restoring backup..."
    Remove-Item -Path $nginxConf -Recurse -Force
    Copy-Item -Path $backupDir -Destination $nginxConf -Recurse -Force
    Remove-Item -Path $backupDir -Recurse -Force
    Write-Host "Backup restored. Please check the NGINX logs for details."
}

exit $exitCode