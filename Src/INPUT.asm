       DEF  INPUT,INCKRD
*
       REF  LINLST,FMTLST,MGNLST
       REF  ARYALC,ARYINS,ARYDEL,ARYADR
       REF  BUFALC,BUFREE,BUFCPY,BUFGRW
       REF  BUFSRK
       REF  VDPADR,VDPWRT
       REF  WINMOD,WINOFF
       REF  DOCSTS,FASTRT

* Key stroke routines in another file
       REF  UPUPSP,DOWNSP
       REF  MNUINT,PRINT

* variables just for INPUT
       REF  PARINX,CHRPAX
       REF  INSTMD,INPTMD
       REF  KEYSTR,KEYEND,KEYWRT,KEYRD

* constants
       REF  BLKUSE
       REF  ENDINP
       REF  CHRMIN,CHRMAX
       REF  STSTYP,STSENT,STSDCR
       REF  STSPAR,STSWIN,STSARW
       REF  ERRMEM
       REF  CURINS,CUROVR

*
       REF  WRAP,MNUHK
       REF  CURMNU
       REF  WRAPDC                       From UTIL.asm

       COPY 'EQUKEY.asm'

*
* Process the new keystrokes
*
* Input: n/a
* Output:
* R0 - 
*  bit 0-13 unchanged
*  bit 14 is set -> enter was pressed
*  bit 15 is set -> something was typed
INPUT
       DECT R10
       MOV  R11,*R10
       MOV  R10,@FASTRT
* Let R13 = address of doc status
       LI   R13,DOCSTS
* Reset Document-Status bits
       SZC  @STSTYP,*R13
       SZC  @STSENT,*R13
       SZC  @STSARW,*R13
* Reset the input mode to unspecified
       CLR  @INPTMD
* Are there more keystrokes to process?
INPUT1 C    @KEYRD,@KEYWRT
       JEQ  INPTRT
* Yes, let R4 = KEYRD
       MOV  @KEYRD,R4
* Is the detected key a visible character?
       CB   *R4,@CHRMIN
       JL   INPUT2
       CB   *R4,@CHRMAX
       JH   INPUT2
* Yes, handle visible character key strokes
       BL   @ADDTXT
       JEQ  INPTRT
       JMP  INPUT3
* No, handle a command key
INPUT2 BL   @KEYBRC
       JEQ  INPTRT
* Increment the key read position
INPUT3 BL   @INCKRD
       JMP  INPUT1
* No, there are not.
INPTRT MOV  *R10+,R11
       RT                  *RTWP

ROUTKY BYTE DELKEY,INSKEY,BCKKEY,FWDKEY
       BYTE UPPKEY,DWNKEY,ENTER,CLRKEY
       BYTE ESCKEY,FCTN0,CTRLY
ROUTKE
       EVEN
ROUTIN DATA DELCHR,INSSWP,BACKSP,FWRDSP
       DATA UPUPSP,DOWNSP,ISENTR,BCKDEL
       DATA MNUINT,WINVRT,SHOWHK
EXPMOD DATA MODEXT,MODEXT,MODEMV,MODEMV
       DATA MODEMV,MODEMV,MODEXT,MODEXT
       DATA MODMNU,MODEMV,MODEMV

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
* Menu input mode
MODMNU EQU  3
*INPTMN DATA 3

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
INSSWP DECT R10
       MOV  R11,*R10
*
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
*
       MOV  *R10+,R11
       RT

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
ISENTR DECT R10
       MOV  R11,*R10
*
       INC  @PARINX
* Break a paragraph in two.
* Create space in paragraph list.
       MOV  @LINLST,R0
       MOV  @PARINX,R1
       BLWP @ARYINS
       JEQ  RTERR
* Save addresses
       MOV  R0,@LINLST
       MOV  R1,R2
* Allocate space for wraplist
       LI   R0,1
       BLWP @ARYALC
       JEQ  TERR1
* Save address
       MOV  R0,R3
* Calculate length of new paragraph.
       DECT R1
       MOV  *R1,R1
       MOV  *R1,R4
       S    @CHRPAX,R4
* Allocate space for new paragraph
       MOV  R4,R0
       C    *R0+,*R0+
       BLWP @BUFALC
       JEQ  TERR2
       MOV  R0,R5
* Change length of old paragraph.
       MOV  @CHRPAX,*R1
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
ENTR3  CLR  @CHRPAX
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
* Update margins
       LI   R2,1
       MOV  @PARINX,R3
       BL   @UPDMGN
* Set document-status bit
       SOC  @STSENT,*R13
*
       MOV  *R10+,R11
       RT

*
* An out-of-memory error occurred pressing enter
*
* Deallocate the wrap list that was allocated
TERR2  MOV  R3,R0
       BLWP @BUFREE
* Remove the paragraph list entry that
* was just created, but cannot be used.
TERR1  MOV  @LINLST,R0
       MOV  @PARINX,R1
       BLWP @ARYDEL
* Decrement the PARINX to its previous value.
       DEC  @PARINX
*
       JMP  RTERR

* Somehow let the user know that there
* is no remaining buffer space.
* Do not reprocess the key that cause the overflow.
RTERR  MOV  @KEYRD,@KEYWRT
       SOC  @ERRMEM,*R13
       MOV  @FASTRT,R10
       MOV  *R10+,R11
       RT                  *RTWP

*
* Delete key was pressed.
*
DELCHR MOV  R11,R12
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
       B    *R12
* If this is the end of document,
* delete nothing.
DELC2  MOV  @LINLST,R9
       MOV  @PARINX,R5
       INC  R5
       C    R5,*R9
       JEQ  DELCRT
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
       JEQ  RTERR
* Let R3 = (possibly new) address of first paragraph
       MOV  R0,R3
* Copy bytes from second paragraph
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
* Update Margin List
       LI   R2,-1
       MOV  @PARINX,R3
       INCT R3
       BL   @UPDMGN
* Find any pair of MGNLST entries with
* matching paragraph indeces, and
* delete the earlier of the pair.
       MOV  @MGNLST,R0
       MOV  *R0,R2
       DECT R2
       JLT  DELCRT
DELC4  MOV  R2,R1
       BLWP @ARYADR
       C    *R1,@MGNLNG(R1)
       JNE  DELC5
       MOV  R2,R1
       BLWP @ARYDEL
DELC5  DEC  R2
       JGT  DELC4
       JEQ  DELC4
* 
DELCRT B    *R12
       

* User typed some text.
* Put it in the buffer.
*
* Output:
*   EQ status bit = if true, leave INPUT routine
ADDTXT DECT R10
       MOV  R11,*R10
* Set input mode if currently unset
       C    @INPTMD,@INPTNN
       JNE  ADDT1
       MOV  @INPTXT,@INPTMD
* Does processing this key involve
* switching input modes.
ADDT1  C    @INPTMD,@INPTXT
       JEQ  ADDT2
* Tell the caller to leave the INPUT routine.
       MOV  *R10+,R11
       S    R0,R0
       RT
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
       JNE  INS1
       B    @RTERR
INS1   MOV  R0,*R6
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
       MOV  @KEYRD,R2
       MOVB *R2,*R0
* Increase character index.
       INC  @CHRPAX
*
       MOV  *R10+,R11
       RT

*
* Branch to non-typing routine specified
* by key code in R4
*
* Output:
*   EQ status bit = if true, leave INPUT routine
KEYBRC DECT R10
       MOV  R11,*R10
* Let R0 = Address of element within ROUTKY
* that corresponds to the pressed key
       LI   R0,ROUTKY
       MOV  R0,R2
KYBRC2 CB   *R4,*R0+
       JEQ  KYBRC3
       CI   R0,ROUTKE
       JL   KYBRC2
       JMP  KYBRC6
KYBRC3 DEC  R0
       S    R2,R0
* Let R1 = address of routine specified in ROUTKY element
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
KYBRC5
* If the next key involves switching to a
* different input mode, leave the routine
       C    *R3,@INPTMD
       JNE  KYEXIT
* Branch to routine associated with key
       BL   *R1
* Jump here when the caller is allowed to 
* continue with the next key.
* This sets the EQ status bit to false.
KYBRC6 MOV  *R10+,R11
       RT
* Jump here when the caller should leave
* the input routine.
* This sets the EQ status bit to true.
KYEXIT MOV  *R10+,R11
       SB   R0,R0
       RT

*
* Backspace Delete
*
BCKDEL
       MOV  R11,R8
* Is this the beginning of document?
       MOV  @PARINX,R0
       A    @CHRPAX,R0
       JEQ  BCKDL1
* No, delete previous character
       BL   @BACKSP
       BL   @DELCHR
BCKDL1 B    *R8

*
* Swap between windowed and vertical mode
*
WINVRT
* Switch modes
       INV  @WINMOD
* If we just switched to vertical mode, clear the horizontal offset
       JEQ  WV1
       CLR  @WINOFF
WV1
* Wrap all paragraphs
       MOV  R11,R12
       BL   @WRAPDC
       MOV  R12,R11
* Set document status to redraw window
       SOC  @STSWIN,*R13
*
       RT

*
* Turn on Hot Key menu
*
SHOWHK
       LI   R0,MNUHK
       MOV  R0,@CURMNU
       RT

*
* Update the Margin List
* Input
*    R2: +1 or -1
*    R3: paragraph index to start with
*
UPDMGN
* Let R0 = address of first Margin List entry
* Let R1 = address following end of Margin List
       MOV  @MGNLST,R0
       MOV  *R0,R1
       SLA  R1,MGNPWR
       C    *R0+,*R0+
       A    R0,R1
* Find first Margin List equal to or above new PARINX value
UM1    C    R0,R1
       JHE  MGNRT
       C    *R0,R3
       JHE  UM2
       AI   R0,MGNLNG
       JMP  UM1
* Increment/Decrement all later entries
UM2    C    R0,R1
       JHE  MGNRT
       A    R2,*R0
       AI   R0,MGNLNG
       JMP  UM2
MGNRT  RT

       END