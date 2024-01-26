

<#  
  .SYNOPSIS   
    Displays file content from multiple files at the same time.
  .DESCRIPTION
	Reads data from one or multiple files based on your filter and your defined interval in current folder.
  .PARAMETER Interval
	How often to check file in seconds, default value is 2 seconds.
  .PARAMETER Filter
	File Filter, Mandatory, You can define multiple files in order no default value. You
  .PARAMETER Last, default value is 5 rows.
	Rows from each file to be displayed
  .PARAMETER FileCount, default value is 5 rows.
	Limit the number of files to parse (last modified). 
  .PARAMETER KeepScreenBuffer, switch
	If defined, instead of clearing screen buffer it will continue with next itteration (without clearing).
  .EXAMPLE  
	Watch-Files -interval 10 -filter *.log
   .EXAMPLE  
	Watch-Files -interval 10 -filter *.log -last 2
  .EXAMPLE  
	Watch-Files -filter Agent*Trasform*.log, *.txt -Top 4 -KeepScreenBuffer 
  .NOTES
	Version:	1.0
	Author:		mytsk
	Creation Date:	2020-08-28
	Purpose/Change: Initial development
  .LINK
	https:/www.github.com/mytsk/Watch-Files
#>
function Watch-Files {  
  Param(
    [parameter(position = 0, Mandatory = $true)]$Filter,
    [parameter(position = 1, Mandatory = $false)][double]$Milliseconds,
    [parameter(position = 1, Mandatory = $false)][double]$Seconds,
    [parameter(position = 2, Mandatory = $false)][int]$Last,
    [parameter(position = 3, Mandatory = $false)][int]$FileCount,
    [parameter(position = 4, Mandatory = $false)][switch]$KeepScreenBuffer
  )
  
  if ($Milliseconds) {
    $type = "milliseconds"
    $interval = $Milliseconds
  }
  elseif ($Seconds) {
    $type = "seconds"
    $interval = $Seconds
  }
  elseif ($Seconds -eq $null -and $Milliseconds -eq $null) {
    $interval = 2
    $type = "seconds"
  }

  
  if (!$Last) { $Last = 5 }
  if (!$FileCount) { $FileCount = 10 }
	
  while ($true) {
    if (!$KeepScreenBuffer) { clear-host }
    Write-Host -ForegroundColor Gray "Reading from files " -nonewline       
    Write-Host -ForegroundColor White "$filter" -nonewline     
    Write-Host -ForegroundColor Gray " every " -nonewline 
    Write-Host -ForegroundColor White "$interval" -nonewline 
    Write-Host -ForegroundColor Gray " $type." 
    Write-Host -ForegroundColor DarkCyan "-------------------------------------------------------------------------------"
    $files = Get-ChildItem -File $filter  | Sort-Object -Property LastWriteTime, Name | Select-Object -last $FileCount

    foreach ($data in $files) {
      write-host -ForegroundColor DarkCyan "File: " -NoNewline
      write-host -ForegroundColor Yellow $data
      get-content -last $last $data
    }
    Write-Host -ForegroundColor DarkCyan "-------------------------------------------------------------------------------"
    Write-Verbose "Files read: $files"
    write-Host "(Ctrl + C to exit)"
    if ($type -eq "milliseconds") {
    
      Start-Sleep -Milliseconds $interval
    }
    elseif ($type -eq "seconds") {
      Start-Sleep -Seconds $interval
    }
    
  }
}
Export-ModuleMember -Function 'Watch-Files'