       DEF  INPUT
*
       REF  LINLST,FMTLST,MGNLST
       REF  ARYALC,ARYINS,ARYDEL,ARYADR
       REF  BUFALC,BUFREE,BUFCPY,BUFGRW
       REF  BUFSRK
       REF  VDPADR,VDPWRT

* Key stroke routines in another file
       REF  UPUPSP,DOWNSP

* variables just for INPUT
       REF  INPTWS
       REF  PARINX,CHRPAX
       REF  INSTMD,INPTMD
       REF  KEYSTR,KEYEND,KEYWRT,KEYRD

* constants
       REF  BLKUSE,USRISR,SIX
       REF  ENDINP
       REF  CHRMIN,CHRMAX
       REF  STSTYP,STSENT,STSDCR
       REF  STSPAR,STSWIN,STSARW
       REF  CURINS,CUROVR

* This data is a work around for the "first DATA word is 0 if REFed bug"
* TODO: Write an issue to Ralph B.'s github
       DATA >1234
*
* Process the new keystrokes
*
* Input: n/a
* Output:
* R0 - 
*  bit 0-13 unchanged
*  bit 14 is set -> enter was pressed
*  bit 15 is set -> something was typed
INPUT  DATA INPTWS,INPUT+4
* Reset Document-Status bits
       SZC  @STSTYP,*R13
       SZC  @STSENT,*R13
       SZC  @STSARW,*R13
* Reset the input mode to unspecified
       CLR  @INPTMD
       JMP  INPTBG
*
INPUT1 MOV  @KEYRD,R10
* Handle visible character key strokes
       CB   *R10,@CHRMIN
       JL   KEYBRC
       CB   *R10,@CHRMAX
       JH   KEYBRC
       B    @ADDTXT
* Branch to non-typing routine specified
* by key code in R10
KEYBRC LI   R0,ROUTKY
       MOV  R0,R2
KYBRC2 CB   *R10,*R0+
       JEQ  KYBRC3
       CI   R0,ROUTKE
       JL   KYBRC2
       JMP  KYBRC4
KYBRC3 DEC  R0
       S    R2,R0
* R0 now has index of routine
* Let R1 = address of desired routine
       LI   R1,ROUTIN
       SLA  R0,1
       A    R0,R1
       MOV  *R1,R1
* Let R3 = acceptable input mode
       LI   R3,EXPMOD
       A    R0,R3
* Set Input mode if currently unset
       C    @INPTMD,@INPTNN
       JNE  KYBRC5
       MOV  *R3,@INPTMD
* If the next key is for different
* input mode, leave routine
KYBRC5 C    *R3,@INPTMD
       JNE   INPTRT
* Branch to routine associated with key
       BL   *R1
KYBRC4
* Increment the key read position
INPTDN BL   @INCKRD
* Are there more keystrokes to process?
INPTBG C    @KEYRD,@KEYWRT
       JNE  INPUT1
* No, there are not.
INPTRT RTWP

DELKEY EQU  >03
INSKEY EQU  >04
CLRKEY EQU  >07
BCKKEY EQU  >08
FWDKEY EQU  >09
UPPKEY EQU  >0B
DWNKEY EQU  >0A
ENTER  EQU  >0D
ESCKEY EQU  >0F

ROUTKY BYTE DELKEY,INSKEY,BCKKEY,FWDKEY
       BYTE UPPKEY,DWNKEY,ENTER,CLRKEY
ROUTKE
       EVEN
ROUTIN DATA DELCHR,INSSWP,BACKSP,FWRDSP
       DATA UPUPSP,DOWNSP,ISENTR,BCKDEL
EXPMOD DATA MODEXT,MODEXT,MODEMV,MODEMV
       DATA MODEMV,MODEMV,MODEXT,MODEXT

* 
* Input mode values
*
* Unspecified input mode
MODENN EQU  0
INPTNN DATA 0
* Text input mode
MODEXT EQU  1
INPTXT DATA 1
* Movement input mode
MODEMV EQU  2
INPTMV DATA 2

* Move position in key stream forwards
* by one address.
INCKRD MOV  @KEYRD,R0
       INC  R0
       CI   R0,KEYEND
       JL   UPDBUF
       LI   R0,KEYSTR
UPDBUF MOV  R0,@KEYRD
       RT

* Specify address of cursor character
* pattern.
INSSWP
       LI   R0,>7F*8+>801
       BL   @VDPADR
* Toggle insert/overwrite mode.
       INV  @INSTMD
       JEQ  INSSW1
* Set cursor pattern for overwrite
       LI   R0,CUROVR
       JMP  INSSW2
* Set cursor pattern for insert
INSSW1 LI   R0,CURINS
INSSW2 LI   R1,7
       BL   @VDPWRT
       JMP  INPTDN

*
* Backspace by one position
*
BACKSP DEC  @CHRPAX
       JLT  BACKS1
       JMP  BACKRT
* Backspace to the end of previous
* paragraph.
BACKS1 DEC  @PARINX
       JLT  BACKS2
* Find the length of the paragraph and
* use that as the new character-within-
* paragraph-index.
       MOV  @LINLST,R0
       MOV  @PARINX,R1
       BLWP @ARYADR
       MOV  *R1,R1
       MOV  *R1,@CHRPAX
       JMP  BACKRT
* The cursor must already be at the
* beginning of the document.
BACKS2 CLR  @CHRPAX
       CLR  @PARINX
BACKRT SOC  @STSARW,*R13
       RT

*
* Fordward space by one position
*
FWRDSP INC  @CHRPAX
* See if we moved beyong paragraph end.
       MOV  @LINLST,R0
       MOV  @PARINX,R1
       BLWP @ARYADR
       MOV  *R1,R1
       C    @CHRPAX,*R1
       JH   FWRDS1
       JMP  FWRDRT
* Move to next paragraph.
FWRDS1 INC  @PARINX
       C    @PARINX,*R0
       JEQ  FWRDS2
       CLR  @CHRPAX
       JMP  FWRDRT
* Apparently we reached end of document.
FWRDS2 DEC  @PARINX
       DEC  @CHRPAX
FWRDRT SOC  @STSARW,*R13
       RT

*
* Enter key pressed
*
ISENTR
*
       INC  @PARINX
* Break a paragraph in two.
* Create space in paragraph list.
       MOV  @LINLST,R0
       MOV  @PARINX,R1
       BLWP @ARYINS
       CI   R0,>FFFF
       JEQ  RTERR
* Save addresses
       MOV  R0,@LINLST
       MOV  R1,R2
* Allocate space for wraplist
       LI   R0,1
       BLWP @ARYALC
       CI   R0,>FFFF
       JEQ  RTERR
* Save address
       MOV  R0,R3
* Calculate length of new paragraph.
       DECT R1
       MOV  *R1,R1
       MOV  *R1,R4
       S    @CHRPAX,R4
* Change length of old paragraph.
       MOV  @CHRPAX,*R1
* Allocate space for new paragraph
       MOV  R4,R0
       C    *R0+,*R0+
       BLWP @BUFALC
       CI   R0,>FFFF
       JEQ  RTERR
       MOV  R0,R5
* Put paragraph in list
       MOV  R0,*R2
* Set new paragraph length and wrap
* list address
       MOV  R4,*R5+
       MOV  R3,*R5+
* Copy part of old paragraph.
       MOV  R4,R2
       MOV  R1,R0
       C    *R0+,*R0+
       A    @CHRPAX,R0
       MOV  R5,R1
       BLWP @BUFCPY
* Adjust CHRPAX
* PARINX was incremented previously.
ENTR2  CLR  @CHRPAX
* Shrink the previous paragraph.
* Let R0 = address of paragraph.
* Let R1 = required space.
       MOV  @LINLST,R0
       MOV  @PARINX,R1
       DEC  R1
       BLWP @ARYADR
       MOV  *R1,R0
       MOV  *R0,R1
       C    *R1+,*R1+
*
       BLWP @BUFSRK
* Set document-status bit
       SOC  @STSENT,*R13
* We processed a key, so move KEYRD
* to the next position before leaving
* the INPUT routine.
       BL   @INCKRD
       RTWP

* Somehow let the user know that there
* is no remaining buffer space.
RTERR  RTWP

*
* Delete key was pressed.
*
DELCHR
* Set document status bit
       SOC  @STSTYP,*R13
*
* Let R1 = Address in Paragraph list
       MOV  @LINLST,R0
       MOV  @PARINX,R1
       BLWP @ARYADR
* Let R3 = address of paragraph
       MOV  *R1,R3
* If cursor is at end of paragraph,
* merge two paragraphs together.
       C    @CHRPAX,*R3
       JEQ  DELC2
* Reduce paragraph length
       DEC  *R3
* Let R4 = position in paragraph
* Let R6 = end of paragraph
       MOV  R3,R4
       C    *R4+,*R4+
       MOV  R4,R6
       A    @CHRPAX,R4
       A    *R3,R6
* Let R5 = next position
       MOV  R4,R5
       INC  R5
* Move characters backwards
DELC1  MOVB *R5+,*R4+
       C    R4,R6
       JLE  DELC1
* Shrink memory block if needed.
       MOV  R3,R0
       MOV  *R3,R1
       C    *R1+,*R1+
       BLWP @BUFSRK
*
       RT
* If this is the end of document,
* delete nothing.
DELC2  MOV  @LINLST,R9
       MOV  @PARINX,R10
       INC  R10
       C    R10,*R9
       JEQ  DELC3
* Merge two paragraphs
* Set document status
       SOC  @STSDCR,*R13
* Let R2 = Address in paragraph list
* Let R4 = Address of second paragraph
       MOV  R1,R2
       INCT R2
       MOV  *R2,R4
* Let R1 = space to reserve
       MOV  *R3,R1
       A    *R4,R1
       C    *R1+,*R1+
* Grow memory block for first paragraph
       MOV  R3,R0
       BLWP @BUFGRW
       CI   R0,>FFFF
       JEQ  RTERR
* Let R3 = address of new paragraph
       MOV  R0,R3
* Copy bytes from second old paragraph
       MOV  R4,R0
       C    *R0+,*R0+
       MOV  R3,R1
       C    *R1+,*R1+
       A    *R3,R1
       MOV  *R4,R2
       BLWP @BUFCPY
* Set length of new paragraph
       A    *R4,*R3
* Deallocate wrap list for second para
       MOV  @2(4),R0
       BLWP @BUFREE
* Deallocate second paragraph
       MOV  R4,R0
       BLWP @BUFREE
* Put merged paragraph in paragraph list
       MOV  @LINLST,R0
       MOV  @PARINX,R1
       BLWP @ARYADR
       MOV  R3,*R1
* Remove one element from paragraph list
       MOV  @LINLST,R0
       MOV  @PARINX,R1
       INC  R1
       BLWP @ARYDEL
* 
DELC3  RT
       


* User typed some text.
* Put it in the buffer.
* R10 hold address of next input key
ADDTXT
* Set input mode if currently unset
       C    @INPTMD,@INPTNN
       JNE  ADDT1
       MOV  @INPTXT,@INPTMD
* If the input mode is not text,
* leave the INPUT routine.
ADDT1  C    @INPTMD,@INPTXT
       JEQ  ADDT2
       RTWP
* Set document status bit
ADDT2  SOC  @STSTYP,*R13
* Let R1 = address of paragraph's
* entry in the paragraph list
       MOV  @LINLST,R0
       MOV  @PARINX,R1
       BLWP @ARYADR
* Is mode insert or overwrite?
       MOV  @INSTMD,R2
       JEQ  INSERT
* R1 already contains address in
* paragraph list.
* Let R0 = address of paragraph.
* If Overwrite position is at the end of
* the paragraph, then act as if this
* were insert mode.
       MOV  *R1,R0
       C    *R0,@CHRPAX
       JEQ  INSERT
* Overwrite text
* R0 contains address of paragraph.
* Set it to the address to overwrite
* text at.
       C    *R0+,*R0+
       A    @CHRPAX,R0
       JMP  RPLTXT
* Grow the paragraph's allocated
* block, if necessary.
* Let R0 be the address of the
* paragraph.
* Let R1 be the length of the paragraph
* plus one new character plus four-byte
* paragraph header.
* Let R6 be the address in the
* paragraph list.
INSERT MOV  R1,R6
       MOV  *R6,R0
       MOV  *R0,R1
       AI   R1,5
       BLWP @BUFGRW
       CI   R0,>FFFF
       JEQ  RTERR
       MOV  R0,*R6
* Insert character.
* Let R2 contain address following
* the paragraph
       MOV  *R0,R2
       S    @CHRPAX,R2
* Increase paragraph length by one.
       INC  *R0
* Let R0 = insertion address.
       C    *R0+,*R0+
       A    @CHRPAX,R0
* Let R1 = next address.
       MOV  R0,R1
       INC  R1
       BLWP @BUFCPY
RPLTXT
* put keystroke in new space
       MOVB *R10,*R0
* Increase character index.
       INC  @CHRPAX
*
       B    @INPTDN

*
* Backspace Delete
*
BCKDEL
       MOV  R11,R12
       BL   @BACKSP
       BL   @DELCHR
       B    *R12

       END