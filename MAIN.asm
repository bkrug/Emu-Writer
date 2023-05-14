       DEF  START
*
       REF  KEYDVC,USRISR
       REF  KEYINT
       REF  KEYSTR,KEYEND,KEYWRT,KEYRD
       REF  MEMBEG,MEMEND
       REF  INPUT,WRAP,POSUPD,DISP
       REF  PARINX
       REF  BUFINT,BUFALC,BUFCPY
       REF  ARYALC,ARYADD
       REF  LINLST,MGNLST,FMTLST
       REF  VDPTXT,VDPSPC
       REF  VDPADR,VDPWRT
       REF  VDPRAD,VDPREA
       REF  STSTYP,STSENT,STSWIN,STSARW
       REF  CURTIM,CUROLD,CURRPL,CURSCN
       REF  CURINS,CHRCUR,CURMOD
       REF  CURMNU,CURFRM,STACK
       REF  ENTMNU,ENTFRM
*
       
START
* Initialize Program
       LI   R10,STACK
       BL   @INTMEM
       BL   @INTKEY
       BL   @VDPTXT
       BL   @INTSCN
       LIMI 2
*
* Main program loop while program runs
*
MAIN
* Clear the document status register
       CLR  R0
* If in menu mode, leave document loop
       MOV  @CURMNU,R1
       JEQ  MAIN0A
       BL   @ENTMNU
* If in form mode, leave document loop
MAIN0A MOV  @CURFRM,R1
       JEQ  MAIN0
       BL   @ENTFRM
* Process user input
MAIN0  BLWP @INPUT
* Wrap the previous paragraph if needed
       MOV  R0,R1
	MOV  R0,R2
       COC  @STSENT,R2
       JNE  MAIN1
       MOV  @PARINX,R0
       DEC  R0
       BLWP @WRAP
* Wrap the current paragraph if needed
MAIN1  COC  @STSENT,R2
       JEQ  MAIN2
       COC  @STSTYP,R2
       JNE  MAIN3
MAIN2  MOV  @PARINX,R0
       BLWP @WRAP
       MOV  R1,R0
MAIN3
* Update cursor and window positions
       BLWP @POSUPD
* Redisplay the screen
       LIMI 0
       BLWP @DISP
       BL   @DRWCUR
       LIMI 2
*
       JMP  MAIN

*
* Initialize Memory
*
INTMEM
* Initialize buffer.
       LI   R0,MEMBEG
       LI   R1,MEMEND
       S    R0,R1
       BLWP @BUFINT
* Reserve space for margin and format
* and paragraph list.
       LI   R0,3
       BLWP @ARYALC
       MOV  R0,@FMTLST
       LI   R0,3
       BLWP @ARYALC
       MOV  R0,@MGNLST
       LI   R0,1
       BLWP @ARYALC
       MOV  R0,@LINLST
* Insert one empty paragraph
* Let R4 = paragraph address
       LI   R0,PAREND-PAR
       MOV  R0,R2
       BLWP @BUFALC
       MOV  R0,R4
       MOV  R0,R1
       LI   R0,PAR
       BLWP @BUFCPY
* Insert one empty wrap list, and
* place address inside paragraph object
       LI   R0,1
       BLWP @ARYALC
       MOV  R0,@2(4)
* Put the paragraph into the
* paragraph list
       MOV  @LINLST,R0
       BLWP @ARYADD
       MOV  R0,@LINLST
       MOV  R4,*R1
*
       RT

* Default paragraph
PAR    DATA 0
       BSS  2
       TEXT ''
PAREND

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

INTRPT
* Decrease cursor time
       DEC   @CURTIM
* Call key scanning interupt
* (which is responsible for return)
       B     @KEYINT
       
* 
* Initialize screen
*
INTSCN MOV  R11,R12
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
* Draw the cursor on screen
*
DRWCUR MOV  R11,R12
*
       COC  @STSTYP,R0
       JEQ  DRWCR2
       COC  @STSENT,R0
       JEQ  DRWCR2
       COC  @STSWIN,R0
       JEQ  DRWCR2
       COC  @STSARW,R0
       JEQ  DRWCR1
       MOV  @CURTIM,R0
       JNE  DRWCR9
* Switch cursor mode
       INV  @CURMOD
       JMP  DRWCR3
* Replace original character
DRWCR1 MOV  @CUROLD,R0
       BL   @VDPADR
       LI   R0,CURRPL
       LI   R1,1
       BL   @VDPWRT
* Store new cursor position
DRWCR2 MOV  @CURSCN,@CUROLD
* Set cursor mode to visible
       SETO @CURMOD
* Store character from new position
       MOV  @CURSCN,R0
       BL   @VDPRAD
       LI   R0,CURRPL
       LI   R1,1
       BL   @VDPREA
* Draw cursor
DRWCR3 MOV  @CURSCN,R0
       BL   @VDPADR
*
       MOV  @CURMOD,R0
       JNE  DRWCR4
       LI   R0,CURRPL
       JMP  DRWCR5
DRWCR4 LI   R0,CHRCUR
DRWCR5 LI   R1,1
       BL   @VDPWRT
* Reset cursor timer
       LI   R0,32
       MOV  R0,@CURTIM
*
DRWCR9 B    *R12

       EVEN

       END