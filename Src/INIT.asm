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
       REF  IOSTRT,IOEND                    * From IO.asm
       REF  FRSHST,FRSHED                   "
       REF  MGNSRT,MGNEND
       REF  MNUSTR,MNUEND
       REF  FRMSRT,FRMEND
       REF  CACHES,CCHMHM
*

       COPY 'EQUADDR.asm'
       COPY 'EQUVAL.asm'

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
       BL   @COPY_PATTERNS_FROM_GROM
       BL   @INVCHR
       BL   @INTMEM
       BL   @SET_FORM_FIELD_CHAR
       BL   @INTKEY
       BL   @INTDOC
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
       LI   R0,SCRTBL
       BL   @VDPADR
       LI   R1,24*SCRNWD
       BL   @VDPSPC
* Define cursor pattern
       LI   R0,CURSOR_PATTERN_ADR
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
TOCACH DATA IOSTRT,IOEND
       DATA FRSHST,FRSHED
       DATA MGNSRT,MGNEND
       DATA MNUSTR,MNUEND
TOCEND

*
* Define char 0 as a dotted line
*
SET_FORM_FIELD_CHAR
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

WRZERO DATA 7

*
* Get Char Patterns from GROM
*
* 7-bytes of each character's pattern definition
* is stored in GROM.
* The 1st byte is omitted and always equals 0.
*
COPY_PATTERNS_FROM_GROM
       DECT R10
       MOV  R11,*R10
* Set GROM address
       LI   R3,GROM_CHAR_PAT
       MOVB R3,@GRMWA
       SWPB R3
       MOVB R3,@GRMWA
* Set VDP Write Address
       LI   R0,8*SPCBAR+PATTBL
       BL   @VDPADR
* Let R0 = 0 (the empty pixel-row)
* Let R1 = remaining bytes to write to VDP RAM
* Let R2 = source to read from
* Let R3 = destination to write to
       CLR  R0
       LI   R1,92*8
       LI   R2,GRMRD
       LI   R3,VDPWD
GROM1
* Every 8th byte is excluded from the GROM
* Write 0 to the VDP RAM
       CZC  @WRZERO,R1
       JNE  !
       MOVB R0,*R3
       DEC  R1
!
* Copy a byte from GROM to VDP RAM
       MOVB *R2,*R3
       DEC  R1
       JNE  GROM1
*
GROMRT MOV  *R10+,R11
       RT

* Useful data is stored at these GROM addresses:
* (Source: https://www.unige.ch/medecine/nouspikel/ti99/groms.htm)
*
* >0451 	Default values of the 8 VDP registers.
* >0459 	Content of the color table, for title screen.
* >04B4 	Characters 32 to 95 patterns, for title screen.
* >06B4 	Regular upper case character patterns.
* >0874 	Lower case character patterns.
* >16E0 	Joysticks codes returned by SCAN.
* >1700 	Key codes returned by SCAN.
* >1730 	Ditto with SHIFT.
* >1760 	Ditto with FCTN.
* >1790 	Ditto with CTRL.
* >17C0 	Key codes in keyboard modes 1 et 2 (half-keyboards).
* >2022 	Error messages (with Basic bias of >60, and lenght byte).
* >285C 	Reserved words in Basic, and corresponding tokens.

       TEXT 'ENDOFINIT'
       EVEN

       END