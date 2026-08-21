# Screen Timeout Tray Toggle for Windows 11
# Left-click tray icon to toggle AC monitor timeout between 1 minute and never.
# Right-click tray icon for menu.
# ASCII-only file for Windows PowerShell compatibility.

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Continue'
$LogPath = Join-Path $env:USERPROFILE 'PowerToggle\ScreenTimeoutTray.log'

function Log-Line([string]$msg) {
    try { Add-Content -Path $LogPath -Value ((Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ' ' + $msg) } catch {}
}

function Get-AcMonitorTimeoutMinutes {
    try {
        $out = & powercfg /query SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 2>$null
        foreach ($line in $out) {
            # Localized Windows output still contains AC and a hex value like 0x0000003c.
            if ($line -match 'AC' -and $line -match '0x([0-9a-fA-F]+)') {
                $seconds = [Convert]::ToInt32($Matches[1], 16)
                if ($seconds -eq 0) { return 0 }
                return [int][Math]::Ceiling($seconds / 60)
            }
        }
    } catch {
        Log-Line ('Get timeout failed: ' + $_.Exception.Message)
    }
    return $null
}

function Set-AcMonitorTimeoutMinutes([int]$minutes) {
    try {
        & powercfg /change monitor-timeout-ac $minutes | Out-Null
        Start-Sleep -Milliseconds 250
        Log-Line ('Set AC monitor timeout minutes=' + $minutes)
    } catch {
        Log-Line ('Set timeout failed: ' + $_.Exception.Message)
    }
}

function New-TrayIcon([bool]$never) {
    $bmp = New-Object System.Drawing.Bitmap 64,64
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $bg = if ($never) { [System.Drawing.Color]::FromArgb(38, 166, 91) } else { [System.Drawing.Color]::FromArgb(230, 126, 34) }
    $brush = New-Object System.Drawing.SolidBrush $bg
    $g.FillEllipse($brush, 2, 2, 60, 60)
    $font = New-Object System.Drawing.Font('Segoe UI', 24, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    $text = if ($never) { 'N' } else { '1' }
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $rect = New-Object System.Drawing.RectangleF 0,0,64,64
    $g.DrawString($text, $font, $white, $rect, $sf)
    $hicon = $bmp.GetHicon()
    $icon = [System.Drawing.Icon]::FromHandle($hicon)
    $g.Dispose(); $brush.Dispose(); $white.Dispose(); $font.Dispose(); $bmp.Dispose()
    return $icon
}

$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Visible = $true
$notify.Text = 'Screen timeout toggle'

$menu = New-Object System.Windows.Forms.ContextMenuStrip
$itemStatus = New-Object System.Windows.Forms.ToolStripMenuItem
$itemSetOne = New-Object System.Windows.Forms.ToolStripMenuItem('Set AC screen off after 1 minute')
$itemSetNever = New-Object System.Windows.Forms.ToolStripMenuItem('Set AC screen never off')
$itemRefresh = New-Object System.Windows.Forms.ToolStripMenuItem('Refresh status')
$itemExit = New-Object System.Windows.Forms.ToolStripMenuItem('Exit')
[void]$menu.Items.Add($itemStatus)
[void]$menu.Items.Add((New-Object System.Windows.Forms.ToolStripSeparator))
[void]$menu.Items.Add($itemSetOne)
[void]$menu.Items.Add($itemSetNever)
[void]$menu.Items.Add((New-Object System.Windows.Forms.ToolStripSeparator))
[void]$menu.Items.Add($itemRefresh)
[void]$menu.Items.Add($itemExit)
$notify.ContextMenuStrip = $menu

function Update-Ui {
    $minutes = Get-AcMonitorTimeoutMinutes
    $never = ($minutes -eq 0)
    if ($null -eq $minutes) {
        $itemStatus.Text = 'Current: read failed'
        $notify.Text = 'Screen timeout: read failed'
    } elseif ($never) {
        $itemStatus.Text = 'Current: AC screen never off'
        $notify.Text = 'Screen timeout: never'
    } else {
        $itemStatus.Text = ('Current: AC screen off after ' + $minutes + ' minute(s)')
        $notify.Text = ('Screen timeout: ' + $minutes + ' min')
    }
    $itemStatus.Enabled = $false
    $itemSetOne.Checked = ($minutes -eq 1)
    $itemSetNever.Checked = $never
    $notify.Icon = New-TrayIcon $never
}

function Show-Balloon([string]$msg) {
    try {
        $notify.BalloonTipTitle = 'Screen timeout toggle'
        $notify.BalloonTipText = $msg
        $notify.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
        $notify.ShowBalloonTip(1800)
    } catch {}
}

function Set-OneMinute {
    Set-AcMonitorTimeoutMinutes 1
    Update-Ui
    Show-Balloon 'AC screen timeout: 1 minute'
}

function Set-Never {
    Set-AcMonitorTimeoutMinutes 0
    Update-Ui
    Show-Balloon 'AC screen timeout: never'
}

function Toggle-Timeout {
    $minutes = Get-AcMonitorTimeoutMinutes
    if ($minutes -eq 0) { Set-OneMinute } else { Set-Never }
}

$itemSetOne.Add_Click({ Set-OneMinute })
$itemSetNever.Add_Click({ Set-Never })
$itemRefresh.Add_Click({ Update-Ui; Show-Balloon 'Status refreshed' })
$itemExit.Add_Click({
    $notify.Visible = $false
    $notify.Dispose()
    [System.Windows.Forms.Application]::Exit()
})
$notify.Add_MouseUp({
    param($sender, $eventArgs)
    if ($eventArgs.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
        Toggle-Timeout
    }
})

Log-Line 'Starting tray app.'
Update-Ui
[System.Windows.Forms.Application]::Run()
