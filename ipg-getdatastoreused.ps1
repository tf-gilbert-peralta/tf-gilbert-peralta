Connect-VIServer sydvmw01.ap.corp.ipgnetwork.com -force
$getdate = get-date -format "dd/MM/yyyy HH:mm"
$ds1 = Get-Datastore | where Name -Match "DK2PSCLUSTER01_IPG01"
$ds2 = Get-Datastore | where Name -Match "DK2PSCLUSTER01_IPG02"
$ds3 = Get-Datastore | where Name -Match "DK2PSCLUSTER01_IPG03"
$usedds1 = $ds1.CapacityGB - $ds1.FreeSpaceGB
$usedds2 = $ds2.CapacityGB - $ds2.FreeSpaceGB
$usedds3 = $ds3.CapacityGB - $ds3.FreeSpaceGB
$usedtotal = $usedds1 + $usedds2 + $usedds3
$newrow = [pscustomobject]@{ date = $getdate; datastore1 = $usedds1; datastore2 = $usedds2; datastore3 = $usedds3; total = $usedtotal }
$outfile = "C:\vmware_reporting\IPG_IaaS_Storage.csv"
if (test-path -path $outfile -pathtype leaf) { Export-Csv $outfile -inputobject $newrow -append } else { $newrow | Export-Csv $outfile -NoTypeInformation }
Disconnect-VIServer -server * -confirm:$false
