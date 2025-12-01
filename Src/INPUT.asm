       DEF  INPUT
*
       REF  PARLST,FMTLST,MGNLST
       REF  UNDLST
       REF  ARYALC,ARYINS,ARYDEL,ARYADR
       REF  ARYADD
       REF  BUFALC,BUFREE,BUFCPY,BUFGRW
       REF  BUFSRK
       REF  VDPADR,VDPWRT                            * VDP.asm
       REF  WINMOD,WINOFF,PRFHRZ
       REF  DOCSTS,FASTRT

* Key stroke routines in another file
       REF  LINBEG,LINEND
       REF  UPUPSP,DOWNSP,PGDOWN,PGUP
       REF  NXTWIN
       REF  MNUINT,PRINT

* variables just for INPUT
       REF  WRAP_START,WRAP_END
       REF  PARINX,CHRPAX
       REF  INSTMD,INPTMD
       REF  KEYWRT,KEYRD
       REF  UNDOIDX,UNDO_ADDRESS,PREV_ACTION

* constants
       REF  ENDINP
       REF  CHRMIN,CHRMAX
       REF  STSTYP,STSENT,STSDCR
       REF  STSPAR,STSWIN,STSARW
       REF  ERRMEM
       REF  CURINS,CUROVR

*
       REF  MNUHK                        From MENU.asm
       REF  CURMNU                       From VAR.asm
       REF  INCKRD                       From UTIL.asm
       REF  WRAP,WRAPDC                  From WRAP.asm

       COPY 'EQUKEY.asm'
       COPY 'CPUADR.asm'

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
* No, let R1 = address of key routine
* Let R0 = double-index of key routine
       BL   @GET_KEY_ROUTINE
* If the input mode changed, leave the input routine
       JEQ  INPTRT
* Create an undo entry if required for the given key
       BL   @TEST_UNDO_ACTION
* Call the routine associated with the current key
INPUT2 BL   *R1
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
       MOVB *R3,R3
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

*
* Check if the circumstances require a new undo object.
* If yes, make one.
*
* Input:
*   R0 - Double-index of detected key
*
TEST_UNDO_ACTION
       DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R1,*R10
       DECT R10
       MOV  R0,*R10
* If the double-index is less than zero, the received key was invalid. Skip it
       CLR  R2
       MOV  R0,R0
       JLT  NO_NEW_UNDO
* Let R2 = undo action for this key
       AI   R0,UNDO_ACTIONS
       MOV  *R0,R2
* If the undo action is 0 or the same as the old one,
* do not create a new undo object.
       JEQ  NO_NEW_UNDO
       C    @PREV_ACTION,R2
       JEQ  NO_NEW_UNDO
*
       BL   @START_FRESH_UNDO_ENTRY
NO_NEW_UNDO
* Record the current undo action
       MOV  R2,@PREV_ACTION
*
       MOV  *R10+,R0
       MOV  *R10+,R1
       MOV  *R10+,R11
       RT

*
* Increment UNDO index and create a new undo object
* without validating that it is necessary.
*
* Input:
*  R2 - undo type
* Output:
*  R0 - address of new undo object
*  R1 - address of new element in undo list
*
START_FRESH_UNDO_ENTRY
       DECT R10
       MOV  R11,*R10
* Yes, increment undo index.
       INC  @UNDOIDX
REMOVE_UNDO_ACTION_LOOP
* Is there already an old undo action at current index?
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
       C    *R0,R1
       JLE  ADD_UNDO_LIST_ELEM
* Yes, deallocate old undo action from memory
       BLWP @ARYADR
       MOV  *R1,R0
       BLWP @BUFREE
* Delete element from undo list
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
       BLWP @ARYDEL
*
       JMP  REMOVE_UNDO_ACTION_LOOP
*
ADD_UNDO_LIST_ELEM
* Has undo list reached maximum length?
       CI   R1,MAX_UNDO_LIST_LENGTH
       JL   UNDO_LIST_LENGTH_OKAY
* Yes, deallocate the oldest undo-object
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R0
       BLWP @BUFREE
* Delete the oldest undo list element
       MOV  @UNDLST,R0
       CLR  R1
       BLWP @ARYDEL
* Decrease the undo index since the list is shorter
       DEC  @UNDOIDX
UNDO_LIST_LENGTH_OKAY
* Add new element at end of undo list
* Let R1 = address of element in undo list
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
       BLWP @ARYADD
       JNE  !
       B    @RTERR
!      MOV  R0,@UNDLST
* Create undo action and store its location in the undo list
       LI   R0,UNDO_PAYLOAD
       BLWP @BUFALC
       JNE  !
       B    @RTERR
!      MOV  R0,*R1
* Store address of undo action longer-term
       MOV  R0,@UNDO_ADDRESS
* Populate undo action
       MOV  R2,*R0+                * type of action
       MOV  @PARINX,*R0+           * paragraph index before action
       MOV  @CHRPAX,*R0+           * character index before action
       MOV  @PARINX,*R0+           * paragraph index after action
       MOV  @CHRPAX,*R0+           * character index after action
       CLR  *R0+                   * length of undo payload
* Restore the value of R0 to point to address of undo object
       AI   R0,-UNDO_PAYLOAD
*
       MOV  *R10+,R11
       RT

*
* Reserve space for undo data
*
* Input:
*   R0 - number of bytes to reserve
* Output:
*   R0 - address of reserved bytes
RESERVE_UNDO_SPACE
       DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R2,*R10
       DECT R10
       MOV  R0,*R10
* Let R3 = address in undo list
* Let R4 = address of undo action
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
       BLWP @ARYADR
       MOV  *R1,R4
       MOV  R1,R3
* Will undo payload surpass max length?
       MOV  @UNDO_ANY_LEN(R4),R0
       A    *R10,R0
       CI   R0,MAX_UNDO_PAYLOAD
       JLE  INCREASE_ACTION_LENGTH
* Yes, create a new undo object
* Let R2 = undo type
* Let R3 = address of new element in undo list
* Let R4 = address of new action
       MOV  *R4,R2
       BL   @START_FRESH_UNDO_ENTRY
       MOV  R1,R3
       MOV  R0,R4
*
INCREASE_ACTION_LENGTH
* Increase length of undo-action
* Let R0 = new address of undo-action
       MOV  R4,R0
       LI   R1,UNDO_PAYLOAD
       A    @UNDO_ANY_LEN(R4),R1
       A    *R10,R1
       BLWP @BUFGRW
       JNE  !
       B    @RTERR
!
* Store new address of undo-action in the undo list
       MOV  R0,R4
       MOV  R0,*R3
* Let R0 = address of reserved space
       AI   R0,UNDO_PAYLOAD
       A    @UNDO_ANY_LEN(R4),R0
* Update the length of the undo text
       A    *R10+,@UNDO_ANY_LEN(R4)
*
       MOV  *R10+,R2
       MOV  *R10+,R11
       RT

CRBYTE BYTE ENTER
ROUTKY BYTE -1,-1
       BYTE DELKEY,INSKEY,BCKKEY,FWDKEY
       BYTE UPPKEY,DWNKEY,ENTER,ERSKEY
       BYTE ESCKEY,FCTN0,FCTN8,FCTN4
       BYTE FCTN5,FCTN6,FCTNL,FCTNSM
       BYTE UNDKEY,RDOKEY
ROUTKE
EXPMOD BYTE MODEXT,MODEXT
       BYTE MODEXT,MODEXT,MODEMV,MODEMV
       BYTE MODEMV,MODEMV,MODEXT,MODEXT
       BYTE MODMNU,MODEMV,MODEMV,MODEMV
       BYTE MODEMV,MODEMV,MODEMV,MODEMV
       BYTE MODEXT,MODEXT
HRZRPL BYTE 0,0
       BYTE 0,0,0,0
       BYTE 1,1,0,0
       BYTE 0,0,0,1
       BYTE 0,1,0,0
       BYTE 0,0
       EVEN
ROUTIN DATA INSERT_TEXT,OVERWRITE_TEXT
       DATA DELCHR,INSSWP,BACKSP,FWRDSP
       DATA UPUPSP,DOWNSP,ISENTR,BCKDEL
       DATA MNUINT,WINVRT,SHOWHK,PGDOWN
       DATA NXTWIN,PGUP,LINBEG,LINEND
       DATA UNDO_OP,REDO_OP
UNDO_ACTIONS
       DATA UNDO_INS,UNDO_OVR
       DATA UNDO_DEL,0,0,0
       DATA 0,0,UNDO_INS,UNDO_BCK
       DATA 0,0,0,0
       DATA 0,0,0,0
       DATA 0,0

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
       MOV  @PARINX,R1
       MOV  @CHRPAX,R2
       BL   @SPLIT_PARAGRAPH
* Update cursor position
       INC  @PARINX
       CLR  @CHRPAX
* Set document-status bit
       SOC  @STSENT,*R13
* Re-wrap the previous and current paragraph
       MOV  @PARINX,R4
       MOV  R4,R3
       DEC  R3
       JLT  !
       BL   @SET_WRAP_PARAGRAPHS
!
* Record inserted character
       LI   R0,1
       BL   @RESERVE_UNDO_SPACE
       MOVB @CRBYTE,*R0
* Record position of cursor after action complete
       BL   @RECORD_CURSOR_AFTER_ACTION
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
DELCHR DECT R10
       MOV  R11,*R10
* Let R1 = Address in Paragraph list
* Let R2 = CHRPAX
       MOV  @PARINX,R1
       MOV  @CHRPAX,R2
* Delete character from paragraph
* Sets R2 (high byte) = deleted character
       BL   @DELETE_CHARACTER_IN_PARA
* Was a character to deleted?
       MOVB R2,R2
       JNE  RECORD_DELETE
* No, cursor is either at the end of a paragraph or of the document.
       MOV  @PARINX,R1
       BL   @MERGE_PARAGRAPHS
* Set delete character as a carriage return
       MOVB @CRBYTE,R2
RECORD_DELETE
* Record deleted character
       LI   R0,1
       BL   @RESERVE_UNDO_SPACE
       MOVB R2,*R0
* Record position of cursor after action complete
       BL   @RECORD_CURSOR_AFTER_ACTION
*
       MOV  *R10+,R11
       RT
*

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
* Let R5 = address to overwrite text at
       MOV  *R1,R5
       AI   R5,PARAGRAPH_TEXT_OFFSET
       A    @CHRPAX,R5
* Let R2 = address of new character
       MOV  @KEYRD,R2
* Record overwritten character and new character in undo action
       LI   R0,2
       BL   @RESERVE_UNDO_SPACE
       MOVB *R2,*R0+
       MOVB *R5,*R0+
* Overwrite character
       MOVB *R2,*R5
* Increase character index.
       INC  @CHRPAX
* Record position of cursor after action complete
       BL   @RECORD_CURSOR_AFTER_ACTION
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
* Insert character at CHRPAX location
       MOV  @PARINX,R3
       MOV  @CHRPAX,R4
       MOV  @KEYRD,R5
       MOVB *R5,R5
       BL   @INSERT_CHARACTER_IN_PARA
* Increase character index.
       INC  @CHRPAX
* Record inserted character
       LI   R0,1
       BL   @RESERVE_UNDO_SPACE
       MOV  @KEYRD,R5
       MOVB *R5,*R0
* Record position of cursor after action complete
       BL   @RECORD_CURSOR_AFTER_ACTION
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
* Record position of cursor after action complete
       BL   @RECORD_CURSOR_AFTER_ACTION
*
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
UNDO_OP
       DECT R10
       MOV  R11,*R10
* Let R0 = address of undo list
* Let R1 = index in undo operation list
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
* Are there any undo operations remaining?
       JLT  UNDO_COMPLETE
* Yes, Let R7 = address of current undo operation in list
       BLWP @ARYADR
       MOV  *R1,R7
* Restore or remove text
* Address in R7 contains an undo type,
* Lowest possible undo type is UNDO_INS (0002) and all are even numbers
       LI   R8,UNDO_SUB_ROUTINES-UNDO_INS
       A    *R7,R8
       MOV  *R8,R8
       BL   *R8
* Restore PARINX and CHRPAX
       MOV  @UNDO_ANY_PARA(R7),@PARINX
       MOV  @UNDO_ANY_CHAR(R7),@CHRPAX
* Move undo position one location earlier
       DEC  @UNDOIDX
UNDO_COMPLETE
       MOV  *R10+,R11
       RT

UNDO_SUB_ROUTINES
       DATA REMOVE_TEXT_IN_UNDO_ACTION
       DATA RESTORE_OVERWRITTEN_TEXT_IN_UNDO_ACTION
       DATA RESTORE_TEXT_IN_UNDO_ACTION
       DATA RESTORE_TEXT_IN_UNDO_ACTION

*
* Redo operation
*
REDO_OP
       DECT R10
       MOV  R11,*R10
* Let R0 = address of undo list
* Let R1 = index of operation to redo
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
       INC  R1
* Are there any redo operations remaining?
       C    R1,*R0
       JHE  REDO_COMPLETE
* Yes, let R7 = address of current undo operation in list
       BLWP @ARYADR
       MOV  *R1,R7
* Restore or remove text
* Address in R7 contains an undo type,
* Lowest possible undo type is UNDO_INS (0002) and all are even numbers
       LI   R8,REDO_SUB_ROUTINES-UNDO_INS
       A    *R7,R8
       MOV  *R8,R8
       BL   *R8
* Restore PARINX and CHRPAX
       MOV  @UNDO_ANY_PARA_AFTER(R7),@PARINX
       MOV  @UNDO_ANY_CHAR_AFTER(R7),@CHRPAX
* Move undo position one location earlier
       INC  @UNDOIDX
REDO_COMPLETE
       MOV  *R10+,R11
       RT

REDO_SUB_ROUTINES
       DATA RESTORE_TEXT_IN_UNDO_ACTION
       DATA 0
       DATA REMOVE_TEXT_IN_UNDO_ACTION
       DATA REMOVE_TEXT_IN_UNDO_ACTION

*
* Key is not recognized
*
DO_NOTHING
       RT

*
* Insert character in arbitrary paragraph
*
* Input:
* R3 = index of paragraph
* R4 = character index within paragraph
* R5 (high byte) = character to insert
*
* Output:
* value at address within R3 could update to reflect paragraph's new position
*
INSERT_CHARACTER_IN_PARA
       DECT R10
       MOV  R11,*R10
* Let R1 & R2 = address within paragraph list
       MOV  @PARLST,R0
       MOV  R3,R1
       BLWP @ARYADR
       MOV  R1,R2
* Grow the paragraph's allocated
* block, if necessary.
* Let R0 be the address of the
* paragraph.
* Let R1 be the length of the paragraph
* plus one new character plus four-byte
* paragraph header.
       MOV  *R1,R0
       MOV  *R0,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET+1
       BLWP @BUFGRW
       JNE  !
* Handle memory error       
       B    @RTERR
!
* Store new paragraph address
       MOV  R0,*R2
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
*
* Input:
*   R1 = paragraph index
*   R2 = character index within paragraph
* Ouput:
*   R2 (high byte) = character deleted (0 if deleting from the end of the paragraph)
DELETE_CHARACTER_IN_PARA
       DECT R10
       MOV  R11,*R10
* Let R1 = Address in Paragraph list
       MOV  @PARLST,R0
       BLWP @ARYADR
* Let R3 = address of paragraph
       MOV  *R1,R3
* Is this the end of the paragraph?
       C    R2,*R3
       JL   !
* Yes, report that no character was remove and leave routine
       SB   R2,R2
       JMP  DELETE_CHARACTER_RETURN
!
* No, reduce paragraph length
       DEC  *R3
* Let R4 = position in paragraph
* Let R6 = end of paragraph
       MOV  R3,R4
       AI   R4,PARAGRAPH_TEXT_OFFSET
       MOV  R4,R6
       A    R2,R4
       A    *R3,R6
* Let R5 = next position
       MOV  R4,R5
       INC  R5
* Store character to delete
       MOVB *R4,R2
* Move characters backwards
DELC1  MOVB *R5+,*R4+
       C    R4,R6
       JLE  DELC1
* Shrink memory block if needed.
       MOV  R3,R0
       MOV  *R3,R1
       C    *R1+,*R1+
       BLWP @BUFSRK
* Set document status bit
       SOC  @STSTYP,*R13
*
DELETE_CHARACTER_RETURN
       MOV  *R10+,R11
       RT

*
* Merge paragraphs
*
* Input:
*  R1 - index of earlier paragraph
*
MERGE_PARAGRAPHS
       DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R1,*R10
* If this is the end of document,
* delete nothing.
       MOV  @PARLST,R0
       MOV  R1,R5
       INC  R5
       C    R5,*R0
       JEQ  MERGE_PARAGRAPHS_RETURN
* Set document status
       SOC  @STSTYP,*R13
       SOC  @STSDCR,*R13
* Let R1 = address in pargraph list of earlier paragraph
* Let R3 = address of earlier paragraph
       BLWP @ARYADR
       MOV  *R1,R3
* Let R4 = Address of later paragraph
       MOV  @2(R1),R4
* Let R1 = space to reserve
       MOV  *R3,R1
       A    *R4,R1
       C    *R1+,*R1+
* Grow memory block for earlier paragraph
       MOV  R3,R0
       BLWP @BUFGRW
       JNE  !
* Handle memory error       
       B    @RTERR
!
* Let R3 = (possibly new) address of earlier paragraph
       MOV  R0,R3
* Copy bytes from later paragraph
* Let R0 = address of later paragraph's text
* Let R1 = address of following end of earlier paragrph's text
* Let R1 = number of bytes to copy / length of later paragraph
       MOV  R4,R0
       C    *R0+,*R0+
       MOV  R3,R1
       C    *R1+,*R1+
       A    *R3,R1
       MOV  *R4,R2
       BLWP @BUFCPY
* Set length of new paragraph
       A    *R4,*R3
* Deallocate wrap list for second paragraph
       MOV  @PARAGRAPH_WRAPLIST_OFFSET(R4),R0
       BLWP @BUFREE
* Deallocate second paragraph
       MOV  R4,R0
       BLWP @BUFREE
* Put merged paragraph in paragraph list
       MOV  @PARLST,R0
       MOV  *R10,R1
       BLWP @ARYADR
       MOV  R3,*R1
* Remove one element from paragraph list
       MOV  @PARLST,R0
       MOV  *R10,R1
       INC  R1
       BLWP @ARYDEL
* Update Margin List
       LI   R2,-1
       MOV  *R10,R3
       INCT R3
       BL   @UPDMGN
* Find any pair of MGNLST entries with
* matching paragraph indeces, and
* delete the earlier of the pair.
       MOV  @MGNLST,R0
       MOV  *R0,R2
       DECT R2
       JLT  MERGE_PARAGRAPHS_RETURN
MERGE_PARAGRAPHS_MARGIN_LOOP
       MOV  R2,R1
       BLWP @ARYADR
       C    *R1,@MGNLNG(R1)
       JNE  !
       MOV  R2,R1
       BLWP @ARYDEL
!      DEC  R2
       JGT  MERGE_PARAGRAPHS_MARGIN_LOOP
       JEQ  MERGE_PARAGRAPHS_MARGIN_LOOP
* 
MERGE_PARAGRAPHS_RETURN
       MOV  *R10+,R1
       MOV  *R10+,R11
       RT

*
* Split paragraph
*
* Input:
*  R1 - index of paragraph
*  R2 - character index of split
*
SPLIT_PARAGRAPH
       DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R8,*R10
       DECT R10
       MOV  R7,*R10
       DECT R10
       MOV  R6,*R10
       DECT R10
       MOV  R5,*R10
       DECT R10
       MOV  R4,*R10
       DECT R10
       MOV  R3,*R10
       DECT R10
       MOV  R1,*R10       
       DECT R10
       MOV  R2,*R10
* Create space in paragraph list.
       MOV  @PARLST,R0
       INC  R1
       BLWP @ARYINS
       JNE  !
       B    @TERR0
!
* Save (possibly new) addresses of paragraph list
       MOV  R0,@PARLST
* Let R3 = address of old entry in paragraph list
* Let R4 = address of new entry in paragraph list
       MOV  R1,R4
       MOV  R1,R3
       DECT R3
* Allocate space for wraplist
       LI   R0,1
       BLWP @ARYALC
       JNE  !
       B    @TERR1
!
* Let R8 = address of new wrap list
       MOV  R0,R8
* Let R5 = Address of old paragraph.
* Let R7 = Length of new paragraph.
* (stack pointer currently points to split position)
       MOV  *R3,R5
       MOV  *R5,R7
       S    *R10,R7
* Allocate space for new paragraph (including paragraph header)
       MOV  R7,R0
       C    *R0+,*R0+
       BLWP @BUFALC
       JNE  !
       B    @TERR2
!
* Let R6 = address of new paragraph
       MOV  R0,R6
* Put new paragraph in list
       MOV  R6,*R4
* Set new paragraph length and wrap list address
       MOV  R7,*R6
       MOV  R8,@2(R6)
* Change length of old paragraph.
* (stack pointer currently points to split position)
       MOV  *R10,*R5
* Copy part of old paragraph.
* Let R0 = address of text from old paragraph
* Let R1 = address of text of new paragraph
* Let R2 = length of new paragraph
       MOV  R5,R0
       C    *R0+,*R0+
       A    *R10,R0
       MOV  R6,R1
       C    *R1+,*R1+
       MOV  R7,R2
       BLWP @BUFCPY
* Shrink the previous paragraph.
* Let R0 = address of paragrah
* Let R1 = length of paragraph + paragrah header
       MOV  R5,R0
       MOV  *R5,R1
       C    *R1+,*R1+
       BLWP @BUFSRK
* Update margins
       LI   R2,1
       MOV  @2(R10),R3
       INC  R3
       BL   @UPDMGN
*
SPLIT_PARA_RETURN
       MOV  *R10+,R2
       MOV  *R10+,R1
       MOV  *R10+,R3
       MOV  *R10+,R4
       MOV  *R10+,R5
       MOV  *R10+,R6
       MOV  *R10+,R7
       MOV  *R10+,R8
       MOV  *R10+,R11
       RT

*
* Input:
*   R7 = address of undo action
*
REMOVE_TEXT_IN_UNDO_ACTION
       DECT R10
       MOV  R11,*R10
* Let R8 = amount to delete
       MOV  @UNDO_ANY_LEN(R7),R8
       JEQ  TEXT_REDELETE_DONE
REDO_DEL_LOOP
* Let R9 & R2 be the point in document from where we are deleting
       C    *R7,@RESTORE_BACKWARDS
       JEQ  !
       MOV  @UNDO_ANY_PARA(R7),R9
       MOV  @UNDO_ANY_CHAR(R7),R2
       JMP  REDO_DELETE_CHAR
!      MOV  @UNDO_ANY_PARA_AFTER(R7),R9
       MOV  @UNDO_ANY_CHAR_AFTER(R7),R2
REDO_DELETE_CHAR
* Delete character from paragraph
       MOV  R9,R1
       BL   @DELETE_CHARACTER_IN_PARA
* If nothing was deleted, merge paragraphs
       MOVB R2,R2
       JNE  !
       MOV  R9,R1
       BL   @MERGE_PARAGRAPHS
!
* Do next character
       DEC  R8
       JNE  REDO_DEL_LOOP
TEXT_REDELETE_DONE
* Set document status bit. We have to assume that the window moved because
* the redo action can move the user to a different part of the document.
       SOC  @STSWIN,*R13
* Set the paragraphs to re-wrap
       MOV  @UNDO_ANY_PARA_AFTER(R7),R3
       MOV  R3,R4
       BL   @SET_WRAP_PARAGRAPHS
*
       MOV  *R10+,R11
       RT

*
*
* Input:
*   R7 = address of undo action
RESTORE_TEXT_IN_UNDO_ACTION
       DECT R10
       MOV  R11,*R10
* Let R8 = address of text to restore
       MOV  R7,R8
       AI   R8,UNDO_PAYLOAD
* Let R9 = end of undo text
       MOV  R8,R9
       A    @UNDO_ANY_LEN(R7),R9
* Wrap the earliest paragraph of the undo action
* See RESTORE_CR for mutli-paragraph actions
       MOV  @UNDO_ANY_PARA(R7),R3
       MOV  @UNDO_ANY_PARA_AFTER(R7),R4
       C    R3,R4
       JLE  !
       MOV  R4,R3
!      MOV  R3,R4
       BL   @SET_WRAP_PARAGRAPHS
* Set @INSERT_CHARACTER_IN_PARA parameters
* Let R3 = paragraph index
* Let R4 = character insertion point with paragraph
       C    *R7,@INSERT_ACTION
       JEQ  !
       MOV  @UNDO_ANY_PARA_AFTER(R7),R3
       MOV  @UNDO_ANY_CHAR_AFTER(R7),R4
       JMP  TEXT_RESTORE_LOOP
!      MOV  @UNDO_ANY_PARA(R7),R3
       MOV  @UNDO_ANY_CHAR(R7),R4
* Is insertion complete?
TEXT_RESTORE_LOOP
       C    R8,R9
       JHE  TEXT_RESTORE_DONE
* No, let R5 = character to insert
       MOVB *R8+,R5
* Insert a character or a carriage return?
       CB   R5,@CRBYTE
       JEQ  RESTORE_CR
* Insert one character
       BL   @INSERT_CHARACTER_IN_PARA
* If undoing a backspace delete, repeat
       C    *R7,@RESTORE_BACKWARDS
       JEQ  TEXT_RESTORE_LOOP 
* Otherwise, move the insert position and repeat
       INC  R4
       JMP  TEXT_RESTORE_LOOP
* Insert a carraige return
RESTORE_CR
* Let param R1 = paragraph index
* Let param R2 = char index to split at
       MOV  R3,R1
       MOV  R4,R2
       BL   @SPLIT_PARAGRAPH
* Set document-status bit
       SOC  @STSENT,*R13
* Specify that one more paragraph must be wrapped
       INC  @WRAP_END
*
       C    *R7,@RESTORE_BACKWARDS
       JEQ  TEXT_RESTORE_LOOP
* Update insert position
       INC  R3
       CLR  R4
*
       JMP  TEXT_RESTORE_LOOP
TEXT_RESTORE_DONE
* Set document status bits
       SOC  @STSTYP,*R13
       SOC  @STSWIN,*R13
*
       MOV  *R10+,R11
       RT

RESTORE_BACKWARDS   DATA UNDO_BCK
INSERT_ACTION       DATA UNDO_INS

*
*
* Input:
*   R7 = address of undo action
RESTORE_OVERWRITTEN_TEXT_IN_UNDO_ACTION
       DECT R10
       MOV  R11,*R10
* Let R8 = address of text to restore
       MOV  R7,R8
       AI   R8,UNDO_PAYLOAD
* Let R9 = end of undo text
       MOV  R8,R9
       A    @UNDO_ANY_LEN(R7),R9
* Rewrap paragraph after we are done.
* This can never be more than one paragraph,
* because we don't allow overwrites of Carriage Returns.
       MOV  @UNDO_ANY_PARA(R7),R3
       MOV  R3,R4
       BL   @SET_WRAP_PARAGRAPHS
* Let R1 = address of paragraph's entry in the paragraph list
       MOV  @PARLST,R0
       MOV  @UNDO_ANY_PARA(R7),R1
       BLWP @ARYADR
* Let R0 = address to overwrite text at
       MOV  *R1,R0
       AI   R0,PARAGRAPH_TEXT_OFFSET
       A    @UNDO_ANY_CHAR(R7),R0
* Are there more characters to restore?
RESTORE_OVERWRITE_LOOP
*       C    R8,R9
*       JHE  RESTORE_OVERWRITE_DONE
* Yes, copy the ovewritten character
*       MOVB *R8,*R0+
* Pick the next character position to restore from
*       INCT R8
*       JMP  RESTORE_OVERWRITE_LOOP
RESTORE_OVERWRITE_DONE
* Set document status bits
*       SOC  @STSTYP,*R13
*       SOC  @STSWIN,*R13
*
       MOV  *R10+,R11
       RT

*
* Input;
*   R3 & R4 = paragraphs to rewrap
*
SET_WRAP_PARAGRAPHS
* If @WRAP_START < 0 or R3 < @WRAP_START, edit it.
       C    R3,@WRAP_START
       JHE  !
       MOV  R3,@WRAP_START
!
* If @WRAP_END < 0 or R4 > @WRAP_END, edit it.
       C    R4,@WRAP_END
       JLT  !
       MOV  R4,@WRAP_END
!
*
       RT

*
* Record position of cursor after action complete
*
RECORD_CURSOR_AFTER_ACTION
* Let R1 = address of undo action
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
       BLWP @ARYADR
       MOV  *R1,R1
* Point undo action to the current cursor position
       MOV  @PARINX,@UNDO_ANY_PARA_AFTER(R1)
       MOV  @CHRPAX,@UNDO_ANY_CHAR_AFTER(R1)
*
       RT

       END