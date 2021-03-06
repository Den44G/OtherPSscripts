$DomSession = New-Object -ComObject Lotus.NotesSession
$DomSession.Initialize("mo2964db")
$maildb = $DomSession.GetDatabase("srvDomino/UNEXBANK/UA","mail\mongodb.nsf")
$memodoc = $maildb.createdocument()
$memodoc.AppendItemValue("Form", "Memo")
$memodoc.appenditemvalue("SendTo", "vkhomenko@unexbank.ua")
$memodoc.appenditemvalue("CopyTo", "dponomarenko@unexbank.ua")
$memodoc.appenditemvalue("Recipients", "vkhomenko@unexbank.ua")
$memodoc.appenditemvalue("From", "MongoDb@unexbank.ua")
$memodoc.appenditemvalue("Principal", "Mongodb@unexbank.ua")
$memodoc.appendItemvalue("Subject", "Перелік клієнтів, до відключення")
      $body =$memodoc.createRichTextItem("Body")
      $body.appendText("Результати виконаної перевірки.")
	  $body.AddNewLine(2)
	  $body.EmbedObject(1454,"","c:\tmp\Clients.xlsx","Attachment")
$memodoc.save($True, $False)
$memodoc.Send($False)
Start-Sleep -Seconds 60
Remove-Item -Path C:\tmp\* -Include cl*,d* -Force