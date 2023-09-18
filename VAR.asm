* Areas of memory that absolutely have
* to be in RAM and could never be part
* of a cartridge ROM should go here.
*

*
* Definitions in this file
*
* Register Workspaces
       DEF  STRWS
       DEF  LOOKWS,ARRYWS
       DEF  WRAPWS
       DEF  INPTWS,POSUWS,DISPWS
       DEF  A208C
       DEF  DSRLWS,MAINWS
       DEF  STACK
*
       DEF  VARBEG,VAREND
* Memory Chunk Buffer
       DEF  BUFADR,BUFEND
* Arrays
       DEF  LINLST,FMTLST,MGNLST
* MAIN.TXT
       DEF  CURTIM,CUROLD,CURRPL,CURMOD
* WRAP.TXT
       DEF  LNWDT1,LNWDTH,WINMOD
* INPUT.TXT
       DEF  PARINX,CHRPAX
       DEF  INSTMD,INPTMD
* POSUPD.TXT
       DEF  LININX,CHRLIX
       DEF  WINOFF,WINPAR,WINLIN
       DEF  CURSCN
* KEY.TXT
       DEF  TIMER,PREVKY,KEYBUF
       DEF  KEYSTR,KEYEND,KEYWRT,KEYRD
       DEF  SCANRT
* MENULOGIC.asm
       DEF  CURMNU
       DEF  FLDVAL,FLDVE
* End of Program
       DEF  MEMBEG,MEMEND

*
* Areas for workspace registers
*
       TEXT 'WORKSPCE'
MAINWS EQU  >8300
A208C  BSS  14                     dsr name buffer - needs to be direclty in front of DSRLNK's workspace
LOOKWS
DSRLWS
ARRYWS BSS  >10
STRWS  BSS  >20
WRAPWS BSS  >20
INPTWS
POSUWS
DISPWS BSS  >20
       TEXT 'STACK '
       BSS  >40
STACK

*
* Areas for changeable values
*

       TEXT 'VARIABLE'
VARBEG
* Address of line list
LINLST BSS  2
* Address of format line list
FMTLST BSS  2
* Address of margin list
MGNLST BSS  2

* MEMBUF.O
* holds block size
* holds address of buffer
BUFADR BSS  >2
* holds first address after the buffer
BUFEND BSS  >2

* MAIN.TXT
CURTIM BSS  2
CUROLD BSS  2
CURMOD BSS  2
CURRPL BSS  1
       EVEN

* WRAP.TXT
* Width of first paragraph line
* If there is no indent it will match
* LNWDTH.
LNWDT1 BSS  2
* General line width
LNWDTH BSS  2
* When reset, use windowed mode like TI-Writer
* Otherwise, use vertical mode
WINMOD BSS  2

* INPUT.TXT
* Current Paragraph Index
PARINX BSS  2
* Character Index in Paragraph
CHRPAX BSS  2
* Insert Mode. 0 = insert, -1 = overwrit
INSTMD BSS  2
* Input mode. 0 = unspecified,
* 1 = text, 2 = movement
INPTMD BSS  2

* POSUPDT.TXT
* Line Index in Paragraph
LININX BSS  2
* Character Index in line
CHRLIX BSS  2
* Window horizontal offset
WINOFF BSS  2
* First Paragraph on screen
WINPAR BSS  2
* First line of paragraph on screen
WINLIN BSS  2
* Position of flashing cursor on screen
CURSCN BSS  2

* KEY.TXT
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
VAREND
       TEXT 'ENDOFPROG'

*
* Buffer for text
*
MEMBEG EQU  >A000
MEMEND EQU  >FFD8
       END

* Addresses >FFD8 through >FFFF are used for XOP 1 on the TI-99/4A. 
* --- E/A manual 24.2.1.1 (page 400)

       END