       DEF  FRMPRT
       REF  PRINT,MNUFL

       COPY 'EQUKEY.asm'

*
* Print Form
*
FRMPRT DATA FLDPR           * Field List
       DATA KEYPR           * Key List
       TEXT 'PRINT'
       BYTE 0
       EVEN

FLDPR  DATA FLDPR1
       TEXT 'Printer Name'
       BYTE 0
       BYTE 72              * Length of field
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