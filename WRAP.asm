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
       MOV  R8,@MGNEND
* Move backwards through margin list
* Find the entry for our target
* paragraph, or the entry before it.
MGN1   S    @MGNLEN,R8
       C    R8,R9
       JL   MGN4
       C    *R8,*R13
       JH   MGN1
* We found current margin entry
* Get indent and left/right margin
MGN2   INCT R8
       MOV  *R8+,R7
       MOV  *R8,R8
       JMP  MGN5
* The format list is empty
MGN3   C    *R9+,*R9+
       MOV  R9,@MGNEND
* There is no previous format
MGN4   LI   R7,>0000
       LI   R8,>1414
* R7 now contains indent and some junk.
* R8 now contains left and right margin.
* Limit R7 to just indent.
* Put left margin in R8
* Put right margin in R9
MGN5   MOV  R8,R9
       SRA  R8,8
       MOVB R8,R9
       SLA  R7,8
       SRA  R7,8
* Convert margins from 1/20th to 1/120th
* of an inch.
       MPY  @SIX,R9
       MPY  @SIX,R8
       MPY  @SIX,R7
       MOV  R8,R7
       ABS  R8
* Now index is in R7,
* absolute index is in R8,
* left margin is in R9,
* right margin is in R10.
* Set R0:
* Page Width - left margn - right margin
* Set R1:
* R0 - indent
       MOV  @PGWDTH,R0
       S    R9,R0
       S    R10,R0
*
       MOV  R0,R1
       S    R8,R1
* If this is a hanging indent,
* R0 goes in LNWDT1, R1 goes in LNWDTH
* else reverse.
       MOV  R7,R7
       JLT  MGN6
       MOV  R0,@LNWDTH
       MOV  R1,@LNWDT1
       JMP  MGN7
MGN6   MOV  R0,@LNWDT1
       MOV  R1,@LNWDTH
MGN7

*=======================================
*
* Let R8 hold the the current char width
* Let R9 hold the the next char change
* Let FMTEND hold the address following
*     the format list
*
       MOV  @FMTLST,R9
       MOV  *R9,R8
       JEQ  FMT3
       SLA  R8,3
       C    *R9+,*R9+
       A    R9,R8
       MOV  R8,@FMTEND
* Move backwards through format list
* Find the entry for the begining of our
* target paragraph, or the last entry
* of a previous paragraph.
FMT1   S    @FMTLEN,R8
       C    R8,R9
       JL   FMT4
       C    *R8,*R13
       JH   FMT1
       JL   FMT2
       MOV  @2(R8),@2(R8)
       JNE  FMT1
* We found current format
FMT2   MOV  R8,R9
       A    @FMTLEN,R9
       AI   R8,6
       MOV  *R8,R8
       JMP  FMT5
* The format list is empty
FMT3   C    *R9+,*R9+
       MOV  R9,@FMTEND
* There is no previous format
FMT4   LI   R8,12
* R8, R9, and FMTEND now have required
* values.
FMT5

*=======================================
*
* Let R3 hold address of beginning of a
*    line within the paragraph.
* Let R4 hold address of beginning of
*    the following line
* Let R5 hold begining of paragraph text
* Let R6 hold address of new wrap list.
* Let R7 hold the address past the end
*    of the paragraph.
*
* address of paragraph text
       MOV  @LINLST,R0
       MOV  *R13,R1
       BLWP @ARYADR
       MOV  R1,R5
       MOV  *R5,R5
       MOV  *R5,R7               Put character length in R7
       C    *R5+,*R5+            Skip paragraph header
* address of begginng of line
       MOV  R5,R3
* address after end of paragraph
       A    R5,R7
* Create new wrap list and save address
       LI   R0,1
       BLWP @ARYALC
       CI   R0,>FFFF
       JEQ  WRPERR
       MOV  R0,R6


*=========================
*
* Populate New Wrap List
*
*=========================
       MOV  R3,R4
* 
* Determine number of characters to go
* into the next line based on the CPI at
* this point in the document and place
* this in R2
*
CHRCT1 MOV  R3,R2
       S    R5,R2
* Use R10 as the remaining line width.
* Give it a different value for first
* line in paragraph.
       MOV  @LNWDTH,R10
       MOV  R2,R2
       JNE  CHRCT2
       MOV  @LNWDT1,R10
* If the next format position points
* past the format list or at a different
* paragraph, then goto CHRCT5.
*   If the next format position does not
* change the character width, look at
* the next format list item.
CHRCT2
CHRCT3 C    R9,@FMTEND
       JEQ  CHRCT5
       C    *R9,*R13
       JNE  CHRCT5
       C    @6(9),R8
       JNE  CHRCT4
       A    @FMTLEN,R9
       JMP  CHRCT3
* Given the current character width,
* find out how much space the characters
* between the format changes will use.
* If the result is less than the
* remaining line width in R10, then
* subtract from R10. Otherwise, goto
* CHRCT5.
CHRCT4 MOV  @2(9),R0
       S    R2,R0
       MPY  R8,R0
       C    R1,R10
       JH   CHRCT5
       S    R1,R10
       MOV  @2(9),R2
       MOV  @6(9),R8          Record new character width
       A    @FMTLEN,R9
       JMP  CHRCT3
* Divide remaining line width by current
* character width and add result to R2
CHRCT5 CLR  R0
       MOV  R10,R1
       DIV  R8,R0
       A    R0,R2
* Decrease R2 by the number of
* characters already placed in previous
* lines.
       A    R5,R2
       S    R3,R2
*
* R2 now contains the maximum number of
* visible characters that can go in the
* next line. Increase R4 by this amount
* and then adjust it to a good breaking
* character.
*
       A    R2,R4
* Is R4 past end of paragraph?
       C    R4,R7
       JHE  WRP5
*
       CB   *R4,@SPACE
       JEQ  WRP2
* Find last invisible character in early
* line
       MOV  R4,R0
WRP1   DEC  R4
       CB   *R4,@SPACE
       JEQ  WRP3
       CB   *R4,@DASH
       JEQ  WRP3
       C    R4,R3
       JH   WRP1
* The word at the beginning of this line
* cannot fit on one line. Break it in middle.
       MOV  R0,R4
       JMP  WRP4
* Find first visible character in next
* line
WRP2   INC  R4
       C    R4,R7
       JHE  WRP5
       CB   *R4,@SPACE
       JEQ  WRP2
       JMP  WRP4
WRP3   INC  R4
* Put address at end of wrap list
WRP4   MOV  R6,R0
       BLWP @ARYADD
       CI   R0,>FFFF
       JEQ  WRPERR
       MOV  R0,R6
       MOV  R4,*R1
* Convert from address to string index
       S    R5,*R1
* Do next line in paragraph
       MOV  R4,R3
       JMP  CHRCT1
* 
* All remaining characters fit on one
* line.
WRP5


*=======================================
* Change R5 from paragraph text address
* to pointer to paragraph's wrap list.
       DECT R5
* Compare line count in old wrap list
* to new wrap list.
* Let R7 = address of old wrap list
       MOV  *R5,R7
	C    *R7,*R6
	JEQ  WRP6
	SOC  @STSPAR,@2(13)
* Deallocate old wrap list.
WRP6   MOV  *R5,R0
       BLWP @BUFREE
* Register new wrap list with paragraph
       MOV  R6,*R5
       RTWP

WRPERR SOC  @ERRMEM,@2(13)
       RTWP

       END