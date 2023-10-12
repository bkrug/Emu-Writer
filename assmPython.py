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
from itertools import chain

#Functions
def get_unlinked_string(include_membuf, object_files):
    unlinked_files = []
    for object_file in object_files:
        unlinked_files.append(object_file + ".obj.temp")
    # These can't be the first files in the list because the first byte is not the program start
    # These can't be at the end, because the main program gets auto-split into smaller pieces
    if include_membuf == True:
        unlinked_files.insert(1, "MEMBUF.noheader.obj")    
        unlinked_files.insert(2, "ARRAY.noheader.obj")
    return " ".join(unlinked_files)

def link_test_files(linked_file, include_membuf, object_files):
    unlinked_files_string = get_unlinked_string(include_membuf, object_files)
    link_command_1 = "xas99.py -l {source} -o {output}"
    link_command_2 = link_command_1.format(source = unlinked_files_string, output = linked_file)
    os.system(link_command_2)

def link_main_files(linked_file, include_membuf, object_files):
    unlinked_files_string = get_unlinked_string(include_membuf, object_files)
    link_command_1 = "xas99.py -i -a \">2000\" -l {source} -o {output}"
    link_command_2 = link_command_1.format(source = unlinked_files_string, output = linked_file)
    os.system(link_command_2)

#Assemble Src and Tests
files1 = os.scandir(".//Src")
files2 = os.scandir(".//Tests")
files = chain(files1, files2)

for file_obj in files:
    if file_obj.name == "LOADTSTS.asm":
        continue
    else:
        print("Assembling " + file_obj.name)
        list_file = file_obj.name.replace(".asm", ".lst")
        obj_file = file_obj.name.replace(".asm", ".obj.temp")
        assemble_command_1 = "xas99.py -q -S -R {source} -L {list} -o {obj}"
        assemble_command_2 = assemble_command_1.format(source = file_obj.path, list = list_file, obj = obj_file)
        os.system(assemble_command_2)

print("Linking Unit Test Runners")
temp_files = [ "TESTFRAM", "ACTTST", "ACT", "VAR", "CONST" ]
link_test_files("ACTRUN.obj", True, temp_files)

temp_files = [ "TESTFRAM", "DISPTST", "DISP", "VAR", "CONST" ]
link_test_files("DISPRUN.obj", True, temp_files)

temp_files = [ "TESTFRAM", "DISPTSTA", "DISP", "VAR", "CONST" ]
link_test_files("DISPARUN.obj", False, temp_files)

temp_files = [ "INPTTST", "TESTUTIL", "INPUT", "WRAP", "ACT", "UTIL", "VAR", "CONST" ]
link_test_files("INPTRUN.obj", True, temp_files)

temp_files = [ "TESTFRAM", "LOOKTST", "LOOK", "VAR", "CONST" ]
link_test_files("LOOKRUN.obj", False, temp_files)

temp_files = [ "TESTFRAM", "POSUTST", "POSUPD", "VAR", "CONST" ]
link_test_files("POSRUN.obj", False, temp_files)

temp_files = [ "TESTFRAM", "WRAPTST", "WRAP", "VAR", "CONST" ]
link_test_files("WRAPRUN.obj", True, temp_files)

print("Linking Key Buffer Test Program")
temp_files = [ "KEYTST", "TESTUTIL", "KEY", "VAR", "CONST" ]
link_test_files("KEYRUN.obj", False, temp_files)

print("Linking Main Program")
temp_files = [
    "MAIN",
    "CONST",
    "INPUT",
    "WRAP",
    "POSUPD",
    "DISP",
    "KEY",
    "VDP",
    "LOOK",
    "ACT",
    "DSRLNK",
    "MENULOGIC",
    "UTIL",
    "HEADER",
    "VAR",
    "CACHETBL",
    "INIT",
    "IO",
    "EDTMGN",
    "MENU"
]
link_main_files("EMUWRITER", True, temp_files)

#Clean up
for file in glob.glob("*.lst"):
    os.remove(file)
for file in glob.glob("*.obj.temp"):
    os.remove(file)