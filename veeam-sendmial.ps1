# veeam mail notification ps scripct

Import-Module Veeam.Backup.PowerShell

# comment
# as vars are not defined in testing, e-mail will be sent but informations will be missing

#default vars
#set values suitable to customer environment
$gettape    = "Tape nicht definiert"
$recipient1 = "defaultrcpt@mail.de"

#condition
$tape1 = Get-VBRTapeMedium | Where-Object {$_.Name -eq "Tape 1"}
if ($tape1.Location.Type -eq "Drive"){
    $gettape = "Tape 1"
    $recipient1 = "rcpt1"
}

$tape2 = Get-VBRTapeMedium | Where-Object {$_.Name -eq "Tape 2"}
if ($tape2.Location.Type -eq "Drive"){
    $gettape = "Tape 2"
    $recipient1 = "rcpt2"
}

$tape3 = Get-VBRTapeMedium | Where-Object {$_.Name -eq "Tape 3"}
if ($tape3.Location.Type -eq "Drive"){
    $gettape = "Tape 3" 
    $recipient1 = "rctp3"
}

$weekly = Get-VBRTapeMedium | Where-Object {$_.Name -eq "weekly"}
if ($tape4.Location.Type -eq "Drive"){
    $gettape = "weekly" 
    $recipient1 = "rctp4"
}

$monthly = Get-VBRTapeMedium | Where-Object {$_.Name -eq "monthly"}
if ($tape4.Location.Type -eq "Drive"){
    $gettape = "monthly" 
    $recipient1 = "rctp5"
}


$bodyline   = "<p><b>Benachrichtigung zu Backupvorgängen</b></p><p>LTO Backup Rotation: Das Band <b>"+$gettape+"</b> wird benötigt. Bitte legen Sie das Band in das Bandlaufwerk ein.</p>"
$subject    = "Backup LTO1 Band "+$gettape+" : Band wird benötigt"

#smtpserver
$smtpserver = ""
$smtpport   = "587"
$smtpfrom   = ""
$smtpuser   = ""
$smtppass   = ""

#message definition
$smtpto  = $recipient1
$message = New-Object System.Net.Mail.MailMessage
$message.From = $smtpfrom
$message.To.Add($smtpto)
$message.Subject = $subject
$message.IsBodyHTML = $true
$Header = @"
<style>
body {font-family: Calibri; font-size: 11pt;}
</style>
"@ 

#content
$message.Body= $bodyline

#sendout
$messageclient = New-Object Net.Mail.SmtpClient($smtpserver,$smtpport)
$messageclient.EnableSsl = $true
$messageclient.Credentials = New-Object System.Net.NetworkCredential($smtpuser,$smtppass)
$messageclient.Send($message)