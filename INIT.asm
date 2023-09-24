       DEF  INIT
*
       REF  MAIN,INTDOC,INTRPT,DRWCR2
       REF  VARBEG,VAREND
       REF  KEYDVC,USRISR
       REF  KEYSTR,KEYWRT,KEYRD
       REF  MAINWS
       REF  MEMBEG
       REF  POSUPD
       REF  VDPTXT,VDPSPC
       REF  VDPADR,VDPRAD,VDPWRT
       REF  STSTYP
       REF  CURINS,CURMOD,WINMOD
       REF  CURMNU,STACK
       REF  MNUTTL
       REF  WRTHDR
       REF  IOSTRT,IOEND
*

       COPY 'CPUADR.asm'
       COPY 'EQUVDPADR.asm'

*
* Initialize Program
*
INIT
       LWPI MAINWS
       LI   R10,STACK
*
       BL   @STORCH
       BL   @INVCHR
       BL   @INTMEM
       BL   @INTDOC
       BL   @INTKEY
       BL   @VDPTXT
       BL   @INTSCN
       BL   @WRTHDR
*
       SETO @WINMOD
       LI   R0,MNUTTL
       MOV  R0,@CURMNU
       MOVB @NOQUIT,@INTSTP
       LIMI 2
       B    @MAIN

*
* Initialize Memory to zero
*
INTMEM LI   R0,VARBEG
IMLP   CLR  *R0+
       CI   R0,VAREND
       JL   IMLP
       RT

*
* Initialize Key Scanning
*
INTKEY
* Define the buffer locations
       LI   R0,KEYSTR
       MOV  R0,@KEYWRT
       MOV  R0,@KEYRD
* Define the interupt routine
       LI   R0,INTRPT
       MOV  R0,@USRISR
* Specify whole keyboard
       CLR  R0
       MOVB R0,@KEYDVC
*
       RT
       
* 
* Initialize screen
*
INTSCN DECT R10
       MOV  R11,*R10
* Clear screen
       CLR  R0
       BL   @VDPADR
       LI   R1,24*40
       BL   @VDPSPC
* Define cursor pattern
       LI   R0,>7F*8+>801
       BL   @VDPADR
       LI   R0,CURINS
       LI   R1,7
       BL   @VDPWRT
* Set cursor to visible
       SETO @CURMOD
* Set position steps
       BLWP @POSUPD
* Draw cursor and return to caller
       SOC  @STSTYP,R0
       BL   @DRWCR2

*
* Invert Character
*
INVCHR
       DECT R10
       MOV  R11,*R10
*
       LI   R0,PATLOW
       BL   @VDPRAD
*
       LI   R0,MEMBEG
       INCT R0
       LI   R1,>0400
INVLP  MOVB @VDPRD,R2
       INV  R2
       MOVB R2,*R0+
       DEC  R1
       JNE  INVLP
*
       LI   R0,PATHGH
       BL   @VDPADR
       LI   R0,MEMBEG
       INCT R0
       LI   R1,>400
       BL   @VDPWRT
*
       MOV  *R10+,R11
       RT

NOQUIT BYTE >80
       TEXT 'ENDOFINIT'
       EVEN

*
* Store executable code in cache
*
STORCH
       DECT R10
       MOV  R11,*R10
* Write code to VDP cache
       LI   R0,VDPCCH
       BL   @VDPADR
       LI   R1,IOSTRT
       LI   R2,VDPWD
       LI   R3,>800
STOR1
       MOVB *R1+,*R2
       DEC  R3
       JNE  STOR1
*
       MOV  *R10+,R11
       RT
       
       END