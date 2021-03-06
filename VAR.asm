*
* Definitions in this file
*
* Register Workspaces
       DEF  STRWS
       DEF  LOOKWS,ARRYWS
       DEF  WRAPWS,INPTWS,POSUWS,DISPWS,SCRNWS
* Memory Chunk Buffer
       DEF  BUFADR,BUFEND
* Arrays
       DEF  LINLST,FMTLST,MGNLST
* MAIN.TXT
       DEF  CURTIM,CUROLD,CURRPL,CURMOD
* WRAP.TXT
       DEF  FMTEND,MGNEND,LNWDT1,LNWDTH
* SCRNWRT.TXT
       DEF  SRCLIN,INDENT,CPI,NXTFMT
       DEF  DSPSTR,CURSTR
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

* Areas of memory that absolutely have
* to be in RAM and could never be part
* of a cartridge ROM should go here.

*
* Areas for workspace registers
*
       TEXT 'WORKSPCE'
LOOKWS
ARRYWS BSS  >10
STRWS  BSS  >20
WRAPWS
INPTWS
POSUWS
DISPWS
SCRNWS BSS  >20

*
* Areas for changeable values
*

       TEXT 'VARIABLE'
* Address of line list
LINLST DATA 0
* Address of format line list
FMTLST DATA 0
* Address of margin list
MGNLST DATA 0

* MEMBUF.O
* holds block size
* holds address of buffer
BUFADR BSS  >2
* holds first address after the buffer
BUFEND BSS  >2

* MAIN.TXT
CURTIM DATA 0
CUROLD DATA 0
CURMOD DATA 0
CURRPL BYTE 0
       EVEN

* WRAP.TXT
FMTEND DATA 0
MGNEND DATA 0
* Width of first paragraph line
* If there is no indent it will match
* LNWDTH.
LNWDT1 DATA 0
* General line width
LNWDTH DATA 0

* SCRNWRT.TXT
SRCLIN DATA 0
INDENT DATA 0
CPI    DATA 0
NXTFMT DATA 0
DSPSTR DATA 0
CURSTR DATA 0

* INPUT.TXT
* Current Paragraph Index
PARINX DATA 0
* Character Index in Paragraph
CHRPAX DATA 0
* Insert Mode. 0 = insert, -1 = overwrit
INSTMD DATA 0
* Input mode. 0 = unspecified,
* 1 = text, 2 = movement
INPTMD DATA 0

* POSUPDT.TXT
* Line Index in Paragraph
LININX DATA 0
* Character Index in line
CHRLIX DATA 0
* Window horizontal offset
WINOFF DATA 0
* First Paragraph on screen
WINPAR DATA 0
* First line of paragraph on screen
WINLIN DATA 0
* Position of flashing cursor on screen
CURSCN DATA 0

       TEXT 'KEY.'
* KEY.TXT
* Time remaining before character repeat
TIMER  DATA 0
* The previously detected key press.
* Wait a while before letting this key
* repeat.
PREVKY BYTE 0
       EVEN
* First address of key buffer
KEYSTR
* Buffer to store keypresses
KEYBUF BSS  >10
* First address after key buffer
KEYEND 
* Address where the next keypress 
* should be stored.
KEYWRT DATA 0
* Next address to read a keypress from.
* If the value here is equal to the
* value in KEYWRT, then there are no
* new characters to write.===
KEYRD  DATA 0

       END