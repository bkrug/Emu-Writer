       DEF  FRMPRT
       REF  PRINT,MNUFL

       COPY 'EQUKEY.asm'

*
* Print Form
*
FRMPRT DATA FLDPR
       DATA KEYPR
       TEXT 'Print Document'
       BYTE 0

FLDPR  DATA FLDPR1
       TEXT 'Device'
       BYTE 0
       BYTE 72              Length of field
* TODO: put conditions on which chars can be entered into this field
FLDPR1 EVEN

KEYPR  DATA KEYPR1
*
       BYTE ENTER
       BYTE NXTRTN
       DATA PRINT
*
       BYTE ESCKEY
       BYTE NXTMNU
       DATA MNUFL
KEYPR1