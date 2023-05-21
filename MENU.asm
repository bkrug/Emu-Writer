       DEF  MNUHOM,MNUFL,MNUTTL
       REF  FRMSAV,FRMLOD,FRMPRT

       COPY 'EQUKEY.asm'

HOTKEY TEXT 'FCTN+9: Previous Menu'
       BYTE 0
HKYHOM TEXT 'FCTN+9: Editor'
NOHTKY BYTE 0

*
* Title Screen
*
MNUTTL DATA TXTTTL
       DATA KEYTTL
       DATA NOFLDS
       DATA NOHTKY
       TEXT ''
       BYTE 0

TXTTTL DATA TXTTT1
       BYTE 0
       BYTE 0
       BYTE 0
       BYTE 0
       TEXT '             ============='
       BYTE 0
       TEXT '               EmuWriter'
       BYTE 0
       TEXT '                  v0.1'
       BYTE 0
       TEXT '             ============='
       BYTE 0
       BYTE 0
       TEXT '    "Be a little late to the party"'
       BYTE 0
       BYTE 0
       BYTE 0
       TEXT '          Released Anyary 2023'
       BYTE 0
       TEXT '    Press ENTER or SPACE to continue'
       BYTE 0
TXTTT1 EVEN

KEYTTL DATA KEYTT1
*
       BYTE ENTER
       BYTE NXTMNU
       DATA 0            * Clearing the menu takes us to the editor
*
       BYTE SPCBAR
       BYTE NXTMNU
       DATA 0
KEYTT1

*
* Main/Home Menu
*
MNUHOM DATA TXTHM
       DATA KEYHM
       DATA NOFLDS
       DATA HKYHOM
       TEXT 'HOME'
       BYTE 0

TXTHM  DATA TXTHM1
       TEXT 'File'
       BYTE 0
*       TEXT 'paGe'
*       BYTE 0
*       TEXT 'pAragraph'
*       BYTE 0
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
       DATA HOTKEY
       TEXT 'FILE'
       BYTE 0

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