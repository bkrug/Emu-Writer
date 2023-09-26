# Emu-Writer
A Word Process for a TI-99/4a

My own attempt at a word processor for the TI-99/4a.
The goal of this project is to understand how a word processor would be written on older technology.
It's fun to imagine that it will be better than TI-Writter/Word-Processor,
but it's not going to be better than a product available to you to run in Windows or Linux.
This project is a strange form of fun and a vanity project, not something that is practicle.

Emu-writer distinguishes itself from TI-Writer with the following featues.

* When you wish to insert text into the middle of a paragraph, just move the cursor to the desired location and start typing.
No need to press FCTN+2 followed by CTRL+2
* FCTN+3 is used as a backspace-delete key.
* FCTN+0 is used to switch between Vertical mode and Windowed mode.
  * Windowed mode works the same as TI-Writer;
when paragraphs will be more than 40 characters wide on paper,
it is necessary for the screen to move to the left or right within a page.
  * Vertical mode assumes that a user wants to read text from the screen.
On screen, the wrap algorithm assumes a paragraph width of 39 characters,
even though the printed document will have wider paragraphs.
  * It is not necessary to switch modes before printing.
The print algorithm automatically wraps the paragraphs for 80-columns.
  * I realize that this is possible in TI-Writer, but that program makes it less intuitive.
The user has to know how to wield the Editor's margin-and-tab configuration in a way that is complemented by the Formater program.

### External Dependencies

MEMBUF.noheader.obj and ARRAY.noheader.obj - Source code can be found at the repo: https://github.com/bkrug/TI-string-buffer.
These contain routines for allocating and de-allocating space for variable-length objects like strings and arrays.

### Taglines

EMU-WRITER -- A semi-modern word processor for a semi-modern world.

EMU-WRITER -- Be a little late to the party.

EMU-WRITER -- WYSIWhaaaaaat?

EMU-WRITER -- You didn't think you needed it, but now you know for sure.

### TODO

* Consider adding a defrag operation that runs every 64/60s seconds.
* Move more variables to the scratch PAD.
* Identify code in MAIN.asm that can be moved to the physical end of the program and eventually overwritten.
