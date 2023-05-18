       DEF  SAVE,LOAD,PRINT
*
       REF  DSRLNK
       REF  VDPADR,VDPWRT,VDPSTR
       REF  LINLST,ARYADR
       REF  FLDVAL

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
FIXSAV EQU  >40                             * Fixed length of save records
MAXPRT EQU  >FE                             * Max Length of print records
*
* PAB data for Saving
SDATA  BYTE 0
       BYTE FIXED+DISPLY+OUTPUT+SEQUEN
       DATA PABBUF
       BYTE FIXSAV                          * Fixed Record Length
       BYTE FIXSAV                          * Length of this record
       DATA 0                               * Record number
       BYTE 0                               * Screen offset
       BYTE 0                               * Name length
SDATA0
*
* PAB data for Loading
LDATA  BYTE 0
       BYTE FIXED+DISPLY+INPUT+SEQUEN
       DATA PABBUF
       BYTE FIXSAV                          * Fixed Record Length
       BYTE FIXSAV                          * Length of this record
       DATA 0                               * Record number
       BYTE 0                               * Screen offset
       BYTE 0                               * Name length
LDATA0
*
* PAB data for Printing
PDATA  BYTE 0
       BYTE VARIAB+DISPLY+OUTPUT+SEQUEN
       DATA PABBUF
       BYTE MAXPRT                          * Max Record Length
       BYTE 0                               * Length of this record
       DATA 0                               * Record number
       BYTE 0                               * Screen offset
       BYTE 0                               * Name length
PDATA0
*
LNGADR DATA PAB+9
*
OPEN   BYTE >00
CLOSE  BYTE >01
READ   BYTE >02
WRITE  BYTE >03
*
CR     BYTE 13
EOD    BYTE 4                               * End of document
*
       EVEN

*
* Save
*
SAVE   DECT R10
       MOV  R11,*R10
* Save stack restore point
       MOV  R10,R12
* Turn off interrupts
       LIMI 0
* Open File
       LI   R2,SDATA
       BL   @OPENFL
* Change I/O op-code to write
       LI   R0,PAB
       BL   @VDPADR
       MOVB @WRITE,@VDPWD
* Set VDP write position
       LI   R0,PABBUF
       BL   @VDPADR
* Let R2 = remaining paragraphs
       MOV  @LINLST,R0
       MOV  *R0,R2
* Let R3 = number of bytes already written to VDP
       CLR  R3
* Let R1 = address of paragraph entry in the paragraph list
       MOV  @LINLST,R0
       CLR  R1
       BLWP @ARYADR
* Let R4 = address within paragraph
* Let R5 = remaining bytes in paragraph
       MOV  *R1,R4
       MOV  *R4,R5
       AI   R4,4
SAVBYT
* If paragraph complete, write CR
       MOV  R5,R5
       JEQ  SAVECR
* Write text to VDP RAM
       MOVB *R4+,@VDPWD
       DEC  R5
       JMP  SAVE3
*
SAVECR
* Prepare for next paragraph
       INCT R1
       DEC  R2
       JEQ  SAVEDN
* Let R4 = address within paragraph
* Let R5 = remaining bytes in paragraph
       MOV  *R1,R4
       MOV  *R4,R5
       AI   R4,4
* Write CR to VDP RAM
       MOVB @CR,@VDPWD
* Enough bytes to write record?
SAVE3  INC  R3
       CI   R3,FIXSAV
* If not, next byte
       JL   SAVBYT
* If yes, write record
       MOV  @LNGADR,@PNTR
       BLWP @DSRLNK
       DATA 8
       BL   @CHKERR
* Re-set VDP write position
       LI   R0,PABBUF
       BL   @VDPADR
*
       CLR  R3
*
       JMP  SAVBYT
* Document complete
SAVEDN
* Write EOD character
       MOVB @EOD,@VDPWD
* Write record
       MOV  @LNGADR,@PNTR
       BLWP @DSRLNK
       DATA 8
       BL   @CHKERR
*
       BL   @CLOSFL
*
       LIMI 2
*
       MOV  *R10+,R11
       RT

*
* Load
*
LOAD   DECT R10
       MOV  R11,*R10
* Save stack restore point
       MOV  R10,R12
* Turn off interrupts
       LIMI 0
* Open File
       LI   R2,LDATA
       BL   @OPENFL
* Change I/O op-code to write
       LI   R0,PAB
       BL   @VDPADR
       MOVB @WRITE,@VDPWD
* Set VDP read position
       LI   R0,PABBUF
       BL   @VDPADR

*
       BL   @CLOSFL
*
       LIMI 2
*
       MOV  *R10+,R11
       RT

*
* Print
*
PRINT  DECT R10
       MOV  R11,*R10
* Save stack restore point
       MOV  R10,R12
* Turn off interrupts
       LIMI 0
* Open File
       LI   R2,PDATA
       BL   @OPENFL
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
* TODO: Test that the length is <= 254 bytes
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
       MOV  @LNGADR,@PNTR
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
*
       BL   @CLOSFL
*
       LIMI 2
*
       MOV  *R10+,R11
       RT

*
* Open file
*
* Input:
*   R2 - Address of PAB Data
* Output:
*   R0, R1, R2 all changed
OPENFL
       DECT R10
       MOV  R11,*R10
* Write PAB data to VDP RAM
       LI   R0,PAB
       BL   @VDPADR
       MOV  R2,R0
       LI   R1,10
       BL   @VDPWRT
* Write device name to VDP RAM
       LI   R2,FLDVAL
       MOV  R2,R0
       BL   @VDPSTR
* Write name length to VDP RAM
       NEG  R2
       A    R0,R2
       SLA  R2,8
*
       MOV  @LNGADR,R0
       BL   @VDPADR
       MOVB R2,@VDPWD
* Store pointer name length
       MOV  @LNGADR,@PNTR
* Open file
       SB   @STATUS,@STATUS
       BLWP @DSRLNK
       DATA 8
       BL   @CHKERR
*
       MOV  *R10+,R11
       RT

CLOSFL
       DECT R10
       MOV  R11,*R10
* Yes, change I/O op-code to close
       LI   R0,PAB
       BL   @VDPADR
       MOVB @CLOSE,@VDPWD
* Close the file
       MOV  @LNGADR,@PNTR
       BLWP @DSRLNK
       DATA 8
       BL   @CHKERR
*
       MOV  *R10+,R11
       RT

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
* Exit fast.
* Restore stack trace to position when we entered the IO routine.
       MOV  R12,R10
       MOV  *R10+,R11
       RT
