$inSab = "D:\ARMSEP\InpSAB\"                #«Вхідна папка до САБ»
$outSab = "D:\ARMSEP\OutSAB\"                #«Вхідна папка до САБ»
$archSep = "D:\ARMSEP\ARCH_SEP"             #«Архів СЕП»
$sabIn = "x:\unexbank\ARM3_TEST\SAB_IN\"    #«Вхідна папка до САБ(мережева) »
$sabOut = "X:\unexbank\ARM3_TEST\SAB_OUT\*" #«Вихідна папка до САБ(мережева) »
$log = "D:\ARMSEP\ARCH_SEP\copyLog.txt"

$filesInpSab = Get-ChildItem -Path $inSab -Include('$*.*','&*.*') -Recurse
foreach($f in $filesInpSab){
Copy-Item $f -destination $sabIn -force -ErrorAction SilentlyContinue
if($? -eq $true){Write-Output "Файл перенесено успішно" +$f |Out-File $log -Append}
else{Write-Output "Файл не перенесено" +$f |Out-File $log -Append}
} 

$filesInSab = Get-ChildItem -Path $inSab -Include('$*.*','&*.*') -Recurse
foreach($f in $filesInSab){
Move-Item $f -destination $archSep -force -ErrorAction SilentlyContinue
if($? -eq $true){Write-Output "Файл перенесено до врхіва успішно" +$f |Out-File $log -Append}
else{Write-Output "Файл не перенесено до архіва" +$f |Out-File $log -Append}
}