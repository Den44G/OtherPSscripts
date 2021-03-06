$comp= Get-Content C:\temp\comp.txt
foreach ($c in $comp){
Get-WMIObject Win32_LogicalDisk -ComputerName $c |Where{$_.DeviceID -ne 'A:'-and $_.ProviderName -eq $null}|
select @{Name="На компьютере ";Expression={$_."SystemName"}},@{Name="На диске ";Expression={$_."DeviceID"}},
@{Name="Свободно ГБ ";Expression={[decimal] ('{0:N0}' -f ($_."FreeSpace"/1GB))}},@{Name="Размер диска ГБ ";Expression={[decimal] ('{0:N0}' -f ($_."Size"/1GB))}},@{Name="Свободно % ";Expression={'{0:P0}' -f ($_."FreeSpace"/$_."Size")}}|ConvertTo-Html -Title "FreeSpace" | Out-File C:\Temp\FreeSpace.htm -Append
}

#Get-WMIObject Win32_LogicalDisk -ComputerName $c |Where{$_.DeviceID -ne 'A:'}|
#select @{Name="На компьютере ";Expression={$_."SystemName"}},@{Name="На диске ";Expression={$_."DeviceID"}},
#@{Name="Свободно MB ";Expression={$_."FreeSpace"/1024}},@{Name="Размер диска ";Expression={$_."Size"/1024}}|ConvertTo-Html -Title "FreeSpace" | Out-File C:\Temp\FreeSpace.htm -Append
#}

#Get-WMIObject Win32_LogicalDisk -ComputerName $c |Where-Object { $_.DeviceID -eq 'C:'}|Select @{Name="На диске С:\ компьютера ";Expression={$_."SystemName"}},
#@{Name="Свободно байт ";Expression={$_."FreeSpace"}}|ConvertTo-Html -Title "FreeSpace" | Out-File C:\Temp\FreeSpace.htm -Append
#}
Write-EventLog -LogName "PsScripts" -Source "FreeSpace" -Message "Файл FreeSpace.htm сформовано" -EventId 6

