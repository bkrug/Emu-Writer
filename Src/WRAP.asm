       DEF  WRAP
       DEF  WRAPDC,WRAPDW
*
* Variables
       REF  LNWDT1,LNWDTH,WINMOD
       REF  PGWDTH,DOCSTS
       REF  PARLST,FMTLST,MGNLST
       REF  BUFREE
       REF  ARYALC,ARYADD,ARYADR
* Workspace
       REF  WRAPWS
* Constants
       REF  SPACE,DASH
       REF  ERRMEM,STSPAR
* From UTIL.asm
       REF  GETMGN

* This data is a work around for the "first DATA word is 0 bug"
       DATA >1234

       COPY 'EQUKEY.asm'

*
* Wrap
*
* Input:
* R0 - Line index. Wrap from here.
* Output:
* DOCSTS
*
WRAP   DATA WRAPWS,WRAP+4
*=======================================
*
* Figure out available line width based
* on left and right margins
*
* Let R8 = address of margin entry for this paragraph
       MOV  *R13,R0
       BL   @GETMGN
       MOV  R0,R8
       JEQ  MGN2B
* Let R0 = indent
       AI   R8,INDENT
       MOVB *R8+,R0
       SRA  R0,8
* Let R1 = paragraph width
       MOVB @PGWDTH,R1
       SB   *R8+,R1
       SB   *R8+,R1
       SRL  R1,8
       JMP  MGN2C
* Set default paragraph width and indents
MGN2B  CLR  R0
       MOVB @PGWDTH,R1
       SRL  R1,8
       AI   R1,-2*DFLTMG
MGN2C
* Are we in windowed mode?
       MOV  @WINMOD,R3
       JEQ  MGN2Z
* No, we are in vertical mode
       LI   R1,SCRNWD-1
* Also make sure indent is in range -20 to +20
       LI   R3,MAXIDT
       C    R0,R3
       JLT  MGN2A
       MOV  R3,R0
MGN2A  NEG  R3
       C    R0,R3
       JGT  MGN2Z
       MOV  R3,R0
* Let R1 = width of first paragraph line
* Let R2 = width of other paragraph lines
MGN2Z  MOV  R1,R2
* Decrease either line 1 width, or regular width by indent
       MOV  R0,R0
       JLT  MGN3
* Indent is positive or zero, decrease first line width
       S    R0,R1
       JMP  MGN5
* Indent is negative, decrease other lines' width
MGN3   A    R0,R2
* Record calculated widths
MGN5   MOV  R1,@LNWDT1
       MOV  R2,@LNWDTH

*
* Let R2 = address of new wrap list
       LI   R0,1
       BLWP @ARYALC
       JEQ  WRPERR
       MOV  R0,R2
* Let R3 = address of paragraph text
* Let R4 = address after paragraph text
       MOV  @PARLST,R0
       MOV  *R13,R1
       BLWP @ARYADR
       MOV  R1,R3
       MOV  *R3,R3
       MOV  *R3,R4
       C    *R3+,*R3+
       A    R3,R4
* Let R5 = address of beginning of current line
       MOV  R3,R5
* Let R7 = line width (of first line in paragraph)
       MOV  @LNWDT1,R7
BRK1
* Let R6 = line break candidate
       MOV  R5,R6
       A    R7,R6
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
       A    R7,R6
       JMP  BRK5
* Move right to next visible character
BRK3
       INC  R6
       C    R6,R4
       JHE  BRK6
       CB   *R6,@SPACE
       JEQ  BRK3
       JMP  BRK5
*
BRK4   INC  R6
* Let R1 = address of new entry in wrap list
BRK5   MOV  R2,R0
       BLWP @ARYADD
       JEQ  WRPERR
       MOV  R0,R2
* Place index within paragraph in new entry
       MOV  R6,*R1
       S    R3,*R1
* Let R7 = line width
       MOV  @LNWDTH,R7
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
	SOC  @STSPAR,@DOCSTS
* Deallocate old wrap list.
WRP6   MOV  *R3,R0
       BLWP @BUFREE
* Register new wrap list with paragraph
       MOV  R2,*R3
       RTWP

WRPERR SOC  @ERRMEM,@DOCSTS
       RTWP

*
* WRAPDC = Wrap all paragraphs in document
* No Input
*
* WRAPDW = Wrap all paragraphs down from given paragraph
* Input
*   R0 = starting paragraph
*
WRAPDC CLR  R0
WRAPDW MOV  @PARLST,R2
WRAPLP C    R0,*R2
       JHE  WRAPDN
       CLR  R1
       BLWP @WRAP
       JEQ  WRAPDN             * If memory error occurs, stop wrapping
       INC  R0
       JMP  WRAPLP
WRAPDN
       RT

       END