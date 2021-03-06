       DEF  MAKETX,PRINTL,OPENF,CLOSEF
       DEF  FAILT,PASST
       REF  VMBW,VMBR,VSBW,DSRLNK
 
PASSED DATA >0000
FAILED DATA >0000
WORKSP BSS  >20
STACK  BSS  >100
 
PASST  INC  @PASSED
       RT
 
FAILT  INC  @FAILED
       RT
 
* Make Hexadecimal Text
* ----------------------
* R0: Word to convert
* R1: Address of output text (4 bytes)
MAKETX DATA WORKSP,MAKEP
MAKEP  LI   R12,STACK
       MOV  *R13,R0
       MOV  @2(R13),R1
       BL   @MAKEHX
       RTWP
MAKEHX MOV  R11,*R12+
       BL   @MAKEP1
       SWPB R0
       BL   @MAKEP1
       SWPB R0
* return
       DECT R12
       MOV  *R12,R11
       RT
 
MAKEP1 MOV  R11,*R12+
       MOV  R4,*R12+
* High Nibble
       MOVB R0,R4
       SRL  R4,4
       BL   @CONVB
       MOVB R4,*R1
       INC  R1
* Low Nibble
       MOVB R0,R4
       SLA  R4,4
       SRL  R4,4
       BL   @CONVB
       MOVB R4,*R1
       INC  R1
* Return
       DECT R12
       MOV  *R12,R4
       DECT R12
       MOV  *R12,R11
       RT
* Convert Byte to ASCII code
CONVB  CI   R4,>0A00
       JHE  CNVB2
       AI   R4,>3000
       RT
CNVB2  AI   R4,>3700
       RT
 
* Scroll screen upward and place text
* at the bottom of the screen. Can be
* multiple lines.
* Also write to file.
* -----------------------------------
* R0: Address of text.
* R1: Length of text.
PRINTL DATA WORKSP,PRINTP
LINLNG DATA 32
SCRN   BSS  >300
CLRTXT TEXT '                                '
       EVEN
PRINTP LI   R12,STACK
       MOV  *R13,R0
       MOV  @2(R13),R1
       BL   @WRITEF
       BL   @SCRLP
       RTWP
       
SCRLP  MOV  R11,*R12+
       MOV  R8,*R12+
       MOV  R9,*R12+
       MOV  R2,*R12+
       MOV  R3,*R12+
 
       MOV  R0,R8
       MOV  R1,R9
* Find ceiling of text length / 32
       CLR  R0
       MOV  R9,R1
       DIV  @LINLNG,R0
       MOV  R1,R1
       JEQ  SCROLL
       INC  R0
* R0 contains number of lines to print.
* If R0 = 0, then return to caller.
SCROLL MOV  R0,R0
       JNE  SCROL1
       B    @SCRLRT
* Scroll text by number of lines in R0.
SCROL1 SLA  R0,5
       LI   R1,SCRN
       LI   R2,>300
       S    R0,R2
       BLWP @VMBR
       CLR  R0
       BLWP @VMBW
* Clear the last line of text.
       MOV  R2,R3
       LI   R0,>2E0
       LI   R1,CLRTXT
       LI   R2,>20
       BLWP @VMBW
*Write new text.
*R3 contains length of text scrolled up.
*   Identical to text start position.
       MOV  R3,R0
       MOV  R8,R1
       MOV  R9,R2
       BLWP @VMBW
       MOV  R8,R0
       MOV  R9,R1
* return
SCRLRT DECT R12
       MOV  *R12,R3
       DECT R12
       MOV  *R12,R2
       DECT R12
       MOV  *R12,R9
       DECT R12
       MOV  *R12,R8
       DECT R12
       MOV  *R12,R11
       RT
 
* Open file
* ---------
* FILENM: the location of the filename
* Must write to FILENM and call OPENF
* before calling WRITEF
PABBUF EQU  >1000
PAB    EQU  >F80
STATUS EQU  >837C
PNTR   EQU  >8356
* Byte 0 = Open
* Byte 1 = Status/Display/Variable
* Byte 4 = max record length 80
* Byte 5 = actual length to write
* Byte 6-7 are not relevant
* Byte 8 = status o file
* Byte 9 = file name length
PDATA  DATA >0012,PABBUF,>5000,>0000,>000F
FILENM TEXT 'DSK3.TESTRESULT'
       EVEN
RCDL   EQU  PDATA+5
WRITE  BYTE >03
CLOSE  BYTE >01
OPENF  DATA WORKSP,OPENFP
* Copy PAB into VDP RAM
OPENFP LI   R12,STACK
       LI   R0,PAB
       LI   R1,PDATA
       LI   R2,25
       BLWP @VMBW
* Open file
       LI   R6,PAB+9
       MOV  R6,@PNTR
       BLWP @DSRLNK
       DATA 8
 
       BL   @ERRORF
 
       RTWP
 
* Write one line of text to file or
* printer.
* ----------------------
* R0: Address of text.
* R1: Length of text.
WRTMSG TEXT 'Writing stuff to disk.'
WRTM0  EVEN
WRITEF
       MOV  R0,*R12+
       MOV  R1,*R12+
       MOV  R2,*R12+
       MOV  R6,*R12+
       MOV  R11,*R12+
* Write line to VDP RAM
       MOV  R1,R2
       MOV  R0,R1
       LI   R0,PABBUF
       BLWP @VMBW
* Update record length
       SWPB R2
       MOVB R2,@PDATA+5
* Change I/O op-code to write.
       MOVB @WRITE,@PDATA
* Rewrite data
       LI   R0,PAB
       LI   R1,PDATA
       LI   R2,25
       BLWP @VMBW
* Do write operation
       LI   R6,PAB+9
       MOV  R6,@PNTR
       BLWP @DSRLNK
       DATA 8
*
       BL   @ERRORF
 
       DECT R12
       MOV  *R12,R11
       DECT R12
       MOV  *R12,R6
       DECT R12
       MOV  *R12,R2
       DECT R12
       MOV  *R12,R1
       DECT R12
       MOV  *R12,R0
       RT
 
* Close file
* ----------
CLOSEF DATA WORKSP,CLOSEP
CLOSEP LI   R12,STACK
* Change I/O op-code to close
       LI   R0,PAB
       MOVB @CLOSE,R1
       BLWP @VSBW
* Close file
       LI   R6,PAB+9
       MOV  R6,@PNTR
       BLWP @DSRLNK
       DATA 8
*
       BL   @ERRORF
 
       RTWP
 
* Report Error
* ------------
ERRGEN TEXT 'Some error occurred.'
ERRMSG TEXT 'File Error Code '
ERRCD  BSS  >1
ERR0
ZEROCR BYTE '0'
       EVEN
ERRORF
       MOV  R0,*R12+
       MOV  R1,*R12+
       MOV  R11,*R12+
       MOV  R0,R0
       JNE  ERR2
       LI   R0,ERRGEN
       LI   R1,ERRMSG-ERRGEN
       BL   @SCRLP
* Read Error Code
ERR2   MOVB @PDATA+1,R0
       SRL  R0,5
       AI   R0,>3000
       MOVB R0,@ERRCD
* If error code is not '0' or
* bit 2 of status byte is on,
* report the error.
       CB   R0,@ZEROCR
       JNE  ERR1
       MOVB @STATUS,R0
       ANDI R0,>2000
       JNE  ERR1
       JMP  ERRRT
* Display Error Message
ERR1   LI   R0,ERRMSG
       LI   R1,ERR0-ERRMSG
       BL   @SCRLP
* Return
ERRRT
       DECT R12
       MOV  *R12,R11
       DECT R12
       MOV  *R12,R1
       DECT R12
       MOV  *R12,R0
       RT
       END