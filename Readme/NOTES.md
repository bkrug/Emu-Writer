### TODO

Before release:
* Copy the documentation readme file into the Emu-writer program disk.
* Try to do away with PREV_ACTION
* Make all undo-actions a consistent length, right from the time they are initialized. Do away with the potential that we could have problems growing an undo action to insert a character.
* Manually test more undo/redo with margins and DSK.BIG.BIG
* CAN WE REPRODUCE THIS BUG: word wrap does not always happen after deleting a CR now.
* Upon a memory error, if the item at the end of the undo list is empty, delete it.

Could be after the release:
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