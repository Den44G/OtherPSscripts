$date= Get-Date
$day = $date.dayofweek
switch($day)
{
Monday{$c=9}
Monday{$c1=14}
Tuesday{$c=8}
Tuesday {$c1=10}
Wednesday {$c=13}
Wednesday{$c1=15}
Thursday{$c=12}
Thursday{$c1=2}
Friday{$c=3}
Friday{$c1=5}
}
$DomSession = New-Object -ComObject Lotus.NotesSession
$DomSession.Initialize("mo2964db")
$maildb = $DomSession.GetDatabase("srvDomino/UNEXBANK/UA","mail\mongodb.nsf")
$path = Get-ChildItem X:\telebank\BLACKBOX\OD\val\* -Include VAL*
if ($Path.exists -eq $true )
	{
Get-Content X:\telebank\BLACKBOX\OD\val\val* -Encoding Oem | sc C:\Valuta\valuta.txt
$memodoc = $maildb.createdocument()
$memodoc.AppendItemValue("Form", "Memo")
$memodoc.appenditemvalue("SendTo", "unexcard@unexbank.ua")
$memodoc.appenditemvalue("CopyTo", "technologists@unexbank.ua")
$memodoc.appenditemvalue("BlindCopyTo", "dzis@unexbank.ua")
$memodoc.appenditemvalue("Recipients", "unexcard@unexbank.ua")
$memodoc.appenditemvalue("From", "MongoDb@unexbank.ua")
$memodoc.appenditemvalue("Principal", "Mongodb@unexbank.ua")
$memodoc.appendItemvalue("Subject", "Курсы валют $date")
$body =$memodoc.createRichTextItem("Body")
	  $color = $DomSession.CreateRichTextStyle()
	  $color.FontSize =(20)
	  $color.NotesFont = (0)
	  $color.NotesColor =($c)
	  $body.AppendStyle($color)
      $body.appendText("Курсы валют $date")
	  $color.FontSize =(18)
	  $color.NotesFont = (0)
	  $color.NotesColor =($c1)
	  $body.AppendStyle($color)
	  $body.AddNewLine(2)
	  $body.EmbedObject(1454,"","c:\Valuta\valuta.txt","Attachment")
$memodoc.save($True, $False)
$memodoc.Send($False)
}
else {break}
Start-Sleep -Seconds 10
Remove-Item -Path X:\telebank\BLACKBOX\OD\val\* -Include val* -Force
Start-Slepp -Seconds 1000 