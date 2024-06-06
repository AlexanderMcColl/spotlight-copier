# You'll need to set your own $workingFolder.
# If your Landscape and Portrait folders aren't subfolders of your working folder, you'll need to customise those too.
$spotlightFolder = "$($env:LOCALAPPDATA)\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\"
$workingFolder = "D:\Pictures\Wallpapers\Spotlight Wallpapers\"
$landscapeFolder = $workingFolder + "Landscape\"
$portraitFolder = $workingFolder + "Portrait\"
$ext = ".jpg"
$copiedFiles = @{}

# Copy all files out of the Spotlight folder that are greater than 120KB.
# Record the filename as a hashtable key, and record the width and height of the image as values associated with that key.
foreach ($file in Get-ChildItem -Path $spotlightFolder) {
    if ($file.length -gt 200KB) {
        # Debugging: Write-Output "found an image to copy"
        $imageFile = $spotlightFolder + $file
        Add-Type -AssemblyName System.Drawing
        $imageObj = New-Object System.Drawing.Bitmap $imageFile
        $imageWidth = $imageObj.Width
        $imageHeight = $imageObj.Height
        $copiedFiles.$file = @()
        $copiedFiles.$file += $imageWidth
        $copiedFiles.$file += $imageHeight
        Copy-Item $imageFile -Destination $workingFolder
    }
}

# Give the copied images .jpg extensions
foreach ($h in $copiedFiles.GetEnumerator() ) {
    $image = $workingFolder + $h.Name
    $imageExt = $image + $ext
    # As long as there is an image in the folder with this filename, proceed.
    # Else remove it from the hashtable.
    if (Test-Path $image) {
        # If there's already an image.jpg file in this folder, delete this image file and remove it from the hashtable.
        # Else as long as this file is in the folder (was copied successfully) append .jpg onto the filename (give it a jpg extension).
        if (Test-Path $imageExt) {
            Remove-Item $image
            $copiedFiles.Remove($h)
        }
        else { Rename-Item $image $imageExt }
    }
    else { $copiedFiles.Remove($h) }
}

# Move the jpg images into folders for landscape and portrait.
foreach ($h in $copiedFiles.GetEnumerator() ) {
    $imageExt = $workingFolder + $h.Name + $ext
    $landscapeCheck = $landscapeFolder + $h.Name + $ext
    $portraitCheck = $PortraitFolder + $h.Name + $ext
    # Check the Portait and Landscape folders for this image.jpg. As long as it isn't in either folder, proceed.
    # Else delete this image.jpg (as it's already been copied over at an earlier date).
    if (-not(Test-Path $landscapeCheck) -and -not(Test-Path $portraitCheck)) {  
        # If the image dimensions are landscape, move it into the Landscape folder        
        if ($h.Value[0] -gt $h.Value[1]) {
            Move-Item $imageExt $landscapeFolder
        }
        # Elseif the image dimensions are portrait, move it into the Portrait folder
        elseif ($h.Value[1] -gt $h.Value[0]) {
            Move-Item $imageExt $portraitFolder
        }
    }
    else {
        Remove-Item $imageExt
        # Debugging: Write-Output "deleted an image because it was a duplicate"
    }
    
}
# Debugging: timeout /t 10 > $null