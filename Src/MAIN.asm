       DEF  DRWCUR,INTDOC,INTPAR
       DEF  MAIN,INTRPT,DRWCR2
*
       REF  INIT
       REF  KEYINT
       REF  MEMBEG,MEMEND
       REF  INPUT,WRAP,POSUPD,DISP
       REF  PARINX,CHRPAX
       REF  BUFINT,BUFALC,BUFCPY
       REF  ARYALC,ARYADD
       REF  LINLST,MGNLST,FMTLST
       REF  PGHGHT,PGWDTH
       REF  VDPADR,VDPRAD,VDPWRT
       REF  STSTYP,STSENT,STSWIN,STSARW
       REF  CURTIM,CUROLD,CURRPL,CURSCN
       REF  CHRCUR,CURMOD
       REF  CURMNU
       REF  ENTMNU
       REF  ADJHDR
*

       COPY 'CPUADR.asm'
       COPY 'EQUVDPADR.asm'
       COPY 'EQUKEY.asm'

BEGIN  B    @INIT
*
* Main program loop while program runs
*
MAIN
* Clear the document status register
       CLR  R0
* If in menu mode, leave document loop
       MOV  @CURMNU,R1
       JEQ  MAIN1
       BL   @ENTMNU
MAIN1
* Process user input
       BLWP @INPUT
* Wrap current or previous paragraphs if needed
       BL   @MYWRAP
* Update cursor and window positions
       BLWP @POSUPD
* Redisplay the screen
       LIMI 0
       BL   @ADJHDR
       BLWP @DISP
       BL   @DRWCUR
       LIMI 2
*
       JMP  MAIN

*
* Initialize Document values
*
* Output:
*  R0 - zero - to imply no error
*  R2 - changed
*  R1 - Address in LINLST
*  R4 - Address of paragraph
INTDOC
* Set default page size
       LI   R0,DFLTHT*>100
       MOVB R0,@PGHGHT
       LI   R0,DFLTPG*>100
       MOVB R0,@PGWDTH
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
* Set cursor position to document start
       CLR  @PARINX
       CLR  @CHRPAX
* Insert one empty paragraph
* Let R4 = paragraph address
INTPAR LI   R0,PAREND-PAR
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
       MOV  R0,@2(R4)
* Put the paragraph into the
* paragraph list
       MOV  @LINLST,R0
       BLWP @ARYADD
       MOV  R0,@LINLST
       MOV  R4,*R1
*
       CLR  R0
*
       RT

* Default paragraph
PAR    DATA 0
       BSS  2
       TEXT ''
PAREND

*
* An interrupt routine to scan for keys
* and increment the time for the cursor to flash
*
INTRPT
* Decrease cursor time
       DEC   @CURTIM
* Call key scanning interupt
* (which is responsible for return)
       B     @KEYINT

*
* Wrap paragraphs if needed
*
MYWRAP
* Let R1 & R2 = copies of document status
       MOV  R0,R1
	MOV  R0,R2
* If user pressed enter,
* wrap the previous paragraph.
       COC  @STSENT,R2
       JNE  WRAP1
       MOV  @PARINX,R0
       DEC  R0
       BLWP @WRAP
* If the user pressed enter or typed something,
* wrap the current paragraph.
WRAP1  COC  @STSENT,R2
       JEQ  WRAP2
       COC  @STSTYP,R2
       JNE  WRAP3
WRAP2  MOV  @PARINX,R0
       BLWP @WRAP
       MOV  R1,R0
*
WRAP3  RT

*
* Draw the cursor on screen
*
DRWCUR DECT R10
       MOV  R11,*R10
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
       MOVB @CURRPL,@VDPWD
* Store new cursor position
DRWCR2 MOV  @CURSCN,@CUROLD
* Set cursor mode to visible
       SETO @CURMOD
* Store character from new position
       MOV  @CURSCN,R0
       BL   @VDPRAD
       MOVB @VDPRD,@CURRPL
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
DRWCR9 MOV  *R10+,R11
       RT

       END