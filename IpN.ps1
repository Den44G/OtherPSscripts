Start-Process C:\Bat\exp.bat -Wait mongoexport.exe
Get-Content C:\Ip\sci.csv -ReadCount 10 |%{$_.substring(67)}|%{$_.trimend('" }')}|Get-Unique| %{$_ -replace "ull"}|Out-File C:\Ip\scl.txt
$set = @{}
Get-Content C:\Ip\scl.txt | %{
    if (!$set.Contains($_)) {
        $set.Add($_, $null)
        $_
    }
} |Sort-Object| Set-Content C:\Ip\scpi.txt
$DomSession = New-Object -ComObject Lotus.NotesSession
$DomSession.Initialize("mo2964db")
$maildb = $DomSession.GetDatabase("srvDomino/UNEXBANK/UA","mail\mongodb.nsf")
$D = get-date
$dif = Compare-Object -ReferenceObject $(Get-Content C:\Ip\scip.txt|%{$_  -replace '"'}| %{$_ -replace ' '}) -DifferenceObject $(Get-Content C:\Ip\scpi.txt) -IncludeEqual
foreach ($difference in $dif)
{
 if ($difference.SideIndicator -eq "==")
      { Add-Content $.$difference -Path C:\Ip\scres.txt }
	  }
	 $Path = Get-Item C:\Ip\scres.txt
	 $ip= Get-Content C:\Ip\scres.txt | %{[string]$_[16..31]}|%{$_.trimend("iS ")}
Start-Sleep -Seconds 10	 
	if ($Path.exists -eq $true )
	{
	   $memodoc = $maildb.createdocument()
$memodoc.AppendItemValue("Form", "Memo")
$memodoc.appenditemvalue("SendTo", "tsygak@unexbank.ua")
$memodoc.appenditemvalue("CopyTo", "dponomarenko@unexbank.ua")
$memodoc.appenditemvalue("Recipients", "tsygak@unexbank.ua")
$memodoc.appenditemvalue("From", "MongoDb@unexbank.ua")
$memodoc.appenditemvalue("Principal", "Mongodb@unexbank.ua")
$memodoc.appenditemvalue("Subject", "Внимание!")
$memodoc.appenditemvalue("Body", "При проверке IP-адресов на $D,есть совпадения,адрес --  $ip")
$memodoc.save($True, $False) 
$memodoc.Send($False)
     }
else
	 {
     $memodoc = $maildb.createdocument()
$memodoc.AppendItemValue("Form", "Memo")
$memodoc.appenditemvalue("SendTo", "tsygak@unexbank.ua")
$memodoc.appenditemvalue("CopyTo", "dponomarenko@unexbank.ua")
$memodoc.appenditemvalue("Recipients","tsygak@unexbank.ua")
$memodoc.appenditemvalue("From", "MongoDb@unexbank.ua")
$memodoc.appenditemvalue("Principal", "Mongodb@unexbank.ua")
$memodoc.appenditemvalue("Subject", "Проверка")
$memodoc.appenditemvalue("Body", " Во время проверки IP-адресов на $D совпадений со списком не обнаружено.")
$memodoc.save($True, $False)
$memodoc.Send($False)
     }
Remove-Item -Path C:\Ip\* -Include sc* -Force	