       DEF  RUNTST
*
       REF  VSBW,KSCAN,VMBW
	   REF  KEYDVC,KEYPRS,USRISR
	   REF  NOKEY,PREVKY,TIMER
	   REF  KEYINT
	   REF  KEYSTR,KEYEND,KEYWRT,KEYRD
	   
RUNTST
* Define the buffer locations
       LI   R0,KEYSTR
       MOV  R0,@KEYWRT
	   MOV  R0,@KEYRD
* Define the interupt routine
       LI   R0,KEYINT
       MOV  R0,@USRISR
* Specify whole keyboard
       CLR  R0
       MOVB R0,@KEYDVC
* Ignore keys pressed before
* running the program
       MOVB @NOKEY,@KEYPRS
* Next position to record a keypress to
       LI   R12,KEYREC
* Delay to simulate a busy system
       MOV  @BSYDLY,R11
*
LOOP
* Copy keys from buffer to record
KEYCPY C    @KEYRD,@KEYWRT
	   JEQ  SCRNWR
	   MOV  @KEYRD,R0
	   MOVB *R0+,*R12+
	   CI   R0,KEYEND
	   JL   KEYCP1
	   LI   R0,KEYSTR
KEYCP1 MOV  R0,@KEYRD
       JMP  KEYCPY
* Disable interrupts before writing
* to VDP
SCRNWR LIMI 0
* Write the buffer contents to Row 0
       CLR  R0
       LI   R1,KEYSTR
       LI   R2,KEYEND
	   S    R1,R2
       BLWP @VMBW
* Write PREVKY and TIMER to Row 23
       MOVB @PREVKY,R0
       LI   R1,TIMHX+4
       BLWP @MAKETX
*
       MOV  @TIMER,R0
       LI   R1,TIMHX
       BLWP @MAKETX
*
       LI   R0,>2E0
       LI   R2,8
       BLWP @VMBW
* Write recorded keys to the screen Row 1-22
       LI   R0,>20
	   LI   R1,KEYREC
	   LI   R2,22*32
	   BLWP @VMBW
* Re-enable interrupts
       LIMI 2
* Wait until delay end before copying
* keypresses from buffer to record.
       DEC  R11
	   JNE  SCRNWR
* Delay to simulate a busy system
       MOV  @BSYDLY,R11
       JMP  LOOP
	   
BSYDLY DATA >40

* Make Hexadecimal Text
* ----------------------
* R0: Word to convert
* R1: Address of output text (4 bytes)
MAKETX DATA WORKSP,MAKEP
WORKSP BSS  >20
STACK  BSS  >20
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

TIMHX  TEXT 'ABCD.ABC'
KEYREC TEXT 'We"re in the money. '
       TEXT 'We"re in the money. '
       TEXT 'We"ve got a lot of what it takes '
	   TEXT 'to get alonggg.'
       BSS  22*32

       END