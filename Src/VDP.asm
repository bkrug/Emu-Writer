*
* A set of routines for communicating
* with VDP RAM
*
       DEF  VDPTXT,VDPRAD,VDPADR
       DEF  VDPREA,VDPWRT
       DEF  VDPSTR,VDPINV,VDPSPC,VDPSPI
*
       REF  SPACE,ISPACE

       COPY 'CPUADR.asm'

BIT0   DATA >8000
BIT1   DATA >4000

* TODO: Only called by initialization code.
* Consider moving this to INIT.asm so that it can be overwritten at run time.
*
* Set Text Mode and Colors
*
* Output:
* R0
VDPTXT
       MOVB @REGLST+1,@REG1CP
       LI   R1,REGLST
VDPT2
* VDP Reg 1, needs to be set to >F0
       MOV  *R1+,R0
* Specify that we are changing a registers
       SOC  @BIT0,R0
       SZC  @BIT1,R0
* Write new value to copy byte
       SWPB R0
* Write new value to VDP register
       MOVB R0,@VDPWA
* Specify VDP register to change
       SWPB R0
       MOVB R0,@VDPWA
* Loop
       CI   R1,REGEND
       JL   VDPT2
*
       RT
REGLST
* Text Mode
       DATA >01F0
* Screen Image table address
       BYTE >02,REG_SCRTBL
* Pattern Table address
       BYTE >04,REG_PATTBL
* White foreground, purple background
       DATA >07FD
REGEND

*
* Set VDP read address 
*
* Input:
* R0 - VDP address
* Output:
* R0 - bits 0 and 1 changed
VDPRAD 
* Set most signfication two bits for 
* reading
       SZC  @BIT0,R0
       SZC  @BIT1,R0
* Write address to system
       JMP  VDPAD1

*
* Set VDP write address 
*
* Input:
* R0 - VDP address
* Output:
* R0 - bits 0 and 1 changed
VDPADR 
* Set most signfication two bits for 
* writing
       SZC  @BIT0,R0
       SOC  @BIT1,R0
* Write address to system
VDPAD1 SWPB R0
       MOVB R0,@VDPWA
       SWPB R0
       MOVB R0,@VDPWA
*
       RT       

*
* Read multiple bytes from VDP
*
* Input:
* R0 - Address to copy text to
* R1 - Number of bytes
* Output:
* R0 - original value + R1's value
* R1 - 0
VDPREA
* Don't read if R1 = 0
       MOV  R1,R1
       JEQ  VRD2
* Read as many bytes as R1 specifies
VRD1   MOVB @VDPRD,*R0+
       DEC  R1
       JNE  VRD1
*
VRD2   RT

*
* Write multiple bytes to VDP
*
* Input:
* R0 - Address of text to copy
* R1 - Number of bytes
* Output:
* R0 - original value + R1's value
* R1 - 0
VDPWRT
* Don't write if R1 = 0
       MOV  R1,R1
       JEQ  VWRT2
* Write as many bytes as R1 specifies
VWRT1  MOVB *R0+,@VDPWD
       DEC  R1
       JNE  VWRT1
*
VWRT2  RT

*
* VDPSTR:
* Write null-terminating string to VDP
*
* Input:
* R0 - Address of text to copy
* Output:
* R0 - Address of null terminator
*
VSTR1  MOVB *R0+,@VDPWD
VDPSTR MOVB *R0,*R0
       JNE  VSTR1
*
       RT

*
* VDPINV:
* Write inverted null-terminating string to VDP
*
* Input:
* R0 - Address of text to copy
* Output:
* R0 - Address of null terminator
* R1 - changed
*
VSTI1  MOVB *R0+,R1
       AI   R1,>8000
       MOVB R1,@VDPWD
VDPINV MOVB *R0,*R0
       JNE  VSTI1
*
       RT

*
* Write multiple spaces to VDP
*
* Input:
* R1 - Number of bytes
* Output:
* R1 - 0
VDPSPC
* Don't write if R1 = 0
       MOV  R1,R1
       JEQ  VSPC2
* Write as many bytes as R1 specifies
VSPC1  MOVB @SPACE,@VDPWD
       DEC  R1
       JNE  VSPC1
*
VSPC2  RT

*
* Write multiple inverted spaces to VDP
*
* Input:
* R1 - Number of bytes
* Output:
* R1 - 0
VDPSPI
* Don't write if R1 = 0
       MOV  R1,R1
       JEQ  VSPI2
* Write as many bytes as R1 specifies
VSPI1  MOVB @ISPACE,@VDPWD
       DEC  R1
       JNE  VSPI1
*
VSPI2  RT
       END