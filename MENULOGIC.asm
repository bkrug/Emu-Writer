       DEF  MNUINT,ENTMNU
*
       REF  CURMNU,CURFRM,FLDVAL,FLDVE    From VAR.asm
       REF  KEYRD,KEYWRT                  "
       REF  INCKRD                        From INPUT.asm
       REF  MNUHOM                        From MENU.asm
       REF  VDPADR                        From VDP.asm
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
* Initialize Field Value
       LI   R1,FLDVAL
MNULP0 SB   *R1,*R1+
       CI   R1,FLDVE
       JL   MNULP0
* Let R9 = address within first field
* If no fields exist for this menu, set R9 to 0
       CLR  R9
       CLR  @CURSCN
       MOV  @CURMNU,R2
       MOV  @FIELDS(R2),R1
       JEQ  MNULP1
       LI   R9,FLDVAL
* Set cursor position on screen
       MOV  @SCRNWD,R0
       SLA  R0,1
       A    @2(R1),R0
       MOV  R0,@CURSCN
* Menu loop
MNULP1 BL   @MNUDSP
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
       LI   R1,2*40
       BL   @VDPSPI
*
       MOV  @SCRNWD,R0
       LI   R2,22
       MPY  R2,R0
       LI   R1,22*40
       BL   @VDPSPC
* Write text
       CLR  R0
       BL   @VDPADR
* Let R2 = address of menu
* Let R3 = address of strings
* Let R4 = end of strings
       MOV  @CURMNU,R2
       MOV  *R2,R3
       MOV  *R3+,R4
* Write title
       MOV  R2,R0
       AI   R0,8
       BL   @VDPINV
* Write Hot keys
       MOV  @SCRNWD,R0
       BL   @VDPADR
*
       MOV  @KEYTXT(R2),R0
       BL   @VDPINV
* Set VDP address for strings
       MOV  @SCRNWD,R0
       SLA  R0,1
       LI   R0,80
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
* Let R3 = address of keys
* Let R4 = end of keys
KEYLP  MOV  @MNUKEY(R2),R3
       MOV  *R3+,R4
* Process cursor
       MOV  @CURSCN,R0
       JEQ  KEY0
       MOV  R7,R0
       BL   @DRWCUR
       CLR  R7
KEY0       
* Wait for key press
       C    @KEYRD,@KEYWRT
       JEQ  KEYLP
* Key press found
       MOV  @KEYRD,R5
       MOVB *R5,R5
* make uppercase
       CB   R5,@LOWA
       JL   KEY1
       CB   R5,@LOWZ
       JH   KEY1
       AI   R5,->2000   
* compare to key list
KEY1   CB   *R3,R5
       JEQ  KEY9
       AI   R3,4
       C    R3,R4
       JL   KEY1
* Found key does not match list
* Is there a field on this menu?
       MOV  @FIELDS(R2),R0
       JEQ  KEY8
* Yes, type or move cursor in field
       LIMI 0
* Is key displayable?
       CB   R5,@SPACE
       JLE  KEY4
       CB   R5,@ASCHGH
       JH   KEY4
* Yes, record keystroke
       MOVB R5,*R9+
* Set document status to "typed"
       SOC  @STSTYP,R7
*
       JMP  KEY5
* Not a typeable key
KEY4
       CB   R5,@DELRGT
       JL   KEY7
       CB   R5,@ARWRGT
       JH   KEY7
* Let R0 = address of arrow or delete key routine
       MOVB R5,R0
       SB   @DELRGT,R0
       SRL  R0,8
       SLA  R0,1
       AI   R0,SPCKEY
       MOV  *R0,R0
       JEQ  KEY5
* Handle arrow or delete key
       BL   *R0
KEY5
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
* Don't let cursor go past edge of field
       LI   R0,FLDVAL
       A    R4,R0
       DEC  R0
       C    R9,R0
       JL   KEY7
       MOV  R0,R9
KEY7
* Let R1 = position within FLDVAL
       LI   R1,FLDVAL
       NEG  R1
       A    R9,R1
* Recalculate cursor position
       MOV  R3,@CURSCN
       A    R1,@CURSCN
* Increment KEYRD so we see next key
       LIMI 2
KEY8   BL   @INCKRD
       JMP  KEYLP
KEY9
* Menu item key pressed, increment key buffer position
       BL   @INCKRD
* Let R0 = address of routine to handle key
       INC  R3
       MOVB *R3+,R0
       SRL  R0,8
       AI   R0,NXTLST
       MOV  *R0,R0
* Let R1 = parameter for handling key
* Might be address of a menu, form, or external routine
       MOV  *R3,R1
* Brand to routine for handling key
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

GOMNU  CLR  @CURFRM
       MOV  R1,@CURMNU
       RT

GORTN  CLR  @CURMNU
       B    *R1
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
