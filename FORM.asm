       DEF  FRMPRT,FRMSAV
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
       DATA 2*40+14         * Field position on screen
       DATA 80-14           * Length of field
FLDPR1 EVEN

*
* Save Form
*
FRMSAV DATA TXTSV           * String List
       DATA KEYSV           * Key List
       DATA FLDSV           * Field List
       EVEN

TXTSV  DATA TXTSV1
       TEXT 'SAVE'
       BYTE 0
       BYTE 0
       TEXT 'File Name'
       BYTE 0
TXTSV1 EVEN

KEYSV  DATA KEYSV1
*
       BYTE ENTER
       BYTE NXTRTN
       DATA PRINT
*
       BYTE ESCKEY
       BYTE NXTMNU
       DATA MNUFL
KEYSV1

FLDSV  DATA FLDSV1
       DATA 2*40+11         * Field position on screen
       DATA 80-11           * Length of field
FLDSV1 EVEN