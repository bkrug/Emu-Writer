       DEF  LINBEG,LINEND
       DEF  UPUPSP,DOWNSP,PGUP,PGDOWN
       DEF  NXTWIN
*
       REF  PARLST                               From VAR.asm
       REF  PARINX,CHRPAX                        "
       REF  STSARW,STSDSH                        "
       REF  WINPAR,WINLIN,WINMGN,WINMOD          "
       REF  PRFHRZ,WINOFF                        "
       REF  STSWIN                               From CONST.asm
       REF  GETIDT,GETMGN                        From UTIL.asm
       REF  PARADR,GETLIN,LOOKUP,LOOKDW          "
       REF  ARYADR                               From ARRAY

       COPY 'EQUKEY.asm'

*
* Beginning of Line
*
LINBEG CLR  R9
       JMP  LINSID

*
* End of Line
*
LINEND LI   R9,>7FFF
*
LINSID DECT R10
       MOV  R11,*R10
* Let R2 = line index
* Let R3 = Address of paragraph
* Let R4 = Wrap list address
* Let R6 = old horizontal position within line
       BL   @GETLIN
* Let horizontal position be some extreme position
       MOV  R9,R6
* Set char position to end of the line
       BL   @SETCHR
*
       MOV  *R10+,R11
       RT

*
* Move the cursor up by one line
*
UPUPSP DECT R10
       MOV  R11,*R10
* Let R2 = line index
* Let R3 = Address of paragraph
* Let R4 = Wrap list address
* Let R6 = old horizontal position within line
       BL   @GETLNH
* Move up within same paragraph
       DEC  R2
       JGT  UPSP2
       JEQ  UPSP2
* Cursor was already at the top of the paragraph.
* Try to move up to previous one.
* Is this the first of the of document?
UPSP1  MOV  @PARINX,R0
       JEQ  UPSP3
* No, move up to previous paragraph
       DEC  @PARINX
       SOC  @STSDSH,*R13
* Let R3 = Address of paragraph
* Let R4 = Wrap list address
       BL   @PARADR
* Let R2 = index of last line in paragraph
       MOV  *R4,R2
* Update CHRPAX
UPSP2  BL   @SETCHR
*
UPSP3  MOV  *R10+,R11
       RT

*
* Move the cursor down by one line
*
DOWNSP DECT R10
       MOV  R11,*R10
* Let R2 = line index
* Let R3 = Address of paragraph
* Let R4 = Wrap list address
* Let R6 = old horizontal position within line
       BL   @GETLNH
* Move down within same paragraph
       INC  R2
* Did we move past the last paragraph-line?
       C    R2,*R4
       JLE  DWNSP2
* Yes, is this already the last paragraph in the document?
DWNSP1 MOV  @PARLST,R0
       MOV  *R0,R0
       DEC  R0
       C    @PARINX,R0
       JEQ  DWNSP3
* No, move down to next paragraph
       INC  @PARINX
       CLR  R2
       SOC  @STSDSH,*R13
* Let R3 = Address of paragraph
* Let R4 = Wrap list address
       BL   @PARADR
* Update CHRPAX
DWNSP2 BL   @SETCHR
*
DWNSP3 MOV  *R10+,R11
       RT

*
* Move cursor and window-position
* down by 22 lines.
*
PGDOWN LI   R9,LOOKDW
       JMP  PAGVRT

*
* Move cursor and window-position
* up by 22 lines.
*
PGUP   LI   R9,LOOKUP

*
* Move cursor and window-position
* vertically by 22 lines.
*
* Input:
*   R9 - Address for either LOOKUP or LOOKDW
PAGVRT DECT R10
       MOV  R11,*R10
* Move window up by one screen
       MOV  @WINPAR,R2
       MOV  @WINLIN,R3
       A    @WINMGN,R3
       LI   R4,TXTHGT
       BL   *R9
       MOV  R2,@WINPAR
       MOV  R3,@WINLIN
       MOV  R4,@WINMGN
* Let R2 = line index
* Let R3 = Address of paragraph
* Let R4 = Wrap list address
* Let R6 = old horizontal position within line
       BL   @GETLNH
* Move cursor down by one screen
       MOV  R2,R3
       MOV  @PARINX,R2
       LI   R4,TXTHGT
       BL   *R9
       MOV  R2,@PARINX
       MOV  R3,R2
*      Ignore R4, the cursor cannot land on the margin description
*
* Let R3 = Address of paragraph
* Let R4 = Wrap list address
       BL   @PARADR
* Update CHRPAX
       BL   @SETCHR
* Redraw whole screen
       SOC  @STSWIN,*R13
*
       MOV  *R10+,R11
       RT

*
* Given CHRPAX and address of wrap list,
* find the paragraph-line index
* and some horizontal position within the line (including indents).
* PRFHRZ can override the real position.
*
* Input:
*   CHRPAX
*   R4 - address of wrap list
* Output:
*   R2 - line index
*   R3 - address of paragrah
*   R4 - wrap list address
*   R6 - horizontal position
* Changed:
*   R5
GETLNH DECT R10
       MOV  R11,*R10
*
       BL   @GETLIN
*
       MOV  @PRFHRZ,R0
       JLT  NOOVRD
* Get previously recorded horizontal position
       MOV  @PRFHRZ,R6
       JMP  LNHRT
* Record the current horizontal position
NOOVRD MOV  R6,@PRFHRZ
*
LNHRT  MOV  *R10+,R11
       RT

*
* Adjust CHRPAX
*
* Input:
*   PARINX
*   R2 - line index
*   R3 - address of paragrah
*   R4 - address of wrap list
*   R6 - old horizontal position
* Changed: R6, R8
SETCHR DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R7,*R10
* Let R1 = address of line break
* if this is the first line, it will point to before index 0 of wrap list.
       MOV  R2,R1
       SLA  R1,1
       INCT R1
       A    R4,R1
* Let R7 = char index of line break
       MOV  *R1,R7
       MOV  R2,R2
       JNE  CHR1
       CLR  R7
CHR1
* Let R8 = length of line
       MOV  @2(R1),R8
       C    *R4,R2
       JNE  CHR2
       MOV  *R3,R8
CHR2   S    R7,R8
* If R2 is the last line, then R8 can be one char longer (for implied carriage return)
       C    R2,*R4
       JNE  CHR3
       INC  R8
CHR3
* Let R0 = the indent for this line
       MOV  @PARINX,R0
       MOV  R2,R1
       BL   @GETIDT
* Reduce horizontal position by size of indent
       S    R0,R6
       JGT  CHR4
       CLR  R6
CHR4
* Is horizontal position longer than the line?
       C    R6,R8
       JHE  CHR5
* No, add line break to horizontal position
       A    R7,R6
       JMP  CHR6
* Yes, let R6 = char at end of line
CHR5   MOV  R7,R6
       A    R8,R6
       DEC  R6
* Update CHRPAX
CHR6   MOV  R6,@CHRPAX
* Edit document status
       SOC  @STSARW,*R13
*
       MOV  *R10+,R7
       MOV  *R10+,R11
       RT

*
* Scroll horizontally by 20 characters
*
NXTWIN DECT R10
       MOV  R11,*R10
* Let R2 = line index
* Let R3 = Address of paragraph
* Let R4 = Wrap list address
* Let R6 = old horizontal position within line
       BL   @GETLIN
* Let R7 = hypothetical new horizontal position
       MOV  @CHRPAX,R7
       AI   R7,SCRNWD/2
       AI   R6,SCRNWD/2
* Set char position
       BL   @SETCHR
* Did cursor move by exactly 20 positions?
       C    @CHRPAX,R7
       JEQ  NXTOFF
* No, set it back to old value
       MOV  R7,@CHRPAX
* Can WINOFF increase by 20 without passing cursor?
NXTOFF MOV  @WINOFF,R7
       AI   R7,SCRNWD/2
       C    R7,@CHRPAX
       JGT  NXTRT
* Yes, increase it
       MOV  R7,@WINOFF
*
NXTRT  MOV  *R10+,R11
       RT

       END