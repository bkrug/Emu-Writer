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
       BYTE PDATA1-PDATAN
PDATAN TEXT 'DSK2.PIO'
PDATA1
MSG    TEXT 'Some text sent to the printer.'
       BYTE 13,10
       TEXT 'A second line.'
MSG1
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
* Change I/O op-code to write
       LI   R0,PAB
       BL   @VDPADR
       MOVB @WRITE,@VDPWD
* Specify number of characters to write
       LI   R0,PAB+5
       BL   @VDPADR
       LI   R0,MSG1-MSG
       SWPB R0
       MOVB R0,@VDPWD
* Write record to VDP RAM
       LI   R0,PABBUF
       BL   @VDPADR
       LI   R0,MSG
       LI   R1,MSG1-MSG
       BL   @VDPWRT
* Write one record
       MOV  R6,@PNTR
       BLWP @DSRLNK
       DATA 8
* Change I/O op-code to close
       LI   R0,PAB
       BL   @VDPADR
       MOVB @CLOSE,@VDPWD
* Close the file
       MOV  R6,@PNTR
       BLWP @DSRLNK
       DATA 8
*
       MOVB @STATUS,R0
       JNE  PRTERR
* Clear error
       SB   R0,@STATUS
*
       B    *R12

* TODO: Fill this in
* Report errors
PRTERR B    *R12