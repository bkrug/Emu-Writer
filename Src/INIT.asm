       DEF  INIT,PRGEND
*
       REF  MAIN,INTDOC,INTRPT,DRWCR2
       REF  VARBEG,VAREND
       REF  KEYDVC
       REF  KEYSTR,KEYWRT,KEYRD
       REF  MAINWS
       REF  DOCSTS
       REF  POSUPD
       REF  VDPTXT,VDPSPC
       REF  VDPADR,VDPRAD,VDPWRT
       REF  STSTYP
       REF  CURINS,CURMOD,WINMOD
       REF  CURMNU,STACK
       REF  MNUTTL
       REF  WRTHDR
       REF  MNUSTR,MNUEND
       REF  FRMSRT,FRMEND
       REF  CACHES,CCHMHM
*

       COPY 'CPUADR.asm'
       COPY 'EQUKEY.asm'

*
* Initialize Program
*
INIT
       LWPI MAINWS
       LI   R10,STACK
*
       BL   @VDPTXT
       BL   @INTSCN
       BL   @STORCH
       BL   @INVCHR
       BL   @INTMEM
       BL   @INTDOC
       BL   @FRMFLD
       BL   @INTKEY
       BL   @WRTHDR
* Set default values
       SETO @WINMOD
* Don't let user use FCTN+= to restart computer
       MOVB @NOQUIT,@INTSTP
* Select title menu
       LI   R0,MNUTTL
       MOV  R0,@CURMNU
*
       LIMI 2
       B    @MAIN

*
* Code after this label will be OVERWRITTEN
* by the INTDOC method.
*
PRGEND

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
       LI   R0,>7F*8+1+PATTBL
       BL   @VDPADR
       LI   R0,CURINS
       LI   R1,7
       BL   @VDPWRT
* Set cursor to visible
       SETO @CURMOD
* Set position steps
       BLWP @POSUPD
* Draw cursor and return to caller
       LI   R13,DOCSTS
       SOC  @STSTYP,*R13
       BL   @DRWCR2

*
* Invert Characters
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
TOCACH DATA MNUSTR,MNUEND
TOCEND

*
* Define char 0 as a dotted line
*
FRMFLD
       DECT R10
       MOV  R11,*R10
*
       LI   R0,PATTBL
       BL   @VDPADR
       CLR  R0
       LI   R1,VDPWD
       LI   R2,7
FRM1   MOVB R0,*R1
       DEC  R2
       JNE  FRM1
*
       LI   R0,>5500
       MOVB R0,*R1
*
* Define char 1 and 2 as vertical and 
* windowed mode symbols.
       LI   R0,CHRPAT
       LI   R2,PATEND-CHRPAT
PATLP  MOVB *R0+,*R1
       DEC  R2
       JNE  PATLP
*
       MOV  *R10+,R11
       RT
*
CHRPAT DATA >FFEF,>EFEF,>EF83,>C7EF
       DATA >9FA7,>BBBB,>BBCB,>F3FF
PATEND

       TEXT 'ENDOFINIT'
       EVEN

       END