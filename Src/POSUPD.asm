       DEF  POSUPD
*
       REF  POSUWS
*
       REF  LOOKUP,LNDIFF
*
       REF  STSWIN
*
       REF  GETMGN                     From UTIL.asm
*
       REF  LINLST,MGNLST
       REF  ARYADR
       REF  FORTY
       REF  PARINX,CHRPAX
       REF  LININX,CHRLIX
       REF  WINOFF,WINPAR,WINLIN
       REF  CURSCN

       TEXT 'POSUPD' 
*
* Input:
*  R0 - Prior Document Status
* Output:
*  R0 - New Document Status
POSUPD DATA POSUWS,POSUPD+4
* Let R10 = stack position
       MOV  @20(R13),R10
*
       BL   @UPINDX
       BL   @UPWOFF
       BL   @UPWTOP
	BL   @UPCURS
       RTWP
      
       COPY 'EQUKEY.asm'

*
* Update LININX and CHRLIX
* That is, calculate the line index
* within the current paragraph, and
* the character index within the
* current line.
*
UPINDX
       DECT R10
       MOV  R11,*R10
* Let R1 = address of current paragraph
       MOV  @LINLST,R0
       C    *R0+,*R0+
       MOV  @PARINX,R1
       SLA  R1,1
       A    R0,R1
       MOV  *R1,R1
* R2 = addres of wrap list
* R5 = index of last paragraph-line
       MOV  @2(1),R2
       MOV  *R2,R5
* R2 = addres of wrap list's first element
       C    *R2+,*R2+
* R3 = index of first line in paragraph
* R4 = character within paragraph
       CLR  R3
       MOV  @CHRPAX,R4
* Change R3 to current line in para
* Change R4 to current char in line
POS1   C    R4,*R2
       JL   POS2
       C    R3,R5
       JEQ  POS2
       INC  R3
       INCT R2
       JMP  POS1
* If cursor is not on first line,
* subtract wrap position from R4
POS2   MOV  R3,R3
       JEQ  POS3
       DECT R2
       S    *R2,R4
POS3
* If cursor is on first line
* and a MGNLST entry exists for this paragraph,
* increase R4 by size of paragrah indent.
       MOV  R3,R3
       JNE  POS4
       MOV  @PARINX,R0
       BL   @GETMGN
       MOV  R0,R0
       JEQ  POS4
       AI   R0,INDENT
       MOVB *R0,R0
       SRL  R0,8
       A    R0,R4
POS4
*
       MOV  R3,@LININX
       MOV  R4,@CHRLIX
*
       MOV  *R10+,R11
       RT

*
* Update Window horizontal offset.
*
UPWOFF
* Let R1 equal half of the window size
       LI   R1,SCRNWD/2
* If window is to the right of the
* cursor, move it left.
UPW0   C    @WINOFF,@CHRLIX
       JLE  UPW1
       SOC  @STSWIN,*R13
       S    R1,@WINOFF
       JMP  UPW0
* If window is to the left of the
* cursor, move it right.
UPW1   MOV  @CHRLIX,R0
       AI   R0,-SCRNWD
UPW2   C    @WINOFF,R0
       JGT  UPW3
       SOC  @STSWIN,*R13
       A    R1,@WINOFF
       JMP  UPW2
*
UPW3   RT

*
* Scroll the window up or down based on
* cursor paragraph and line
*
UPWTOP
* Check if cursor is earlier in the 
* document than the first line on the
* screen or not.
       C    @WINPAR,@PARINX
       JL   CHKDWN
       JH   UPWUP
       C    @WINLIN,@LININX
       JLE  CHKDWN
* Cursor is earlier in the document
* than the screen. Scroll the screen up.
UPWUP  MOV  @PARINX,@WINPAR
       MOV  @LININX,@WINLIN
       SOC  @STSWIN,*R13
       RT

* Check if the cursor is later in the
* document than the last line of the
* screen.
CHKDWN
* If the cursor were at the bottom of
* the screen, what paragraph and line
* would be at the top of the screen?
* Place the answer in R0 and R1.
       MOV  @PARINX,R0
       MOV  @LININX,R1
       LI   R2,21
       BLWP @LOOKUP
* If that moves us past document start,
* set hypothetical paragraph to 0.
       CI   R0,-1
       JNE  CHKD1
       CLR  R0
CHKD1
* If that hypothetical paragraph and
* line is later in the document than
* the current Window-paragraph and
* Window-line, then scroll down.
       C    @WINPAR,R0
       JL   UPWDWN
       JH   UPWRT
       C    @WINLIN,R1
       JHE  UPWRT
* Scroll down.
UPWDWN MOV  R0,@WINPAR
       MOV  R1,@WINLIN
       SOC  @STSWIN,*R13
*
UPWRT  RT

*
* Update cursor's position on screen
*
UPCURS 
* Find number of paragraph-lines 
* between cursor's line
       MOV  @WINPAR,R0
       MOV  @WINLIN,R1
       MOV  @PARINX,R2
       MOV  @LININX,R3
       BLWP @LNDIFF
* Increase R0 to account for screen
* header rows
       INCT R0
* Let R1 = number of screen positions
* in lines
	MPY  @FORTY,R0
* Add screen positions for current line
       A    @CHRLIX,R1
       S    @WINOFF,R1
* Save result
       MOV  R1,@CURSCN
*
       RT

       END