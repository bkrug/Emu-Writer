       DEF  POSUPD,GETROW
*
       REF  POSUWS
*
       REF  STSWIN
*
       REF  GETMGN,GETIDT,LSTIDX             From UTIL.asm
       REF  GETLIN,LOOKUP,MGNADR             "
       REF  ARYADR                           From ARRAY.obj
*
       REF  MGNLST
       REF  FORTY
       REF  PARINX,CHRPAX
       REF  LININX,CHRLIX
       REF  WINOFF,WINPAR,WINLIN,WINMGN
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
* Let R2 = line index
* Let R6 = old horizontal position within line
       BL   @GETLIN
*
       MOV  R2,@LININX
       MOV  R6,@CHRLIX
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
UPWTOP DECT R10
       MOV  R11,*R10
* Let R1 = index of last line in paragraph
       MOV  @WINPAR,R2
       BL   @LSTIDX
* Is WINLIN > max line index?
       C    @WINLIN,R1
       JLE  UT1
* Yes, fix that.
* Sometimes this happens after switching to horizontal mode.
       MOV  R1,@WINLIN
UT1
* Check if cursor is earlier in the 
* document than the first line on the
* screen or not.
       C    @WINPAR,@PARINX
       JL   CHKDWN
       JH   UPWUP
       C    @WINLIN,@LININX
       JLE  CHKDWN
* Cursor is earlier in the document
* than the screen.
* Scroll the screen up.
* Turn off display of top paragraph's
* margin entry.
UPWUP  MOV  @PARINX,@WINPAR
       MOV  @LININX,@WINLIN
       CLR  @WINMGN
*
       SOC  @STSWIN,*R13
*
       MOV  *R10+,R11
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
*
       BL   @LOOKUP
* R2 now contains earliest acceptable paragraph.
* R3 now contains earliest acceptable paragraph-line.
* R4 contains value for WINMGN.
*
* Is screen pointing to an earlier paragrah than R2?
       C    @WINPAR,R2
       JL   GODOWN
* No, is screen pointing to a later paragrah than R2?
       JH   SKIP
* No, is screen pointing to an earlier line than R3?
       C    @WINLIN,R3
       JL   GODOWN
* No, is screen pointing to a later lien than R3?
       JH   SKIP
* No, is screen pointing to the start of a paragraph?
       MOV  @WINLIN,R0
       JNE  SKIP
* Yes, is the Margin Entry Display flag set, when it needs to be unset?
       C    @WINMGN,R4
       JGT  SKIP
       JEQ  SKIP
* WINPAR and WINLIN are pointing to a paragraph that is too early.
GODOWN MOV  R2,@WINPAR
       MOV  R3,@WINLIN
       MOV  R4,@WINMGN
* Redraw whole screen
       SOC  @STSWIN,*R13
* If program jumped to this point,
* then it decided to skip updating the screen position.
SKIP   MOV  *R10+,R11
       RT

*
* Update cursor's position on screen
*
UPCURS DECT R10
       MOV  R11,*R10
* Let R4 = screen row that paragraph starts on
       MOV  @PARINX,R0
       BL   @GETROW
       MOV  R0,R4
* Does paragraph have a margin entry?
       MOV  R1,R1
       JEQ  UPCR2
* Yes, is it visible?
       C    @WINPAR,@PARINX
       JNE  UPCR1
       MOV  @WINMGN,R0
       JEQ  UPCR2
* Yes, this is either not the top paragraph
* or the top pararaph's margin entry is visible.
* Add one line to R4.
UPCR1  INC  R4
UPCR2
* Let R4 = screen row that the cursor sits on
       A    @LININX,R4
* Let R5 = screen position based on lines in R4
       LI   R0,SCRNWD
	MPY  R0,R4
* Add screen positions for current line
       A    @CHRLIX,R5
       S    @WINOFF,R5
* Save result
       MOV  R5,@CURSCN
*
       MOV  *R10+,R11
       RT

*
* Calculate the screen row that a given
* paragraph should start on.
*
* Input:
*   R0: requested paragraph
* Output:
*   R0: screen row
*   R1: address of MGNLST entry
*       0 = there is no MGNLST entry for this paragraph
* (Note that the output can be a negative number
* if the paragraph's first line is above the screen)
*
GETROW DECT R10
       MOV  R11,*R10
* Let R3 = requested paragraph
       MOV  R0,R3
* Find number of paragraph-lines 
* between cursor's line and screen's top line
       MOV  @WINPAR,R2
* Let R4 = counted lines
       CLR  R4
       S    @WINLIN,R4
* Is R2 pointing to the cursor paragraph yet?
GR1    C    R2,R3
       JEQ  GR4
* Let R1 = index of last line in paragraph
       BL   @LSTIDX
* Increase R4 by number of lines in paragraph
       A    R1,R4
       INC  R4
* Does the current paragraph have a MGNLST entry?
       MOV  R2,R0
       BL   @MGNADR
       MOV  R1,R1
       JEQ  GR3
* Yes, does R2 either contain an index
* different from the first paragraph on
* screen, or are we supposed to display
* the Margin entry for the first visible
* paragraph?
       C    @WINPAR,R2
       JNE  GR2
       MOV  @WINMGN,R0
       JEQ  GR3
       MOV  @WINLIN,R0
       JNE  GR3
* We will display the Margin entry
* for whatever paragraph is in R2.
* So increment the screen row count.
GR2    INC  R4
* Loop to next paragraph
GR3    INC  R2
       JMP  GR1
*
GR4
* Increase R4 to account for screen
* header rows
       AI   R4,HDRHGT
* Let R1 = address of paragraph's margin entry
       MOV  R3,R0
       BL   @MGNADR
* Let R0 = screen row
       MOV  R4,R0
*
       MOV  *R10+,R11
       RT

       END