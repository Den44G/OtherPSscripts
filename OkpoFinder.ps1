$ErrorActionPreference = "SilentlyContinue"
$A=Get-Content C:\OKPO\okpo.txt| %{$_  -replace '"'}| %{$_ -replace ' '}
$dt = Get-SqlData 'srv-db' ibank2ua 'SELECT * FROM ibank2ua.ua_payment'
$DomSession = New-Object -ComObject Lotus.NotesSession
$DomSession.Initialize("mo2964db")
$maildb = $DomSession.GetDatabase("srvDomino/UNEXBANK/UA","mail\mongodb.nsf")
foreach($i in $A)
{
$dt |where {$_.rcpt_okpo -eq "$i"}| Select @{Name="Дата операции";Expression={$_."date_doc"}},
@{Name="Сумма";Expression={$_."Amount"}},
@{Name="Название клиента ЮнексБанка";Expression={$_."cln_name"}},
@{Name="ЕДРПОУ";Expression={$_."cln_okpo"}},
@{Name="Счет";Expression={$_."cln_account"}},
@{Name="Название получателя";Expression={$_."rcpt_name"}},
@{Name="Счет получателя";Expression={$_."rcpt_account"}},
@{Name="ЕДРПОУ получателя";Expression={$_."rcpt_okpo"}},
@{Name="Банк получателя";Expression={$_."rcpt_bank_name"}},
@{Name="МФО банка получателя";Expression={$_."rcpt_bank_mfo"}}|ConvertTo-Html -Title "Информация по работе клиентов " | Out-File C:\OKPO\okpo.htm -Append
}
$d=Get-Item C:\OKPO\okpo.htm 
if ($d.length -gt 1100) 
{
$memodoc = $maildb.createdocument()
$memodoc.AppendItemValue("Form", "Memo")
$memodoc.appenditemvalue("SendTo", "tsygak@unexbank.ua")
$memodoc.appenditemvalue("CopyTo", "dponomarenko@unexbank.ua")
#$memodoc.appenditemvalue("BlindCopyTo", "poveda@unexbank.ua")
$memodoc.appenditemvalue("Recipients", "tsygak@unexbank.ua")
$memodoc.appenditemvalue("From", "MongoDb@unexbank.ua")
$memodoc.appenditemvalue("Principal", "Mongodb@unexbank.ua")
$memodoc.appendItemvalue("Subject", "Проверка по ЕДРПОУ")
      $body =$memodoc.createRichTextItem("Body")
      $body.appendText("Результаы выполненной проверки.")
	  $body.AddNewLine(2)
	  $body.EmbedObject(1454,"","c:\OKPO\okpo.htm","Attachment")
$memodoc.save($True, $False)
$memodoc.Send($False)
}
else 
{$memodoc = $maildb.createdocument()
$memodoc.AppendItemValue("Form", "Memo")
$memodoc.appenditemvalue("SendTo","tsygak@unexbank.ua")
$memodoc.appenditemvalue("CopyTo", "dponomarenko@unexbank.ua")
$memodoc.appenditemvalue("BlindCopyTo", "tsygak@unexbank.ua")
$memodoc.appenditemvalue("Recipients","malenko@unexbank.ua")
$memodoc.appenditemvalue("From", "MongoDb@unexbank.ua")
$memodoc.appenditemvalue("Principal", "Mongodb@unexbank.ua")
$memodoc.appenditemvalue("Subject", "Проверка")
$memodoc.appenditemvalue("Body", " Во время проверки, операций в Клиент-Банке, связанных с указанными лицами не обнаружено.")
$memodoc.save($True, $False)
$memodoc.Send($False)
}
Remove-Item C:\OKPO\* -Include okpo.* -Force