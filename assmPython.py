#
# It would be nice for the assembly script to be in Python
# instead of powershell, so that the rest of the homebrew
# community can use it even if they are not in a Windows environment.
#
# Moving it is a work in progress.
#

import os
from subprocess import check_output
from itertools import chain

#Assemble Src and Tests
files1 = os.scandir(".//Src")
files2 = os.scandir(".//Tests")
files = chain(files1, files2)

for fileObj in files:
    if fileObj.name == "LOADTSTS.asm":
        continue
    else:
        print("Assembling " + fileObj.name)
        listFile = fileObj.name.replace(".asm", ".lst")
        objFile = fileObj.name.replace(".asm", ".obj.temp")
        assembleCommand = "xas99.py -q -S -R " + fileObj.path + " -L " + listFile + " -o " + objFile
        shellOutput = check_output(assembleCommand, shell=True)
        if len(shellOutput) == 0:
            print(shellOutput)