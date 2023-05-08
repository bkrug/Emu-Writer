       DEF  PRINT
*
       REF  DSRLNK
       REF  VDPADR,VDPWRT

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
PDATA0 TEXT 'DSK2.PIO'
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
* Write PAB data to VDP RAM
       LI   R0,PAB
       BL   @VDPADR
       LI   R0,PDATA
       LI   R1,PDATA1-PDATA
       BL   @VDPWRT
* Store pointer name length
       LI   R6,PAB+9
       MOV  R6,@PNTR
* Open file
       BLWP @DSRLNK
       DATA 8
* TODO: It doesn't seem like we can
* do error checks after opening the file.
* We'll have to confirm that the file exists
* some other way 
*
* Change I/O op-code to write
       LI   R0,PAB
       BL   @VDPADR
       MOVB @WRITE,@VDPWD
* Specify number of characters to write
       LI   R0,PAB+5
       BL   @VDPADR
       LI   R0,OUTP1-OUTP
       SWPB R0
       MOVB R0,@VDPWD
* Write record to VDP RAM
       LI   R0,PABBUF
       BL   @VDPADR
       LI   R0,OUTP
       LI   R1,OUTP1-OUTP
       BL   @VDPWRT
* Write one record
       MOV  R6,@PNTR
       BLWP @DSRLNK
       DATA 8
       BL   @CHKERR
* Change I/O op-code to close
       LI   R0,PAB
       BL   @VDPADR
       MOVB @CLOSE,@VDPWD
* Close the file
       MOV  R6,@PNTR
       BLWP @DSRLNK
       DATA 8
       BL   @CHKERR
*
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
       B    *R12