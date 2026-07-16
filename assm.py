# Run this script with XAS99 to assemble all files
# See https://endlos99.github.io/xdt99/
#
# If you can't run powershell scripts research this command locally:
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
import os, glob
from itertools import chain

#Functions
WORK_FOLDER = "Fiad"

def get_work_file(filename):
    return os.path.join(WORK_FOLDER, filename)

def get_unlinked_string(include_membuf, object_files):
    unlinked_files = []
    for object_file in object_files:
        unlinked_files.append(get_work_file(object_file + ".obj.temp"))
    # These can't be the first files in the list because the first byte is not the program start
    # These can't be at the end, because the main program gets auto-split into smaller pieces
    if include_membuf == True:
        unlinked_files.insert(1, "MEMBUF.noheader.obj")    
        unlinked_files.insert(2, "ARRAY.noheader.obj")
    return " ".join(unlinked_files)

def link_test_files(linked_file, include_membuf, object_files):
    unlinked_files_string = get_unlinked_string(include_membuf, object_files)
    link_command_1 = "xas99.py -l {source} -o {output}"
    link_command_2 = link_command_1.format(source = unlinked_files_string, output = get_work_file(linked_file))
    os.system(link_command_2)

# We load the program at address >A002 so that we can put a buffer allocation header at >A000.
# In MAIN.asm, see BUFFER_ALLOCATION_LOOP and BUFFER_ADDRESSES,
# where we mark the program as belonging to a filled block.
def link_main_files(linked_file, include_membuf, object_files):
    unlinked_files_string = get_unlinked_string(include_membuf, object_files)
    link_command_1 = "xas99.py -i -a \">A002\" -l {source} -o {output}"
    link_command_2 = link_command_1.format(source = unlinked_files_string, output = get_work_file(linked_file))
    os.system(link_command_2)

#Assemble Src and Tests
srcPath = os.path.join("Src")
testsPath = os.path.join("Tests")
files1 = os.scandir(srcPath)
files2 = os.scandir(testsPath)
files = chain(files1, files2)

for file_obj in files:
    print("Assembling " + file_obj.name)
    list_file = get_work_file(file_obj.name.replace(".asm", ".lst"))
    obj_file = get_work_file(file_obj.name.replace(".asm", ".obj.temp"))
    assemble_command_1 = "xas99.py -q -S -R {source} -L {list} -o {obj}"
    assemble_command_2 = assemble_command_1.format(source = file_obj.path, list = list_file, obj = obj_file)
    os.system(assemble_command_2)

print("Linking Unit Test Runners")
temp_files = [ "TESTFRAM", "ACTTST", "ACT", "UTIL", "TESTVAR", "VAR", "CONST" ]
link_test_files("ACTRUN.obj", True, temp_files)

temp_files = [ "TESTFRAM", "DISPTST", "DISP", "UTIL", "POSUPD", "HEADER", "TESTVAR", "VAR", "CONST" ]
link_test_files("DISPRUN.obj", True, temp_files)

temp_files = [ "TESTFRAM", "DISPTSTA", "DISP", "UTIL", "POSUPD", "HEADER", "TESTVAR", "VAR", "CONST" ]
link_test_files("DISPARUN.obj", True, temp_files)

temp_files = [ "TESTFRAM", "INPTTST", "INPUT", "UNDO", "ACT", "WRAP", "UTIL", "TESTVAR", "VAR", "CONST" ]
link_test_files("INPTRUN.obj", True, temp_files)

temp_files = [ "TESTFRAM", "UNDOTST", "INPUT", "UNDO", "ACT", "WRAP", "UTIL", "TESTVAR", "VAR", "CONST" ]
link_test_files("UNDORUN.obj", True, temp_files)

temp_files = [ "TESTFRAM", "POSUTST", "POSUPD", "UTIL", "TESTVAR", "VAR", "CONST" ]
link_test_files("POSRUN.obj", True, temp_files)

temp_files = [ "TESTFRAM", "WRAPTST", "WRAP", "UTIL", "TESTVAR", "VAR", "CONST" ]
link_test_files("WRAPRUN.obj", True, temp_files)

temp_files = [ "TESTFRAM", "MGNTST", "TESTVAR", "VAR", "CONST", "UNDO", "EDTMGN" ]
link_test_files("MGNRUN.obj", True, temp_files)

print("Linking Key Buffer Test Program")
temp_files = [ "KEYTST", "KEY", "VAR", "CONST" ]
link_test_files("KEYRUN.obj", False, temp_files)

print("Linking Main Program")
temp_files = [
    "MAIN",
    "CONST",
    "INPUT",
    "UNDO",
    "WRAP",
    "POSUPD",
    "DISP",
    "KEY",
    "VDP",
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
for file in glob.glob(os.path.join(WORK_FOLDER, "*.lst")):
    os.remove(file)
for file in glob.glob(os.path.join(WORK_FOLDER, "*.obj.temp")):
    os.remove(file)

# Extract MANUAL from floppy image to .MD file
os.system("xdm99.py SampleDocuments.dsk -e MANUAL1 -o Readme/MANUAL1.md")
os.system("xdm99.py SampleDocuments.dsk -e MANUAL2 -o Readme/MANUAL2.md")

# Strip the 16-byte FIAD header and any trailer after the ASCII ETX (code 3) marker
def clean_manual_file(path):
    with open(path, "rb") as f:
        data = f.read()
    data = data[16:]
    etx_index = data.find(3)
    if etx_index != -1:
        data = data[:etx_index]
    with open(path, "wb") as f:
        f.write(data)

clean_manual_file("Readme/MANUAL1.md")
clean_manual_file("Readme/MANUAL2.md")

# Create disk image
print("Creating disk image")
disk_image = os.path.join('EmuWriter.v0.4.dsk')
# Clone the sample documents disk, removing files that end users don't need
os.system("xdm99.py SampleDocuments.dsk -d BIG ITCH NOTEMUDOC VERTOOHIGH -o " + disk_image)
# Rename the disk as the Emu-writer program disk
os.system("xdm99.py " + disk_image + " -n EMU")
program_files = glob.glob(os.path.join(".", WORK_FOLDER, "EMUWRITE*"))
for program_file in program_files:
    if not program_file.endswith(".dsk"):
        # Add the program files to disk
        add_command_1 = "xdm99.py {disk_image} -a {program_file} -f PROGRAM"
        add_command_2 = add_command_1.format(disk_image = disk_image, program_file = program_file)
        os.system(add_command_2)
        # Write-Protect the program files
        protect_command_1 = "xdm99.py {disk_image} -w {program_file}"
        protect_command_2 = protect_command_1.format(disk_image = disk_image, program_file = program_file.replace("./Fiad/", ""))
        os.system(protect_command_2)

# Create test-runner disk image
print("Creating test-runner disk images")
disk_image = os.path.join('EmuWriter.Tests1.dsk')
os.system("xdm99.py -X dsdd -n EMUTEST " + disk_image)
#
add_command_1 = "xdm99.py {disk_image} -a ./Fiad/EDIT1 -n EDIT1"
add_command_2 = add_command_1.format(disk_image = disk_image)
os.system(add_command_2)
#
object_files = ["ACTRUN.obj", "DISPRUN.obj", "DISPARUN.obj", "INPTRUN.obj", "KEYRUN.obj", "POSRUN.obj", "WRAPRUN.obj"]
for object_file in object_files:
    # Add the program files to disk
    add_command_1 = "xdm99.py {disk_image} -a {object_file} -n{file_name} -f DIS/FIX80"
    file_and_path = os.path.join(".", "Fiad", object_file)
    add_command_2 = add_command_1.format(disk_image = disk_image, object_file = file_and_path, file_name = object_file.replace(".obj", ""))
    os.system(add_command_2)

disk_image = os.path.join('EmuWriter.Tests2.dsk')
os.system("xdm99.py -X dsdd -n EMUTEST " + disk_image)
#
add_command_1 = "xdm99.py {disk_image} -a ./Fiad/EDIT1 -n EDIT1"
add_command_2 = add_command_1.format(disk_image = disk_image)
os.system(add_command_2)
#
object_files = ["UNDORUN.obj", "MGNRUN.obj"]
for object_file in object_files:
    # Add the program files to disk
    add_command_1 = "xdm99.py {disk_image} -a {object_file} -n{file_name} -f DIS/FIX80"
    file_and_path = os.path.join(".", "Fiad", object_file)
    add_command_2 = add_command_1.format(disk_image = disk_image, object_file = file_and_path, file_name = object_file.replace(".obj", ""))
    os.system(add_command_2)

# Add TIFILES header to all object files
print("Adding TIFILES header")
for file in glob.glob(os.path.join(WORK_FOLDER, "*.obj")):
    if not file.endswith(".noheader.obj"):
        header_command_1 = "xdm99.py -T {object_file} -f DIS/FIX80 -o {object_file}"
        header_command_2 = header_command_1.format(object_file = file)
        os.system(header_command_2)

# Add TIFILES header to EMUWRITER
for program_file in program_files:
    if not program_file.endswith(".dsk"):
        header_command_1 = "xdm99.py -T {program_file} -f PROGRAM -o {program_file}"
        header_command_2 = header_command_1.format(program_file = program_file)
        os.system(header_command_2)