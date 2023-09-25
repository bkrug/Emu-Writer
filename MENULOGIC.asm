       DEF  MNUINT,ENTMNU
*
       REF  CURMNU,FLDVAL,FLDVE           From VAR.asm
       REF  KEYRD,KEYWRT                  "
       REF  INCKRD                        From INPUT.asm
       REF  MNUHOM                        From MENU.asm
       REF  VDPADR,VDPRAD                 From VDP.asm
       REF  VDPSTR,VDPINV,VDPSPC,VDPSPI   From VDP.asm
       REF  VDPREA,VDPWRT                 From VDP.asm
       REF  STSWIN,STSTYP,STSARW
       REF  DRWCUR
       REF  CUROLD,CURRPL,CURMOD
       REF  CURSCN
       REF  BUFALC,BUFREE
       REF  SCRNWD

       COPY 'CPUADR.asm'
       COPY 'EQUKEY.asm'

DELRGT BYTE DELKEY
DELLFT BYTE CLRKEY
ARWLFT BYTE BCKKEY
ARWRGT BYTE FWDKEY
SPACE  TEXT ' '
LOWA   TEXT 'a'
LOWZ   TEXT 'z'
ASCHGH BYTE 126

* Offsets from menu address
MNUKEY EQU  2
FIELDS EQU  4
KEYTXT EQU  6

*
* Initialize home menu
*
MNUINT
* Skip the most recently read key
       BL   @INCKRD
* Select Home menu as start menu
       LI   R0,MNUHOM
       MOV  R0,@CURMNU
* We are still BLWP'd into the INPUT method.
* So return to the document loop now.
       RTWP

*
* Display the current menu
* Wait for a key press
*
ENTMNU
       DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R0,*R10
       DECT R10
       MOV  R0,@CUROLD
       DECT R10
       MOV  R0,@CURMOD
       DECT R10
       MOV  R0,@CURRPL
       DECT R10
       MOV  R0,@CURSCN
*
       CLR  @CURMOD
MNULP
* Let R7 = Document Status
       CLR  R7
       SOC  @STSTYP,R7
* Initialize form fields
       BL   @INTFLD
* Display new menu, and process keys until user leaves menu
       BL   @MNUDSP
       BL   @KEYWT
       MOV  @CURMNU,R0
       JNE  MNULP
* Set document status as if window has moved
* Redraw the entire screen
       MOV  *R10+,R0
       SOC  @STSWIN,R0
*
       MOV  *R10+,@CURSCN
       MOV  *R10+,@CURRPL
       MOV  *R10+,@CURMOD
       MOV  *R10+,@CUROLD
*
       MOV  *R10+,R11
       RT

*
* Display text of menu
*
MNUDSP
       DECT R10
       MOV  R11,*R10
*
       LIMI 0
* Clear screen
       CLR  R0
       BL   @VDPADR
*
       MOV  @SCRNWD,R1
       SLA  R1,1
       BL   @VDPSPI
*
       MOV  @SCRNWD,R0
       LI   R2,22
       MPY  R2,R0
       BL   @VDPSPC
* Let R2 = address of menu
* Let R3 = address of strings
* Let R4 = end of strings
       MOV  @CURMNU,R2
       MOV  *R2,R3
       MOV  *R3+,R4
* Write title
       CLR  R0
       BL   @VDPADR
*
       MOV  @KEYTXT(R2),R0
       BL   @VDPINV
* Write Hot keys
       MOV  @SCRNWD,R0
       BL   @VDPADR
*
       MOV  R2,R0
       AI   R0,8
       BL   @VDPINV
* Set VDP address for strings
       MOV  @SCRNWD,R0
       SLA  R0,1
       BL   @VDPADR
* Write strings
       MOV  R3,R0
DSP1   BL   @VDPSTR
*
       MOV  R3,R1
       S    R0,R1
       A    @SCRNWD,R1
       BL   @VDPSPC
*
       INC  R0
       MOV  R0,R3
       C    R0,R4
       JL   DSP1
*
       LIMI 2
       MOV  *R10+,R11       
       RT

*
* Wait for key and process it
*
* Input:
*   R2 - Address of menu header 
*
KEYWT  DECT R10
       MOV  R11,*R10
* Let R3 = address of key list (for navigtion)
* Let R4 = end of key list
KEY1   MOV  @MNUKEY(R2),R3
       MOV  *R3+,R4
* Let R5 (high byte) = key pressed
       BL   @GETKEY
* Let R3 = address within key list
* Is the detected key in the key list?
* Is it used to navigate within between menus?
KEY2   CB   *R3,R5
       JEQ  KEY9
       AI   R3,4
       C    R3,R4
       JL   KEY2
* No, is there a field on this menu?
       MOV  @FIELDS(R2),R0
       JEQ  KEY8
* Yes, type or move cursor in field
       BL   @TYPEKY
* Increment KEYRD so we see next key
KEY8   BL   @INCKRD
       JMP  KEY1
* Navigate within menu system based on element in key list
KEY9   BL   @MNUNAV
* Let R2 = address of new menu header
       MOV  @CURMNU,R2
* If error occurred, stay in menu
       MOV  R0,R0
       JNE  KEY1
* else, done processing this menu
       MOV  *R10+,R11
       RT

*
* Initialize form fields
* Let R9 = memory address within FLDVAL
*
INTFLD
* Initialize Field Value
       LI   R1,FLDVAL
INITF1 SB   *R1,*R1+
       CI   R1,FLDVE
       JL   INITF1
* Let R9 = memory address within FLDVAL
* If no fields exist for this menu, set R9 to 0
       CLR  R9
       CLR  @CURSCN
       MOV  @CURMNU,R2
       MOV  @FIELDS(R2),R1
       JEQ  INITF2
       LI   R9,FLDVAL
* Set cursor position on screen
       MOV  @SCRNWD,R0
       SLA  R0,1
       A    @2(R1),R0
       MOV  R0,@CURSCN
*
INITF2
       RT

*
* Get Key Press
*
* Input:
*   R7 - document status
* Changed: R0,R7
* Ouput: R5 (high byte)
*
GETKEY DECT R10
       MOV  R11,*R10
* Process cursor
KEYLP
       MOV  @CURSCN,R0
       JEQ  GETK1
       MOV  R7,R0
       BL   @DRWCUR
       CLR  R7
GETK1
* Wait for key press
       C    @KEYRD,@KEYWRT
       JEQ  KEYLP
* Key press found
       MOV  @KEYRD,R5
       MOVB *R5,R5
* make uppercase
       CB   R5,@LOWA
       JL   GETK2
       CB   R5,@LOWZ
       JH   GETK2
       AI   R5,->2000
GETK2
*
       MOV  *R10+,R11
       RT

*
* Type key press in a form field
*
* Input:
*   R5 (high byte) - detected key press
*   R7 - Document status?
*   R9 - memory address within FLDVAL
* Changed: R0, R1, R3, R4, R7
* Output: R9
*   R3 - screen address of first field
*   R4 - Length of field
*   R9 - memory address within FLDVAL
*
TYPEKY DECT R10
       MOV  R11,*R10
*
       LIMI 0
* Is key displayable?
       CB   R5,@SPACE
       JLE  TYPE1
       CB   R5,@ASCHGH
       JH   TYPE1
* Yes, record keystroke
       MOVB R5,*R9+
* Set document status to "typed"
       SOC  @STSTYP,R7
*
       JMP  TYPE2
* Not a typeable key
TYPE1
       CB   R5,@DELRGT
       JL   TYPE3
       CB   R5,@ARWRGT
       JH   TYPE3
* Let R0 = address of arrow or delete key routine
       MOVB R5,R0
       SB   @DELRGT,R0
       SRL  R0,8
       SLA  R0,1
       AI   R0,SPCKEY
       MOV  *R0,R0
       JEQ  TYPE2
* Handle arrow or delete key
       BL   *R0
TYPE2
* Redisplay field values
* Let R4 = Length of current field
       BL   @DSPVAL
* Don't let cursor go past edge of field
* Let R0 = final position within the field
* Let R9 = no greater than R0
       LI   R0,FLDVAL
       A    R4,R0
       DEC  R0
       C    R9,R0
       JL   TYPE3
       MOV  R0,R9
TYPE3
* Let R1 = index of cursor relative to FLDVAL
       LI   R1,FLDVAL
       NEG  R1
       A    R9,R1
* Recalculate cursor position
       MOV  R3,@CURSCN
       A    R1,@CURSCN
       LIMI 2
*
       MOV  *R10+,R11
       RT

*
* Redisplay field values
*
* Input: R2
* Changed: R0, R1, R3
* Output:
*   R3 - screen address of first field
*   R4 - Length of field
*
DSPVAL
       DECT R10
       MOV  R11,*R10
* Let R3 = screen address of first field
* Let R4 = length of field
       MOV  @FIELDS(R2),R0
       INCT R0
       MOV  @SCRNWD,R3
       SLA  R3,1
       A    *R0+,R3
       MOV  *R0,R4
* Write field value to VDP
       MOV  R3,R0
       BL   @VDPADR
       LI   R0,FLDVAL
       MOV  R4,R1
       BL   @VDPWRT
*
       MOV  *R10+,R11
       RT

*
* Arrow and delete keys pressed in form field
*
SPCKEY
* Delete key in form field
       DATA FWDDEL
*
       DATA 0,0,0
* Backspace Delete key in form field
       DATA BCKDEL
* Left arrow
       DATA LFTSPC
* Right arrow
       DATA RGTSPC

LFTSPC
* Don't move left of field start
       CI   R9,FLDVAL
       JLE  LFTRT
*
       DEC  R9
       SOC  @STSARW,R7
LFTRT  RT

RGTSPC
* Don't move right if we've reached end of input
       MOVB *R9,*R9
       JEQ  RGTRT
* Move cursor
       INC  R9
       SOC  @STSARW,R7
RGTRT  RT

BCKDEL 
       DECT R10
       MOV  R11,*R10
* Don't move left of field start
       CI   R9,FLDVAL
       JLE  BCKRT
*
       BL   @LFTSPC
       BL   @FWDDEL
*
BCKRT  MOV  *R10+,R11       
       RT

FWDDEL
       MOV  R9,R0
       MOV  R0,R1
       INC  R1
DEL1   CI   R1,FLDVE
       JHE  DEL2
       MOVB *R1+,*R0+
       JMP  DEL1
DEL2
*
       SOC  @STSTYP,R7
*
       RT

*
* Navigate within menu system based on element in key list
*
* Input: R3 - address of element in key list
* Changed: R1,R3
* Output: R0 - non-zero in case of error
*
MNUNAV
       DECT R10
       MOV  R11,*R10
* Menu item key pressed, increment key buffer position
       BL   @INCKRD
* Let R0 = address of menu navigation routine
       INC  R3
       MOVB *R3+,R0
       SRL  R0,8
       AI   R0,NXTLST
       MOV  *R0,R0
* Let R1 = parameter for menu navigation
* Might be address of a menu, form, or external routine
       MOV  *R3,R1
* Branch to menu navigation routine
       BL   *R0
*
       MOV  *R10+,R11
       RT

*
* List of routines to branch to
* According to menu's key list
*
NXTLST DATA GOMNU
       DATA GORTN
       DATA GOCCH

*
* Switch to meu specified by a particular key
GOMNU
* Specify new menu
       MOV  R1,@CURMNU
* No error
       CLR  R0
       RT

*
* Run the routine specified by a given key
GORTN
       DECT R10
       MOV  R11,*R10
*
       BL   *R1
       MOV  R0,R0
* If no error occurred, clear current menu and return to editor
       JNE  GORTN1
       CLR  @CURMNU
*
GORTN1 MOV  *R10+,R11
       RT

*
* Load a routine from cache and branch to it
GOCCH
       DECT R10
       MOV  R11,*R10
* Let R4 = cache object to load/branch to
       MOV  R1,R4
* Read code from VDP cache
       MOV  *R4,R0
       BL   @VDPRAD
       LI   R1,VDPRD
       LI   R2,LOADED
       LI   R3,>800
GOCCH2
       MOVB *R1,*R2+
       DEC  R3
       JNE  GOCCH2
* Branch to address in CPU RAM
       MOV  @2(R4),R1
       BL   @GORTN
*
GOCCH9 MOV  *R10+,R11
       RT

       END