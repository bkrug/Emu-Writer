       DEF  MNUINT
*
       REF  CURMNU                        From VAR.asm
       REF  KEYRD,KEYWRT                  "
       REF  INCKRD                        From INPUT.asm
       REF  MNUHOM                        From MENU.asm
       REF  VDPADR,VDPSPC,VDPSTR          From VDP.asm

*
* Initialize start menu
*
MNUINT
* Skip the most recently read key
       BL   @INCKRD
* Select Home menu as start menu
       LI   R0,MNUHOM
       MOV  R0,@CURMNU
       JMP  MNUDSP

*
* Display the current menu
* Wait for a key press
*
MNUDSP
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
* Let R3 = address of keys
* Let R4 = end of keys
KEYLP  MOV  @2(R2),R3
       MOV  *R3+,R4
* Wait for key press
       C    @KEYRD,@KEYWRT
       JEQ  KEYLP
* Key press found, compare to key list
       MOV  @KEYRD,R5
       MOVB *R5,R5
KEY1   CB   *R3,R5
       JEQ  KEY2
       AI   R3,4
       C    R3,R4
       JL   KEY1
* Found key does not match list
* Increment KEYRD so we see next key
       BL   @INCKRD
       JMP  KEYLP
KEY2
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
       B    *R0
*

GOMNU  MOV  R1,@CURMNU
       JMP  MNUDSP

NXTLST DATA GOMNU
       DATA 0
       DATA 0