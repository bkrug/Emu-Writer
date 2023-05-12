       DEF  MNUINT
*
       REF  CURMNU                        From VAR.asm
       REF  MNUHOM                        From MENU.asm
       REF  VDPADR,VDPSPC,VDPSTR          From VDP.asm

*
* Initialize start menu
*
MNUINT LI   R0,MNUHOM
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
JMP    JMP  JMP