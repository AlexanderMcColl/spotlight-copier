# spotlight-copier

Copy wallpapers from Windows Spotlight the lockscreen folder so you can use them as your own wallpapers and backgrounds

## Background

Windows Spotlight gives you new landscape wallpapers every day, but only for your lockscreen, and then deletes them a few days later

I like to use these wallpapers in a folder that the built-in Windows wallpaper slideshow cycles through every day.

These two PowerShell files automate that process.

## What these files do

### ScheduledTaskCreator.ps1

This script creates a scheduled task to run SpotlightCopier.ps1 on system logon. It only needs to be run once and after that you should make any changes directly to the scheduled task. I have an AMD 5800h and NVMe SSD and this is so lightweight to run that I don't mind having it execute on logon. If you want different scheduled task settings, you have to modify the task yourself.

### SpotlightCopier.ps1

This script runs 3 loops.

First it enumerates all the files in the Windows Spotlight images folder that are over 200KB in size into a hashtable and copies them to a working folder of your choice. I recommend this being a folder you don't use, which has two subfolders - Landscape and Portrait. They'll be used later for sorting the images.
(This folder has some random small files in it, but all the Spotlight images are a few hundred KB to 1-2MB in size)

Then it loops through the hashtable and renames the files it copied into the working folder to give them a .jpg extension. They're stored by Windows without an extension.

Finally it moves them into either a Landcape or Portrait folder depending on their dimensions. It never overwrites files in any of the directories it copies or moves to.
It deletes any duplicates or leftovers and exits.

It should only ever touch files with filenames that it recorded in its hashtable as it was copying from the Windows Sportlight images folder. Nonetheless, I wouldn't keep any other files in the working folder, just to be safe.

## Installation

1. Save both files somewhere they can live hapilly and be called on every logon by a Scheduled Task.
   I have a folder named Applications on my D drive where I keep things like this.
2. Check the filepaths for saving images are correct for your system. Change them if needed.
3. Right click ScheduledTaskCreator.ps1 and 'Run with Powershell'. If you don't have this option, you may just be able to double click it, or Open With... Powershell. You shouldn't need to run it as administrator but maybe you will. I dunno.
4. Open Windows Task Scheduler and double check that there's a task named "Copy Windows Spotlight Images". If you run it, it should populate your chosen folders with some images. If that doesn't happen, delete that task, check your filepaths in the scripts and try again.
5. You can now safely delete ScheduledTaskCreator.ps1. You only need to keep SpotlightCopier.ps1.
   (Optional) 6. Set up your Landscape folder as your desktop wallpaper folder in Windows, with a slideshow. Set up your Portrait folder to sync with your phone for new phone wallpapers.

## Uninstallation

To uninstall this script, simply go into Windows Task Manager and delete the task with the name "Copy Windows Spotlight Images", then delete these 2 files.
