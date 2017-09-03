$DomSession = New-Object -ComObject Lotus.NotesSession
$DomSession.Initialize("mo2964db")
$maildb = $DomSession.GetDatabase("srvDomino/UNEXBANK/UA","mail\mongodb.nsf")
$memodoc = $maildb.createdocument()
$memodoc.AppendItemValue("Form", "Memo")
$memodoc.appenditemvalue("SendTo", "dmatviychuk@unexbank.ua")
$memodoc.appenditemvalue("CopyTo", "dponomarenko@unexbank.ua")
$memodoc.appenditemvalue("Recipients", "dmatviychuk@unexbank.ua")
$memodoc.appenditemvalue("From", "MongoDb@unexbank.ua")
$memodoc.appenditemvalue("Principal", "Mongodb@unexbank.ua")
$memodoc.appendItemvalue("Subject", "Свободное дисковое пространство")
      $body =$memodoc.createRichTextItem("Body")
      $body.appendText("Результаты выполненной проверки.")
	  $body.AddNewLine(2)
	  $body.EmbedObject(1454,"","c:\temp\FreeSpace.htm","Attachment")
$memodoc.save($True, $False)
$memodoc.Send($False)
Start-Sleep -Seconds 60
Remove-Item -Path C:\temp\* -Include free* -Force