#
# It would be nice for the assembly script to be in Python
# instead of powershell, so that the rest of the homebrew
# community can use it even if they are not in a Windows environment.
#
# Moving it is a work in progress.
#

# Run this script with XAS99 to assemble all files
# See https://endlos99.github.io/xdt99/
#
# If you can't run powershell scripts research this command locally:
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
import os, glob
from subprocess import check_output
from itertools import chain

#Functions
def link_files(linked_file, include_membuf, object_files):
    unlinked_files = []
    for object_file in object_files:
        unlinked_files.append(object_file + ".obj.temp")
    if include_membuf == True:
        unlinked_files.append("MEMBUF.noheader.obj")    
        unlinked_files.append("ARRAY.noheader.obj")
    unlinked_files_string = " ".join(unlinked_files)
    link_command_1 = "xas99.py -l {source} -o {output}"
    link_command_2 = link_command_1.format(source = unlinked_files_string, output = linked_file)
    os.system(link_command_2)

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
        assembleCommand1 = "xas99.py -q -S -R {sourceFile} -L {listFile} -o {objFile}"
        assembleCommand2 = assembleCommand1.format(sourceFile = fileObj.path, listFile = listFile, objFile = objFile)
        os.system(assembleCommand2)

print("Linking Unit Test Runners")
temp_files = [ "TESTFRAM", "ACTTST", "ACT", "VAR", "CONST" ]
link_files("ACTRUN.obj", True, temp_files)

temp_files = [ "TESTFRAM", "DISPTST", "DISP", "VAR", "CONST" ]
link_files("DISPRUN.obj", True, temp_files)

temp_files = [ "TESTFRAM", "DISPTSTA", "DISP", "VAR", "CONST" ]
link_files("DISPARUN.obj", False, temp_files)

temp_files = [ "INPTTST", "TESTUTIL", "INPUT", "WRAP", "ACT", "UTIL", "VAR", "CONST" ]
link_files("INPTRUN.obj", True, temp_files)

temp_files = [ "TESTFRAM", "LOOKTST", "LOOK", "VAR", "CONST" ]
link_files("LOOKRUN.obj", False, temp_files)

#Clean up
for file in glob.glob("*.lst"):
    os.remove(file)
for file in glob.glob("*.obj.temp"):
    os.remove(file)