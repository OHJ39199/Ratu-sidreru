#Requires -Version 5.1
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#region === Notificaciones (globitos sidreros) ===
function New-ToastIcon {
    if (-not $script:NotifyIcon) {
        $script:NotifyIcon = New-Object System.Windows.Forms.NotifyIcon
        $script:NotifyIcon.Icon = [System.Drawing.SystemIcons]::Information
        $script:NotifyIcon.Text = "Ratón borrachu"
        $script:NotifyIcon.Visible = $true
    }
    return $script:NotifyIcon
}

function Show-Toast {
    param(
        [string]$Title   = "Ratón borrachu",
        [string]$Message = "",
        [switch]$Balloon
    )
    Write-Host "[$Title] $Message" -ForegroundColor Cyan

    if ($Balloon) {
        $ni = New-ToastIcon
        $ni.BalloonTipIcon  = "Info"
        $ni.BalloonTipTitle = $Title
        $ni.BalloonTipText  = $Message
        $ni.ShowBalloonTip(3000)
    }
}
#endregion

#region === Paso borracho ultra-caótico ===
function Move-DrunkStep {
    param(
        [System.Drawing.Point]$Target,
        [int]$Step         = 25,
        [int]$Sway         = 12,
        [int]$Jitter       = 18,
        [int]$IntervalMs  = 22,
        [switch]$Clamp,
        [double]$Intensity = 1.0,
        [switch]$ChaosMode
    )

    # Área total de todos los monitores
    $vs     = [System.Windows.Forms.SystemInformation]::VirtualScreen
    $left   = $vs.Left
    $top    = $vs.Top
    $right  = $vs.Right - 1
    $bottom = $vs.Bottom - 1

    # Nuevo objetivo aleatorio si no hay uno
    if (-not $Target) {
        $Target = [System.Drawing.Point]::new(
            (Get-Random -Minimum $left   -Maximum ($right  + 1)),
            (Get-Random -Minimum $top    -Maximum ($bottom + 1))
        )
    }

    $pos = [System.Windows.Forms.Cursor]::Position

    # Vector al objetivo
    $vx = $Target.X - $pos.X
    $vy = $Target.Y - $pos.Y
    $dist = [Math]::Sqrt($vx*$vx + $vy*$vy)

    # Intensidad + variación aleatoria de velocidad
    $speedVar = Get-Random -Minimum 0.7 -Maximum 1.4
    $stepEff  = [int]($Step  * $Intensity * $speedVar)
    $swayEff  = [int]($Sway  * $Intensity)
    $jitterEff= [int]($Jitter* $Intensity)

    # Dirección normalizada y desplazamiento base
    if ($dist -gt 0) {
        $dx = [int]($vx / $dist * $stepEff)
        $dy = [int]($vy / $dist * $stepEff)
    } else {
        $dx = $dy = 0
    }

    # Deriva y temblor normal
    $newX = $pos.X + $dx + (Get-Random -Min (-$swayEff)  -Max ($swayEff  + 1)) + (Get-Random -Min (-$jitterEff) -Max ($jitterEff + 1))
    $newY = $pos.Y + $dy + (Get-Random -Min (-$swayEff)  -Max ($swayEff  + 1)) + (Get-Random -Min (-$jitterEff) -Max ($jitterEff + 1))

    # ==== CHAOS MODE (el infierno) ====
    if ($ChaosMode) {
        $roll = Get-Random -Minimum 1 -Maximum 101
        switch ($roll) {
            {$_ -le 15} { # 15 % Zig-zag brutal
                $zig = Get-Random -Minimum -1 -Maximum 2
                $newX += ($stepEff + $swayEff) * $zig
                $newY -= ($stepEff + $swayEff) * $zig
            }
            {$_ -le 27} { # 12 % Sprint sidrero
                $burst = Get-Random -Minimum 3 -Maximum 7
                $newX += $dx * $burst + (Get-Random -Min (-$jitterEff*3) -Max ($jitterEff*3 + 1))
                $newY += $dy * $burst + (Get-Random -Min (-$jitterEff*3) -Max ($jitterEff*3 + 1))
            }
            {$_ -le 36} { # 9 % Resbalón (overshoot)
                $over = Get-Random -Minimum 1.4 -Maximum 3.0
                $newX = $pos.X + [int]($dx * $over)
                $newY = $pos.Y + [int]($dy * $over)
            }
            {$_ -le 44} { # 8 % Vibración epilepsia
                for ($i = 0; $i -lt 7; $i++) {
                    $mx = $newX + (Get-Random -Min (-12*$Intensity) -Max (12*$Intensity + 1))
                    $my = $newY + (Get-Random -Min (-12*$Intensity) -Max (12*$Intensity + 1))
                    if ($Clamp) { $mx = [Math]::Clamp($mx,$left,$right); $my = [Math]::Clamp($my,$top,$bottom) }
                    [System.Windows.Forms.Cursor]::Position = [System.Drawing.Point]::new([int]$mx,[int]$my)
                    Start-Sleep -Milliseconds 8
                }
            }
        }
    }

    # Clamp final para no salirse nunca de las pantallas
    if ($Clamp) {
        $newX = [Math]::Clamp($newX, $left, $right)
        $newY = [Math]::Clamp($newY, $top,  $bottom)
    }

    [System.Windows.Forms.Cursor]::Position = [System.Drawing.Point]::new([int]$newX,[int]$newY)
    Start-Sleep -Milliseconds $IntervalMs
    return $Target
}
#endregion

#region === Control principal ===
function Start-RatonBorrachu {
    param(
        [int]$DurationSec    = 0,      # 0 = infinito
        [int]$Step           = 28,
        [int]$Sway           = 16,
        [int]$Jitter         = 24,
        [int]$IntervalMs     = 18,
        [int]$RetargetEvery  = 35,
        [switch]$Clamp,
        [switch]$Balloons,
        [double]$Intensity   = 2.5,
        [switch]$ChaosMode
    )

    Show-Toast "Ratón borrachu" "¡Tira pal chigre! ¡Metemos caña y más tambaleo!" -Balloon:$Balloons

    $start  = Get-Date
    $count  = 0
    $target = $null
    $script:StopRatonBorrachu = $false

    try {
        while (-not $script:StopRatonBorrachu) {
            # Tiempo límite (si se usa)
            if ($DurationSec -gt 0 -and ((Get-Date) - $start).TotalSeconds -ge $DurationSec) { break }

            # Cambiar objetivo cada X pasos o de forma aleatoria (más impredecible)
            if ($count % [Math]::Max(1,$RetargetEvery) -eq 0 -or (Get-Random -Maximum 9) -eq 0) {
                $target = $null
            }

            $target = Move-DrunkStep -Target $target -Step $Step -Sway $Sway -Jitter $Jitter `
                                     -IntervalMs $IntervalMs -Clamp:$Clamp -Intensity $Intensity -ChaosMode:$ChaosMode
            $count++
        }
    }
    finally {
        Show-Toast "Ratón borrachu" "¡Párase'l tinglau! ¡Marcho que tengo la muyer esperando!" -Balloon:$Balloons
        if ($script:NotifyIcon) {
            $script:NotifyIcon.Visible = $false
            $script:NotifyIcon.Dispose()
            $script:NotifyIcon = $null
        }
    }
}

function Stop-RatonBorrachu { $script:StopRatonBorrachu = $true }
#endregion

# ¡¡¡A DARLE CAÑA!!!
Start-RatonBorrachu -Clamp -Balloons -Intensity 2.5 -ChaosMode -Step 28 -Sway 16 -Jitter 24 -IntervalMs 18 -RetargetEvery 35