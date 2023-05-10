       DEF  PRINT
*
       REF  DSRLNK
       REF  VDPADR,VDPWRT
       REF  LINLST,ARYADR

PABBUF EQU  >1000
PAB    EQU  >F80
*
       COPY 'CPUADR.asm'
*
FIXED  EQU  >00
VARIAB EQU  >10
*
DISPLY EQU  >00
INTERN EQU  >08
*
UPDATE EQU  >00
OUTPUT EQU  >02
INPUT  EQU  >04
APPEND EQU  >06
*
SEQUEN EQU  >00
RELATV EQU  >01
*
MAXLNG EQU  >FE
*
PDATA  BYTE 0
       BYTE DISPLY+VARIAB+OUTPUT+SEQUEN
       DATA PABBUF
       BYTE MAXLNG
       BYTE 0
       DATA >0000
       BYTE 0
       BYTE PDATA1-PDATA0
PDATA0 TEXT 'CLIP'
PDATA1
OUTP   BYTE 13,10
       TEXT 'Some text sent to the printer.'
       BYTE 13,10
       TEXT 'A second line.'
OUTP1
OPEN   BYTE >00
CLOSE  BYTE >01
READ   BYTE >02
WRITE  BYTE >03
       EVEN

PRINT  MOV  R11,R12
* Turn off interrupts
       LIMI 0
* Write PAB data to VDP RAM
       LI   R0,PAB
       BL   @VDPADR
       LI   R0,PDATA
       LI   R1,PDATA1-PDATA
       BL   @VDPWRT
* Store pointer name length
       LI   R3,PAB+9
       MOV  R3,@PNTR
* Open file
       SB   @STATUS,@STATUS
       BLWP @DSRLNK
       DATA 8
       BL   @CHKERR
* Change I/O op-code to write
       LI   R0,PAB
       BL   @VDPADR
       MOVB @WRITE,@VDPWD
* Let R2 = current paragraph
       CLR  R2
* Let R1 = address of paragraph's
* entry in the paragraph list
       MOV  @LINLST,R0
PRINT1 MOV  R2,R1
       BLWP @ARYADR
* Let R4 = address of paragraph
* Let R5 = address of wrap list
* Let R6 = address within paragraph
* Let R7 = line in paragraph (0-based)
       MOV  *R1,R4
       MOV  @2(R4),R5
       MOV  R4,R6
       AI   R6,4
       CLR  R7
PRINT2
* Let R8 = length of line
       MOV  *R5,*R5
       JNE  LENP1
* Set Length for paragraph with one line
       MOV  *R4,R8
       JMP  PRINT3
*
LENP1  MOV  R7,R7
       JNE  LENP2
* Set length for first line in paragraph
       MOV  @4(R5),R8
       JMP  PRINT3
*
LENP2  C    R7,*R5
       JHE  LENP3
* Set length for middle lines in paragraph
       MOV  R5,R0
       MOV  R7,R1
       BLWP @ARYADR
*
       CLR  R8
       S    @-2(R1),R8
       A    *R1,R8
       JMP  PRINT3
* Set length for last line in paragraph
LENP3  MOV  R5,R0
       MOV  R7,R1
       DEC  R1
       BLWP @ARYADR
*
       CLR  R8
       S    *R1,R8
       A    *R4,R8
* Write record to VDP RAM
PRINT3       
       LI   R0,PABBUF
       BL   @VDPADR
       MOV  R6,R0
       MOV  R8,R1
       BL   @VDPWRT
* In PAB, specify number of characters to write
       LI   R0,PAB+5
       BL   @VDPADR
       SWPB R8
       MOVB R8,@VDPWD
* Write one record
       MOV  R3,@PNTR
       BLWP @DSRLNK
       DATA 8
       BL   @CHKERR
* End of paragraph?
       C    R7,*R5
       JHE  PRINT4
* No, let R6 = address of next line in paragraph
       MOV  R5,R0
       MOV  R7,R1
       BLWP @ARYADR
       MOV  R4,R6
       AI   R6,4
       A    *R1,R6
* Loop to write next line
       INC  R7
       JMP  PRINT2
PRINT4
* Last paragraph of document?
       INC  R2
       MOV  @LINLST,R0
       C    R2,*R0
       JL   PRINT1
* Yes, change I/O op-code to close
       LI   R0,PAB
       BL   @VDPADR
       MOVB @CLOSE,@VDPWD
* Close the file
       MOV  R3,@PNTR
       BLWP @DSRLNK
       DATA 8
       BL   @CHKERR
*
       LIMI 2
       B    *R12

MSG0   BYTE MSG1-MSG0-1
       TEXT 'Err 0: Bad device name'
MSG1   BYTE MSG2-MSG1-1
       TEXT 'Err 1: Device is write protected'
MSG2   BYTE MSG3-MSG2-1
       TEXT 'Err 2: File type on disk not as expected'
MSG3   BYTE MSG4-MSG3-1
       TEXT 'Err 3: Illegal operation of peripheral'
MSG4   BYTE MSG5-MSG4-1
       TEXT 'Err 4: Out of space'
MSG5   BYTE MSG6-MSG5-1
       TEXT 'Err 5: Read past end of file'
MSG6   BYTE MSG7-MSG6-1
       TEXT 'Err 6: Device not connected or other'
MSG7   BYTE MSG8-MSG7-1
       TEXT 'Err 7: File does not exist'
MSG8   EVEN
MSGNUM DATA MSG0,MSG1,MSG2,MSG3
       DATA MSG4,MSG5,MSG6,MSG7
ERRSTS DATA >2000
*
* Report errors if any
*
CHKERR
* Check status bit
       MOVB @STATUS,R0
       COC  @ERRSTS,R0
       JEQ  CHKE1
* No error occurred
       RT
* Error occurred
* Read from VDP RAM
CHKE1  LI   R0,PAB+1
       BL   @VDPADR
       MOVB @VDPRD,R2
* Let R2 = error number in range 0-7
       SRL  R2,13
       SLA  R2,1
* Let R2 = address of error messsage
       AI   R2,MSGNUM
       MOV  *R2,R2
* Write messsage
       CLR  R0
       BL   @VDPADR
       MOVB *R2+,R1
       SRL  R1,8
       MOV  R2,R0
       BL   @VDPWRT
* Clear error
       SB   @STATUS,@STATUS
* Return to caller. Skip rest of print routine.
       LIMI 2
       B    *R12