#Only works up to powershell 5.1, they removed some web scraping tools from PS7
$c = $host.UI.PromptForCredential('Your Credentials', 'Enter Credentials', '', '')
$r = Invoke-WebRequest 'https://koha.salinapublic.org/cgi-bin/koha/mainpage.pl' -SessionVariable Session
$form = $r.Forms[0]
$form.fields['userid'] = $c.UserName
$form.fields['password'] = $c.GetNetworkCredential().Password
$r = Invoke-WebRequest -Uri ('https://koha.salinapublic.org/cgi-bin/koha/tools/access_files.pl' + $form.Action) -WebSession $Session -Method POST -Body $form.Fields
$link = ((Invoke-WebRequest -WebSession $Session -Uri ‘https://koha.salinapublic.org/cgi-bin/koha/tools/access_files.pl’).Links |Where innerHTML -Like "borrowers.db").href
Invoke-WebRequest -WebSession $Session -Uri ('https://koha.salinapublic.org' + $link) -OutFile 'D:\Desktop\test\borrowers.db'