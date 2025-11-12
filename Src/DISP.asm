*
* Routine for redisplaying screen text
*
*Input:
* R0 - Document status
*
       DEF  DISP
* Methods for writing to VDP
       REF  VDPADR,VDPWRT,VDPINV,VDPSPC
* From UTIL
       REF  GETIDT
* From POSUPD
       REF  GETROW,MGNADR
* From HEADER
       REF  DRWMGN
*
       REF  DISPWS
       REF  PARLST,FMTLST,MGNLST
       REF  WRAP_START
       REF  PARINX
       REF  WINOFF,WINPAR,WINLIN,WINMGN
       REF  WINMOD
       REF  STSTYP,STSENT,STSWIN
       REF  ERRMEM
       REF  FORTY

       COPY 'EQUKEY.asm'
       COPY 'CPUADR.asm'

       TEXT 'DISP'
DISP   DATA DISPWS,DISP+4
* Let R10 = Stack position
       MOV  @20(R13),R10
*
       BL   @NOTHIN
* Let R9 = starting paragraph index
       BL   @STRPAR
* Let R12 = starting screen row
       LI   R12,HDRHGT
       C    R9,@WINPAR
       JEQ  DISP1
*
       MOV  R9,R0
       BL   @GETROW
       MOV  R0,R12
DISP1
* Set initial VDP address
       BL   @VDPSTR
       
*
* Redraw the rows for one paragraph of
* text.
*
* Let R2 = starting paragraph-line
       CLR  R2
       C    @WINPAR,R9
       JNE  DISP2
       MOV  @WINLIN,R2
* Since we got here, we will re-display
* the screen's top paragraph.
* Should we display the margin entry?
       JNE  DISP3
       MOV  @WINMGN,R0
       JEQ  DISP3
* Yes, if one exists for this paragraph.
DISP2
* Is there a margin list entry?
* Let R1 = address of margin entry
       MOV  R9,R0
       BL   @MGNADR
       MOV  R1,R1
       JEQ  DISP3
* Yes, display it.
       MOV  R1,R0
       BL   @DRWMGN
       LI   R1,SCRNWD-30
       BL   @VDPSPC
* Track screen-row
       INC  R12
       CI   R12,24
       JHE  DISP5
DISP3
* Let R3 = address of paragraph
       MOV  R9,R3
       BL   @PARADR                     * This routine is defined locally, NOT in UTIL.asm
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
DISP4
* Decrease remaining paragraph-lines
       DEC  R6       
* Write a row of text
       BL   @WRTLIN
* Track screen-row
       INC  R12
       CI   R12,24
       JHE  DISP5
* No longer on first paragraph-line
       INC  R2
* Check if this is last paragraph-line
       MOV  R6,R6
       JNE  DISP4
* Increment paragraph-index
       INC  R9
* Set starting line of paragraph.
       CLR  R2
* Continue with next paragraph?
       BL   @NXTPAR
       JEQ  DISP2
*
DISP5  RTWP

********* Sub-Routines *********

*
* Check document status to see if part
* of screen should be redrawn
*
NOTHIN
       MOV  *R13,R0
       ANDI R0,STATYP+STAPAR+STADCR+STAENT+STAWIN
       JNE  NOT1
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
* Did the window move?
       COC  @STSWIN,R0
       JEQ  SP1
* Did the user press enter?
       COC  @STSENT,R0
       JEQ  SP2
* Set starting position to cursor's
* paragraph.
       MOV  @PARINX,R9
       RT
* Set starting position based on window
* position.
SP1    MOV  @WINPAR,R9
       RT
* The user pressed enter, so start from
* a previous paragraph.
SP2    MOV  @WRAP_START,R9
       C    @WINPAR,R9
       JLT  !
       MOV  @WINPAR,R9
!
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
       AI   R0,SCRTBL
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
       A    @PARLST,R3
       C    *R3+,*R3+
       MOV  *R3,R3
       RT

*
* WRTLIN
*
* Write one line of text onto screen.
*
* Input:
*   R2 = index of line within paragraph
*   R3 = address of paragraph text
*   R4 = length of paragraph
*   R5 = address two bytes prior to
*          wrap list's first element
*   R6 = paragraph line count
*   R9 = current paragraph index
*
WRTLIN DECT R10
       MOV  R11,*R10
* Let R8 = size of indent
       MOV  R9,R0
       MOV  R2,R1
       BL   @GETIDT
       MOV  R0,R8
* Let R1 = indent spaces on screen
       MOV  R8,R1
       S    @WINOFF,R1
       JLT  WRTMG9
       JEQ  WRTMG9
* R1 > 0, draw indent
       BL   @VDPSPC
WRTMG9
* According to algorithm derived in GETALG,
* Let R0 = starting position
* Let R1 = length of text
       BL   @GETALG
       BL   *R7
* Let R8 = max columns we can fit on screen
       S    @WINOFF,R8
       JLT  WRTMX
       NEG  R8
       AI   R8,SCRNWD
       JMP  WRTMX1
WRTMX  LI   R8,SCRNWD
WRTMX1
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
*  R8 - left indent
* Output:
* R0, R1
PONELN DECT R10
       MOV  R2,*R10
* TODO: This algorithm for setting R2
* exists in all four algorithms.
* Try not to repeat it anymore.
*
* Let R2 = horizontal offset
* either zero or (Window Offset - indent), whichever is greater
       MOV  @WINOFF,R2
       JEQ  PONE1
       S    R8,R2
       JGT  PONE1
       CLR  R2
PONE1
*
       MOV  R3,R0
       A    R2,R0
* Let R1 be the length of paragraph 
* minus window offset
       MOV  R4,R1
       S    R2,R1
*
       MOV  *R10+,R2
       RT

*
* PFSTLN
* Set parameters for writing a first
* line of a multiline paragraph
*
* Input: 
*  R3 - paragraph text address
*  R5 - wrap list element address
*  R8 - left indent
* Output:
* R0, R1, R5
PFSTLN DECT R10
       MOV  R2,*R10
* Let R2 = horizontal offset
* either zero or (Window Offset - indent), whichever is greater
       MOV  @WINOFF,R2
       JEQ  PFST1
       S    R8,R2
       JGT  PFST1
       CLR  R2
PFST1
*
       MOV  R3,R0
       A    R2,R0
*
       INCT R5
       MOV  *R5,R1
       S    R2,R1
*
       MOV  *R10+,R2
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
*  R8 - left indent
* Output:
* R0, R1, R5
PMIDLN DECT R10
       MOV  R2,*R10
* Let R2 = horizontal offset
* either zero or (Window Offset - indent), whichever is greater
       MOV  @WINOFF,R2
       JEQ  PMID1
       S    R8,R2
       JGT  PMID1
       CLR  R2
PMID1
*
       MOV  *R5,R0
       A    R3,R0
       A    R2,R0
*
       CLR  R1
       S    *R5,R1
       INCT R5
       A    *R5,R1
       S    R2,R1
*
       MOV  *R10+,R2
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
PLSTLN DECT R10
       MOV  R2,*R10
* Let R2 = horizontal offset
* either zero or (Window Offset - indent), whichever is greater
       MOV  @WINOFF,R2
       JEQ  PLST1
       S    R8,R2
       JGT  PLST1
       CLR  R2
PLST1
*
       MOV  *R5,R0
       A    R3,R0
       A    R2,R0
* Let R1 be the length of last line 
* minus window offset
       MOV  R4,R1
       S    *R5,R1
       S    R2,R1
*
       MOV  *R10+,R2
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
       ANDI R0,STAPAR+STAENT+STAWIN+STADCR
       JNE  NXT1
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
       MOV  @PARLST,R0
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