$file1="C:\Ip\scip.txt"
$file2="\\int.unexbank.ua\unex\home\tsygak\IP\IP.txt"
$file3="C:\OKPO\okpo.txt"
$file4="\\int.unexbank.ua\unex\home\tsygak\IP\okpo.txt"
$file5="\\int.unexbank.ua\unex\home\tsygak\IP\IP.txt"
$file6="\\int.unexbank.ua\unex\home\tsygak\IP\okpo.txt"
$ip= Get-content "\\int.unexbank.ua\unex\home\tsygak\IP\IP.txt"
$okpo= Get-content "\\int.unexbank.ua\unex\home\tsygak\IP\okpo.txt"
$ip1= Get-content "\\int.unexbank.ua\unex\home\tsygak\IP\IP.txt"
$okpo1= Get-content "\\int.unexbank.ua\unex\home\tsygak\IP\okpo.txt"
if ($ip -gt 0)
{sc -Value $ip -Path $file1 
Clear-Content $file2 -Force
Write-EventLog -LogName "PsScripts" -Source "CopyIp" -Message "Содержимое файла IP скопировано" -EventId 1
}
if ($okpo -gt 0)
{sc -Value $okpo -Path $file3 
Clear-Content $file4 -Force
Write-EventLog -LogName "PsScripts" -Source "CopyIp" -Message "Содержимое файла OKPO скопировано" -EventId 2
}
if ($ip1 -gt 0)
{sc -Value $ip1 -Path $file1 
Clear-Content $file5 -Force
Write-EventLog -LogName "PsScripts" -Source "CopyIp" -Message "Содержимое файла IP скопировано" -EventId 1
}
if ($okpo1 -gt 0)
{sc -Value $okpo1 -Path $file3 
Clear-Content $file6 -Force
Write-EventLog -LogName "PsScripts" -Source "CopyIp" -Message "Содержимое файла OKPO скопировано" -EventId 2
}