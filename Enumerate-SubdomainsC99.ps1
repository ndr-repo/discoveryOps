Write-Host " "
Write-Host "discoveryOps: Passive Scanner: c99.nl - API Wrapper" -ForegroundColor Red
Write-Host "`nDescription: Gathers known subdomains from c99.nl, creates clean IPv4 and subdomain lists for external use." -ForegroundColor Red
Write-Host " "
Write-Host "Created by Gabriel H. @weekndr_sec" -ForegroundColor Red
Write-Host "https://github.com/ndr-repo | http://weekndr.me"  -ForegroundColor Red
Write-Host "Licensed by GNU GPLv3" -ForegroundColor Red
Write-Host " "
$userKey = Read-Host "Enter the c99.nl API key" 
$secureKey = ConvertTo-SecureString $userKey -AsPlainText -Force
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey)
$apiKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
$targetDomain = Read-Host "Enter the target domain" 
$directoryPath = Read-Host "Enter the path to place the results folder"
$dateTime = Get-Date
$whoami = whoami 
New-Item -ItemType Directory $directoryPath\$targetDomain -Force -InformationAction Ignore
New-Item -ItemType File $directoryPath\$targetDomain\results_$targetDomain.log -Force -InformationAction Ignore
New-Item -ItemType File $directoryPath\$targetDomain\iplist_$targetDomain.log -Force -InformationAction Ignore
New-Item -ItemType File $directoryPath\$targetDomain\subdomain_$targetDomain.log -Force -InformationAction Ignore
Write-Host " "
Write-Host "Scan Results:" -ForegroundColor Cyan
Invoke-RestMethod -Method Get -Uri "https://api.c99.nl/subdomainfinder?key=$apiKey&domain=$targetDomain&server=US&json" | Select-Object -ExpandProperty subdomains | Sort-Object "ip" | Format-Table -Property "ip","subdomain","cloudflare" -Wrap -AutoSize | Out-String -Stream | Tee-Object "$directoryPath\$targetDomain\results_$targetDomain.log"
Write-Host " "
Write-Host "Unique IPv4 Addresses:"  -ForegroundColor Cyan
Write-Host " "
Invoke-RestMethod -Method Get -Uri "https://api.c99.nl/subdomainfinder?key=$apiKey&domain=$targetDomain&server=US&json" | Select-Object -ExpandProperty subdomains | Sort-Object "ip" -Unique | Format-Table -Property "ip" -Wrap -AutoSize -HideTableHeaders | Out-String -Stream | findstr.exe /R ^[0-9.].| Tee-Object "$directoryPath\$targetDomain\ipList_$targetDomain.log"
Write-Host " "
Write-Host "Unique Subdomains:"  -ForegroundColor Cyan
Write-Host " "
Invoke-RestMethod -Method Get -Uri "https://api.c99.nl/subdomainfinder?key=$apiKey&domain=$targetDomain&server=US&json" | Select-Object -ExpandProperty subdomains | Sort-Object "subdomain" -Unique | Format-Table -Property "subdomain" -Wrap -AutoSize -HideTableHeaders | Out-String -Stream | findstr.exe /R ^[a-zA-Z0-9.].| Tee-Object "$directoryPath\$targetDomain\subdomain_$targetDomain.log"
Write-Host " "
Write-Host "Scan completed!" -ForegroundColor Red
Write-Host "Scanned by $whoami at $dateTime" -ForegroundColor Red
Write-Host "Scan results stored at $directoryPath\$targetDomain"-ForegroundColor Red
Write-Host " "
Write-Host "Created by Gabriel H., @weekndr_sec" -ForegroundColor Red
Write-Host "Passive Scanner - Subdomain Enumeration - c99.nl " -ForegroundColor Red
Write-Host "https://github.com/ndr-repo | http://weekndr.me" -ForegroundColor Red
Write-Host " "
