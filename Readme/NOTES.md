### TODO

* BUG: word wrap does not always happen after deleting a CR now.
* When creating the disk image, write-protect the program files.
* When splitting a paragraph, the "new" paragraph should always be the smaller of the two. This makes memory management easier.
* Consider adding a defrag operation that runs every 64/60s seconds.
* The save routine appears to ignore write-protection status. Use the PAB's STATUS op-code in order to fix that, or alternatively, simply refuse to overwrite any file that is not DSP/FIX 64.

### Manual test cases

* When the memeory is full, do the following and confirm that there are no graphical problems:
  * When the system cannot let you split paragraphs using the enter key, the document should not change.
  * When the system cannot let you merge paragraphs using the delete key, the document should not change.
  * When the system cannot let you insert new characters in an existing paragraph, the document should stop changing.
* Load the file "BIG". Press enter many times from the end of the document.
When the memory is full, the cursor stops blinking. Scroll up to the non-blank line, and it blinks again.
Scroll back down to the last empty line and it stops blinking again.

### Personal Notes

mame ti99_4a -ioport peb -ioport:peb:slot2 32kmem -ioport:peb:slot7 tirs232 -parl pio.txt -serl1 rs232.txt -ioport:peb:slot8 hfdc -window -cart "/home/bkrug/TI-99/carts-rpk/Programming/Editor-Assembler.rpk" -flop1 "./EmuWriter.Tests2.dsk" -flop2 "./EmuWriter.v0.4.dsk" 