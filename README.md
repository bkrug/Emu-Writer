# Emu-Writer
A Word Process for a TI-99/4a

My own attempt at a word processor for the TI-99/4a.
The goal of this project is to understand how a word processor would be written on older technology.
I hope that it will be better than TI-Writter/Word-Processor,
but it's not going to be better than a product available to you to run in Windows or Linux.
This project is a strange form of fun and a vanity project, not something that is practicle.

### Assembled files

All the assembly code in this repo currently uses the extension "TXT".
The source code assumes that any assembled object code has an extension of "O" and is placed in "DSK2".
For example, MAIN.TXT is assembled into DSK2.MAIN.O.
If you wish to use a different extension for object code or store it in a different disk,
Edit the files ending "LOAD.TXT" in your local files.
These contain lists of dependent object code.
Some of the "TST" files also contain an filename to output test results to.

### Unit Tests

Files with "TST" in their name contain unit tests.
To run any particluar set of unit tests, you can run a file whose name ends "LOAD.O" form E/A option 3.
Press ENTER and type "LTEST" as the program name.

For example, DISPTST.TXT contains tests that test the logic in DISP.TXT. 
DISPLOAD.TXT contains code to load DISP.O and its dependencies from DSK2.
DISPLOAD.TXT contains a list of all the required files, and thus can be used to decide which files to assemble.

There are some files TESTUTIL.TXT and TESTFRAME.TXT in the source code.
TESTUTIL.TXT is the old test framework.
TESTFRAME.TXT is the new test framework.

### Running the program

To run the program, assemble MAINLOAD.TXT as DSK2.MAINLOAD.O, and assemble all of the files that are listed in MAINLOAD.
Load "DSK2.MAINLOAD.O" from E/A option 3.
Enter "LTEST" as the program name.

### VAR & CONST

CONST.TXT - Stores some constant values that are shared by at least two source code files

VAR.TXT - All areas of memory that can change are to be located here.
If the finished program is small enough, then I can simulate a ROM cartridge for most of the code.
But variables and workspaces will still need to be stored in the memory expansion RAM.

### External Dependencies

MEMBUF.O and ARRAY.O - Source code can be found at the repo: https://github.com/bkrug/TI-string-buffer.
These contain routines for allocating and de-allocating space for variable-length objects like strings and arrays.
