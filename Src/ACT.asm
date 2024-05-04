       DEF  UPUPSP,DOWNSP,PGDOWN
*
       REF  PARLST                               From VAR.asm
       REF  PARINX,CHRPAX,LININX,CHRLIX          "
       REF  STSARW,STSDSH                        "
       REF  WINMOD                               "
       REF  GETIDT                               From UTIL.asm

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
* Is this the last paragraph-line?
       C    @LININX,*R4
       JEQ  DWNSP1
* Move down within same paragraph
       INC  @LININX
       JMP  DWNSP2
* Don't move past end of document
DWNSP1 MOV  @PARLST,R0
       MOV  *R0,R0
       DEC  R0
       C    @PARINX,R0
       JEQ  ARRWRT
* Move down to next paragraph
       INC  @PARINX
       CLR  @LININX
       SOC  @STSDSH,*R13
* Recalculate R3 & R4
DWNSP2 BL   @PARADR
*
       JMP  ADJCHR

*
* Move cursor and window-position
* down by 22 lines.
*
PGDOWN DECT R10
       MOV  R11,*R10
*
       JMP  ADJCHR

*
* Adjust CHRPAX and CHRLIX
*
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
* If new line is too shorter than previous,
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

       END