       DEF  FRMSAV,FRMLOD,FRMPRT,FRMNEW
*
       REF  MNUFL
       REF  SAVE,LOAD,PRINT,MYBNEW

       COPY 'EQUKEY.asm'

HKYFIL TEXT 'FCTN+9: File Menu'
       BYTE 0

*
* Save Form
*
FRMSAV DATA TXTSV           * String List
       DATA KEYSV           * Key List
       DATA FLDSV           * Field List
       DATA HKYFIL          * Hotkey Text
       TEXT 'SAVE'
       BYTE 0

TXTSV  DATA TXTSV1
       BYTE 0
       TEXT 'File Name'
       BYTE 0
TXTSV1 EVEN

KEYSV  DATA KEYSV1
*
       BYTE ENTER
       BYTE NXTRTN
       DATA SAVE
*
       BYTE ESCKEY
       BYTE NXTMNU
       DATA MNUFL
KEYSV1

FLDSV  DATA FLDSV1
       DATA 40+11           * Field position on screen
       DATA 80-11           * Length of field
FLDSV1 EVEN

*
* Load Form
*
FRMLOD DATA TXTLD           * String List
       DATA KEYLD           * Key List
       DATA FLDSV           * Same Field List as Save screen
       DATA HKYFIL
       TEXT 'LOAD'
       BYTE 0

TXTLD  DATA TXTLD1
       BYTE 0
       TEXT 'File Name'
       BYTE 0
TXTLD1 EVEN

KEYLD  DATA KEYLD1
*
       BYTE ENTER
       BYTE NXTRTN
       DATA LOAD
*
       BYTE ESCKEY
       BYTE NXTMNU
       DATA MNUFL
KEYLD1

*
* Print Form
*
FRMPRT DATA TXTPR           * String List
       DATA KEYPR           * Key List
       DATA FLDPR           * Field List
       DATA HKYFIL
       TEXT 'PRINT'
       BYTE 0
       EVEN

TXTPR  DATA TXTPR1
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
       DATA 40+14           * Field position on screen
       DATA 80-14           * Length of field
FLDPR1 EVEN

*
* New Document Form
*
FRMNEW DATA TXTNW           * String List
       DATA KEYNW           * Key List
       DATA FLDNW           * Field List
       DATA HKYFIL
       TEXT 'NEW DOCUMENT'
       BYTE 0
       EVEN

TXTNW  DATA TXTNW1
       BYTE 0
       TEXT 'Clear old document. Are you sure?'
       BYTE 0
       TEXT '(Y/N)'
       BYTE 0
TXTNW1 EVEN

KEYNW  DATA KEYNW1
*
       BYTE ENTER
       BYTE NXTRTN
       DATA MYBNEW
*
       BYTE ESCKEY
       BYTE NXTMNU
       DATA MNUFL
KEYNW1

FLDNW  DATA FLDNW1
       DATA 80+8            * Field position on screen
       DATA 1               * Length of field
FLDNW1 EVEN