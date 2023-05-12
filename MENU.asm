       DEF  MNUHOM,MNUFL
       REF  FRMPRT

       COPY 'EQUKEY.asm'

*
* Main/Home Menu
*
MNUHOM DATA TXTHM
       DATA KEYHM

TXTHM  DATA TXTHM1
       TEXT 'File'
       BYTE 0
       TEXT 'paGe'
       BYTE 0
       TEXT 'pAragraph'
       BYTE 0
TXTHM1 EVEN

KEYHM  DATA KEYHM1
       TEXT 'F'
       BYTE NXTMNU
       DATA MNUFL
*
       BYTE ESCKEY
       BYTE NXTRTN
       DATA SHWEDT
KEYHM1

*
* File Menu
*
MNUFL  DATA TXTFL
       DATA KEYFL

TXTFL  DATA TXTFL1
       TEXT 'Save'
       BYTE 0
       TEXT 'Load'
       BYTE 0
       TEXT 'Print'
       BYTE 0
TXTFL1 EVEN

KEYFL  DATA KEYFL1
       TEXT 'P'
       BYTE NXTFRM
       DATA FRMPRT
*
       BYTE ESCKEY
       BYTE NXTMNU
       DATA SHWEDT       
KEYFL1

*
* Return to editor
*
SHWEDT