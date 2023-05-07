*
* A set of routines for communicating
* with VDP RAM
*
       DEF  VDPTXT,VDPADR,VDPRAD
       DEF  VDPWRT,VDPSPC,VDPREA
*
       REF  SPACE

VDPWA  EQU  >8C02        VDP RAM write address
VDPRD  EQU  >8800        VDP RAM read data
VDPWD  EQU  >8C00        VDP RAM write data
VDPSTA EQU  >8802        VDP RAM status
REG1CP EQU  >83D4        Address holding a copy of VDP Register 1

BIT0   DATA >8000
BIT1   DATA >4000

*
* Set Text Mode
*
* Output:
* R0
VDPTXT
* VDP Reg 1, needs to be set to >F0
       LI   R0,>01F0
* Specify that we are changing a registers
       SOC  @BIT0,R0
       SZC  @BIT1,R0
* Write new value to copy byte
       SWPB R0
       MOVB R0,@REG1CP
* Write new value to VDP register
       MOVB R0,@VDPWA
* Specify VDP register to change
       SWPB R0
       MOVB R0,@VDPWA
* Set Color in Reg 7
       LI   R0,>07FD
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
*
       RT

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
       END