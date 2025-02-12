Get-NetTCPConnection -State Listen | ForEach-Object {

    $procID = $_.OwningProcess
    
    $proc = Get-Process -Id $procID -ErrorAction SilentlyContinue
    
    $svc  = Get-WmiObject Win32_Service -Filter "ProcessId = $procID" -ErrorAction SilentlyContinue

    [PSCustomObject]@{
        LocalAddress = $_.LocalAddress
        LocalPort    = $_.LocalPort
        PID          = $procID
        ProcessName  = if ($proc) { $proc.ProcessName } else { "N/A" }
        ServiceName  = if ($svc)  { $svc.Name }         else { "N/A" }
    }
} | Sort-Object LocalPort
