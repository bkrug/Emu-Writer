       DEF  FRMPRT
       REF  PRINT,MNUFL

       COPY 'EQUKEY.asm'

*
* Print Form
*
FRMPRT DATA TXTPR           * String List
       DATA KEYPR           * Key List
       DATA FLDPR           * Field List
       EVEN

TXTPR  DATA TXTPR1
       TEXT 'PRINT'
       BYTE 0
       TEXT ' '
       BYTE 0
       TEXT 'Printer Name'
       BYTE 0
TXTPR1 EVEN

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

FLDPR  DATA FLDPR1
       DATA 14              * Field position on screen
       DATA 72              * Length of field
* TODO: put conditions on which chars can be entered into this field
FLDPR1 EVEN