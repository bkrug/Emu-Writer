       DEF  MNUHOM,MNUFL,MNUTTL,MNUHK
       DEF  MNUSTR,MNUEND
       DEF  FRMSAV,FRMLOD,FRMPRT,FRMNEW,FRMQIT
       DEF  FRMMGN
*
       REF  SAVE,LOAD,PRINT,MYBNEW,MYBQIT         From IO.asm
       REF  EDTMGN                                From EDTMGN.asm
       REF  CCHPRT,CCHLOD,CCHSAV                  From CACHETBL.asm
       REF  CCHNEW,CCHQIT                         "
       REF  CCHMGN                                "
       REF  PARINX,FLDVAL                         From VAR.asm
       REF  GETMGN,BYTSTR                         From UTIL.asm
       REF  BUFCPY                                From MEMBUF

       COPY 'CPUADR.asm'
       COPY 'EQUKEY.asm'

       AORG >C800
MNUSTR
       XORG LOADED

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
       DATA NOHTKY          * Address of string to display hotkeys
       DATA 0               * Form Population Logic
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
       TEXT '                  v0.2'
       BYTE 0
       TEXT '             ============='
       BYTE 0
       BYTE 0
       TEXT '    "Be a little late to the party"'
       BYTE 0
       BYTE 0
       BYTE 0
       TEXT '           Released Month 202x'
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
       DATA HKYHOM          * Address of string to display hotkeys
       DATA 0               * Form Population Logic
       TEXT 'HOME'
       BYTE 0

TXTHM  DATA TXTHM1
       BYTE 0
       TEXT 'File'
       BYTE 0
       TEXT 'Margins'
       BYTE 0
TXTHM1 EVEN

KEYHM  DATA KEYHM1
       TEXT 'F'
       BYTE NXTMNU
       DATA MNUFL
*
       TEXT 'M'
       BYTE NXTFRM
       DATA FRMMGN
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
       DATA HOTKEY          * Address of string to display hotkeys
       DATA 0               * Form Population Logic
       TEXT 'FILE'
       BYTE 0

TXTFL  DATA TXTFL1
       BYTE 0
       TEXT 'New'
       BYTE 0
       TEXT 'Save'
       BYTE 0
       TEXT 'Load'
       BYTE 0
       TEXT 'Print'
       BYTE 0
       TEXT 'Quit'
       BYTE 0
TXTFL1 EVEN

KEYFL  DATA KEYFL1
       TEXT 'N'
       BYTE NXTFRM
       DATA FRMNEW
*
       TEXT 'S'
       BYTE NXTFRM
       DATA FRMSAV
*
       TEXT 'L'
       BYTE NXTFRM
       DATA FRMLOD
*
       TEXT 'P'
       BYTE NXTFRM
       DATA FRMPRT
*
       TEXT 'Q'
       BYTE NXTFRM
       DATA FRMQIT
*
       BYTE ESCKEY
       BYTE NXTMNU
       DATA MNUHOM
KEYFL1

*
* Hotkey Menu
*
MNUHK  DATA TXTHK
       DATA KEYHK
       DATA NOFLDS
       DATA HKYHOM          * Address of string to display hotkeys
       DATA 0               * Form Population Logic
       TEXT 'Hot Keys'
       BYTE 0

TXTHK  DATA TXTHK1
       BYTE 0
       TEXT 'FCTN+1 Delete Char'
       BYTE 0
       TEXT 'FCTN+2 Insert/Overwrite'
       BYTE 0
       TEXT 'FCTN+3 Backspace Delete'
       BYTE 0
       TEXT 'FCTN+0 Vertical/Windowed Mode'
       BYTE 0
TXTHK1 EVEN

KEYHK  DATA KEYHK1
       BYTE ESCKEY
       BYTE NXTMNU          * When pressing escape key from home menu
       DATA 0               * Set the current menu to 0, so we leave menu mode
KEYHK1

*
* FORMS
*

HKYFIL TEXT 'FCTN+9: File Menu'
       BYTE 0
       EVEN

*
* Save Form
*
FRMSAV DATA TXTSV           * String List
       DATA KEYSV           * Key List
       DATA FLDSV           * Field List
       DATA HKYFIL          * Hotkey Text
       DATA 0               * Form Population Logic
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
       BYTE NXTCCH
       DATA CCHSAV
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
       DATA HKYFIL          * Address of string to display hotkeys
       DATA 0               * Form Population Logic
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
       BYTE NXTCCH
       DATA CCHLOD
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
       DATA HKYFIL          * Address of string to display hotkeys
       DATA 0               * Form Population Logic
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
       BYTE NXTCCH
       DATA CCHPRT
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
       DATA HKYFIL          * Address of string to display hotkeys
       DATA 0               * Form Population Logic
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
       BYTE NXTCCH
       DATA CCHNEW
*
       BYTE ESCKEY
       BYTE NXTMNU
       DATA MNUFL
KEYNW1

FLDNW  DATA FLDNW1
       DATA 80+8            * Field position on screen
       DATA 1               * Length of field
FLDNW1 EVEN

*
* Quit Form
*
FRMQIT DATA TXTQT           * String List
       DATA KEYQT           * Key List
       DATA FLDQT           * Field List
       DATA HKYFIL          * Address of string to display hotkeys
       DATA 0               * Form Population Logic
       TEXT 'QUIT'
       BYTE 0
       EVEN

TXTQT  DATA TXTQT1
       BYTE 0
       TEXT 'Quit. Are you sure? (Y/N)'
       BYTE 0
TXTQT1 EVEN

KEYQT  DATA KEYQT1
*
       BYTE ENTER
       BYTE NXTCCH
       DATA CCHQIT
*
       BYTE ESCKEY
       BYTE NXTMNU
       DATA MNUFL
KEYQT1

FLDQT  DATA FLDQT1
       DATA 40+27           * Field position on screen
       DATA 1               * Length of field
FLDQT1 EVEN

*
* Margin Form
*
FRMMGN DATA TXTMG           * String List
       DATA KEYMG           * Key List
       DATA FLDMG           * Field List
       DATA HOTKEY          * Address of string to display hotkeys
       DATA POPMG           * Form Population Logic
       TEXT 'MARGINS'
       BYTE 0
       EVEN

TXTMG  DATA TXTMG1
       BYTE 0
       TEXT 'Left Margin'
       BYTE 0
       TEXT 'Right Margin'
       BYTE 0
TXTMG1 EVEN

KEYMG  DATA KEYMG1
*
       BYTE ENTER
       BYTE NXTCCH
       DATA CCHMGN
*
       BYTE ESCKEY
       BYTE NXTMNU
       DATA MNUHOM
KEYMG1

FLDMG  DATA FLDMG1
*
       DATA 40+13           * Field position on screen
       DATA 3               * Length of field
*
       DATA 80+13           * Field position on screen
       DATA 3               * Length of field
FLDMG1 EVEN

MGNDFT TEXT '10'
       BYTE 0
       TEXT '10'
       BYTE 0
POPMG  DECT R10
       MOV  R2,*R10
       DECT R10
       MOV  R3,*R10
       DECT R10
       MOV  R4,*R10
       DECT R10
       MOV  R5,*R10
       DECT R10
       MOV  R6,*R10
       DECT R10
       MOV  R11,*R10
* Let R0 = address of current margin data
       MOV  @PARINX,R0
       BL   @GETMGN
* Is there a margin entry for this paragraph?
       MOV  R0,R6
       JEQ  POPMGD
* Yes, populate FLDVAL
* Left Margin
       MOVB @LEFT(R6),R1
       LI   R2,FLDVAL
       BL   @BYTSTR
* Right Margin
       LI   R1,DFLTPG
       SLA  R1,8
       SB   @LEFT(R6),R1
       SB   @PWIDTH(R6),R1
       LI   R2,FLDVAL
       AI   R2,3
       BL   @BYTSTR
       JMP  POPMGR
* Populate with defaults
* TODO: why can't we use BUFCPY here?
POPMGD LI   R0,MGNDFT
       LI   R1,FLDVAL
       MOV  *R0+,*R1+
       MOV  *R0+,*R1+
       MOV  *R0,*R1
*
POPMGR MOV  *R10+,R11
       MOV  *R10+,R6
       MOV  *R10+,R5
       MOV  *R10+,R4
       MOV  *R10+,R3
       MOV  *R10+,R2
       RT

MNUEND AORG