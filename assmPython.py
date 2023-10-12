#
# It would be nice for the assembly script to be in Python
# instead of powershell, so that the rest of the homebrew
# community can use it even if they are not in a Windows environment.
#
# Moving it is a work in progress.
#

import os
from subprocess import check_output

#Assemble Src and Tests
files1 = os.listdir(".//Src")
files2 = os.listdir(".//Tests")
files = files1 + files2

for fileName in files:
    print("Assembling " + fileName)
    listFile = fileName.replace(".asm", ".lst")
    objFile = fileName.replace(".asm", ".obj.temp")
    assembleCommand = "xas99.py -q -S -R .//Src//" + fileName + " -L " + listFile + " -o " + objFile
    shellOutput = check_output(assembleCommand, shell=True)
    if len(shellOutput) == 0:
        print(shellOutput)
#     xas99.py -q -S -R $file.FullName -L $listFile -o $objFile
# }