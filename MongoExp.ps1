$date= Get-Date
$date1=(Get-Date).AddDays(-61)
function ConvertTo-UnixTimestamp {	$epoch = Get-Date -Year 1970 -Month 1 -Day 1 -Hour 0 -Minute 0 -Second 0	 
$input | % {$milliSeconds = [math]::truncate($_.ToUniversalTime().Subtract($epoch).TotalMilliSeconds)		
Write-Output $milliSeconds	}	} 
$a=$date | ConvertTo-UnixTimestamp 
$b=$date1 | ConvertTo-UnixTimestamp
$c=" --db ibank-log" +" --collection log" +' -f "client_id"' +" --query " + '"{ "event_time"'+":{"+ '$gte ' + ":new Date("+$b+"),"+'$lt '+ ":new Date("+ $a +')}}"' + " --out C:\tmp\d.csv"
start-process C:\mongo\bin\mongoexport.exe -ArgumentList $c -Wait
$header = "code1","code2","code3","code4"
import-csv C:\tmp\d.csv -Delimiter ':' -Header $header| select code4  | Export-Csv  C:\tmp\d1.csv 
Get-Content C:\tmp\d1.csv |% {$_ -replace "code4"}| %{$_ -replace "\D"} |Sort| Get-Unique |Out-File C:\tmp\cln.txt
Get-SqlData 'srv-db' ibank2ua 'SELECT client_id,reg_date,status FROM ibank2ua.clients'| where {$_.reg_date -lt $date1}| where {$_.status -ne 0 }|Export-Csv C:\tmp\clnoff.csv
$header = "code1","code2","code3"
import-csv C:\tmp\clnoff.csv -Delimiter '"' -Header $header|select code2| %{$_ -replace "code2"}|%{$_ -replace "\D"}|Out-File C:\tmp\clnoff.txt
$dif = Compare-Object -ReferenceObject $(Get-Content C:\Tmp\clnoff.txt) -DifferenceObject $(Get-Content C:\Tmp\cln.txt) -IncludeEqual
foreach ($difference in $dif)
{
 if ($difference.SideIndicator -eq "<=")
      { Add-Content $.$difference -Path C:\tmp\ClnRes.txt }
	  }
Get-Content C:\Tmp\ClnRes.txt |%{[string]$_[16..19]}| ForEach-Object {$_ -replace ";"} | ForEach-Object {$_ -replace " "}| ForEach-Object {$_ -replace "Si"} | Set-Content C:\Tmp\Cln2.txt 
$A=Get-Content C:\tmp\cln2.txt
$excel = new-object -comobject excel.application
$excel.visible = $true
$workbook = $excel.workbooks.add()
$workbook.workSheets.item(3).delete()
$workbook.WorkSheets.item(2).delete()
$workbook.WorkSheets.item(1).Name = "Не користуються КБ"
$sheet = $workbook.WorkSheets.Item("Не користуються КБ")
$x=2
$lineStyle = "microsoft.office.interop.excel.xlLineStyle" -as [type]
$colorIndex = "microsoft.office.interop.excel.xlColorIndex" -as [type]
$borderWeight = "microsoft.office.interop.excel.xlBorderWeight" -as [type]
$chartType = "microsoft.office.interop.excel.xlChartType" -as [type]
For($b = 1 ; $b -le 3 ; $b++)
{
 $sheet.cells.item(1,$b).font.bold = $true
 $sheet.cells.item(1,$b).borders.LineStyle = $lineStyle::xlDashDot
 $sheet.cells.item(1,$b).borders.ColorIndex = $colorIndex::xlColorIndexAutomatic
# $sheet.cells.item(1,$b).borders.width = $borderWidth::xlMedium
}
$sheet.cells.item(1,1) = "Назва"
$sheet.cells.item(1,2) = "ЕДРПОУ"
$sheet.cells.item(1,3) = "Відділення"
foreach($i in $A)
{
Get-SqlData 'srv-db' ibank2ua 'SELECT Distinct a.client_id, a.name_cln,a.okpo ,ia.name
FROM ibank2ua.clients a, ibank2ua.accounts b ,ibank2ua.init_as ia
WHERE a.client_id=b.client_id and ia.branch_id = b.branch_id'| where {$_.client_id -eq "$i"}|
ForEach-Object {
 $sheet.cells.item($x,1) = $_.name_cln
 $sheet.cells.item($x,2) = $_.okpo
 $sheet.cells.item($x,3) = $_.name
 $x++
} 
}
$range = $sheet.usedRange
$range.EntireColumn.AutoFit() | out-null
$WorkBook.SaveAs('C:\tmp\Clients.xlsx')
$Excel.Quit()
Write-EventLog -LogName "PsScripts" -Source "ClnOff" -Message "Файл створено " -EventId 5