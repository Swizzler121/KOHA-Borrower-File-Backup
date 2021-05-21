#Only works up to powershell 5.1, they removed 
$c = $host.UI.PromptForCredential('Your Credentials', 'Enter Credentials', '', '')
$r = Invoke-WebRequest 'https://<kohadomain>/cgi-bin/koha/mainpage.pl' -SessionVariable Session
$form = $r.Forms[0]
$form.fields['userid'] = $c.UserName
$form.fields['password'] = $c.GetNetworkCredential().Password
$r = Invoke-WebRequest -Uri ('https://<kohadomain>/cgi-bin/koha/tools/access_files.pl' + $form.Action) -WebSession $Session -Method POST -Body $form.Fields
$link = ((Invoke-WebRequest -WebSession $Session -Uri ‘https://<kohadomain>/cgi-bin/koha/tools/access_files.pl’).Links |Where innerHTML -Like "borrowers.db").href
Invoke-WebRequest -WebSession $Session -Uri ('https://<kohadomain>' + $link) -OutFile 'C:\<outputpath>\borrowers.db'
