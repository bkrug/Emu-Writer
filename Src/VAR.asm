* Areas of memory that absolutely have
* to be in RAM and could never be part
* of a cartridge ROM should go here.
*

*
* Definitions in this file
*
* Register Workspaces
       DEF  STRWS
       DEF  ARRYWS
       DEF  WRAPWS
       DEF  POSUWS,DISPWS
       DEF  MAINWS
       DEF  STACK
*
       DEF  VARBEG,VAREND
       DEF  FASTRT
* Memory Chunk Buffer
       DEF  BUFADR,BUFEND
* Arrays
       DEF  PARLST,FMTLST,MGNLST
       DEF  UNDLST
*
       DEF  PGHGHT,PGWDTH
* MAIN.asm
       DEF  DOCSTS
       DEF  CURTIM,CUROLD,CURRPL,CURMOD
* IO.asm
       DEF  VER2,PREVBM,PGELIN
* DSRLNK.asm
       DEF  A2032                  cru base for dsr
       DEF  A2034                  dsr address   "
       DEF  A2036                  name size     "
       DEF  A2038                  e o name ptr  "
       DEF  A203A                  counts        "
       DEF  A208C                  dsr name buffer
       DEF  DSRLWS
* WRAP.asm
       DEF  LNWDT1,LNWDTH,WINMOD
* INPUT.asm
       DEF  WRAP_START,WRAP_END
       DEF  PARINX,CHRPAX
       DEF  INSTMD,INPTMD
       DEF  UNDOIDX,UNDO_ADDRESS,PREV_ACTION
* POSUPD.asm
       DEF  LININX,CHRLIX
       DEF  WINOFF,WINPAR,WINLIN,WINMGN
       DEF  PRFHRZ,CURSCN
* KEY.asm
       DEF  TIMER,PREVKY,KEYBUF
       DEF  KEYSTR,KEYEND,KEYWRT,KEYRD
       DEF  SCANRT
* MENULOGIC.asm
       DEF  CURMNU
       DEF  FLDVAL,FLDVE
* HEADER.asm
       DEF  TWODIG
* End of Program
       DEF  MEMBEG,MEMEND

*
* Areas for workspace registers
*
       TEXT 'WORKSPCE'
MAINWS EQU  >8300
ARRYWS EQU  >8320
STRWS  EQU  >8330
WRAPWS BSS  >20
POSUWS
DISPWS BSS  >20

*
* >40-byte stack (>8380-83BF)
*
STACK  EQU  >83C0

*
* Areas for changeable values
*

       TEXT 'VARIABLE'
VARBEG
* Address of paragraph list
PARLST BSS  2
* Address of format list
FMTLST BSS  2
* Address of margin list
MGNLST BSS  2
* Address of list of undo/redo actions
UNDLST BSS  2
* Page height and width in lines and characters
PGHGHT BSS  1
PGWDTH BSS  1

* MEMBUF.O
* holds block size
* holds address of buffer
BUFADR BSS  >2
* holds first address after the buffer
BUFEND BSS  >2

* If something happens equivalent to throwing an exception,
* at the point that is like a catch-block,
* restore the Stack Pointer to this value.
FASTRT BSS  >2

* MAIN.asm
DOCSTS BSS  2
CURTIM BSS  2
CUROLD BSS  2
CURMOD BSS  2
CURRPL BSS  1

* IO.asm
VER2   BSS  1
PREVBM BSS  1
       EVEN
PGELIN BSS  2                  Remaining page lines

* DSRLNK.asm
A2032  BSS  2                  cru base for dsr
A2034  BSS  2                  dsr address   "
A2036  BSS  2                  name size     "
A2038  BSS  2                  e o name ptr  "
A203A  BSS  2                  counts        "
A208C  BSS  14                 dsr name buffer - needs to be direclty in front of DSRLNK's workspace
DSRLWS BSS  >20

* WRAP.asm
* Width of first paragraph line
* If there is no indent it will match
* LNWDTH.
LNWDT1 BSS  2
* General line width
LNWDTH BSS  2
* When reset, use windowed mode like TI-Writer
* Otherwise, use vertical mode
WINMOD BSS  2

* INPUT.asm
* If enter is pressed, or deletion of carriage return is undone,
* more than one paragraph will need to be undone.
WRAP_START   BSS  2
WRAP_END     BSS  2
*
* Master values
*
* Current Paragraph Index
PARINX BSS  2
* Character Index in Paragraph
CHRPAX BSS  2
*
* Window values
*
* Window horizontal offset
WINOFF BSS  2
* First Paragraph on screen
WINPAR BSS  2
* First line of paragraph on screen
WINLIN BSS  2
* If WINMGN = -1 and top screen paragraph has margin entry, display it.
* If WINMGN = 0, do not display margin entry for top paragraph.
WINMGN BSS  2
* Prefered Horizontal Position
* Set to -1 if vertical movements should use current horizontal position.
* Set to non-negative values if vertical movements should attempt to move to that position.
PRFHRZ BSS  2
*
* Modes
*
* Insert Mode. 0 = insert, -1 = overwrit
INSTMD BSS  2
* Input mode. 0 = unspecified,
* 1 = text, 2 = movement
INPTMD BSS  2
* Address of the current undo action
UNDOIDX           BSS  2
* Address of the current undo action
UNDO_ADDRESS      BSS  2
* Previous action
* Address of most recent input routine to be processed
PREV_ACTION       BSS  2

* POSUPDT.asm
*
* Calculated values. Dependent on Master and Window values.
*
* Position of flashing cursor on screen
CURSCN BSS  2
*
* Hopefully obsolete values.
*
* Line Index in Paragraph
LININX BSS  2
* Character Index in line
CHRLIX BSS  2

* KEY.asm
* Time remaining before character repeat
TIMER  BSS  2
* Scan return address
SCANRT BSS  2
* The previously detected key press.
* Wait a while before letting this key
* repeat.
PREVKY BSS  1
       EVEN
* First address of key buffer
KEYSTR
* Buffer to store keypresses
KEYBUF BSS  >10
* First address after key buffer
KEYEND 
* Address where the next keypress 
* should be stored.
KEYWRT BSS  2
* Next address to read a keypress from.
* If the value here is equal to the
* value in KEYWRT, then there are no
* new characters to write.===
KEYRD  BSS  2

* MENULOGIC.asm
CURMNU BSS  2
FLDVAL BSS  80
FLDVE

* HEADER.asm
* Space for ASCII for two-digit number
TWODIG BSS  2

VAREND
       TEXT 'ENDOFPRG'

*
* Buffer for text
*
MEMBEG EQU  >A000
MEMEND EQU  >F780
       END

* Addresses >FFD8 through >FFFF are used for XOP 1 on the TI-99/4A. 
* --- E/A manual 24.2.1.1 (page 400)

       END