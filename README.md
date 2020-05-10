# Emu-Writer
A Word Process for a TI-99/4a

My own attempt at a word processor for the TI-99/4a.
The goal of this project is to understand how a word processor would be written on older technology.
I hope that it will be better than TI-Writter/Word-Processor,
but it's not going to be better than a product available to you to run in Windows or Linux.
This project is a strange form of fun and a vanity project, not something that is practicle.

### SCRNWRT

SCRNWRT.TXT - a module that takes strings from the text buffer and creates a version that is viewable on screen.
It takes format information like bold, underline, and italic and inserts markers to represent the point at which the format changes.

SCRNTST.TXT - unit tests for SCRNWRT.TXT. 
If you assemble SCRNWRT and SCRNTST and have TESTUTIL.O, you can load all three files from Load and Run and Run RUNTST.

SCRNLOAD.TXT - loads SCRNWRT.O, SCRNTST.O, and some other object code and runs the tests for you.
After loading, use LTEST to run.

### WRAP

WRAP.TXT - a routine to wrap text. This code depends on ARRAY.TXT and MEMBUF.TXT.

WRAPTST.TXT - unit tests for WRAP.TXT

WRAPLOAD.TXT - loads WRAP.O, WRAPTST.O, and some other object code.
After loading, use LTSEST to run.

### ARRAY

ARRAY.TXT - a set of routines for managing arrays in Assembly.
All arrays have items whose size is a power of two (2,4,8,16, ...).
The routines allow you to insert, add, or delete items.
You can also get the address of an item with a given index.
These routines depend upon MEMBUF.TXT

ARRYTST.TXT - Array tests

ARRYLOAD.TXT - Loads and runs array tests and their dependencies.

### KEY

KEY.TXT - contains a routine that takes input from the keyboard and places it in a key-press buffer.
If some part of the program is processing data for a long time, a user's keystrokes will still be stored and processed.
The routine is meant to be run from an interrupt.

KEYTST.TXT - a demo of the routine in KEY.TXT.
It displays the contents of the key-press buffer on the top row of the screen.
On the rest of the screen it shows the contents being copied from the buffer to another area of memory.
The demo uses a delay to simulate being busy.
This demonstrates copying the key presses out of the buffer without loosing them every once in a while.

### INPUT

INPUT.TXT - a routine that reads the contents of the key-press buffer and processes different key strokes.
This may include adding text to a string, or using an arrow key.

### VAR & CONST

CONST.TXT - Stores some constant values that are shared by at least two source code files

VAR.TXT - All areas of memory that can change should ideally be located here.
If the finished program is small enough, then I can simulate a ROM cartridge for most of the code.
But variables and workspaces will still need to be stored in the memory expansion RAM.

MEMBUF.O - Source code can be found at the repo: https://github.com/bkrug/TI-string-buffer.
This is a routine useful for storing things like strings.
