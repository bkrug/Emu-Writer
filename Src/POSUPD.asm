       DEF  POSUPD
*
       REF  POSUWS
*
       REF  STSWIN
*
       REF  GETIDT                     From UTIL.asm
       REF  ARYADR                     From ARRAY.asm
*
       REF  PARLST,MGNLST
       REF  FORTY
       REF  PARINX,CHRPAX
       REF  LININX,CHRLIX
       REF  WINOFF,WINPAR,WINLIN
       REF  CURSCN,WINMOD

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
       MOV  @PARLST,R0
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
* Let R0 = the indent for this line
       MOV  @PARINX,R0
       MOV  R3,R1
       BL   @GETIDT
* increase R4 by size of paragrah indent.
POS4   A    R0,R4
POS5
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
* Update WINPAR and WINLIN.
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
*
* Let R2 = paragraph index
* Let R3 = line index
       MOV  @PARINX,R2
       MOV  @LININX,R3
* Let R4 = number of lines to look upwards
       LI   R4,TXTHGT-1
CD1
* Is number of remaining lines moving backwards
* smaller than remaining lines in this paragraph?
       C    R4,R3
       JLE  CD2
* No, look upwards by at least one paragraph.
* Decrease R4 by this paragraph's line count.
       S    R3,R4
       DEC  R4
* Point to earlier paragraph
       DEC  R2
       JLT  CD3
* Let R1 = address in PARLST
       MOV  @PARLST,R0
       MOV  R2,R1
       BLWP @ARYADR
* Let R1 = address of paragraph
       MOV  *R1,R1
* Let R1 = address of wrap list
       MOV  @2(R1),R1
* Let R3 = index of last line in paragraph
       MOV  *R1,R3
* Try next paragraph
       JMP  CD1
* Earliest acceptable line is in this paragraph
CD2    S    R4,R3
       JMP  CD4
* Earliest acceptable line is the beginning of the document
CD3    CLR  R2
       CLR  R3
CD4
* R2 now contains earliest acceptable paragraph
* R3 now contains earliest acceptable paragraph-line.
*
* Is screen pointing to a later paragrah than R2?
       C    @WINPAR,R2
       JH   CD6
* No, is screen pointing to an earlier paragrah than R2?
       JL   CD5
* No, is screen pointing to an earlier line than R3
       C    @WINLIN,R3
       JHE  CD6
* WINPAR and WINLIN are pointing to a paragraph that is too early.
CD5    MOV  R2,@WINPAR
       MOV  R3,@WINLIN
* Redraw whole screen
       SOC  @STSWIN,*R13
*
CD6    RT

*
* Update cursor's position on screen
*
UPCURS 
* Find number of paragraph-lines 
* between cursor's line and screen's top line
       MOV  @WINPAR,R2
* Let R4 = counted lines
       CLR  R4
       S    @WINLIN,R4
* Is R2 pointing to the cursor paragraph yet?
UC1    C    R2,@PARINX
       JEQ  UC2
* Let R1 = address in PARLST
       MOV  @PARLST,R0
       MOV  R2,R1
       BLWP @ARYADR
* Let R1 = address of paragraph
       MOV  *R1,R1
* Let R1 = address of wrap list
       MOV  @2(R1),R1
* Increase R4 by number of lines in paragraph
       A    *R1,R4
       INC  R4
* Loop to next paragraph
       INC  R2
       JMP  UC1
* Add current line of paragraph to R4
UC2    A    @LININX,R4
* Increase R4 to account for screen
* header rows
       AI   R4,HDRHGT
* Let R5 = screen position based on lines in R4
       LI   R0,SCRNWD
	MPY  R0,R4
* Add screen positions for current line
       A    @CHRLIX,R5
       S    @WINOFF,R5
* Save result
       MOV  R5,@CURSCN
*
       RT

       END