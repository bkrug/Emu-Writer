# Emu-Writer
A Word Process for a TI-99/4a

My own attempt at a word processor for the TI-99/4a.
The goal of this project is to understand how a word processor would be written on older technology.
I hope that it will be better than TI-Writter/Word-Processor,
but it's not going to be better than a product available to you to run in Windows or Linux.
This project is a strange form of fun and a vanity project, not something that is practicle.

### Assembled files

There are several files in the source code which will load several assembled files at once.
See any file that ends "LOAD.TXT" as an example.
The laod files assume that all files are assembled with a ".O" extension and are located on DSK2.
So, MAIN.TXT is assembled into MAIN.O.

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

To run the program, assemble all files that are not unit test files.
You don't need to assemble any "LOAD.TXT" files except "MAINLOAD.TXT".
Load "DSK2.MAINLOAD.O" from E/A option 3.
Enter "LTEST" as the program name.

### VAR & CONST

CONST.TXT - Stores some constant values that are shared by at least two source code files

VAR.TXT - All areas of memory that can change should ideally be located here.
If the finished program is small enough, then I can simulate a ROM cartridge for most of the code.
But variables and workspaces will still need to be stored in the memory expansion RAM.

MEMBUF.O and ARRAY.O - Source code can be found at the repo: https://github.com/bkrug/TI-string-buffer.
These contain routines useful for storing things like strings and arrays.
