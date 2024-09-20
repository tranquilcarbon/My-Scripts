<#
.SYNOPSIS
    This script generates MD5, SHA1, and SHA256 hashes for all files in a specified folder.

.DESCRIPTION
    The script prompts the user for a folder path, retrieves all files within the folder (including subfolders), and generates cryptographic hashes (MD5, SHA1, and SHA256) for each file.
    It displays the progress of the operation by indicating the current file being hashed out of the total number of files.
    The script also logs the time taken to complete the entire hashing process.

.EXAMPLE
    PS> .\GenerateHashes.ps1
    Enter folder path: C:\Users\User\Documents
    Generating hashes for 50 files in C:\Users\User\Documents
    Hashing file 1 of 50 - document1.txt - 
    Path: C:\Users\User\Documents\document1.txt
    MD5 hash: 9e107d9d372bb6826bd81d3542a419d6
    SHA1 hash: 2fd4e1c67a2d28fced849ee1bb76e7391b93eb12
    SHA256 hash: d7a8fbb307d7809469ca9abac5a7d0b540982a2db6e2fe6ce0bbf852cd104bb4
    
    Hashing complete.
    Finished script at '2024-09-20 15:10:32Z'. Took '00:05:20' to run.

.DETAILS
    This script uses the `Get-FileHash` cmdlet to compute MD5, SHA1, and SHA256 hashes for each file in a specified folder.
    It processes files recursively and outputs the file path and computed hashes for each file. 
    The progress is displayed during execution, and the script records the total elapsed time.

.Output
    Object: Outputs file path, MD5, SHA1, and SHA256 hash values for each file.

.LINK
    N/A

.AUTHOR
    tranquilcarbon
    Date: 20/09/2024
#>


begin {
    # Display the time that this script started running.
    [DateTime] $startTime = Get-Date
    Write-Information "Starting script at '$($startTime.ToString('u'))'."
  
    # Main part of script
    $folderPath = Read-Host "Enter folder path"
    # gets folder path.
    $files = Get-ChildItem -Path $folderPath -Recurse -File
    $totalFiles = $files.Count
    $currentFile = 1
    
    Write-Host "Generating hashes for $totalFiles files in $folderPath" -ForegroundColor Yellow
    
    foreach ($file in $files) {
        $filePath = $file.FullName
        $fileName = $file.Name
        $md5Hash = Get-FileHash -Path $filePath -Algorithm MD5
        $sha1Hash = Get-FileHash -Path $filePath -Algorithm SHA1
        $sha256Hash = Get-FileHash -Path $filePath -Algorithm SHA256
        #part that get hashes.
    
        Write-Host "Hashing file $currentFile of $totalFiles - $fileName - " -NoNewline
    
        Write-Output "Path: $filePath"
        Write-Output "MD5 hash: $($md5Hash.Hash)"
        Write-Output "SHA1 hash: $($sha1Hash.Hash)"
        Write-Output "SHA256 hash: $($sha256Hash.Hash)"
        Write-Output ""
    
        $currentFile++
    }
    
    Write-Host "Hashing complete" -ForegroundColor Green
  }

end{
    [DateTime] $finishTime = Get-Date
    [TimeSpan] $elapsedTime = $finishTime - $startTime
    write-host "Finished script at '$($finishTime.ToString('u'))'. Took '$elapsedTime' to run." -ForegroundColor Green
    }