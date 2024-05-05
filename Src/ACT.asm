       DEF  UPUPSP,DOWNSP,PGDOWN
*
       REF  PARLST                               From VAR.asm
       REF  PARINX,CHRPAX,LININX,CHRLIX          "
       REF  WINPAR,WINLIN                        "
       REF  STSARW,STSDSH                        "
       REF  WINMOD                               "
       REF  GETIDT,GETMGN                        From UTIL.asm
       REF  ARYADR                               From ARRAY

       COPY 'EQUKEY.asm'

*
* Move the cursor up by one line
*
UPUPSP DECT R10
       MOV  R11,*R10
*
       MOV  @LININX,R0
       JEQ  UPSP1
* Move up within same paragraph
       DEC  @LININX
* Let R3 = Address of paragraph
* Let R4 = Wrap list address
       BL   @PARADR
*
       JMP  UPSP2
* Don't move past start of document
UPSP1  MOV  @PARINX,R0
       JEQ  ARRWRT
* Move up to previous paragraph
       DEC  @PARINX
       SOC  @STSDSH,*R13
* Let R3 = Address of paragraph
* Let R4 = Wrap list address
       BL   @PARADR
*
       MOV  *R4,@LININX
UPSP2  JMP  ADJCHR

*
* Move the cursor down by one line
*
DOWNSP DECT R10
       MOV  R11,*R10
* Let R3 = Address of paragraph
* Let R4 = Wrap list address
       BL   @PARADR
* Let R2 = line index
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
* Move cursor down by one screen
       MOV  @PARINX,R3
       MOV  @LININX,R4
       BL   @SCRLD
       MOV  R3,@PARINX
       MOV  R4,@LININX
* Let R4 = address of wrap list
       BL   @PARADR
*
       JMP  ADJCHR

*
* Adjust CHRPAX and CHRLIX
*
* Input:
*    R4 = address of wrap list
ADJCHR
* Let R5 = address of prev line break
* Let R6 = address of next iine break
       MOV  @LININX,R6
       SLA  R6,1
       C    *R6+,*R6+
       A    R4,R6
       MOV  R6,R5
       DECT R5
* Let R5 = prev line break
* Let R6 = next line break
       MOV  *R5,R5
       MOV  *R6,R6
* If this is first paragraph-line,
* prev line break is 0.
       MOV  @LININX,R0
       JNE  ADJC1
       CLR  R5
* If this is the last paragraph-line,
* next line break is paragraph-length
* plus one.
ADJC1  C    *R4,@LININX
       JNE  ADJC2
       MOV  *R3,R6
       INC  R6
ADJC2
* Let R7 = new CHRPAX
       MOV  R5,R7
       A    @CHRLIX,R7
* Let R0 = the indent for this line
       MOV  @PARINX,R0
       MOV  R5,R1
       BL   @GETIDT
* Decrease R7 by the indent.
ADJ3   S    R0,R7
* Prevent CHRPAX from falling to before
* line break.
       C    R7,R5
       JGT  ADJC4
       MOV  R5,R7
ADJC4
* If new line is shorter than previous,
* avoid wrapping around to the next line.
* Just move to the end of the new line.
       C    R7,R6
       JL   ADJC5
       MOV  R6,R7
       DEC  R7
ADJC5
* update CHRPAX and CHRLIX
       MOV  R7,@CHRPAX
       S    R5,R7
       MOV  R7,@CHRLIX
* Edit document status
       SOC  @STSARW,*R13
*
ARRWRT MOV  *R10+,R11
       RT

*
* Given CHRPAX and address of wrap list,
* find the paragraph-line index
* and the horizontal position within the line (including indents).
*
* Input:
*   CHRPAX
*   R4 - address of wrap list
* Output:
*   R2 - line index
*   R6 - horizontal position
* Changed:
*   R5
GETLIN
       DECT R10
       MOV  R11,*R10
* Let R5 = current location in wrap list
* Let R6 = end of wrap list
       MOV  R4,R5
       C    *R5+,*R5+
       MOV  *R4,R6
       SLA  R6,1
       A    R5,R6
* Let R2 = line index
       SETO R2
       DECT R5
* Increment line index until we find an entry >= CHRPAX
LIN1   INC  R2
       INCT R5
       C    R5,R6
       JEQ  LIN2
       C    *R5,@CHRPAX
       JLE  LIN1
* Let R6 = horizontal position
LIN2   MOV  @CHRPAX,R6
* Is the current line, the first line?
       MOV  R2,R2
       JEQ  LIN3
* No, subtract the previous line break from R6
       DECT R5
       S    *R5,R6
*
LIN3
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
* Let R0 = the indent for this line
       MOV  @PARINX,R0
       MOV  R2,R1
       BL   @GETIDT
* Reduce horizontal position by size of indent
       S    R0,R6
       JGT  CHR3
       CLR  R6
CHR3
* Is horizontal position longer than the line?
       C    R6,R8
       JHE  CHR4
* No, add line break to horizontal position
       A    R7,R6
       JMP  CHR5
* Yes, let R6 = char at end of line
CHR4   MOV  R7,R6
       A    R8,R6
       DEC  R6
* Update CHRPAX
CHR5   MOV  R6,@CHRPAX
* Edit document status
       SOC  @STSARW,*R13
*
       MOV  *R10+,R11
       RT

*
* Get paragraph address and wrap list
* address.
*
* Input:
* R3 - paragraph index
* Output:
* R3 - paragraph address
* R4 - wrap list address
PARADR 
* Set R3
       MOV  @PARINX,R3
       SLA  R3,1
       A    @PARLST,R3
       C    *R3+,*R3+
       MOV  *R3,R3
* Set R4
       MOV  R3,R4
       INCT R4
       MOV  *R4,R4
*
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
       RT


       END