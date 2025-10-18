       DEF  INPUT
       DEF  INPTS,INPTE
*
       REF  PARLST,FMTLST,MGNLST
       REF  UNDLST,UNDIDX
       REF  ARYALC,ARYINS,ARYDEL,ARYADR
       REF  ARYADD
       REF  BUFALC,BUFREE,BUFCPY,BUFGRW
       REF  BUFSRK
       REF  VDPADR,VDPWRT
       REF  WINMOD,WINOFF,PRFHRZ
       REF  DOCSTS,FASTRT

* Key stroke routines in another file
       REF  LINBEG,LINEND
       REF  UPUPSP,DOWNSP,PGDOWN,PGUP
       REF  NXTWIN
       REF  MNUINT,PRINT

* variables just for INPUT
       REF  PARENT
       REF  PARINX,CHRPAX
       REF  INSTMD,INPTMD
       REF  KEYWRT,KEYRD
       REF  UNDOIDX,UNDO_ADDRESS,PREV_ACTION

* constants
       REF  BLKUSE
       REF  ENDINP
       REF  CHRMIN,CHRMAX
       REF  STSTYP,STSENT,STSDCR
       REF  STSPAR,STSWIN,STSARW
       REF  ERRMEM
       REF  CURINS,CUROVR

*
       REF  MNUHK
       REF  CURMNU
       REF  INCKRD                       From UTIL.asm
       REF  WRAP,WRAPDC                  From WRAP.asm

       COPY 'EQUKEY.asm'
       COPY 'CPUADR.asm'

       AORG >F000
INPTS
       XORG LOADED

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
       SB   @INPTMD,@INPTMD
* Are there more keystrokes to process?
INPUT1 C    @KEYRD,@KEYWRT
       JEQ  INPTRT
* Yes, let R4 (high byte) = ascii value of key read
       MOV  @KEYRD,R4
* No, let R1 = address of non-typing routine
       BL   @GET_KEY_ROUTINE
* If the input mode changed, leave the input routine
       JEQ  INPTRT
* Store routine's double-index to the stack
       DECT R10
       MOV  R0,*R10
* Call the routine associated with the current key
INPUT2 BL   *R1
* Note the most recent action
       MOV  *R10+,R0
       AI   R0,UNDO_ACTIONS
       MOV  *R0,@PREV_ACTION
* Increment the key read position
INPUT3 BL   @INCKRD
       JMP  INPUT1
* There are either no more keys to process,
* or the input mode changed.
* Return to caller.
INPTRT MOV  *R10+,R11
       RT                  *RTWP

*
* Let R1 = address of a non-typing routine specified
* by key code in R4
*
* Input:
*   R4 (highbyte) = detected key
* Output:
*   R0 = double-index of the routine
*   R1 = address of the routine
*   EQ status bit = if true, leave INPUT routine
GET_KEY_ROUTINE
       DECT R10
       MOV  R11,*R10
* Is the detected key a visible character?
       CB   *R4,@CHRMIN
       JL   NONVISIBLE_KEY
       CB   *R4,@CHRMAX
       JH   NONVISIBLE_KEY
* Yes
* Is mode insert or overwrite?
       MOV  @INSTMD,R2
       JEQ  SET_INSERT_RT
* Let R1 = address of paragraph's
* entry in the paragraph list
       MOV  @PARLST,R0
       MOV  @PARINX,R1
       BLWP @ARYADR
* Let R0 = address of paragraph and it's length.
* Is overwrite position at the end of the paragraph?
       MOV  *R1,R0
       C    *R0,@CHRPAX
       JEQ  SET_INSERT_RT
* No, Let R0 = index of OVERWRITE_TEXT in ROUTKY
       LI   R0,1
       JMP  ROUTINE_SELECTED
SET_INSERT_RT
* Let R0 = index of INSERT_TEXT in ROUTKY
       CLR  R0
       JMP  ROUTINE_SELECTED
* No,
* Let R0 = index of element within ROUTKY
* that corresponds to the pressed key
NONVISIBLE_KEY
       LI   R0,ROUTKY
       MOV  R0,R2
KYBRC2 CB   *R4,*R0+
       JEQ  KYBRC3
       CI   R0,ROUTKE
       JL   KYBRC2
       JMP  INVALID_KEY
KYBRC3 DEC  R0
       S    R2,R0
ROUTINE_SELECTED
* Let R3 = a value from the HRZRPL list.
       LI   R3,HRZRPL
       A    R0,R3
       MOV  *R3,R3
* Does the value from HRZRPL suggest that we should clear
* the perferred horizontal position for moving the cursor up and down by a line?
       JNE  !
* Yes, clear it
       SETO @PRFHRZ
!
* Let R3 = acceptable input mode
       LI   R3,EXPMOD
       A    R0,R3
* Let R1 = address of routine specified in ROUTKY element
       LI   R1,ROUTIN
       SLA  R0,1
       A    R0,R1
       MOV  *R1,R1
* Set Input mode if currently unset
       CB   @INPTMD,@INPTNN
       JNE  !
       MOVB *R3,@INPTMD
!
* If the next key involves switching to a
* different input mode, leave the routine.
*
* This ensures that word wraps will
* occur, even if someone types so fast
* that keypresses and arrow keys
* appear in the keybuffer simultaneously.
       CB   *R3,@INPTMD
       JNE  KYEXIT
* Return to caller.
* Find routine for the next key.
* This sets the EQ status bit to false.
       MOV  *R10+,R11
       RT
* Key does not have a routine associated with it.
INVALID_KEY
       SETO R0
       LI   R1,DO_NOTHING
       MOV  *R10+,R11
       RT
* Input Mode changed.
* Leave the routine so that word-wrap runs.
* Set R1 to null and the EQ status bit to true.
KYEXIT MOV  *R10+,R11
       S    R1,R1
       RT

ROUTKY BYTE -1,-1
       BYTE DELKEY,INSKEY,BCKKEY,FWDKEY
       BYTE UPPKEY,DWNKEY,ENTER,ERSKEY
       BYTE ESCKEY,FCTN0,FCTN8,FCTN4
       BYTE FCTN5,FCTN6,FCTNL,FCTNSM
       BYTE UNDKEY
ROUTKE
EXPMOD BYTE MODEXT,MODEXT
       BYTE MODEXT,MODEXT,MODEMV,MODEMV
       BYTE MODEMV,MODEMV,MODEXT,MODEXT
       BYTE MODMNU,MODEMV,MODEMV,MODEMV
       BYTE MODEMV,MODEMV,MODEMV,MODEMV
       BYTE MODEXT
HRZRPL BYTE 0,0
       BYTE 0,0,0,0
       BYTE 1,1,0,0
       BYTE 0,0,0,1
       BYTE 0,1,0,0
       BYTE 0
       EVEN
ROUTIN DATA INSERT_TEXT,OVERWRITE_TEXT
       DATA DELCHR,INSSWP,BACKSP,FWRDSP
       DATA UPUPSP,DOWNSP,ISENTR,BCKDEL
       DATA MNUINT,WINVRT,SHOWHK,PGDOWN
       DATA NXTWIN,PGUP,LINBEG,LINEND
       DATA UNDO_OP
UNDO_ACTIONS
       DATA 0,0
       DATA UNDO_DEL,0,0,0
       DATA 0,0,0,0
       DATA 0,0,0,0
       DATA 0,0,0,0
       DATA 0

* 
* Input mode values
*
* Unspecified input mode
MODENN EQU  0
INPTNN BYTE MODENN
* Text input mode
MODEXT EQU  1
INPTXT BYTE MODEXT
* Movement input mode
MODEMV EQU  2
* INPTMV BYTE MODEMV
* Menu input mode
MODMNU EQU  3
*INPTMN BYTE MODMNU

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
       MOV  @PARLST,R0
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
       MOV  @PARLST,R0
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
       MOV  @PARLST,R0
       MOV  @PARINX,R1
       BLWP @ARYINS
       JEQ  TERR0
* Save addresses
       MOV  R0,@PARLST
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
       CLR  @CHRPAX
* Shrink the previous paragraph.
* Let R0 = address of paragraph.
* Let R1 = required space.
       MOV  @PARLST,R0
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
* Is PARENT already set?
* If not, let PARENT = the second paragraph to re-wrap
       MOV  @PARENT,R0
       JNE  ENT1
       MOV  @PARINX,@PARENT
ENT1
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
TERR1  MOV  @PARLST,R0
       MOV  @PARINX,R1
       BLWP @ARYDEL
* Decrement the PARINX to its previous value.
TERR0  DEC  @PARINX
*
* Somehow let the user know that there
* is no remaining buffer space.
* Do not reprocess the key that cause the overflow.
*
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
* Do we need to make a new undo action?
       LI   R2,UNDO_DEL
       C    @PREV_ACTION,R2
       JEQ  UNDO_DEL_EXISTS
* Yes, add element
       MOV  @UNDLST,R0
       BLWP @ARYADD
       JEQ  RTERR
       MOV  R0,@UNDLST
* Store undo index
       MOV  *R0,@UNDOIDX
       DEC  @UNDOIDX
* Create undo action and store its location in the undo list
       LI   R0,8
       BLWP @BUFALC
       JEQ  RTERR
       MOV  R0,*R1
* Store address of undo action longer-term
       MOV  R0,@UNDO_ADDRESS
* Populate undo action
       MOV  R2,*R0+                * type of action
       MOV  @PARINX,*R0+
       MOV  @CHRPAX,*R0+
       CLR  *R0                    * length of delete text
UNDO_DEL_EXISTS
*
* Let R1 = Address in Paragraph list
       MOV  @PARLST,R0
       MOV  @PARINX,R1
       BLWP @ARYADR
* Let R3 = address of paragraph
       MOV  *R1,R3
* If cursor is at end of paragraph,
* merge two paragraphs together.
       C    @CHRPAX,*R3
       JEQ  MERGE_PARAGRAPHS
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
* Let R7 = address of undo action
       MOV  @UNDO_ADDRESS,R7
* Increase length of undo-action
       MOV  R7,R0
       LI   R1,UNDO_DEL_TEXT+1
       A    @UNDO_DEL_LEN(R7),R1
       BLWP @BUFGRW
       JEQ  RTERR
       MOV  R0,R7
* Store deleted character to undo-action
       MOV  R7,R8
       AI   R8,UNDO_DEL_TEXT
       A    @UNDO_DEL_LEN(R7),R8
       MOVB *R4,*R8
       INC  @UNDO_DEL_LEN(R7)
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
*
*
MERGE_PARAGRAPHS:
* If this is the end of document,
* delete nothing.
       MOV  @PARLST,R9
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
       MOV  @PARLST,R0
       MOV  @PARINX,R1
       BLWP @ARYADR
       MOV  R3,*R1
* Remove one element from paragraph list
       MOV  @PARLST,R0
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

*
* Overwrite text in paragraph
*
OVERWRITE_TEXT
       DECT R10
       MOV  R11,*R10
* Set document status bit
       SOC  @STSTYP,*R13
* Let R1 = address of paragraph's
* entry in the paragraph list
       MOV  @PARLST,R0
       MOV  @PARINX,R1
       BLWP @ARYADR
* Let R0 = address of paragraph.
       MOV  *R1,R0
* Let R0 = address to overwrite text at
       AI   R0,PARAGRAPH_TEXT_OFFSET
       A    @CHRPAX,R0
* put keystroke in new space
       MOV  @KEYRD,R2
       MOVB *R2,*R0
* Increase character index.
       INC  @CHRPAX
*
       MOV  *R10+,R11
       RT

*
* Insert text in paragraph
*
INSERT_TEXT
       DECT R10
       MOV  R11,*R10
* Set document status bit
       SOC  @STSTYP,*R13
* Let R1 = address of paragraph's
* entry in the paragraph list
       MOV  @PARLST,R0
       MOV  @PARINX,R1
       BLWP @ARYADR
* Insert character at CHRPAX location
       MOV  R1,R3
       MOV  @CHRPAX,R4
       MOV  @KEYRD,R5
       MOVB *R5,R5
       BL   @INSERT_CHARACTER_IN_PARA
* Increase character index.
       INC  @CHRPAX
*
       MOV  *R10+,R11
       RT

*
* Insert character in arbitrary paragraph
*
* Input:
* R3 = address in paragraph list
* R4 = character index within paragraph
* R5 (high byte) = character to insert
*
* Output:
* value at address within R3 could update to reflect paragraph's new position
*
INSERT_CHARACTER_IN_PARA
       DECT R10
       MOV  R11,*R10
* Grow the paragraph's allocated
* block, if necessary.
* Let R0 be the address of the
* paragraph.
* Let R1 be the length of the paragraph
* plus one new character plus four-byte
* paragraph header.
       MOV  *R3,R0
       MOV  *R0,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET+1
       BLWP @BUFGRW
       JNE  !
* Handle memory error       
       B    @RTERR
* Store new paragraph address
!      MOV  R0,*R3
* Let R2 = number of characters after insertion point
       MOV  *R0,R2
       S    R4,R2
* Increase paragraph length by one.
       INC  *R0
* Move part of paragraph ahead one position
* Let R0 = insertion address.
* Let R1 = next address.
* R2 already contains length of data
       C    *R0+,*R0+
       A    R4,R0
       MOV  R0,R1
       INC  R1
       BLWP @BUFCPY
* put character in new space
       MOVB R5,*R0
*
       MOV  *R10+,R11
       RT

*
* Backspace Delete
*
BCKDEL DECT R10
       MOV  R11,*R10
* Is this the beginning of document?
       MOV  @PARINX,R0
       A    @CHRPAX,R0
       JEQ  BCKDL1
* No, delete previous character
       BL   @BACKSP
       BL   @DELCHR
BCKDL1 MOV  *R10+,R11
       RT

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

*
* Undo operation
*
* TODO: Update cursor position
UNDO_OP
       DECT R10
       MOV  R11,*R10
* Let R0 = address of undo list
* Let R1 = index in undo operation list
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
* Are there any undo operations remaining?
       JLT  UNDO_COMPLETE
* Yes, Let R6 = address of current undo operation in list
       BLWP @ARYADR
       MOV  *R1,R6
* Let R7 = address of text to restore
       MOV  R6,R7
       AI   R7,UNDO_DEL_TEXT
* Let R8 = end of undo text
       MOV  R7,R8
       A    @UNDO_DEL_LEN(R6),R8
* Let R3 = address within paragraph list
       MOV  @PARLST,R0
       MOV  @UNDO_ANY_PARA(R6),R1
       BLWP @ARYADR
       MOV  R1,R3
* Let R4 = character insertion point with paragraph
       MOV  @UNDO_ANY_CHAR(R6),R4
* Is insertion complete?
TEXT_RESTORE_LOOP
       C    R7,R8
       JHE  TEXT_RESTORE_DONE
       MOVB *R7+,R5
       BL   @INSERT_CHARACTER_IN_PARA
* Repeat
       INC  R4
       JMP  TEXT_RESTORE_LOOP
TEXT_RESTORE_DONE
* Restore PARINX and CHRPAX
       MOV  @UNDO_ANY_PARA(R6),@PARINX
       MOV  @UNDO_ANY_CHAR(R6),@CHRPAX
* Move undo position one location earlier
       DEC  @UNDOIDX
* Set document status bit, as this is necessary regardless of what we are undoing
       SOC  @STSWIN,*R13       
UNDO_COMPLETE
       MOV  *R10+,R11
       RT

*
* Key is not recognized
*
DO_NOTHING
       RT

INPTE  AORG
       END