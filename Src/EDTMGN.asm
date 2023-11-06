       DEF  EDTMGN
       DEF  MGNSRT,MGNEND
*
       REF  PARINX,MGNLST,PARLST          From VAR.asm
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
* Let R15 = Page Width
       LI   R0,FLDVAL
       BL   @PRSINT
       MOV  R0,R0
       JNE  EXIT
       MOV  R1,R15
* Let R14 = Page Height
       LI   R0,FLDVAL
       AI   R0,FPHGHT
       BL   @PRSINT
       MOV  R0,R0
       JNE  EXIT
       MOV  R1,R14
*
* Allocate ten bytes to store parsed
* indent, left, right, top, and bottom
* margin as 16-bit values.
*
* Let R6 = address of allocated space
       CLR  R6
       LI   R0,10
       BLWP @BUFALC
       JEQ  EMERR
       MOV  R0,R6
* indent
       LI   R0,FLDVAL
       AI   R0,FINDNT
       BL   @PRSINT
       MOV  R0,R0
       JNE  EXIT
       MOV  R1,*R6
* left margin
       LI   R0,FLDVAL
       AI   R0,FLEFT
       BL   @PRSINT
       MOV  R0,R0
       JNE  EXIT
       MOV  R1,@2(R6)
* right margin
       LI   R0,FLDVAL
       AI   R0,FRIGHT
       BL   @PRSINT
       MOV  R0,R0
       JNE  EXIT
       MOV  R1,@4(R6)
* top margin
       LI   R0,FLDVAL
       AI   R0,FTOP
       BL   @PRSINT
       MOV  R0,R0
       JNE  EXIT
       MOV  R1,@6(R6)
* bottom margin
       LI   R0,FLDVAL
       AI   R0,FBOT
       BL   @PRSINT
       MOV  R0,R0
       JNE  EXIT
       MOV  R1,@8(R6)
*
* Validate margin sizes
*
       BL   @VALIDT
       JEQ  EXIT
*
* Record Validated data
*
       BL   @RECVLD
       JEQ  EMERR
* Search any duplicate entries and delete them.
       BL   @DELDUP
* Re-wrap, this and lower paragraphs
       MOV  @PARINX,R0
       BL   @WRAPDW
* No Error
       CLR  R0
* Leave routine regardless of if an error occurred or not.
EXIT   DECT R10
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
MINSIZ DATA 10
MAXSIZ DATA 254
ZERO   TEXT '0'
NINE   TEXT '9'
LETERH TEXT 'H'
PGBIG  TEXT 'Maximum page sizes are 254'
       BYTE 0
PGSML  TEXT 'Minimum page sizes are 10'
       BYTE 0
MGNERR TEXT 'Some of margins & indents too large'
       BYTE 0
TBMERR TEXT 'Page height minus margins must be > 10'
       BYTE 0
NUMERR TEXT 'Margins and Page Sizes must be numbers'
       BYTE 0
REQERR TEXT 'All fields are required'
       BYTE 0
       EVEN

*
* Validate the margins and page sizes
*
* Input
*   R6: Address of parsed margin values
*   R14: New Page Height
*   R15: New Page Width
*
VALIDT
* Validate Page Sizes
       LI   R1,PGSML
       C    R14,@MINSIZ
       JL   VLDERR
       C    R15,@MINSIZ
       JL   VLDERR
*
       LI   R1,PGBIG
       C    R14,@MAXSIZ
       JH   VLDERR
       C    R15,@MAXSIZ
       JH   VLDERR
* Let R1 = ABS(indent)
       MOV  *R6,R1
       ABS  R1
* Let R0 = paragraph width
       MOV  15,R0
       S    @2(R6),R0
       S    @4(R6),R0
       S    R1,R0
* Is resulting paragraph width large enough?
       LI   R1,MGNERR
       C    R0,@MINSIZ
       JLT  VLDERR
* Let R0 = pritable lines per page
       MOV  R14,R0
       S    @6(R6),R0
       S    @8(R6),R0
* Is resulting printable height high enough?
       LI   R1,TBMERR
       C    R0,@MINSIZ
       JLT  VLDERR
* Reset EQU status bit to indicate no error
       LI   R2,-1
       RT
* No, set error message
VLDERR SETO R0
* Set EQU status bit to indicate error
       S    R2,R2
       RT

*
* Record Validated Data
*
* Output:
*   If Status EQ = true, indicates error
RECVLD
* Create or Edit Margin List entry
* Let R2 = index of MGNLST element
* Let R3 = address of MGNLST element
* Let R4 = element count
       CLR  R2
       MOV  @MGNLST,R4
       MOV  R4,R3
       C    *R3+,*R3+
       MOV  *R4,R4
* Do we need to insert element at end of list?
       JEQ  RV2
* Find first MGNLST element for matching or later paragraph
RV1    C    *R3,@PARINX
       JH   RV2
       JEQ  RV3
       AI   R3,8
       INC  R2
       C    R2,R4
       JL   RV1
* We need to insert a new element
RV2    MOV  @MGNLST,R0
       MOV  R2,R1
       BLWP @ARYINS
       JEQ  MEMERR
       MOV  R0,@MGNLST
       MOV  R1,R3
RV3
* Is indent hanging?
       LI   R0,FLDVAL
       AI   R0,FHANG
       CB   *R0,@LETERH
       JNE  RV4
* Yes, negate it.
       NEG  *R6
RV4
* Set Paragraph Index
       MOV  @PARINX,*R3
* Copy margin data to actual MGNLST
       MOVB @1(R6),@INDENT(R3)
       MOVB @3(R6),@LEFT(R3)
       MOVB @5(R6),@RIGHT(R3)
       MOVB @7(R6),@TOP(R3)
       MOVB @9(R6),@BOTTOM(R3)
* Record Page Width
       SLA  R15,8
       MOVB R15,@PGWDTH
* Record Page Height
       SLA  R14,8
       MOVB R14,@PGHGHT
* No error       
       RT
* Memeory Error
MEMERR S    R0,R0
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
* Let R1 = address of a margin entry
DUP1   MOV  R2,R1
       BLWP @ARYADR
* Let R3 = a location within the margin entry
* Let R4 = address of next element
       MOV  R1,R3
       AI   R3,INDENT
       MOV  R1,R4
       AI   R4,MGNLNG
* Compare margins and indents for each
* element
DUPCMP CB   @MGNLNG(R3),*R3+
       JNE  DUP2
       C    R3,R4
       JL   DUPCMP
* Duplicate found, delete it.
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