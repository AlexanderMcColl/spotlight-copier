$spotlightFolder = "$($env:LOCALAPPDATA)\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\"
$workingFolder = "D:\Pictures\Wallpapers\Spotlight Wallpapers\"
$landscapeFolder = $workingFolder + "Landscape\"
$portraitFolder = $workingFolder + "Portrait\"
$ext = ".jpg"
$copiedFiles = @{}


foreach ($file in Get-ChildItem -Path $spotlightFolder) {
    if ($file.length -gt 200KB) {
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

foreach ($h in $copiedFiles.GetEnumerator() ) {
    $image = $workingFolder + $h.Name
    $imageExt = $image + $ext
    if (-not(Test-Path $imageExt)) {
        if (Test-Path $image) {
            Rename-Item $image $imageExt
            $landscapeCheck = $landscapeFolder + $h.Name + $ext
            $portraitCheck = $PortraitFolder + $h.Name + $ext
            if (-not(Test-Path $landscapeCheck) -and -not(Test-Path $portraitCheck)) {          
                if ($h.Value[0] -gt $h.Value[1]) {
                    Move-Item $imageExt $landscapeFolder
                }
                elseif ($h.Value[1] -gt $h.Value[0]) {
                    Move-Item $imageExt $portraitFolder
                }
            }
            else { Remove-Item $imageExt }
        }
    }
    else { Remove-Item $image }
}