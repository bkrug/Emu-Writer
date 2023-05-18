       DEF  MNUHOM,MNUFL
       REF  FRMSAV,FRMLOD,FRMPRT

       COPY 'EQUKEY.asm'

*
* Main/Home Menu
*
MNUHOM DATA TXTHM
       DATA KEYHM
       DATA NOFLDS

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
       BYTE NXTMNU          * When pressing escape key from home menu
       DATA 0               * Set the current menu to 0, so we leave menu mode
KEYHM1

*
* File Menu
*
MNUFL  DATA TXTFL
       DATA KEYFL
       DATA NOFLDS

TXTFL  DATA TXTFL1
       TEXT 'Save'
       BYTE 0
       TEXT 'Load'
       BYTE 0
       TEXT 'Print'
       BYTE 0
TXTFL1 EVEN

KEYFL  DATA KEYFL1
       TEXT 'S'
       BYTE NXTMNU
       DATA FRMSAV
*
       TEXT 'L'
       BYTE NXTMNU
       DATA FRMLOD
*
       TEXT 'P'
       BYTE NXTMNU
       DATA FRMPRT
*
       BYTE ESCKEY
       BYTE NXTMNU
       DATA MNUHOM
KEYFL1