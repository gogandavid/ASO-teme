
#Să se proiecteze o aplicație (powershell, cmd, MSVC/C++ preferabil) care să identifice toate serviciile sistem care rulează la modul curent pe mașină.
#În cadrul aplicației anterioare să se identifice dll-urile multiple.

$runningServices = Get-CimInstance -ClassName Win32_Service | Where-Object { $_.State -eq 'Running' }

$results = @()

foreach ($service in $runningServices) {
    $name = $service.Name
    $pathName = $service.PathName

    $dllPath = "N/A (Executabil direct / Nu are ServiceDll)"
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\$name\Parameters"

    if (Test-Path $regPath) {
        $serviceDll = Get-ItemProperty -Path $regPath -Name "ServiceDll" -ErrorAction SilentlyContinue
        
        if ($serviceDll -and $serviceDll.ServiceDll) {
            $dllPath = [System.Environment]::ExpandEnvironmentVariables($serviceDll.ServiceDll)
        }
    }

    $results += [PSCustomObject]@{
        NumeServiciu   = $name
        CaleExecutabil = $pathName
        CaleDLL        = $dllPath
    }
}

Clear-Host
Write-Host "servicii active si DLL-uri multiple identificate in Registry:" -ForegroundColor Cyan
$results | Format-Table NumeServiciu, CaleExecutabil, CaleDLL -AutoSize