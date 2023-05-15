       DEF  MNUINT,ENTMNU
*
       REF  CURMNU,CURFRM,FLDVAL,FLDVE    From VAR.asm
       REF  KEYRD,KEYWRT                  "
       REF  INCKRD                        From INPUT.asm
       REF  MNUHOM                        From MENU.asm
       REF  VDPADR,VDPSPC,VDPSTR          From VDP.asm
       REF  VDPREA,VDPWRT                 From VDP.asm
       REF  STSWIN,STSTYP,STSARW
       REF  DRWCUR
       REF  CUROLD,CURRPL,CURMOD
       REF  CURSCN
       REF  BUFALC,BUFREE

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
       CLR  R0
       LI   R1,FLDVAL
MNULP0 MOVB R0,*R1+
       CI   R1,FLDVE
       JL   MNULP0
* Let R9 = address within first field
* If no fields exist for this menu, set R9 to 0
       CLR  R9
       CLR  @CURSCN
       MOV  @CURMNU,R2
       MOV  @4(R2),R1
       JEQ  MNULP1
       LI   R9,FLDVAL
* Set cursor position on screen
       MOV  @2(R1),@CURSCN
* Menu loop
MNULP1 BL   @MNUDSP
       BL   @KEYWT
       MOV  @CURMNU,R0
       JNE  MNULP
*
       MOV  *R10+,@CURSCN
       MOV  *R10+,@CURRPL
       MOV  *R10+,@CURMOD
       MOV  *R10+,@CUROLD
* Set document status as if window has moved
* Redraw the entire screen
       MOV  *R10+,R0
       SOC  @STSWIN,R0
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
       LI   R1,24*40
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
* Write strings
       MOV  R3,R0
DSP1   BL   @VDPSTR
*
       MOV  R3,R1
       S    R0,R1
       AI   R1,40
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
KEYLP  MOV  @2(R2),R3
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
       JL   KEY8
       CB   R5,@ARWRGT
       JH   KEY8
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
       MOV  @4(R2),R0
       INCT R0
       MOV  *R0+,R3
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
       C    R9,R0
       JL   KEY8
       MOV  R0,R9
KEY8
* Let R1 = position within FLDVAL
       LI   R1,FLDVAL
       NEG  R1
       A    R9,R1
* Recalculate cursor position
       MOV  R3,@CURSCN
       A    R1,@CURSCN
* Increment KEYRD so we see next key
       LIMI 2
       BL   @INCKRD
       JMP  KEYLP
KEY9
* Key found, increment key buffer position
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
       DATA GOFRM
       DATA GORTN

GOMNU  CLR  @CURFRM
       MOV  R1,@CURMNU
       RT

GOFRM  CLR  @CURMNU
       MOV  R1,@CURFRM
       RT

* We should not call external routines from menu mode
* Just other menus and forms
GORTN  RT

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
* Don't move left of field
       CI   R9,FLDVAL
       JLE  LFTRT
*
       DEC  R9
       SOC  @STSARW,R7
LFTRT  RT

RGTSPC
* Don't move right of field
       LI   R0,FLDVE
       DEC  R0
       C    R9,R0
       JHE  RGTRT
*
       INC  R9
       SOC  @STSARW,R7
RGTRT  RT

BCKDEL 
       DECT R10
       MOV  R11,*R10
* Don't move left of field
       CI   R9,FLDVAL
       JLE  BCKRT
*
       BL   @LFTSPC
       BL   @FWDDEL
*
BCKRT  MOV  *R10+,R11       
       RT

FWDDEL
       DECT R10
       MOV  R11,*R10
*
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
       MOV  *R10+,R11       
       RT
