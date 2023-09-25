       DEF  EDTMGN
       DEF  MGNSRT,MGNEND
*
       REF  PARINX,MGNLST,LINLST          From VAR.asm
       REF  ARYINS,ARYDEL                 From ARRAY.asm
       REF  WRAP                          From WRAP.asm

       COPY 'CPUADR.asm'

INDENT EQU  3
LEFT   EQU  4
RIGHT  EQU  5

       AORG >B000
MGNSRT
       XORG LOADED

EDTMGN
       DECT R10
       MOV  R11,*R10
* Debug code. Always inserting at index 0.
       CLR  R2
       JMP  EM2
* Let R2 = index of MGNLST element
* Let R3 = address of MGNLST element
* Let R4 = element count
       CLR  R2
       MOV  @MGNLST,R4
       MOV  R4,R3
       C    *R3+,*R3+
       MOV  *R4,R4
* Do we need to insert element at end of list?
       JEQ  EM2
* Find first MGNLST element for matching or later paragraph
EM1    C    *R3,@PARINX
       JH   EM2
       JEQ  EM9
       AI   R3,8
       INC  R2
       C    R2,R4
       JL   EM1
* We need to insert a new element
EM2    MOV  @MGNLST,R0
       MOV  R2,R1
       BLWP @ARYINS
       JEQ  EMERR
       MOV  R0,@MGNLST
       MOV  R1,R3
* Populate element
       MOV  @PARINX,*R3
EM9    LI   R2,>1428
       MOV  R2,@LEFT(R3)
*
       BL   @WRAPDC
* No Error
       CLR  R0
*
       MOV  *R10+,R11
       RT

*
* An error occurred
*
EMERR  SETO R0
       RT

*
* Wrap all paragraphs
*
* TODO: This is duplicate code
WRAPDC
       MOV  @LINLST,R2
       CLR  R0
WRAPLP C    R0,*R2
       JHE  WRAPDN
       CLR  R1
       BLWP @WRAP
       CI   R0,>FFFF
       JEQ  WRAPDN
       INC  R0
       JMP  WRAPLP
WRAPDN
       RT

MGNEND AORG