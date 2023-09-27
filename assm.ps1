# Run this script with XAS99 to assemble all files
# See https://endlos99.github.io/xdt99/
#
# If you can't run powershell scripts research this command locally:
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# Assemble the files
$files = Get-ChildItem ".\" -Filter *.asm |
         Where-Object { $_.Name -ne 'LOADTSTS.asm' }
ForEach($file in $files) {
    write-host 'Assembling' $file.Name
    $listFile = $file.Name.Replace(".asm", "") + ".lst"
    $objFile = $file.Name.Replace(".asm", "") + ".obj.temp"
    xas99.py -q -S -R $file.Name -L $listFile -o $objFile
}

write-host 'Linking Unit Test Runners'

xas99.py -l `
    TESTFRAM.obj.temp `
    ACTTST.obj.temp `
    ACT.obj.temp `
    MEMBUF.noheader.obj `
    VAR.obj.temp `
    CONST.obj.temp `
    ARRAY.noheader.obj `
    -o ACTRUN.obj

xas99.py -l `
    TESTFRAM.obj.temp `
    DISPTSTA.obj.temp `
    DISP.obj.temp `
    VAR.obj.temp `
    CONST.obj.temp `
    -o DISPARUN.obj
# xas99.py -i DISPARUN.obj

xas99.py -l `
    TESTFRAM.obj.temp `
    DISPTST.obj.temp `
    DISP.obj.temp `
    VAR.obj.temp `
    CONST.obj.temp `
    -o DISPRUN.obj
# xas99.py -i DISPRUN.obj

xas99.py -l `
    INPTTST.obj.temp `
    TESTUTIL.obj.temp `
    INPUT.obj.temp `
    MEMBUF.noheader.obj `
    VAR.obj.temp `
    CONST.obj.temp `
    ARRAY.noheader.obj `
    WRAP.obj.temp `
    ACT.obj.temp `
    -o INPTRUN.obj

xas99.py -l `
    TESTFRAM.obj.temp `
    LOOKTST.obj.temp `
    LOOK.obj.temp `
    VAR.obj.temp `
    CONST.obj.temp `
    -o LOOKRUN.obj

xas99.py -l `
    TESTFRAM.obj.temp `
    POSUTST.obj.temp `
    POSUPD.obj.temp `
    VAR.obj.temp `
    CONST.obj.temp `
    -o POSRUN.obj

xas99.py -l `
    TESTFRAM.obj.temp `
    WRAPTST.obj.temp `
    WRAP.obj.temp `
    MEMBUF.noheader.obj `
    VAR.obj.temp `
    CONST.obj.temp `
    ARRAY.noheader.obj `
    -o WRAPRUN.obj

write-host 'Linking Key Buffer Test Program'
xas99.py -l `
    KEYTST.obj.temp `
    TESTUTIL.obj.temp `
    KEY.obj.temp `
    VAR.obj.temp `
    CONST.obj.temp `
    -o KEYRUN.obj

write-host 'Linking Main Program'
xas99.py -i -a ">2000" -l `
    MAIN.obj.temp `
    CONST.obj.temp `
    MEMBUF.noheader.obj `
    ARRAY.noheader.obj `
    INPUT.obj.temp `
    WRAP.obj.temp `
    POSUPD.obj.temp `
    DISP.obj.temp `
    KEY.obj.temp `
    VDP.obj.temp `
    LOOK.obj.temp `
    ACT.obj.temp `
    DSRLNK.obj.temp `
    MENULOGIC.obj.temp `
    UTIL.obj.temp `
    HEADER.obj.temp `
    VAR.obj.temp `
    CACHETBL.obj.temp `
    INIT.obj.temp `
    IO.obj.temp `
    EDTMGN.obj.temp `
    MENU.obj.temp `
    -o EMUWRITER

Remove-Item *.obj.temp
Remove-Item *.lst

# Create disk image
write-host 'Creating disk image'
$diskImage = 'EmuWriter.dsk'
xdm99.py -X sssd $diskImage
$programFiles = Get-ChildItem ".\" -Filter EMUWRITE* |
         Where-Object { $_.Name -ne 'EmuWriter.dsk' }
ForEach($programFile in $programFiles) {
    xdm99.py $diskImage -a $programFile.Name -f PROGRAM
}

# Add TIFILES header to all object files
$objectFiles = Get-ChildItem ".\" -Filter *.obj |
               Where-Object { $_.Name.EndsWith('.noheader.obj') -ne 1 }
ForEach($objectFile in $objectFiles) {
    xdm99.py -T $objectFile.Name -f DIS/FIX80 -o $objectFile.Name
}

# Add TIFILES header to EMUWRITER
ForEach($programFile in $programFiles) {
    xdm99.py -T $programFile.Name -f PROGRAM -o $programFile.Name
}