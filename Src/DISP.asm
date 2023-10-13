*
* Routine for redisplaying screen text
*
*Input:
* R0 - Document status
*
       DEF  DISP
* Methods for writing to VDP
       REF  VDPADR,VDPWRT,VDPSPC
* From UTIL
       REF  GETMGN
*
       REF  DISPWS
       REF  LINLST,FMTLST,MGNLST
       REF  PARINX
       REF  WINOFF,WINPAR,WINLIN
       REF  STSTYP,STSENT,STSDCR
       REF  STSPAR,STSWIN
       REF  ERRMEM
       REF  FORTY

       COPY 'EQUKEY.asm'

       TEXT 'DISP'
DISP   DATA DISPWS,DISP+4
* Let R10 = Stack position
       MOV  @20(R13),R10
*
       BL   @NOTHIN
* Let R9 = starting paragraph index
* Let R12 = starting screen row
* Set initial VDP address
       BL   @STRPAR
       BL   @SCRNRW
       BL   @VDPSTR
       
*
* Redraw the rows for one paragraph of
* text.
*
* Let R2 = starting paragraph-line
       CLR  R2
       C    @WINPAR,R9
       JNE  DISP1
       MOV  @WINLIN,R2
* Let R3 = address of starting paragraph
DISP1  MOV  R9,R3
       BL   @PARADR
* Let R3 = address of paragraph text
* Let R4 = length of paragraph
* Let R5 = address two bytes prior to
*          wrap list's first element
* Let R6 = paragraph line count
       MOV  *R3+,R4
       MOV  *R3+,R5
       MOV  *R5+,R6
       INC  R6
* If starting in the middle of the
* paragraph. Adjust R5 and R6.
       S    R2,R6
       A    R2,R5
       A    R2,R5
DISP2
* Decrease remaining paragraph-lines
       DEC  R6       
* Write a row of text
       BL   @WRTLIN
* Track screen-row
       INC  R12
       CI   R12,24
       JHE  DISP3
* No longer on first paragraph-line
       INC  R2
* Check if this is last paragraph-line
       MOV  R6,R6
       JNE  DISP2
* Increment paragraph-index
       INC  R9
* Set starting line of paragraph.
       CLR  R2
* Continue with next paragraph?
       BL   @NXTPAR
       JEQ  DISP1
*
DISP3  RTWP

********* Sub-Routines *********

*
* Check document status to see if part
* of screen should be redrawn
*
NOTHIN
       MOV  *R13,R0
       COC  @STSTYP,R0
       JEQ  NOT1
       COC  @STSPAR,R0
       JEQ  NOT1
       COC  @STSDCR,R0
       JEQ  NOT1
       COC  @STSENT,R0
       JEQ  NOT1
       COC  @STSWIN,R0
       JEQ  NOT1
* Nothing to redraw
       RTWP
* Redraw some portion of the screen
NOT1   RT

*
* Let R9 = starting paragraph index
*
STRPAR 
* Let R0 = contain document status
       MOV  *R13,R0
* If window has moved, redraw screen.
       COC  @STSWIN,R0
       JEQ  SP2
* Set starting position to cursor's
* paragraph.
       MOV  @PARINX,R9
* Avoid setting R9 to -1.
       JEQ  SP1
* If the user pressed enter, start from
* previous paragraph.
       COC  @STSENT,R0
       JNE  SP1
       DEC  R9
*
SP1    RT
* Set starting position based on window
* position.
SP2    MOV  @WINPAR,R9
       RT

*
* Let R12 = starting screen row
*
SCRNRW DECT R10
       MOV  R11,*R10
* If cursor's paragraph is at top of
* screen, then only skip screen header.
       CLR  R12
       C    @WINPAR,R9
       JEQ  SROW2
*
       MOV  @WINPAR,R1
* Let R12 total screen rows to skip
       MOV  @WINLIN,R12
       NEG  R12
* Let R3 = paragraph address
SROW1  MOV  R1,R3
       BL   @PARADR
* Let R3 = wrap list address
       INCT R3
       MOV  *R3,R3
* Add paragraph length to row count
       A    *R3,R12
       INC  R12
* Keep going until we reach the
* cursor's paragraph
       INC  R1
       C    R1,R9
       JL   SROW1
* Skip two rows that are reserved for
* document information.
SROW2  INCT R12
*
       MOV  *R10+,R11
       RT
       
*
* Set VDP write address so that the
* routine can redraw the current
* paragraph.
*
VDPSTR DECT R10
       MOV  R11,*R10
* Let R0 = R12 * screen width
       MOV  R12,R2
       MPY  @FORTY,R2
       MOV  R3,R0
* Set VDP write address
       BL   @VDPADR
*
       MOV  *R10+,R11
       RT

*
* Get paragraph address from index
*
* Input:
* R3 - paragraph index
* Output:
* R3 - paragraph address
PARADR SLA  R3,1
       A    @LINLST,R3
       C    *R3+,*R3+
       MOV  *R3,R3
       RT

*
* WRTLIN
*
* Write one line of text onto screen.
*
* Input:
* R2,R3,R4,R5,R6
* R9 = current paragraph index
*
WRTLIN DECT R10
       MOV  R11,*R10
* Let R8 = size of indent
       CLR  R8
* Should we write indent?
*       MOV  R2,R2
*       JNE  WRTMG9
*       MOV  R9,R0
*       BL   @GETMGN
*       MOV  R0,R8
*       JEQ  WRTMG9
*       MOVB @INDENT(R8),R8
*       JEQ  WRTMG9
* Yes, write indent spaces
* Let R8 = size of indent
*       SRL  R8,8
*       MOV  R8,R1
*       BL   @VDPSPC
WRTMG9
* Set R0 & R1 parameters for starting
* position and length of text
       BL   @GETALG       
       BL   *R7
* Let R8 = number of columns right of indent
       NEG  R8
       AI   R8,SCRNWD
* Length must be >= 0 and <= R8
       MOV  R1,R1
       JGT  WRTL1
       CLR  R1
WRTL1  C    R1,R8
       JLE  WRTL2
       MOV  R8,R1
WRTL2
* Write visible chars to screen.
       MOV  R1,R7
       BL   @VDPWRT
* Write trailing spaces
       MOV  R7,R1
       NEG  R1
       A    R8,R1
       BL   @VDPSPC
*
       MOV  *R10+,R11
       RT

*
* Get algorithm appropriate for
* setting starting position and length
* parameters for writing
* Single-line paragraph, first-line,
* mid-line, or last-line
*
* Input:
* R2 - number of paragraph-lines before 
*      current line
* R6 - number of paragraph-lines after
*      current line
* Output
* R7 - address of parameter routine
*
GETALG LI   R7,ALGLST
* If R2 != 0, add 4 to R7
       MOV  R2,R2
       JEQ  ALG1
       C    *R7+,*R7+
* If R6 != 0, add 2 to R7
ALG1   MOV  R6,R6
       JEQ  ALG2
       INCT R7
* Put routine address in R7
ALG2   MOV  *R7,R7
*
       RT

ALGLST
* First-line Yes, Last-line Yes
       DATA PONELN
* First-line Yes, Last-line No
       DATA PFSTLN
* First-line No, Last-line Yes
       DATA PLSTLN
* First-line No, Last-line No
       DATA PMIDLN

*
* PONELN
* Set parameters for writing a one line
* paragraph
*
* Input:
*  R3 - paragraph text address
*  R4 - length of paragraph
* Output:
* R0, R1
PONELN MOV  R3,R0
       A    @WINOFF,R0
* Let R1 be the length of paragraph 
* minus window offset
       MOV  R4,R1
       S    @WINOFF,R1
       RT

*
* PFSTLN
* Set parameters for writing a first
* line of a multiline paragraph
*
* Input: 
*  R3 - paragraph text address
*  R5 - wrap list element address
* Output:
* R0, R1, R5
PFSTLN MOV  R3,R0
       A    @WINOFF,R0
*
       INCT R5
       MOV  *R5,R1
       S    @WINOFF,R1
*
       RT
      
*
* PMIDLN
* Set parameters for writing a
* non-first and non-last line of
* a multiline paragraph
*
* Input: 
*  R3 - paragraph text address
*  R5 - wrap list element address
* Output:
* R0, R1, R5
PMIDLN MOV  *R5,R0
       A    R3,R0
       A    @WINOFF,R0
*
       CLR  R1
       S    *R5,R1
       INCT R5
       A    *R5,R1
       S    @WINOFF,R1
       RT

*
* PLSTLN
* Set parameters for writing a last
* line of a mulitline paragraph
*
* Input: 
*  R3 - paragraph text address
*  R4 - length or paragraph
*  R5 - wrap list element address
* Output:
* R0, R1, R5
PLSTLN 
       MOV  *R5,R0
       A    R3,R0
       A    @WINOFF,R0
* Let R1 be the length of last line 
* minus window offset
       MOV  R4,R1
       S    *R5,R1
       S    @WINOFF,R1
       RT

*
* Decide wether or not to continue
* by drawing the next paragraph.
*
NXTPAR DECT R10
       MOV  R11,*R10
* If paragraph line-count changed,
* continue drawing the screen.
       MOV  *R13,R0
       COC  @STSPAR,R0
       JEQ  NXT1
       COC  @STSENT,R0
       JEQ  NXT1
       COC  @STSWIN,R0
       JEQ  NXT1
       COC  @STSDCR,R0
       JEQ  NXT1
* Don't write next paragraph
NXTNO
       MOV  *R10+,R11
       LI   R0,-1
       RT
* Write next paragraph
NXTYES
       MOV  *R10+,R11
       S    R0,R0
       RT
*
NXT1
* Don't read past document-end
       MOV  @LINLST,R0
       C    R9,*R0
       JL   NXTYES
* Clear remaining screen
       LI   R0,24
       S    R12,R0
       MPY  @FORTY,R0
       BL   @VDPSPC
*
       JMP  NXTNO

       END