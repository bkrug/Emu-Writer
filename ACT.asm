       DEF  UPUPSP,DOWNSP
*
       REF  LINLST
       REF  PARINX,CHRPAX,LININX,CHRLIX
       REF  STSARW

*
* Move the cursor up by one line
*
UPUPSP MOV  R11,R12
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
* Let R3 = Address of paragraph
* Let R4 = Wrap list address
       BL   @PARADR
*
       MOV  *R4,@LININX
UPSP2  JMP  ADJCHR

*
* Move the cursor down by one line
*
DOWNSP MOV  R11,R12
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
DWNSP1 MOV  @LINLST,R0
       MOV  *R0,R0
       DEC  R0
       C    @PARINX,R0
       JEQ  ARRWRT
* Move down to next paragraph
       INC  @PARINX
       CLR  @LININX
* Recalculate R3 & R4
DWNSP2 BL   @PARADR
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
* Let R7 = new CHRPAX
ADJC2  MOV  R5,R7
       A    @CHRLIX,R7
       C    R7,R6
       JL   ADJC3
       MOV  R6,R7
       DEC  R7
* update CHRPAX and CHRLIX
ADJC3  MOV  R7,@CHRPAX
       S    R5,R7
       MOV  R7,@CHRLIX
* Edit document status
       SOC  @STSARW,*R13
*
ARRWRT B    *R12
       
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
       A    @LINLST,R3
       C    *R3+,*R3+
       MOV  *R3,R3
* Set R4
       MOV  R3,R4
       INCT R4
       MOV  *R4,R4
*
       RT

       END