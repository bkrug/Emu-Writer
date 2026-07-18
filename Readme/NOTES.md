# TODO

Before release:
* Manually test more undo/redo with margins and DSK.BIG.BIG

Could be after the release:
* When splitting a paragraph, the "new" paragraph should always be the smaller of the two. This makes memory management easier.
* Consider adding a defrag operation that runs every 64/60s seconds.
* The save routine appears to ignore write-protection status. Use the PAB's STATUS op-code in order to fix that, or alternatively, simply refuse to overwrite any file that is not DSP/FIX 64.

# Manual test cases

* When the memeory is full, do the following and confirm that there are no graphical problems:
  * When the system cannot let you split paragraphs using the enter key, the document should not change.
  * When the system cannot let you merge paragraphs using the delete key, the document should not change.
  * When the system cannot let you insert new characters in an existing paragraph, the document should stop changing.
* Load the file "BIG". Press enter many times from the end of the document.
When the memory is full, the cursor stops blinking. Scroll up to the non-blank line, and it blinks again.
Scroll back down to the last empty line and it stops blinking again.
* Load the file "BIG". Go to the second character of the longest paragraph you can find.
Press enter once. We expect a memory full error.
Confirm that there are no empty elements in the undo list.
* Load the file "BIG". Go to an empty paragraph and type several characters with an arrow key in between each character.
  * We should NOT see undo list elements with the pointer >FFFF
  * We are hoping that the memory is too full to hold 16 undo objects. If that is the case, the undo list should contain the most recent actions, not the earliest.

# xdm99

## Disk image

(existing image name wo/ options) catalogue disk
-X craetes a blank disk image with the specified density & sidieness (i.e. dssd)
  -n disk name
-o clones the original disk applying specifed changes to the clone
-n rename disk
-C check disk for errors
-R attempt repair disk errors (mostly by deleting bad files!) (HINT: use with -o)
-Z change the density or sidieness

## Files in disk image

-e extract file(s)
  -N do not convert to lower-case
  -o specify a filename
  -o specify a directory to output several files
  -t include TIFILES header
  -9 include v9t9 header
-a add file(s)
  -n changes the name of the file being added
  -f file type (DIS/FIX 80 = DISFIX80 = df80)
-r rename file(s), separate old/new names with colon(:)
-d delete file(s)
-w toggle write-proection of file(s)
-p print file contents of file to stdout

## Alread extracted files

-I view header info of file
-P print contents of file
-F convert from the current header format
  -o name of copy
  -t to TIFILES format
  -9 to v9t9 format
  (neither -t nor -9) to headerless file
-T add header information to an extract file with none
  -f file type
  -n disk image file name
  -o new local file system name

## Archive

-K
-Y
-E
-A

# Commands

mame ti99_4a -ioport peb -ioport:peb:slot2 32kmem -ioport:peb:slot7 tirs232 -parl pio.txt -serl1 rs232.txt -ioport:peb:slot8 hfdc -window -cart "/home/bkrug/TI-99/carts-rpk/Programming/Editor-Assembler.rpk"  -flop1 "./EmuWriter.v0.4.dsk" -flop2 "./SampleDocuments.dsk"