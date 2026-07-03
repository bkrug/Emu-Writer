* Tests to add:
*
* Undo a margin entry insertion that really just edit a later entry to point to the current paragraph.  (edit previous entry)
* Undo a margin entry edit.  (edit current entry)
* Undo a margin entry edit that resulted in deleting a later margin entry.   (edit current entry, delete next entry)
* Undo a margin entry edit that resulted in mergin (deleting) that entry into an earlier entry.    (delete the current entry)

       DEF  TSTLST,RSLTFL
       DEF  WRAPDW

* Assert Routine
       REF  AEQ,AZC,AOC,ABLCK
* From EDTMGN.asm
       REF  EDTMGN,UNDO_MARGIN
       REF  MGNSRT
* From Buffer library
       REF  ARYALC,ARYADD,ARYINS,ARYDEL
       REF  ARYADR
       REF  BUFALC,BUFINT,BUFCPY
* from VAR.asm
       REF  PARLST,FMTLST,MGNLST
       REF  UNDLST,UNDOIDX
       REF  PARINX
       REF  FLDVAL,PGWDTH,PGHGHT

       COPY '../Src/EQUADDR.asm'
       COPY '../Src/EQUVAL.asm'

TSTLST DATA TSTEND-TSTLST-2/8
* Insert a margin in an empty margin list
       DATA MGN1
       TEXT 'MGN1  '
* Insert a margin-entry at the end of a non-empty list
       DATA MGN2
       TEXT 'MGN2  '
* Insert a margin-entry at the beginning of a non-empty list
       DATA MGN3
       TEXT 'MGN3  '
* Insert a margin-entry in between two entries, where this will not create a duplicate
       DATA MGN4
       TEXT 'MGN4  '
* Attempt to insert a margin-entry that would be identical to the one directly after it.
* The result is to edit the later entry, leaving the list size unchanged.
       DATA MGN5
       TEXT 'MGN5  '
* Attempt to insert a margin-entry that would be identical to the one directly before it.
* The result is to edit the earlier entry, leaving the list size unchanged.
       DATA MGN6
       TEXT 'MGN6  '
* Edit an existing margin-entry (same paragraph index).
       DATA EDIT1
       TEXT 'EDIT1 '
* Edit an existing margin-entry such that it will be identical to the following entry.
* The result will be to delete the following entry, shrinking the list size by one.
       DATA EDIT2
       TEXT 'EDIT2 '
* Edit an existing margin-entry such that it will be identical to the preceding entry.
* The result will be to delete the later entry, shrinking the list size by one.
       DATA EDIT3
       TEXT 'EDIT3 '
* Undo a margin entry insertion that grew the list size.
       DATA UNDO1
       TEXT 'UNDO1 '
* Undo an attempt to insert a margin entry that actually merged two entries.
       DATA UNDO2
       TEXT 'UNDO2 '
* Undo an attempt to insert a margin entry that would merely have duplicated an earlier entry.
       DATA UNDO3
       TEXT 'UNDO3 '
* Undo a margin entry edit.
       DATA UNDO4
       TEXT 'UNDO4 '
* Undo a margin entry edit that resulted in
* merging with a later margin entry, to avoid duplicates.
       DATA UNDO5
       TEXT 'UNDO5 '
* Undo a margin entry edit that resulted in
* merging with an earlier margin entry, to avoid duplicates.
       DATA UNDO6
       TEXT 'UNDO6 '
TSTEND
RSLTFL BYTE RSLTFE-RSLTFL-1
       TEXT 'DSK.EMUTEST.TESTRESULT'
RSLTFE
       EVEN

********
* Mocks
* -----
* We don't need to actually wrap the paragraphs
********
WRAPDW RT

****************************************
*
* Initialization for individual test.
*
****************************************

TSTINT
* EDTMGN is code that we cache in the VDP RAM.
* Copy EDTMGN to the LOADED address so it can be run.
       LI   R0,MGNSRT
       LI   R1,LOADED
       LI   R2,>800
       BLWP @BUFCPY
* Set the buffer contents to zero
       LI   R0,SPACE
       LI   R1,SPCEND
CLEAR_SPACE
       CLR  *R0+
       C    R0,R1
       JL   CLEAR_SPACE
* Initialize buffer.
       LI   R0,SPACE
       LI   R1,SPCEND-SPACE
       BLWP @BUFINT
* Reserve space for margin and format
* and paragraph list.
       LI   R0,3
       BLWP @ARYALC
       MOV  R0,@MGNLST
* Initialize undo/redo list
       LI   R0,1
       BLWP @ARYALC
       MOV  R0,@UNDLST
       SETO @UNDOIDX
* Mock user input in form
       LI   R0,DEFAULT_FIELD_VALUES
       LI   R1,FLDVAL
       LI   R2,DEFAULT_FIELD_VALUES_END
       LI   R3,DEFAULT_FIELD_VALUES
       S    R3,R2
       BLWP @BUFCPY
*
       RT

*
* A mock paragraph list that pretends to have 1,000 paragraphs,
* even though it is really empty.
*
* We are assuming the tests and code-under-test don't need to read any paragraph contents.
*
TEST_PARA_LIST:
       DATA 1000
       DATA 2

*
* User-typed field values
*
* (see FPHGHT to FBOT in EQUVAL)
DEFAULT_FIELD_VALUES:
       TEXT '96 '   * Page width
       TEXT '66 '   * Page height
       TEXT '12 '   * Left margin
       TEXT '13 '   * Right margin
       TEXT '6  '   * indent
       TEXT 'F'     * First line/hanging
       TEXT '6  '   * Top margin
       TEXT '7  '   * Bottom margin
DEFAULT_FIELD_VALUES_END

LIST_CONTENTS_MSG:
       TEXT 'Expected a particular set of margin list contents.'
LIST_CONTENTS_MSG_END

*
* Populate the margin list with the
* margin entries provided by the caller.
*
* Input:
*   R0 - address of source data
*   R1 - address directly following
*        the source data
*
SETUP_INITIAL_MARGIN_LIST:
       MOV  R0,R4
       MOV  R1,R5
* Let R1 = number of margin entires
       S    R0,R1
       SRL  R1,3
       MOV  R1,R2
* Add margin list entries
       MOV  @MGNLST,R0
SETUP_MARGIN_LIST_LOOP:
       BLWP @ARYADD
       MOV  R0,@MGNLST
       DEC  R2
       JNE  SETUP_MARGIN_LIST_LOOP
* Copy margin contents
       MOV  R4,R0
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       MOV  R5,R2
       S    R4,R2
       BLWP @BUFCPY
*
       RT

*
* Insert a margin in an empty margin list
*
MGN1
* -------
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Leave the margin list empty
*
* Set the paragraph index
       LI   R0,5
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,1
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,MGN1_LARGER_MARGIN_LIST_MSG
       LI   R3,MGN1_LARGER_MARGIN_LIST_MSG_END-MGN1_LARGER_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,MGN1_EXPECTED_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,MGN1_EXPECTED_MARGIN_ENTRIES_END-MGN1_EXPECTED_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

MGN1_EXISTING_MARGIN_ENTRIES
MGN1_EXISTING_MARGIN_ENTRIES_END

MGN1_LARGER_MARGIN_LIST_MSG:
       TEXT 'Margin list should now be larger'
MGN1_LARGER_MARGIN_LIST_MSG_END
       EVEN

MGN1_EXPECTED_MARGIN_ENTRIES:
       DATA 5,>0006,>0C0D,>0607
MGN1_EXPECTED_MARGIN_ENTRIES_END

*
* Insert a margin-entry at the end of a non-empty list
*
MGN2
* -------
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set up initial margin list
       LI   R0,MGN2_EXISTING_MARGIN_ENTRIES
       LI   R1,MGN2_EXISTING_MARGIN_ENTRIES_END
       BL   @SETUP_INITIAL_MARGIN_LIST
* Set initial page width and height
       LI   R0,50*>100
       MOVB R0,@PGWDTH
       LI   R0,40*>100
       MOVB R0,@PGHGHT
*
       LI   R0,30
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,MGN2_LARGER_MARGIN_LIST_MSG
       LI   R3,MGN2_LARGER_MARGIN_LIST_MSG_END-MGN2_LARGER_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,MGN2_EXPECTED_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,MGN2_EXPECTED_MARGIN_ENTRIES_END-MGN2_EXPECTED_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
*
       CLR  R1
       MOVB @PGWDTH,R1
       SRL  R1,8
       LI   R0,96
       LI   R2,MGN2_PAGE_WIDTH_MSG
       LI   R3,MGN2_PAGE_WIDTH_MSG_END-MGN2_PAGE_WIDTH_MSG
       BLWP @AEQ
*
       CLR  R1
       MOVB @PGHGHT,R1
       SRL  R1,8
       LI   R0,66
       LI   R2,MGN2_PAGE_HEIGHT_MSG
       LI   R3,MGN2_PAGE_HEIGHT_MSG_END-MGN2_PAGE_HEIGHT_MSG
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

MGN2_EXISTING_MARGIN_ENTRIES:
       DATA 10,>0006,>0C0C,>0808
       DATA 20,>00FA,>0A0C,>0606
MGN2_EXISTING_MARGIN_ENTRIES_END

MGN2_PAGE_WIDTH_MSG:
       TEXT 'Page width should be updated from user input'
MGN2_PAGE_WIDTH_MSG_END

MGN2_PAGE_HEIGHT_MSG:
       TEXT 'Page height should be updated from user input'
MGN2_PAGE_HEIGHT_MSG_END

MGN2_LARGER_MARGIN_LIST_MSG:
       TEXT 'Margin list should now be larger'
MGN2_LARGER_MARGIN_LIST_MSG_END
       EVEN

MGN2_EXPECTED_MARGIN_ENTRIES:
       DATA 10,>0006,>0C0C,>0808
       DATA 20,>00FA,>0A0C,>0606
       DATA 30,>0006,>0C0D,>0607
MGN2_EXPECTED_MARGIN_ENTRIES_END

*
* Insert a margin-entry at the beginning of a non-empty list
*
MGN3
* -------
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set up initial margin list
       LI   R0,MGN2_EXISTING_MARGIN_ENTRIES
       LI   R1,MGN2_EXISTING_MARGIN_ENTRIES_END
       BL   @SETUP_INITIAL_MARGIN_LIST
*
       LI   R0,4
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,MGN3_LARGER_MARGIN_LIST_MSG
       LI   R3,MGN3_LARGER_MARGIN_LIST_MSG_END-MGN3_LARGER_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,MGN3_EXPECTED_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,MGN3_EXPECTED_MARGIN_ENTRIES_END-MGN3_EXPECTED_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

MGN3_LARGER_MARGIN_LIST_MSG:
       TEXT 'Margin list should now be larger'
MGN3_LARGER_MARGIN_LIST_MSG_END
       EVEN

MGN3_EXPECTED_MARGIN_ENTRIES:
       DATA 4,>0006,>0C0D,>0607
       DATA 10,>0006,>0C0C,>0808
       DATA 20,>00FA,>0A0C,>0606
MGN3_EXPECTED_MARGIN_ENTRIES_END

*
* Insert a margin-entry in between two entries, where this will not create a duplicate
*
MGN4
* -------
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set up initial margin list
       LI   R0,MGN2_EXISTING_MARGIN_ENTRIES
       LI   R1,MGN2_EXISTING_MARGIN_ENTRIES_END
       BL   @SETUP_INITIAL_MARGIN_LIST
*
       LI   R0,15
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,MGN4_LARGER_MARGIN_LIST_MSG
       LI   R3,MGN4_LARGER_MARGIN_LIST_MSG_END-MGN4_LARGER_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,MGN4_EXPECTED_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,MGN4_EXPECTED_MARGIN_ENTRIES_END-MGN4_EXPECTED_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

MGN4_LARGER_MARGIN_LIST_MSG:
       TEXT 'Margin list should now be larger'
MGN4_LARGER_MARGIN_LIST_MSG_END
       EVEN

MGN4_EXPECTED_MARGIN_ENTRIES:
       DATA 10,>0006,>0C0C,>0808
       DATA 15,>0006,>0C0D,>0607
       DATA 20,>00FA,>0A0C,>0606
MGN4_EXPECTED_MARGIN_ENTRIES_END

*
* Attempt to insert a margin-entry that would be identical to the one directly after it.
* The result is to edit the later entry, leaving the list size unchanged.
*
MGN5
* -------
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Setup user input in form
       LI   R0,MGN5_USER_INPUT
       LI   R1,FLDVAL
       LI   R2,MGN5_USER_INPUT_END-MGN5_USER_INPUT
       BLWP @BUFCPY
* Set up initial margin list
       LI   R0,MGN5_EXISTING_MARGIN_ENTRIES
       LI   R1,MGN5_EXISTING_MARGIN_ENTRIES_END
       BL   @SETUP_INITIAL_MARGIN_LIST
*
       LI   R0,15
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,MGN5_UNCHANGED_MARGIN_LIST_MSG
       LI   R3,MGN5_UNCHANGED_MARGIN_LIST_MSG_END-MGN5_UNCHANGED_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,MGN5_EXPECTED_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,MGN5_EXPECTED_MARGIN_ENTRIES_END-MGN5_EXPECTED_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

*
* User-typed field values
*
* (note that these values are identical to what is specified for the paragraph at index 20)
MGN5_USER_INPUT:
       TEXT '96 '   * Page width
       TEXT '66 '   * Page height
       TEXT '12 '   * Left margin
       TEXT '12 '   * Right margin
       TEXT '6  '   * indent
       TEXT 'F'     * First line/hanging
       TEXT '8  '   * Top margin
       TEXT '8  '   * Bottom margin
MGN5_USER_INPUT_END
       EVEN

MGN5_EXISTING_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>0006,>0C0C,>0808
       DATA 30,>00F1,>0F0F,>0709
MGN5_EXISTING_MARGIN_ENTRIES_END

MGN5_UNCHANGED_MARGIN_LIST_MSG:
       TEXT 'Margin list size should remain unchanged'
MGN5_UNCHANGED_MARGIN_LIST_MSG_END
       EVEN

MGN5_EXPECTED_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 15,>0006,>0C0C,>0808
       DATA 30,>00F1,>0F0F,>0709
MGN5_EXPECTED_MARGIN_ENTRIES_END

*
* Attempt to insert a margin-entry that would be identical to the one directly before it.
* The result is to edit the earlier entry, leaving the list size unchanged.
*
MGN6
* -------
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Setup user input in form
       LI   R0,MGN6_USER_INPUT
       LI   R1,FLDVAL
       LI   R2,MGN6_USER_INPUT_END-MGN6_USER_INPUT
       BLWP @BUFCPY
* Set up initial margin list
       LI   R0,MGN6_EXISTING_MARGIN_ENTRIES
       LI   R1,MGN6_EXISTING_MARGIN_ENTRIES_END
       BL   @SETUP_INITIAL_MARGIN_LIST
*
       LI   R0,25
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,MGN6_UNCHANGED_MARGIN_LIST_MSG
       LI   R3,MGN6_UNCHANGED_MARGIN_LIST_MSG_END-MGN6_UNCHANGED_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,MGN6_EXPECTED_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,MGN6_EXPECTED_MARGIN_ENTRIES_END-MGN6_EXPECTED_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

*
* User-typed field values
*
* (note that these values are identical to what is specified for the paragraph at index 20)
MGN6_USER_INPUT:
       TEXT '96 '   * Page width
       TEXT '66 '   * Page height
       TEXT '11 '   * Left margin
       TEXT '13 '   * Right margin
       TEXT '6  '   * indent
       TEXT 'H'     * First line/hanging
       TEXT '8  '   * Top margin
       TEXT '8  '   * Bottom margin
MGN6_USER_INPUT_END
       EVEN

MGN6_EXISTING_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>00FA,>0B0D,>0808
       DATA 30,>00F1,>0F0F,>0709
MGN6_EXISTING_MARGIN_ENTRIES_END

MGN6_UNCHANGED_MARGIN_LIST_MSG:
       TEXT 'Margin list should remain unchanged'
MGN6_UNCHANGED_MARGIN_LIST_MSG_END
       EVEN

MGN6_EXPECTED_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>00FA,>0B0D,>0808
       DATA 30,>00F1,>0F0F,>0709
MGN6_EXPECTED_MARGIN_ENTRIES_END

*
* Edit an existing margin-entry (same paragraph index).
*
EDIT1
* -------
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Setup user input in form
       LI   R0,EDIT1_USER_INPUT
       LI   R1,FLDVAL
       LI   R2,EDIT1_USER_INPUT_END-EDIT1_USER_INPUT
       BLWP @BUFCPY
* Set up initial margin list
       LI   R0,EDIT1_EXISTING_MARGIN_ENTRIES
       LI   R1,EDIT1_EXISTING_MARGIN_ENTRIES_END
       BL   @SETUP_INITIAL_MARGIN_LIST
* Set initial page width and height
       LI   R0,96*>100
       MOVB R0,@PGWDTH
       LI   R0,66*>100
       MOVB R0,@PGHGHT
*
       LI   R0,20
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,EDIT1_UNCHANGED_MARGIN_LIST_MSG
       LI   R3,EDIT1_UNCHANGED_MARGIN_LIST_MSG_END-EDIT1_UNCHANGED_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,EDIT1_EXPECTED_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,EDIT1_EXPECTED_MARGIN_ENTRIES_END-EDIT1_EXPECTED_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
*
       CLR  R1
       MOVB @PGWDTH,R1
       SRL  R1,8
       LI   R0,70
       LI   R2,EDIT1_PAGE_WIDTH_MSG
       LI   R3,EDIT1_PAGE_WIDTH_MSG_END-EDIT1_PAGE_WIDTH_MSG
       BLWP @AEQ
*
       CLR  R1
       MOVB @PGHGHT,R1
       SRL  R1,8
       LI   R0,55
       LI   R2,EDIT1_PAGE_HEIGHT_MSG
       LI   R3,EDIT1_PAGE_HEIGHT_MSG_END-EDIT1_PAGE_HEIGHT_MSG
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* User-typed field values
*
* (note that these values differ from every entry already in the margin list)
EDIT1_USER_INPUT:
       TEXT '70 '   * Page width
       TEXT '55 '   * Page height
       TEXT '15 '   * Left margin
       TEXT '17 '   * Right margin
       TEXT '4  '   * indent
       TEXT 'H'     * First line/hanging
       TEXT '9  '   * Top margin
       TEXT '11 '   * Bottom margin
EDIT1_USER_INPUT_END
       EVEN

EDIT1_EXISTING_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>0006,>0C0C,>0808
       DATA 30,>00F1,>0F0F,>0709
EDIT1_EXISTING_MARGIN_ENTRIES_END

EDIT1_PAGE_WIDTH_MSG:
       TEXT 'Page width should be updated from user input'
EDIT1_PAGE_WIDTH_MSG_END

EDIT1_PAGE_HEIGHT_MSG:
       TEXT 'Page height should be updated from user input'
EDIT1_PAGE_HEIGHT_MSG_END

EDIT1_UNCHANGED_MARGIN_LIST_MSG:
       TEXT 'Margin list size should remain unchanged'
EDIT1_UNCHANGED_MARGIN_LIST_MSG_END
       EVEN

EDIT1_EXPECTED_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>00FC,>0F11,>090B
       DATA 30,>00F1,>0F0F,>0709
EDIT1_EXPECTED_MARGIN_ENTRIES_END

*
* Edit an existing margin-entry such that it will be identical to the following entry.
* The result will be to delete the following entry, shrinking the list size by one.
*
EDIT2
* -------
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Setup user input in form
       LI   R0,EDIT2_USER_INPUT
       LI   R1,FLDVAL
       LI   R2,EDIT2_USER_INPUT_END-EDIT2_USER_INPUT
       BLWP @BUFCPY
* Set up initial margin list
       LI   R0,EDIT2_EXISTING_MARGIN_ENTRIES
       LI   R1,EDIT2_EXISTING_MARGIN_ENTRIES_END
       BL   @SETUP_INITIAL_MARGIN_LIST
*
       LI   R0,20
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,2
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,EDIT2_SMALLER_MARGIN_LIST_MSG
       LI   R3,EDIT2_SMALLER_MARGIN_LIST_MSG_END-EDIT2_SMALLER_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,EDIT2_EXPECTED_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,EDIT2_EXPECTED_MARGIN_ENTRIES_END-EDIT2_EXPECTED_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

*
* User-typed field values
*
* (note that these values match the entry at paragraph index 30)
EDIT2_USER_INPUT:
       TEXT '96 '   * Page width
       TEXT '66 '   * Page height
       TEXT '15 '   * Left margin
       TEXT '15 '   * Right margin
       TEXT '15 '   * indent
       TEXT 'H'     * First line/hanging
       TEXT '7  '   * Top margin
       TEXT '9  '   * Bottom margin
EDIT2_USER_INPUT_END
       EVEN

EDIT2_EXISTING_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>0006,>0C0C,>0808
       DATA 30,>00F1,>0F0F,>0709
EDIT2_EXISTING_MARGIN_ENTRIES_END

EDIT2_SMALLER_MARGIN_LIST_MSG:
       TEXT 'Margin list should shrink by one entry'
EDIT2_SMALLER_MARGIN_LIST_MSG_END
       EVEN

EDIT2_EXPECTED_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>00F1,>0F0F,>0709
EDIT2_EXPECTED_MARGIN_ENTRIES_END

*
* Edit an existing margin-entry such that it will be identical to the preceding entry.
* The result will be to delete the later entry, shrinking the list size by one.
*
EDIT3
* -------
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Setup user input in form
       LI   R0,EDIT3_USER_INPUT
       LI   R1,FLDVAL
       LI   R2,EDIT3_USER_INPUT_END-EDIT3_USER_INPUT
       BLWP @BUFCPY
* Set up initial margin list
       LI   R0,EDIT3_EXISTING_MARGIN_ENTRIES
       LI   R1,EDIT3_EXISTING_MARGIN_ENTRIES_END
       BL   @SETUP_INITIAL_MARGIN_LIST
*
       LI   R0,20
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,2
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,EDIT3_SMALLER_MARGIN_LIST_MSG
       LI   R3,EDIT3_SMALLER_MARGIN_LIST_MSG_END-EDIT3_SMALLER_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,EDIT3_EXPECTED_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,EDIT3_EXPECTED_MARGIN_ENTRIES_END-EDIT3_EXPECTED_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

*
* User-typed field values
*
* (note that these values match the entry at paragraph index 10)
EDIT3_USER_INPUT:
       TEXT '96 '   * Page width
       TEXT '66 '   * Page height
       TEXT '10 '   * Left margin
       TEXT '10 '   * Right margin
       TEXT '5  '   * indent
       TEXT 'F'     * First line/hanging
       TEXT '6  '   * Top margin
       TEXT '6  '   * Bottom margin
EDIT3_USER_INPUT_END
       EVEN

EDIT3_EXISTING_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>0006,>0C0C,>0808
       DATA 30,>00F1,>0F0F,>0709
EDIT3_EXISTING_MARGIN_ENTRIES_END

EDIT3_SMALLER_MARGIN_LIST_MSG:
       TEXT 'Margin list should shrink by one entry'
EDIT3_SMALLER_MARGIN_LIST_MSG_END
       EVEN

EDIT3_EXPECTED_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 30,>00F1,>0F0F,>0709
EDIT3_EXPECTED_MARGIN_ENTRIES_END

*
* Undo a margin entry insertion that grew the list size.
*
UNDO1
* -------
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set up initial margin list
       LI   R0,UNDO1_EXISTING_MARGIN_ENTRIES
       LI   R1,UNDO1_EXISTING_MARGIN_ENTRIES_END
       BL   @SETUP_INITIAL_MARGIN_LIST
* Set the cursor's paragraph in the document
       LI   R0,15
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,UNDO1_LARGER_MARGIN_LIST_MSG
       LI   R3,UNDO1_LARGER_MARGIN_LIST_MSG_END-UNDO1_LARGER_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,UNDO1_EXPECTED_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,UNDO1_EXPECTED_MARGIN_ENTRIES_END-UNDO1_EXPECTED_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
* Act
* Let R7 = address of the undo action.
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
       BLWP @ARYADR
       MOV  *R1,R7
       BL   @UNDO_MARGIN
* Assert
       LI   R0,2
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,UNDO1_ORIGINAL_MARGIN_LIST_MSG
       LI   R3,UNDO1_ORIGINAL_MARGIN_LIST_MSG_END-UNDO1_ORIGINAL_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,UNDO1_EXISTING_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,UNDO1_EXISTING_MARGIN_ENTRIES_END-UNDO1_EXISTING_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

UNDO1_EXISTING_MARGIN_ENTRIES:
       DATA 10,>0006,>0C0C,>0808
       DATA 20,>00FA,>0A0C,>0606
UNDO1_EXISTING_MARGIN_ENTRIES_END       

UNDO1_LARGER_MARGIN_LIST_MSG:
       TEXT 'Margin list should now be larger'
UNDO1_LARGER_MARGIN_LIST_MSG_END
       EVEN

UNDO1_EXPECTED_MARGIN_ENTRIES:
       DATA 10,>0006,>0C0C,>0808
       DATA 15,>0006,>0C0D,>0607
       DATA 20,>00FA,>0A0C,>0606
UNDO1_EXPECTED_MARGIN_ENTRIES_END

UNDO1_ORIGINAL_MARGIN_LIST_MSG:
       TEXT 'Margin list should return to its original size after undo'
UNDO1_ORIGINAL_MARGIN_LIST_MSG_END
       EVEN

*
* Undo an attempt to insert a margin entry that actually merged two entries.
*
UNDO2
* -------
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Setup user input in form
       LI   R0,UNDO2_USER_INPUT
       LI   R1,FLDVAL
       LI   R2,UNDO2_USER_INPUT_END-UNDO2_USER_INPUT
       BLWP @BUFCPY
* Set up initial margin list
       LI   R0,UNDO2_EXISTING_MARGIN_ENTRIES
       LI   R1,UNDO2_EXISTING_MARGIN_ENTRIES_END
       BL   @SETUP_INITIAL_MARGIN_LIST
*
       LI   R0,15
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,UNDO2_UNCHANGED_MARGIN_LIST_MSG
       LI   R3,UNDO2_UNCHANGED_MARGIN_LIST_MSG_END-UNDO2_UNCHANGED_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,UNDO2_EXPECTED_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,UNDO2_EXPECTED_MARGIN_ENTRIES_END-UNDO2_EXPECTED_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
* Act
* Let R7 = address of the undo action.
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
       BLWP @ARYADR
       MOV  *R1,R7
       BL   @UNDO_MARGIN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,UNDO2_ORIGINAL_MARGIN_LIST_MSG
       LI   R3,UNDO2_ORIGINAL_MARGIN_LIST_MSG_END-UNDO2_ORIGINAL_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,UNDO2_EXISTING_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,UNDO2_EXISTING_MARGIN_ENTRIES_END-UNDO2_EXISTING_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

*
* User-typed field values
*
* (note that these values are identical to what is specified for the paragraph at index 20)
UNDO2_USER_INPUT:
       TEXT '96 '   * Page width
       TEXT '66 '   * Page height
       TEXT '12 '   * Left margin
       TEXT '12 '   * Right margin
       TEXT '6  '   * indent
       TEXT 'F'     * First line/hanging
       TEXT '8  '   * Top margin
       TEXT '8  '   * Bottom margin
UNDO2_USER_INPUT_END
       EVEN

UNDO2_EXISTING_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>0006,>0C0C,>0808
       DATA 30,>00F1,>0F0F,>0709
UNDO2_EXISTING_MARGIN_ENTRIES_END

UNDO2_UNCHANGED_MARGIN_LIST_MSG:
       TEXT 'Margin list size should remain unchanged'
UNDO2_UNCHANGED_MARGIN_LIST_MSG_END
       EVEN

UNDO2_EXPECTED_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 15,>0006,>0C0C,>0808
       DATA 30,>00F1,>0F0F,>0709
UNDO2_EXPECTED_MARGIN_ENTRIES_END

UNDO2_ORIGINAL_MARGIN_LIST_MSG:
       TEXT 'Margin list contents should return to original after undo'
UNDO2_ORIGINAL_MARGIN_LIST_MSG_END
       EVEN

*
* Undo an attempt to insert a margin entry that would merely have duplicated an earlier entry.
*
UNDO3
* -------
* The new entry would be identical
* to the margin entry directly
* before it, so no new entry is
* actually created.
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Setup user input in form
       LI   R0,UNDO3_USER_INPUT
       LI   R1,FLDVAL
       LI   R2,UNDO3_USER_INPUT_END-UNDO3_USER_INPUT
       BLWP @BUFCPY
* Set up initial margin list
       LI   R0,UNDO3_EXISTING_MARGIN_ENTRIES
       LI   R1,UNDO3_EXISTING_MARGIN_ENTRIES_END
       BL   @SETUP_INITIAL_MARGIN_LIST
*
       LI   R0,25
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,UNDO3_UNCHANGED_MARGIN_LIST_MSG
       LI   R3,UNDO3_UNCHANGED_MARGIN_LIST_MSG_END-UNDO3_UNCHANGED_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,UNDO3_EXPECTED_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,UNDO3_EXPECTED_MARGIN_ENTRIES_END-UNDO3_EXPECTED_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
* Act
* Let R7 = address of the undo action.
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
       BLWP @ARYADR
       MOV  *R1,R7
       BL   @UNDO_MARGIN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,UNDO3_STILL_UNCHANGED_MARGIN_LIST_MSG
       LI   R3,UNDO3_STILL_UNCHANGED_MARGIN_LIST_MSG_END-UNDO3_STILL_UNCHANGED_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,UNDO3_EXISTING_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,UNDO3_EXISTING_MARGIN_ENTRIES_END-UNDO3_EXISTING_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

*
* User-typed field values
*
* (note that these values are identical to what is specified for the paragraph at index 20)
UNDO3_USER_INPUT:
       TEXT '96 '   * Page width
       TEXT '66 '   * Page height
       TEXT '11 '   * Left margin
       TEXT '13 '   * Right margin
       TEXT '6  '   * indent
       TEXT 'H'     * First line/hanging
       TEXT '8  '   * Top margin
       TEXT '8  '   * Bottom margin
UNDO3_USER_INPUT_END
       EVEN

UNDO3_EXISTING_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>00FA,>0B0D,>0808
       DATA 30,>00F1,>0F0F,>0709
UNDO3_EXISTING_MARGIN_ENTRIES_END

UNDO3_UNCHANGED_MARGIN_LIST_MSG:
       TEXT 'Margin list size should remain unchanged'
UNDO3_UNCHANGED_MARGIN_LIST_MSG_END
       EVEN

UNDO3_EXPECTED_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>00FA,>0B0D,>0808
       DATA 30,>00F1,>0F0F,>0709
UNDO3_EXPECTED_MARGIN_ENTRIES_END

UNDO3_STILL_UNCHANGED_MARGIN_LIST_MSG:
       TEXT 'Margin list should still be unchanged after undo'
UNDO3_STILL_UNCHANGED_MARGIN_LIST_MSG_END
       EVEN

*
* Undo a margin entry edit.
*
UNDO4
* The original paragraph is the
* same as an existing entry, so
* that entry is edited in place.
* -------
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Setup user input in form
       LI   R0,UNDO4_USER_INPUT
       LI   R1,FLDVAL
       LI   R2,UNDO4_USER_INPUT_END-UNDO4_USER_INPUT
       BLWP @BUFCPY
* Set up initial margin list
       LI   R0,UNDO4_EXISTING_MARGIN_ENTRIES
       LI   R1,UNDO4_EXISTING_MARGIN_ENTRIES_END
       BL   @SETUP_INITIAL_MARGIN_LIST
*
       LI   R0,20
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,UNDO4_UNCHANGED_MARGIN_LIST_MSG
       LI   R3,UNDO4_UNCHANGED_MARGIN_LIST_MSG_END-UNDO4_UNCHANGED_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,UNDO4_EXPECTED_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,UNDO4_EXPECTED_MARGIN_ENTRIES_END-UNDO4_EXPECTED_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
* Act
* Let R7 = address of the undo action.
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
       BLWP @ARYADR
       MOV  *R1,R7
       BL   @UNDO_MARGIN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,UNDO4_ORIGINAL_MARGIN_LIST_MSG
       LI   R3,UNDO4_ORIGINAL_MARGIN_LIST_MSG_END-UNDO4_ORIGINAL_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,UNDO4_EXISTING_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,UNDO4_EXISTING_MARGIN_ENTRIES_END-UNDO4_EXISTING_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

*
* User-typed field values
*
* (note that these values differ from every entry already in the margin list)
UNDO4_USER_INPUT:
       TEXT '70 '   * Page width
       TEXT '55 '   * Page height
       TEXT '15 '   * Left margin
       TEXT '17 '   * Right margin
       TEXT '4  '   * indent
       TEXT 'H'     * First line/hanging
       TEXT '9  '   * Top margin
       TEXT '11 '   * Bottom margin
UNDO4_USER_INPUT_END
       EVEN

UNDO4_EXISTING_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>0006,>0C0C,>0808
       DATA 30,>00F1,>0F0F,>0709
UNDO4_EXISTING_MARGIN_ENTRIES_END

UNDO4_UNCHANGED_MARGIN_LIST_MSG:
       TEXT 'Margin list size should remain unchanged after edit'
UNDO4_UNCHANGED_MARGIN_LIST_MSG_END
       EVEN

UNDO4_EXPECTED_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>00FC,>0F11,>090B
       DATA 30,>00F1,>0F0F,>0709
UNDO4_EXPECTED_MARGIN_ENTRIES_END

UNDO4_ORIGINAL_MARGIN_LIST_MSG:
       TEXT 'Margin list size should remain unchanged after undo'
UNDO4_ORIGINAL_MARGIN_LIST_MSG_END
       EVEN

*
* Undo a margin entry edit that resulted in
* merging with a later margin entry, to avoid duplicates.
*
UNDO5
* -------
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Setup user input in form
       LI   R0,UNDO5_USER_INPUT
       LI   R1,FLDVAL
       LI   R2,UNDO5_USER_INPUT_END-UNDO5_USER_INPUT
       BLWP @BUFCPY
* Set up initial margin list
       LI   R0,UNDO5_EXISTING_MARGIN_ENTRIES
       LI   R1,UNDO5_EXISTING_MARGIN_ENTRIES_END
       BL   @SETUP_INITIAL_MARGIN_LIST
*
       LI   R0,20
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,2
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,UNDO5_SMALLER_MARGIN_LIST_MSG
       LI   R3,UNDO5_SMALLER_MARGIN_LIST_MSG_END-UNDO5_SMALLER_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,UNDO5_EXPECTED_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,UNDO5_EXPECTED_MARGIN_ENTRIES_END-UNDO5_EXPECTED_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
* Act
* Let R7 = address of the undo action.
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
       BLWP @ARYADR
       MOV  *R1,R7
       BL   @UNDO_MARGIN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,UNDO5_ORIGINAL_MARGIN_LIST_MSG
       LI   R3,UNDO5_ORIGINAL_MARGIN_LIST_MSG_END-UNDO5_ORIGINAL_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,UNDO5_EXISTING_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,UNDO5_EXISTING_MARGIN_ENTRIES_END-UNDO5_EXISTING_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

*
* User-typed field values
*
* (note that these values match the entry at paragraph index 30)
UNDO5_USER_INPUT:
       TEXT '96 '   * Page width
       TEXT '66 '   * Page height
       TEXT '15 '   * Left margin
       TEXT '15 '   * Right margin
       TEXT '15 '   * indent
       TEXT 'H'     * First line/hanging
       TEXT '7  '   * Top margin
       TEXT '9  '   * Bottom margin
UNDO5_USER_INPUT_END
       EVEN

UNDO5_EXISTING_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>0006,>0C0C,>0808
       DATA 30,>00F1,>0F0F,>0709
UNDO5_EXISTING_MARGIN_ENTRIES_END

UNDO5_SMALLER_MARGIN_LIST_MSG:
       TEXT 'Margin list should shrink by one entry'
UNDO5_SMALLER_MARGIN_LIST_MSG_END
       EVEN

UNDO5_EXPECTED_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>00F1,>0F0F,>0709
UNDO5_EXPECTED_MARGIN_ENTRIES_END

UNDO5_ORIGINAL_MARGIN_LIST_MSG:
       TEXT 'Margin list should return to its original size after undo'
UNDO5_ORIGINAL_MARGIN_LIST_MSG_END
       EVEN

*
* Undo a margin entry edit that resulted in
* merging with an earlier margin entry, to avoid duplicates.
*
UNDO6
* -------
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Setup user input in form
       LI   R0,UNDO6_USER_INPUT
       LI   R1,FLDVAL
       LI   R2,UNDO6_USER_INPUT_END-UNDO6_USER_INPUT
       BLWP @BUFCPY
* Set up initial margin list
       LI   R0,UNDO6_EXISTING_MARGIN_ENTRIES
       LI   R1,UNDO6_EXISTING_MARGIN_ENTRIES_END
       BL   @SETUP_INITIAL_MARGIN_LIST
*
       LI   R0,20
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,2
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,UNDO6_SMALLER_MARGIN_LIST_MSG
       LI   R3,UNDO6_SMALLER_MARGIN_LIST_MSG_END-UNDO6_SMALLER_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,UNDO6_EXPECTED_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,UNDO6_EXPECTED_MARGIN_ENTRIES_END-UNDO6_EXPECTED_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
* Act
* Let R7 = address of the undo action.
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
       BLWP @ARYADR
       MOV  *R1,R7
       BL   @UNDO_MARGIN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,UNDO6_ORIGINAL_MARGIN_LIST_MSG
       LI   R3,UNDO6_ORIGINAL_MARGIN_LIST_MSG_END-UNDO6_ORIGINAL_MARGIN_LIST_MSG
       BLWP @AEQ
*
       LI   R0,UNDO6_EXISTING_MARGIN_ENTRIES
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,UNDO6_EXISTING_MARGIN_ENTRIES_END-UNDO6_EXISTING_MARGIN_ENTRIES
       LI   R3,LIST_CONTENTS_MSG
       LI   R4,LIST_CONTENTS_MSG_END-LIST_CONTENTS_MSG
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

*
* User-typed field values
*
* (note that these values match the entry at paragraph index 10)
UNDO6_USER_INPUT:
       TEXT '96 '   * Page width
       TEXT '66 '   * Page height
       TEXT '10 '   * Left margin
       TEXT '10 '   * Right margin
       TEXT '5  '   * indent
       TEXT 'F'     * First line/hanging
       TEXT '6  '   * Top margin
       TEXT '6  '   * Bottom margin
UNDO6_USER_INPUT_END
       EVEN

UNDO6_EXISTING_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>0006,>0C0C,>0808
       DATA 30,>00F1,>0F0F,>0709
UNDO6_EXISTING_MARGIN_ENTRIES_END

UNDO6_SMALLER_MARGIN_LIST_MSG:
       TEXT 'Margin list should shrink by one entry'
UNDO6_SMALLER_MARGIN_LIST_MSG_END
       EVEN

UNDO6_EXPECTED_MARGIN_ENTRIES:
       DATA 10,>0005,>0A0A,>0606
       DATA 30,>00F1,>0F0F,>0709
UNDO6_EXPECTED_MARGIN_ENTRIES_END

UNDO6_ORIGINAL_MARGIN_LIST_MSG:
       TEXT 'Margin list should return to its original size after undo'
UNDO6_ORIGINAL_MARGIN_LIST_MSG_END
       EVEN

*****************************

SPACE  BSS  >1000
SPCEND

       END