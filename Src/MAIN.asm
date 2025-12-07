       DEF  DRWCUR,INTDOC,INTPAR
       DEF  MAIN,INTRPT,DRWCR2
* Memory Chunk Buffer
       DEF  BUFADR,BUFEND
*
       REF  INIT,PRGEND
       REF  KEYINT
       REF  INPUT,WRAP,POSUPD,DISP
       REF  WRAP_START,WRAP_END
       REF  PARINX,CHRPAX
       REF  BUFINT,BUFALC,BUFCPY
       REF  ARYALC,ARYADD
       REF  PARLST,MGNLST,FMTLST
       REF  UNDLST,UNDOIDX
       REF  PREV_ACTION
       REF  PGHGHT,PGWDTH
       REF  VDPADR,VDPRAD,VDPWRT
       REF  STSTYP,STSENT,STSWIN,STSARW
       REF  DOCSTS
       REF  CURTIM,CUROLD,CURRPL,CURSCN
       REF  CHRCUR,CURMOD
       REF  CURMNU
       REF  ENTMNU
       REF  ADJHDR
*

       COPY 'EQUADDR.asm'
       COPY 'EQUVAL.asm'

BEGIN  B    @INIT
*
* Main program loop while program runs
*
MAIN
* Clear the document status register
       CLR  R0
       MOV  R0,@DOCSTS
* Reset the range of paragraphs that should be wrapped.
       SETO @WRAP_START
       SETO @WRAP_END
* If in menu mode, leave document loop
       MOV  @CURMNU,R1
       JEQ  MAIN1
       BL   @ENTMNU
MAIN1
* Process user input
       BL   @INPUT
* Wrap current or previous paragraphs if needed
       BL   @MYWRAP
* Update cursor and window positions
       MOV  @DOCSTS,R0
       BLWP @POSUPD
       MOV  R0,@DOCSTS
* Redisplay the screen
       LIMI 0
       BL   @ADJHDR
*
       MOV  @DOCSTS,R0
       BLWP @DISP
       MOV  R0,@DOCSTS
*
       MOV  @DOCSTS,R0
       BL   @DRWCUR
       LIMI 2
*
       JMP  MAIN

*
* Initialize Document values
* (Overwrite anything following INIT.asm's PRGEND label)
*
* Output:
*  R0 - zero - to imply no error
*  R2 - changed
*  R1 - Address in PARLST
*  R4 - Address of paragraph
INTDOC
* Set default page size
       LI   R0,DFLTHT*>100
       MOVB R0,@PGHGHT
       LI   R0,DFLTPG*>100
       MOVB R0,@PGWDTH
* Initialize buffer.
* Hack the buffer by setting initial headers for allocated and unallocated space.
* In a sense, the text buffer exceeds 32KB,
* but only because it overlaps places it can't write to.
       LI   R0,BUFFER_ADDRESSES
       LI   R1,MEMBEG
BUFFER_ALLOCATION_LOOP
       MOV  *R0+,*R1
       A    *R0,*R1
       S    R1,*R1
       MOV  *R0+,R1
       CI   R0,BUFFER_ADDRESSES_END
       JL   BUFFER_ALLOCATION_LOOP
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
       MOV  R0,@PARLST
       LI   R0,1
       BLWP @ARYALC
       MOV  R0,@UNDLST
       CLR  @PREV_ACTION
* Set cursor position to document start
       CLR  @PARINX
       CLR  @CHRPAX
* Initialize index in undo/redo list
       SETO @UNDOIDX
* Insert one empty paragraph
* Let R4 = paragraph address
INTPAR LI   R0,EMPPAR
       BLWP @BUFALC
       MOV  R0,R4
* Put the paragraph into the
* paragraph list
       MOV  @PARLST,R0
       BLWP @ARYADD
       MOV  R0,@PARLST
       MOV  R4,*R1
* Specify the paragraph length as 0
* Let R4 = address of address of wrap list
       CLR  *R4+
* Insert one empty wrap list, and
* place address inside paragraph object
       LI   R0,1
       BLWP @ARYALC
       MOV  R0,*R4
*
       CLR  R0
*
       RT

*
* Buffer for text
*
EMPTY_BLOCK     EQU >0000
FILLED_BLOCK    EQU >8000

BUFFER_ADDRESSES
       DATA EMPTY_BLOCK,>3FFE
       DATA FILLED_BLOCK,>A000
       DATA FILLED_BLOCK,PRGEND
       DATA EMPTY_BLOCK,MEMEND
BUFFER_ADDRESSES_END

* Required for MEMBUF.noheader.obj
*
* holds address of buffer (MEMBEG)
BUFADR EQU  BUFFER_ALLOCATION_LOOP-2
* holds first address after the buffer (MEMEND)
BUFEND EQU  BUFFER_ADDRESSES_END-2

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
* Let R2 = copy of document status
	MOV  @DOCSTS,R2
* If user pressed enter,
* wrap at least 2 paragraphs.
       COC  @STSENT,R2
       JNE  WRAP1
* Let R3 = first paragraph to wrap
* Let R4 = last paragraph to wrap
* If WRAP_START >= 0, then it contains the first new paragraph from pressing enter.
       MOV  @WRAP_START,R3
       JLT  WRAP1
       MOV  @WRAP_END,R4
	JMP  WRAP2
* If the user typed something,
* wrap the current paragraph.
WRAP1  COC  @STSTYP,R2
       JNE  WRAPRT
* Let R3 = first paragraph to wrap
* Let R4 = last paragraph to wrap
       MOV  @PARINX,R3
       MOV  R3,R4
* Wrap each paragraph up to the current one
WRAP2  MOV  R3,R0
       BLWP @WRAP
       INC  R3
       C    R3,R4
       JLE  WRAP2
*
WRAPRT RT

*
* Draw the cursor on screen
*
* Input:
*  R0 = Document status
DRWCUR DECT R10
       MOV  R11,*R10
*
       MOV  R0,R1
       ANDI R1,STATYP+STAENT+STAWIN
       JNE  DRWCR2
       COC  @STSARW,R0
       JEQ  DRWCR1
       MOV  @CURTIM,R0
       JGT  DRWCR9
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
* Is this the time to display the cursor or the original character?
       MOV  @CURMOD,R0
       JNE  DRWCR4
* Draw Original character
       LI   R0,CURRPL
       JMP  DRWCR5
* Draw Cursor
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