# Force Windows 11 to show the Screen Timeout tray icon outside the hidden ^ menu.
# Windows stores tray visibility in HKCU:\Control Panel\NotifyIconSettings.

$root = 'HKCU:\Control Panel\NotifyIconSettings'
$changed = 0
Get-ChildItem $root -ErrorAction SilentlyContinue | ForEach-Object {
    $p = $_.PSPath
    $v = Get-ItemProperty $p -ErrorAction SilentlyContinue
    if (($v.InitialTooltip -like 'Screen timeout*') -or (($v.ExecutablePath -like '*WindowsPowerShell*') -and ($v.InitialTooltip -like 'Screen*'))) {
        Set-ItemProperty -Path $p -Name IsPromoted -Type DWord -Value 1 -ErrorAction SilentlyContinue
        $changed++
    }
}
"Promoted=$changed"
