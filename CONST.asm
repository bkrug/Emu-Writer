       DEF  FMTLEN,MGNLEN,PGWDTH
       DEF  SIX,FORTY,SCRNWD
       DEF  USRISR
       DEF  STSTYP,STSENT,STSDCR
       DEF  STSPAR,STSWIN
       DEF  STSARW
       DEF  ERRMEM
       DEF  DELKEY
       DEF  LF,CR,CHRMIN,CHRMAX
       DEF  SPACE,DASH,CHRCUR,ENDINP,NOKEY
       DEF  ISPACE
       DEF  CURINS,CUROVR

* Values in this file are constants that
* may need to be shared by different
* modules

* The left-most bit of a memory header
* indicates if the memory chunk is in
* use or not.
* It is defined in MEMBUF.O
* BLKUSE DATA >8000
* Number of bytes in each entry of the
* margin list.
MGNLEN
* Number of bytes in each entry of the
* format list.
FMTLEN DATA 8
* Page width in 120ths of an inch
PGWDTH DATA 8*120
* Address defining address of user-
* defined service routine
USRISR EQU  >83C4

SIX    DATA 6
SCRNWD
FORTY  DATA 40

* Document status codes
* Text Typed
STSTYP DATA >1
* Enter Pressed
STSENT DATA >2
* Deleted Carriage Return
STSDCR DATA >4
* Paragraph Line Count Changed
STSPAR DATA >8
* Window Moved
STSWIN DATA >10
* Arrow Key Pressed
STSARW DATA >20
* Insufficient Memory Error
ERRMEM DATA >8000

* ASCII codes
DELKEY BYTE >03
LF     BYTE >0A
CR     BYTE >0D
CHRMIN
SPACE  TEXT ' '
DASH   TEXT '-'
CHRMAX BYTE >7E
CHRCUR BYTE >7F
ISPACE BYTE >20+>80
ENDINP BYTE >FE
NOKEY  BYTE >FF

* Cursor pattern in insert mode
CURINS BYTE >60,>60,>60,>60,>60,>60,>60
* Cursor pattern in overwrite mode
CUROVR BYTE >00,>00,>00,>00,>00,>7C,>7C
       EVEN
       END