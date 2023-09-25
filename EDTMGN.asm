       DEF  EDTMGN
       DEF  MGNSRT,MGNEND
*
       REF  PARINX,MGNLST,LINLST          From VAR.asm
       REF  FLDVAL                        "
       REF  ARYINS,ARYDEL                 From ARRAY.asm
       REF  WRAP                          From WRAP.asm

       COPY 'CPUADR.asm'

INDENT EQU  3
LEFT   EQU  4
PWIDTH EQU  5         Paragraph width

       AORG >B000
MGNSRT
       XORG LOADED

EDTMGN
       DECT R10
       MOV  R11,*R10
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
* Set paragraph index of new element
       MOV  @PARINX,*R3
* Let R4 = left margin
EM9    LI   R0,FLDVAL
       BL   @PRSINT
       MOV  R1,R4
* Let R5 = right margin
       LI   R0,FLDVAL
       AI   R0,3
       BL   @PRSINT
       MOV  R1,R5
* Let R5 = paragraph width
* Assume a page width of 80
       NEG  R5
       AI   R5,80
       S    R4,R5
* Set left margin and page width in MGNLST element
       SLA  R4,8
       SLA  R5,8
       MOVB R4,@LEFT(R3)
       MOVB R5,@PWIDTH(R3)
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

*
* Parse 3-character string as integer
*
* Input:
*   R0 - address of string
* Output:
*   R1 - parsed int
PRSINT
       DECT R10
       MOV  R3,*R10
       DECT R10
       MOV  R4,*R10
* Let R1 = parsed number
* Let R3 = number of remaining char
       CLR  R1
       LI   R3,3
* Is next digit empty?
PI1    MOVB *R0+,R4
       JEQ  PI2
* No, multiply previous calculations by 10
       MPY  @TEN,R1
       MOV  R2,R1
* Convert digit to number and add to R1
       SB   @ZERO,R4
       SRA  R4,8
       A    R4,R1
* Have we already converted three digits?
       DEC  R3
       JH   PI1
* Finished
PI2    MOV  *R10+,R4
       MOV  *R10+,R3
       RT
*
TEN    DATA 10
ZERO   TEXT '0'
       EVEN


MGNEND AORG