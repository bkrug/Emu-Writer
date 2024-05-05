       DEF  UPUPSP,DOWNSP,PGUP,PGDOWN
*
       REF  PARLST                               From VAR.asm
       REF  PARINX,CHRPAX                        "
       REF  STSARW,STSDSH                        "
       REF  WINPAR,WINLIN,WINMGN,WINMOD          "
       REF  STSWIN                               From CONST.asm
       REF  GETIDT,GETMGN                        From UTIL.asm
       REF  PARADR,GETLIN,LOOKUP                 "
       REF  ARYADR                               From ARRAY

       COPY 'EQUKEY.asm'

*
* Move the cursor up by one line
*
UPUPSP DECT R10
       MOV  R11,*R10
* Let R2 = line index
* Let R3 = Address of paragraph
* Let R4 = Wrap list address
* Let R6 = old horizontal position within line
       BL   @GETLIN
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
       BL   @GETLIN
* Is this the last paragraph-line?
       C    R2,*R4
       JEQ  DWNSP1
* Move down within same paragraph
       INC  R2
       JMP  DWNSP2
* Don't move past end of document
DWNSP1 MOV  @PARLST,R0
       MOV  *R0,R0
       DEC  R0
       C    @PARINX,R0
       JEQ  DWNSP3
* Move down to next paragraph
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
PGDOWN DECT R10
       MOV  R11,*R10
* Move window down by one screen
       MOV  @WINPAR,R3
       MOV  @WINLIN,R4
       BL   @SCRLD
       MOV  R3,@WINPAR
       MOV  R4,@WINLIN
* Let R2 = line index
* Let R3 = Address of paragraph
* Let R4 = Wrap list address
* Let R6 = old horizontal position within line
       BL   @GETLIN
* Move cursor down by one screen
       MOV  @PARINX,R3
       MOV  R2,R4
       BL   @SCRLD
       MOV  R3,@PARINX
       MOV  R4,R2
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
* Move cursor and window-position
* up by 22 lines.
*
PGUP   DECT R10
       MOV  R11,*R10
* Move window up by one screen
       MOV  @WINPAR,R2
       MOV  @WINLIN,R3
       LI   R4,TXTHGT
       BL   @LOOKUP
       MOV  R2,@WINPAR
       MOV  R3,@WINLIN
       MOV  R4,@WINMGN
* Let R2 = line index
* Let R3 = Address of paragraph
* Let R4 = Wrap list address
* Let R6 = old horizontal position within line
       BL   @GETLIN
* Move cursor down by one screen
       MOV  R2,R3
       MOV  @PARINX,R2
       LI   R4,TXTHGT
       BL   @LOOKUP
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
* Adjust CHRPAX
*
* Input:
*   PARINX
*   R2 - line index
*   R3 - address of paragrah
*   R4 - address of wrap list
*   R6 - old horizontal position
* Changed: R6
SETCHR DECT R10
       MOV  R11,*R10
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
       MOV  *R10+,R11
       RT

*
* Given a paragraph and line index.
* Get values one screen lower.
*
* Input:
*   R3 - paragraph index
*   R4 - line index
* Output:
*   R3 & R4
SCRLD
       DECT R10
       MOV  R5,*R10
       DECT R10
       MOV  R6,*R10
       DECT R10
       MOV  R11,*R10
* Let R5 = remaining lines
       LI   R5,TXTHGT
* Let R6 = address within PARLST minus two bytes
       MOV  R3,R6
       SLA  R6,1
       INCT R6                * Skip 4 bytes for array header, but then subtract 2. We change R6 every time we loop through SDL1.
       A    @PARLST,R6
* Decrease R3 because we change it when we loop through SDL1.
       DEC  R3
* Let R6 = next entry in paragrah list
* Let R3 = index of next paragrah
SDL1   INCT R6
       INC  R3
* Does paragrah have a margin entry?
       MOV  R3,R0
       BL   @GETMGN
       MOV  R0,R0
       JEQ  SDL2
       C    *R0,R3
       JNE  SDL2
* Yes, account for it in R5
       DEC  R5
* Let R7 = address of wrap list
SDL2   MOV  *R6,R7
       INCT R7
       MOV  *R7,R7
* Let R7 = number of lines in paragrah
       MOV  *R7,R7
       INC  R7
* Decrease remaining lines
       S    R7,R5
* If R5 > 0, then loop
       JGT  SDL1
*
       JEQ  SD2
* R5 < 0, so we subtracted too many lines
       A    R7,R5
* Set new paragraph and line indexes
SD2    AI   R6,-4
       S    @PARLST,R6
       SRL  R6,1
       MOV  R6,R3
       MOV  R5,R4
*
       MOV  *R10+,R11
       MOV  *R10+,R6
       MOV  *R10+,R5
       RT

       END