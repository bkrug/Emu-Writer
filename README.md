# Emu-Writer
A Word Process for a TI-99/4a

My own attempt at a word processor for the TI-99/4a.
The goal of this project is to understand how a word processor would be written on older technology.
I hope that it will be better than TI-Writter/Word-Processor,
but it's not going to be better than a product available to you to run in Windows or Linux.
This project is a strange form of fund, not something that is practicle.

### SCRNWRT

SCRNWRT.TXT - a module that takes strings from the text buffer and creates a version that is viewable on screen.
It takes format information like bold, underline, and italic and inserts markers to represent the point at which the format changes.

SCRNTST.TXT - unit tests for SCRNWRT.TXT. 
If you assemble SCRNWRT and SCRNTST and have TESTUTIL.O, you can load all three files from Load and Run and Run RUNTST.

LSCRNTST.TXT - loads SCRNWRT.O, SCRNTST.O, and some other object code and runs the tests for you.
After loading, use LTEST to run.

### WRAP

WRAP.TXT - a routine to wrap text.

WRAPTST.TXT - unit tests for WRAP.TXT

LWRAPTST.TXT - loads WRAP.O, WRAPTST.O, and some other object code.
After loading, use LTSEST to run.

### VAR & CONST

CONST.TXT - Stores some constant values that are shared by at least two source code files

VAR.TXT - All areas of memory that can change should ideally be located here.
If the finished program is small enough, then I can simulate a ROM cartridge for most of the code.
But variables will still need to be stored in the memory expansion RAM.