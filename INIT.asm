       DEF  INIT
*
       REF  MAIN,INTDOC,INTRPT,DRWCR2
       REF  VARBEG,VAREND
       REF  KEYDVC
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
       REF  FRSHST,FRSHED
       REF  MGNSRT,MGNEND
       REF  MNUSTR,MNUEND
       REF  FRMSRT,FRMEND
       REF  CACHES,CCHMHM
       REF  LOADCH
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
       MOVB @NOQUIT,@INTSTP
* Load menus from VDP cache
       LI   R0,CCHMHM
       MOV  *R0,R0
       BL   @LOADCH
* Select title menu
       LI   R0,MNUTTL
       MOV  R0,@CURMNU
*
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
* Initialize VDP write address
       LI   R0,VDPCCH
       BL   @VDPADR
*
       LI   R4,TOCACH
       LI   R5,CACHES
       LI   R6,VDPCCH
* Update VDP RAM address in CACHES for this particular cache
* Later, we need to know where to load from.
STOR1  MOV  *R5,R7
STOR2  MOV  R6,*R5+
       INCT R5
       C    *R5,R7
       JEQ  STOR2
* Write code to VDP cache
       MOV  *R4+,R1
       LI   R2,VDPWD
       MOV  *R4+,R3
STOR3  MOVB *R1+,*R2
       INC  R6
       C    R1,R3
       JL   STOR3
* End of loop?
       CI   R4,TOCEND
       JL   STOR1
* Yes
       MOV  *R10+,R11
       RT
TOCACH DATA IOSTRT,IOEND
       DATA FRSHST,FRSHED
       DATA MGNSRT,MGNEND
       DATA MNUSTR,MNUEND
       DATA FRMSRT,FRMEND
TOCEND
       
       END