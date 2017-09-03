$outSab = "D:\ARMSEP\OutSAB\"                #«Вхідна папка до САБ»
$archSep = "D:\ARMSEP\ARCH_SEP"             #«Архів СЕП»
$sabOut = "X:\unexbank\ARM3_TEST\SAB_OUT\*" #«Вихідна папка до САБ(мережева) »
$log = "D:\ARMSEP\ARCH_SEP\copyLog.txt"

$filesSabOut = Get-ChildItem -Path $sabOut -Include('$*.*','&*.*') -Recurse
foreach($f in $filesSabOut){
Move-Item $f -destination $outSab -force -ErrorAction SilentlyContinue
if($? -eq $true){Write-Output "Файл перенесено успішно" +$f |Out-File $log -Append}
else{Write-Output "Файл не перенесено" +$f |Out-File $log -Append}
} 

$filesOutSab = Get-ChildItem -Path $outSab -Include('$*.*','&*.*') -Recurse
foreach($f in $filesOutSab){
Move-Item $f -destination $archSep -force -ErrorAction SilentlyContinue
if($? -eq $true){Write-Output "Файл перенесено до врхіва успішно" +$f |Out-File $log -Append}
else{Write-Output "Файл не перенесено до архіва" +$f |Out-File $log -Append}
}

#$dist =@($archSep,$inSab)
##Копирование сразу в несколько папок
#$filesSabOut = Get-ChildItem -Path $sabOut
#foreach($f in $filesSabOut){
#foreach($d in $dist){
#Copy-Item $f -destination $d -force -ErrorAction SilentlyContinue}
#if($? -eq $true){Write-Output "Success copy" +$f |Out-File $log -Append}
#}