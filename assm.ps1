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
    MEMBUF.obj.temp `
    VAR.obj.temp `
    CONST.obj.temp `
    ARRAY.obj.temp `
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
    MEMBUF.obj.temp `
    VAR.obj.temp `
    CONST.obj.temp `
    ARRAY.obj.temp `
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
    SCRNTST.obj.temp `
    TESTUTIL.obj.temp `
    SCRNWRT.obj.temp `
    MEMBUF.obj.temp `
    VAR.obj.temp `
    CONST.obj.temp `
    -o SCRNRUN.obj

xas99.py -l `
    TESTFRAM.obj.temp `
    WRAPTST.obj.temp `
    WRAP.obj.temp `
    MEMBUF.obj.temp `
    VAR.obj.temp `
    CONST.obj.temp `
    ARRAY.obj.temp `
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
xas99.py -l `
    MAIN.obj.temp `
    CONST.obj.temp `
    MEMBUF.obj.temp `
    ARRAY.obj.temp `
    INPUT.obj.temp `
    WRAP.obj.temp `
    POSUPD.obj.temp `
    DISP.obj.temp `
    KEY.obj.temp `
    VDP.obj.temp `
    LOOK.obj.temp `
    ACT.obj.temp `
    PRINT.obj.temp `
    VAR.obj.temp `
    END.obj.temp `
    -o MAINRUN.obj

# Add TIFILES header to MAIN
# xdm99.py -T 'MAIN.PRG' -f PROGRAM -o PROGRAM

Remove-Item *.obj.temp
Remove-Item *.lst

# Add TIFILES header to all object files
$objectFiles = Get-ChildItem ".\" -Filter *.obj |
               Where-Object { $_.Name -ne 'ARRAY.obj' -and $_.Name -ne 'MEMBUF.obj' }
ForEach($objectFile in $objectFiles) {
    xdm99.py -T $objectFile.Name -f DIS/FIX80 -o $objectFile.Name
}