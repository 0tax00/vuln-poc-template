Get-NetTCPConnection -State Listen | ForEach-Object {
    # Use um nome de variável diferente de $PID, que já é reservada
    $procID = $_.OwningProcess

    # Obter o processo (se existir)
    $proc = Get-Process -Id $procID -ErrorAction SilentlyContinue

    # Obter o serviço associado a esse processo (se for um serviço)
    $svc  = Get-WmiObject Win32_Service -Filter "ProcessId = $procID" -ErrorAction SilentlyContinue

    # Criar um objeto customizado com as informações desejadas
    [PSCustomObject]@{
        LocalAddress = $_.LocalAddress
        LocalPort    = $_.LocalPort
        PID          = $procID
        ProcessName  = if ($proc) { $proc.ProcessName } else { "N/A" }
        ServiceName  = if ($svc)  { $svc.Name }         else { "N/A" }
    }
} | Sort-Object LocalPort
