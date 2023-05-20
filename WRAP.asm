       DEF  WRAP
*
       REF  LINLST,FMTLST,MGNLST
       REF  BUFREE
       REF  ARYALC,ARYADD,ARYADR
* Workspace
       REF  WRAPWS
* Constants
       REF  SPACE,DASH,SIX
       REF  FMTLEN,MGNLEN,PGWDTH
       REF  ERRMEM,STSPAR
* Variables
       REF  FMTEND,MGNEND,LNWDT1,LNWDTH

* This data is a work around for the "first DATA word is 0 bug"
* TODO: Write an issue to Ralph B.'s github
       DATA >1234

*
* Wrap
*
* Input:
* R0 - Line index. Wrap from here.
* R1 - Document Staus
* Output:
* R1 - Document Status
*
WRAP   DATA WRAPWS,WRAP+4
*=======================================
*
* Figure out available line width based
* on left and right margins
*
*
       MOV  @MGNLST,R9
       MOV  *R9,R8
       JEQ  MGN3
       SLA  R8,3
       C    *R9+,*R9+
       A    R9,R8
* Move backwards through margin list
* Find the entry for our target
* paragraph, or the entry before it.
MGN1   S    @MGNLEN,R8
       C    R8,R9
       JL   MGN4
       C    *R8,*R13
       JH   MGN1
* We found current margin entry
* Record Pargraph Width
MGN2   INCT R8
       INCT R8
       MOV  *R8,R0
       SB   R0,R0
       MOV  R0,@LNWDTH
       MOV  R0,@LNWDT1
       JMP  MGN5
* The format list is empty
MGN3
* Set default paragraph width
MGN4   LI   R8,60
       MOV  R8,@LNWDTH
       MOV  R8,@LNWDT1
MGN5

* Let R2 = address of new wrap list
       LI   R0,1
       BLWP @ARYALC
       CI   R0,>FFFF
       JEQ  WRPERR
       MOV  R0,R2
* Let R3 = address of paragraph text
* Let R4 = address after paragraph text
       MOV  @LINLST,R0
       MOV  *R13,R1
       BLWP @ARYADR
       MOV  R1,R3
       MOV  *R3,R3
       MOV  *R3,R4
       C    *R3+,*R3+
       A    R3,R4
* Let R5 = address of beginning of current line
       MOV  R3,R5
BRK1
* Let R6 = line break candidate
       MOV  R5,R6
       A    @LNWDTH,R6
* Past end of paragraph?
       C    R6,R4
       JHE  BRK6
* Is current char breakable?
       CB   *R6,@SPACE
       JEQ  BRK3
* No, move left to first breakable
BRK2   DEC  R6
       CB   *R6,@SPACE
       JEQ  BRK4
       CB   *R6,@DASH
       JEQ  BRK4
       C    R6,R5
       JH   BRK2
* The word at the beginning of this line
* cannot fit on one line. Break it in middle.
       MOV  R5,R6
       A    @LNWDTH,R6
       JMP  BRK5
* Move right to next visible character
BRK3
       INC  R6
       C    R6,R4
       JHE  BRK6
       CB   *R6,@SPACE
       JEQ  BRK3
       JMP  BRK5
BRK4   INC  R6
BRK5
* Let R1 = address of new entry in wrap list
       MOV  R2,R0
       BLWP @ARYADD
       CI   R0,>FFFF
       JEQ  WRPERR
       MOV  R0,R2
* Place index within paragraph in new entry
       MOV  R6,*R1
       S    R3,*R1
* Do next line in paragraph
       MOV  R6,R5
       JMP  BRK1
* 
* All remaining characters fit on one
* line.
BRK6

*=======================================
* Change R3 from paragraph text address
* to pointer to paragraph's wrap list.
       DECT R3
* Compare line count in old wrap list
* to new wrap list.
* Let R7 = address of old wrap list
       MOV  *R3,R7
	C    *R7,*R2
	JEQ  WRP6
	SOC  @STSPAR,@2(13)
* Deallocate old wrap list.
WRP6   MOV  *R3,R0
       BLWP @BUFREE
* Register new wrap list with paragraph
       MOV  R2,*R3
       RTWP

WRPERR SOC  @ERRMEM,@2(13)
       RTWP

       END