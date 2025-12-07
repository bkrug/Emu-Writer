       DEF  FORTY
       DEF  STSTYP,STSENT,STSDCR,STSPAR
       DEF  STSWIN,STSDSH,STSARW
       DEF  ERRMEM
       DEF  CHRMIN,CHRMAX
       DEF  SPACE,DASH,CHRCUR,ENDINP,NOKEY
       DEF  ISPACE
       DEF  CURINS,CUROVR

* Values in this file are constants that
* may need to be shared by different
* modules

       COPY 'EQUVAL.asm'

FORTY  DATA 40

* Document status codes
STSTYP DATA STATYP        * Text Typed
STSENT DATA STAENT        * Enter Pressed
STSDCR DATA STADCR        * Deleted Carriage Return
STSPAR DATA STAPAR        * Paragraph Line Count Changed
STSWIN DATA STAWIN        * Window Moved
STSDSH DATA STADSH        * Redisplay dashboard line (margins, fonts)
STSARW DATA STAARW        * Arrow Key Pressed
ERRMEM DATA ERAMEM        * Insufficient Memory Error

* ASCII codes
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