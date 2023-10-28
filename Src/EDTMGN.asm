       DEF  EDTMGN
       DEF  MGNSRT,MGNEND
*
       REF  PARINX,MGNLST,LINLST          From VAR.asm
       REF  FLDVAL,PGWDTH,PGHGHT          "
       REF  BUFALC,BUFREE,BUFCPY          From MEMBUF
       REF  ARYINS,ARYDEL,ARYADR          From ARRAY
       REF  WRAP                          From WRAP.asm
       REF  WRAPDw                        From UTIL.asm

       COPY 'CPUADR.asm'
       COPY 'EQUKEY.asm'

       AORG >B000
MGNSRT
       XORG LOADED

EDTMGN
       DECT R10
       MOV  R11,*R10
* Record Page Width
       LI   R0,FLDVAL
       BL   @PRSINT
       MOV  R0,R0
       JNE  EM10
       SLA  R1,8
       MOVB R1,@PGWDTH
* Record Page Height
       LI   R0,FLDVAL
       AI   R0,FPHGHT
       BL   @PRSINT
       MOV  R0,R0
       JNE  EM10
       SLA  R1,8
       MOVB R1,@PGHGHT
*
* Allocate enough space for a MGNLST element
*
* Let R6 = address of allocated space
       CLR  R6
       LI   R0,MGNLNG
       BLWP @BUFALC
       JEQ  EMERR
       MOV  R0,R6
* Set Paragraph Index
       MOV  @PARINX,*R6
*
* Read user input for left/right margin
*
* Let R4 = left margin
       LI   R0,FLDVAL
       AI   R0,FLEFT
       BL   @PRSINT
       MOV  R0,R0
       JNE  EM10
       MOV  R1,R4
* Let R5 = right margin
       LI   R0,FLDVAL
       AI   R0,FRIGHT
       BL   @PRSINT
       MOV  R0,R0
       JNE  EM10
       MOV  R1,R5
* Validate margin sizes
       BL   @MGNSIZ
       JEQ  EM10
* Set left margin and paragraph width in MGNLST element
       SLA  R4,8
       SLA  R5,8
       MOVB R4,@LEFT(R6)
       MOVB R5,@RIGHT(R6)
*
* Read user input for indent
*
* Let R4 = indent
       LI   R0,FLDVAL
       AI   R0,FINDNT
       BL   @PRSINT
       MOV  R0,R0
       JNE  EM10
       MOV  R1,R4
* Set indent in MGNLST entry
       SLA  R4,8
       MOVB R4,@INDENT(R6)
*
* Create or Edit Margin List entry
*
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
EM9
* Copy margin data to actual MGNLST
       MOV  R6,R0
       MOV  R3,R1
       LI   R2,MGNLNG
       BLWP @BUFCPY
* Search any duplicate entries and delete them.
       BL   @DELDUP
* Re-wrap, this and lower paragraphs
       MOV  @PARINX,R0
       BL   @WRAPDW
* No Error
       CLR  R0
* Leave routine regardless of if an error occurred or not.
EM10   DECT R10
       MOV  R0,*R10
* Deallocate temp workspace
       MOV  R6,R0
       BLWP @BUFREE
*
       MOV  *R10+,R0
       MOV  *R10+,R11
       RT

*
* An out-of-memeory error occurred
*
EMERR
* Deallocate temp workspace
       MOV  R6,R0
       JEQ  EMERR1
       BLWP @BUFREE
*
EMERR1 SETO R0
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
* Is next char a digit?
       CB   R4,@ZERO
       JL   PTERR
       CB   R4,@NINE
       JH   PTERR
* Yes, multiply previous calculations by 10
       MPY  @TEN,R1
       MOV  R2,R1
* Convert digit to number and add to R1
       SB   @ZERO,R4
       SRA  R4,8
       A    R4,R1
* Have we already converted three digits?
       DEC  R3
       JH   PI1
PI2
* Did we find at least one digit?
       CI   R3,3
       JEQ  PTREQ
* Yes, so restore values from stack and return
       MOV  *R10+,R4
       MOV  *R10+,R3
* Set EQU status bit to false
       CLR  R0
       RT
* Error: Field is empty
PTREQ  LI   R1,REQERR
       JMP  PTERR1       
* Error: This is not a number
PTERR
       LI   R1,NUMERR
PTERR1 SETO R0
*
       MOV  *R10+,R4
       MOV  *R10+,R3
       RT
*
TEN    DATA 10
ZERO   TEXT '0'
NINE   TEXT '9'
MGNERR TEXT 'Page width minus margins must be > 10'
       BYTE 0
NUMERR TEXT 'Margins must be numbers'
       BYTE 0
REQERR TEXT 'All fields are required'
       BYTE 0
       EVEN

*
* Validate that the combined left/right margin size is okay
*
* Input
*   R4: left margin
*   R5: right margin
*
MGNSIZ
* Let R0 = paragraph width
       MOVB @PGWDTH,R0
       SRL  R0,8
       S    R5,R0
       S    R4,R0       
* Is combined left/right margin small enough?
       CI   R0,9
       JGT  MGNRT
* No, set error message
       SETO R0
       LI   R1,MGNERR
* Set EQU status bit to indicate error
       S    R2,R2
       RT
* Reset EQU status bit to indicate no error
MGNRT  LI   R2,-1
       RT

*
* Search any duplicate entries and delete them.
*
DELDUP
* Let R0 = begining of MGNLST
* Let R2 = index of current element
       MOV  @MGNLST,R0
       MOV  *R0,R2
       DECT R2
       JLT  DUP3
* Compare left margin and paragraph width
* for each element
DUP1   MOV  R2,R1
       BLWP @ARYADR
       CB   @INDENT(R1),@MGNLNG+INDENT(R1)
       JNE  DUP2
       C    @LEFT(R1),@MGNLNG+LEFT(R1)
       JNE  DUP2
* Delete duplicate
       MOV  R2,R1
       INC  R1
       BLWP @ARYDEL
* Get ready for next element
DUP2   DEC  R2
       JGT  DUP1
       JEQ  DUP1
DUP3
       RT

MGNEND AORG