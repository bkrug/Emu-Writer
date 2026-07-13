Unlike the main README file,
this documentation is pretending to target a 1980s audience.
So it might say some things that seem a little bit obvious to a user in the 21st century.

# Loading Emu-Writer

Emu-Writer requires at least one floppy drive and the TI-99/4a 32K memory expansion.
A printer is recommended.

Place the included floppy disk in any drive.
Insert your Editor/Assembler cartridge into your TI-99/4a.
From the TI startup screen, press any key.
From the next menu, presss "2" for "Editor / Assembler".
From the Editor/Assembler menu press "5" for "Run Program File".
Type "DSK.EMU.EMUWRITER" or "DSKx.EMUWRITER" and press ENTER, replacing "x" with a number corresponding to your floppy drive.

This will load the Emu-writer program from disk.
When loading is complete, you will see a title screen with the program's name.
Press ENTER or SPACE from the title screen, and you will enter the word-processor's "editor".
From here you can begin typing a document, but there is additional functionality described below.

# Writing, inserting, and ovewriting text

When you first load Emu-Writer, the editor is empty.
Pressing keys for any visible character of text, will result in adding characters to the screen and to the document's first paragraph.
The editor displays white text on a purple background, but the top two lines of the screen have the colors inverted.
Those top two lines, show information about your document.
You can't edit them directly, but they will prove to be useful later.

You can begin a new paragraph at any time by pressing ENTER.
Pressing enter from the end of a paragraph will start a new paragraph.
Pressing enter from the middle of a paragraph will split the paragraph into two.
(You can merge the paragraphs back together with either delete key.)
Separate paragraphs will always word wrap separately, so the end of a paragraph will always be the end of a line-of-text.
But the word processor will automatically decide where to end any other line of text.

By default, the cursor is in insert mode.
You can tell that the flashing cursor is in this mode when it is just as tall as capital letters.
You can type text from wherever the cursor is located without overwriting what text already exists.
When the cursor is in the middle of a paragraph, pressing a key for visible text will cause other characters to move over by one position and make space for what you typed.
When the cursor is at the end of a paragraph, pressing a key for visible text will make the paragraph one character longer.

Press FCTN+2 (hold down the FCTN key and press 2) to switch between insert and ovewrite mode.
This changes the cursor from a box that is tall and narrow, to a box that is short and wide.
When the cursor is in the middle of a paragraph now, pressing a key for visible text will replace the character under the cursor with whatever you typed.
However when the cursor is at the end of a paragraph, overwrite mode has the same behavior as insert mode.
Likewise, the ENTER key has the same behavior in both of these modes.

You can delete characters that you don't want any more.
Press FCTN+1, to delete the character that is located at the cursor's position.
This will work the same way in insert and ovewrite mode.
Press FCTN+3, to delete the character directly to the left of the cursor.
This has the same effect as pressing FCTN+S first, and then FCTN+1.

Emu-writer has an automatic word wrap feature.
Meaning that the word processor tries to fit as many words as possible on one line,
but will move a word to the next line if there is no room for it on an earlier line.
So as you delete characters or insert new characters from the beginning or middle of a paragraph,
new space will become available or be taken away from some lines of text.
So the word processor will often move some of the words to different lines, but the order of the words within a paragraph will never change.

# Movement keys and "hot keys"

When you wish to move the cursor, you can use arrow keys that you may be familiar with from TI Basic, or other TI-99/4a programs.
Hold down the FCTN key and press S to move the cursor one space to the left.
If the cursor is already at the left-most position within a line, holding FCTN and pressing S will bring the cursor to the right-most position in the previous line.
Hold down the FCTN key and press D to move the cursor one space to the right.
Hold down the FCTN key and press either E or X to move the cursor up or down by one line.

When you first load Emu-writer, the screen is inside of the editor.
The top of the editor screen mentions the key combination FCTN+8, which is used to see a list of "hot keys".
Hold down the FCTN key and press 8.
This will give you a list of keys that you can press from the editor, but they do not type text.
These are called "hot keys".
When you are done reading this screen press FCTN+9 to return to the editor.

Some hot keys have been described earlier in this document, such as FCTN+1, FCTN+2, and FCTN+3.

Some hot keys give you additinal ways to move the cursor.
For example, FCTN+4 is called "page down" because it will move the cursor down by one screen.
In other words, the cursor will move to 22 lines of text later in the document.
It is the same as pressing FCTN+X 22 times.
FCTN+6 is called "page up", and is like pressing FCTN+E 22 times.

FCTN+L and FCTN+; will move the cursor to the beginning or end of the current line.

Also note that in many TI-99/4a programs FCTN+= will cause the computer to restart, but this key doesn't do anything in Emu-writer.
See the section "Operations Menu", to learn how to quit the program.

Other hot keys are described in other sections of this documentation,
but you can keep coming back to the hot key screen using FCTN+8, for a reminder of the available hot keys.

# Handling 80+ columnn text on a 40-column screen

The TI-99/4a can only display 40 characters of text on a single line on the screen.
Most users have printers which can fit at least 80 characters on one line of the page.
By default, Emu-writer assumes that you would like to have a left and right margin that are 10-characters long.
This leaves up to 60 characters of visible text per line.
(See "Margins" to learn how to change the default.)

Since the characters-per-line is different between the screen and your printer, we must adopt one of two strategies to display text on screen.
Emu-writer allows you to switch between either of these strategies instantly, using the key FCTN+0.

### Vertical Mode

One strategy for dealing with different line lengths on the screen and printer is called "Vertical Mode".
In this mode, the word wrap logic chooses to display shorter lines of text on screen than on paper,
meaning that the line breaks on screen will not match up with what you see when you print the document.
The paragraph on screen will normally have more lines than the same paragraph on paper, even thought the actual words are the same.
Often, the user can see the entire paragraph on screen at once, even though it is longer than 40-characters.

"Vertical mode" is useful when you wish to review your document on screen before printing.
It allows you to read the entire document from start to finish, and the only movement keys you need to press are Page Down/Page Up (FCTN+4/FCTN+6).
With some word processors, improving your document may require that you print a first draft and read it.
When using those other word processors, the user may need to mark spelling and grammar mistakes with a pencil and then return to the word processor to make changes.
But vertical mode is designed to let the user do all of their edting on screen, and the final draft is the only one that needs to be printed.

If you print a document while in vertical mode, the word wrap logic will print line endings that are logical on paper without chaning what you see on screen.
Meaning that printing a document while in vertical mode, will NOT result in 40-character long lines on paper.

The maximum length of a line of text in vertical mode is not 40 characters, despite what one might assume.
Instead, the rightmost possible visible character can appear in the 39th position of a line.
An unlimited number of space-characters can appear following the 39th character.
Therefore, it is possible to position your cursor on the 41st or later character of that line, and the word processor might hide the leftmost 20 characters of that line.
If you begin typing, nothing bad will happen.
The word processor will make sure that any new non-space word wraps to the next line.
Alternatively, if you don't want to type anything, press FCTN+L or an arrow key to return the cursor to the beginning of the line.

### Windowed Mode

Another stragey is called "Windowed mode".
This causes lines of text to be the same length on screen that they would be on paper.
But that means that the user might not be able to see the entire lines of text on screen at once.
Instead, the user has a 40-character long "window" into the text.

When your cursor is at the beginnin of a line of text that is about 60 characters long,
you will be able to see the left-most 40 characters.
If you hold down the right arrow key (FCTN+D) for long enough, the cursor will move to the 41st character,
causing the window to move.
The window moves in increments of 20 characters,
so now you will be able to see the 21st through 60th character instead of the 1st through 40th.

You can also use FCTN+5 to move between windows faster.

There is no theoretic limit to the number of windows you can have.
For example, some user may have a printer that defaults to 12 characters per inch and uses paper that is 11-inches wide.
If the paragraph is set up to have 0-character margins, then lines can have up to 131 characters.
The user will need to press FCTN+5 to move through seven different windows to see an entire line of text.
(See the "Margins" section of this documentation to configure a document and paragraph for this setting.)

Windowed Mode is useful when you want to see where the lines of text within a paragraph will end before you print the document.

### Switching Modes

You can swtich between modes using the FCTN+0 hot key.
At the right edge of the second line of the editor, there is an icon which indicates which mode you are in.
The vertical mode icon looks like an arrow pointing down.
The windows mode icon looks like a parallelagram or a window tilted sideways.

To experiment with these different modes, load the sample documents from the Emu-writer program disk.
These documents are called THREELANG and HANSEL.

# Operations Menu

From the editor, you can press FCTN+9 (hold down the FCTN key while pressing 9) to see the operations menu.
You can press FCTN+9 again to return to the editor.

The operations menu allows you to work with your document in ways that do not involve typing.
These include saving, loading, or printing your document.
They alos include changing margins.

Note that from the first menu you can press "F" to go to the "Files" sub-menu.
From there you can press "S" to save or "L" to load.

### Loading and Saving

To load a file, from the editor screen press FCTN+9, then press "F", then press "L".
This brings you to a screen where you can type a file name.
If the Emu-writer program disk is in drive 1, type "DSK1.THREELANG" or "DSK1.HANSEL" to load an example file.

Saving a file is almost the same.
From the editor screen press FCTN+9, then press "F", then press "S".
You will see a similar screen for saving the file.

Emu-writer files are saved as DIS/INT 64 files.
There is no mechinisam to prevent you from overwriting a file.

### Printing

From the editor screen, press FCTN+9, then press "F", then press "P".

When printing you will be asked to specify a printer name.
If your printer is connected through a serial port, specify "RS232" or "RS232/2" as the printer name.
If your printer is connected through a parallel port, specify "PIO" as the printer name.
Do not add the ".CR" or ".LF" suffixes to your printer name.

You can specify a filename as the printer name if you want.
The file on disk will be of type DIS/VAR 254.

If you are from the future, you might be using the emulator Classic 99.
You may use "CLIP" as the printer name.
When the print operation is complete, leave your emulator and open a generic text editor.
Paste the contents of your clipboard into the text editor, in order to see the document formated for paper.

### New document

The new-document function will erase the document in memory and restore Emu-writer to the state it was in at load time.
From the editor screen, press FCTN+9, then press "F", then press "N".
The screen will ask you to confirm that you are willing to erase the document.
If you say "Y" for yes, it will return you to the editor screen with a blank document.
Otherwise, it will return you to the editor screen and you can continue to edit the existing document.

### Quit

From the editor screen, press FCTN+9, then press "F", then press "N".
If you confirm that you want to quit, the TI-99/4a will restart.
Otherwise, the program will return you to the document you were editing.

### Margins Screen

To edit paragraph margins or page settings, from the editor screen press FCTN+9, then "M".

The margin screen allows you to change the page size or the paragraph margins.
Page sizes stay the same for the entire document.
Pargraph magins can be different for different paragraphs.

From the margin screen, you can see two fields that allow you to set the document's page size.
The page width measures the page width in characters.
The page height measures the page height in lines.
The user must know how many characters per page and how many lines per page their printer is designed to print.

Most users have printers that can print either 80 or 85 characters per line and 66 lines per page are common settings.
But you may need to change these values based on:
- paper size in inches
- your printer's default number of characters per inch
- your printer's default number of lines per inch

Do not account for margins when specifying the page size.
This is handled by the margins.

Each paragraph can have margins associated with it.
The user is allowed to specify left, right, top, and bottom margins.
The user can also specify a first line indent or a haning indent.
A first line indent moves the beginin of the first line further left than is specified by the left margin.
A haning indent means that every line except the first line will be indented further left than is required by the left margin.

When you reach the margin screen, the word processor remembers which paragraph your cursor was located in from the editor screen.
When you specify new margins, a margin descriptor will be visible above the current paragraph in editor screen.
This margin descriptor is displayed with inverted text and will not be printed.
Also notice that from anywhere in the document, the top of the screen displays labels "LM", "RM", "IN", "TM", and "BM" followed by a number.
This reports the size of the left, right, indent, top, and bottom margins for which ever paragraph the cursor is in.
Even if there is no margin descriptor visible on screen for a particular paragaph, you can still see the current margins.

When you specify new margins for one paragraph,
the margins will apply to every paragraph after that until the word processor finds another margin descriptor.
For example, you might specify left and right margins of 20 on the twentith paragraph in your document.
Then you might move to the fifteenth paragraph in your document and specify left and right margins of 15.
The 16th, 17th, 18th, and 19th paragraphs will have the same margins as the 15th, but the 20th and later will continue to have 20-character left and right margins.

The top and bottom margins are non-intuitive.
If the margin descriptor is applied to the first paragraph on a page, then the top and bottom margins will apply to that page and every page after it.
If the margin descriptor is applied to a different paragraph on a page, then the top and bottom margins do not take effect until the next page.

If the word processor notices a margin descriptor with settings that are identical to the most recent earlier margin descriptor, it will delete the second one.
For example, you might specify margins for the fifth paragraph.
You change your mind, and decide that you would like those settings to apply to the third and fourth paragraphs.
When you change the settings for the third paragraph, the word processor will notcie that the settings for the fifth paragraph are identical, and will be deleted.

Margins are not WYSIWYG.
You cannot see extra blank spaces on screen to represent the margins.
You will only see them when printing the document.
But you can see the indents on screen.
In windowed mode, the indents on screen will match the indents on paper.
In vertical mode, the indents that do not exceed 20 characters will match the indents on paper.
You can specify indents of larger than 20 characters, and they will print to the size you specify, but on screen in vertical mode they will be displayed as 20 character margins.

Again, page width and height is the same for the entire document.
If you have multiple margin descriptors in your document.
Changing the page size for one margin descriptor will change the page size for any other margin descriptor.
You can only see the page size from the Margin screen; you cannot see it form the editor.

# Undo/Redo

If you make a mistake you can press the "undo" button, CTRL+Z.
For example, perhaps you press FCTN+1 five times to delete five consecutive characters.
Then you change your mind.
You can hold down CTRL and press Z to restore those five characters.

CTRL+Y is the "redo" key.
If you change your mind again, you can press CTRL+Y and it will delete the characters that you just restored.

Deleting, inserting, and overwriting characters and be undone and redone.
Changing margins can be undone and redone.
Pressing CTRL+Z more than one time will undo more than one consecutive change.
The same is true for CTRL+Y.

Emu-writer will remember up to 16 undo/redo events and will forget older events.
Deleting 5 consecutive characters, without moving the cursor, is an example of a single event.
Deleting up to 255 consecutive characters can be one event, but deleting 256 characters will be regarded as two events.
So, you would need to press CTRL+Z twice to restore all of them.
Deleting some characters, moving the cursor, and deleting more characters counts as two undo/redo events.
So, you would need to press CTRL+Z twice to restore all of them.
Deleting some characters, typing some characters, and deleting more characters counts as three events.
So, you would need to press CTRL+Z three times to restore all of the characters and remove the ones you inserted.

Here is a list of all possible undo/redo events:
- deleting up to 255 consecutive characters using FCTN+1 without pressing a key that moves the cursor
- deleting up to 255 consecutive characters using FCTN+3 without pressing a key that moves the cursor
- inserting up to 255 consecutive characters without pressing a key that moves the cursor
- ovewriting up to 127 consecutive characters without pressing a key that moves the cursor
- changing the margins for any one paragraph

Again, typing more than 255 consecutive characters can still be undone.
But Emu-writer will break that up into multiple events.