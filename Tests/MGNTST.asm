* Tests to add:
*
* Undo a margin entry insertion that grew the list size.  (create an entry)
* Undo a margin entry insertion that really just edit a later entry to point to the current paragraph.  (edit previous entry)
* Undo a margin entry edit.  (edit current entry)
* Undo a margin entry edit that resulted in deleting a later margin entry.   (edit current entry, delete next entry)
* Undo a margin entry edit that resulted in mergin (deleting) that entry into an earlier entry.    (delete the current entry)

       DEF  TSTLST,RSLTFL
       DEF  WRAPDW

* Assert Routine
       REF  AEQ,AZC,AOC,ABLCK
* From EDTMGN.asm
       REF  EDTMGN
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
clear_space
       CLR  *R0+
       C    R0,R1
       JL   clear_space
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
       LI   R0,default_field_values
       LI   R1,FLDVAL
       LI   R2,default_field_values_end
       LI   R3,default_field_values
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
test_para_list:
       DATA 1000
       DATA 2

*
* User-typed field values
*
* (see FPHGHT to FBOT in EQUVAL)
default_field_values:
       TEXT '96 '   * Page width
       TEXT '66 '   * Page height
       TEXT '12 '   * Left margin
       TEXT '13 '   * Right margin
       TEXT '6  '   * indent
       TEXT 'F'     * First line/hanging
       TEXT '6  '   * Top margin
       TEXT '7  '   * Bottom margin
default_field_values_end

list_contents_msg:
       TEXT 'Expected a particular set of margin list contents.'
list_contents_msg_end

*
* Populate the margin list with the
* margin entries provided by the caller.
*
* Input:
*   R0 - address of source data
*   R1 - address directly following
*        the source data
*
setup_initial_margin_list:
       MOV  R0,R4
       MOV  R1,R5
* Let R1 = number of margin entires
       S    R0,R1
       SRL  R1,3
       MOV  R1,R2
* Add margin list entries
       MOV  @MGNLST,R0
setup_margin_list_loop:
       BLWP @ARYADD
       MOV  R0,@MGNLST
       DEC  R2
       JNE  setup_margin_list_loop
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
* User presses enter to split a
* paragraph.
* The original paragraph is earlier
* than any entry in the margin list.
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
       LI   R2,mgn1_larger_margin_list_msg
       LI   R3,mgn1_larger_margin_list_msg_end-mgn1_larger_margin_list_msg
       BLWP @AEQ
*
       LI   R0,mgn1_expected_margin_entries
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,mgn1_expected_margin_entries_end-mgn1_expected_margin_entries
       LI   R3,list_contents_msg
       LI   R4,list_contents_msg_end-list_contents_msg
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

mgn1_existing_margin_entries
mgn1_existing_margin_entries_end

mgn1_larger_margin_list_msg:
       TEXT 'Margin list should now be larger'
mgn1_larger_margin_list_msg_end

mgn1_expected_margin_entries:
       DATA 5,>0006,>0C0D,>0607
mgn1_expected_margin_entries_end

*
* Insert a margin-entry at the end of a non-empty list
*
MGN2
* -------
* User presses enter to split a
* paragraph.
* The original paragraph is earlier
* than any entry in the margin list.
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set up initial margin list
       LI   R0,mgn2_existing_margin_entries
       LI   R1,mgn2_existing_margin_entries_end
       BL   @setup_initial_margin_list
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
       LI   R2,mgn2_larger_margin_list_msg
       LI   R3,mgn2_larger_margin_list_msg_end-mgn2_larger_margin_list_msg
       BLWP @AEQ
*
       LI   R0,mgn2_expected_margin_entries
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,mgn2_expected_margin_entries_end-mgn2_expected_margin_entries
       LI   R3,list_contents_msg
       LI   R4,list_contents_msg_end-list_contents_msg
       BLWP @ABLCK
*
       CLR  R1
       MOVB @PGWDTH,R1
       SRL  R1,8
       LI   R0,96
       LI   R2,mgn2_page_width_msg
       LI   R3,mgn2_page_width_msg_end-mgn2_page_width_msg
       BLWP @AEQ
*
       CLR  R1
       MOVB @PGHGHT,R1
       SRL  R1,8
       LI   R0,66
       LI   R2,mgn2_page_height_msg
       LI   R3,mgn2_page_height_msg_end-mgn2_page_height_msg
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

mgn2_existing_margin_entries:
       DATA 10,>0006,>0C0C,>0808
       DATA 20,>00FA,>0A0C,>0606
mgn2_existing_margin_entries_end

mgn2_page_width_msg:
       TEXT 'Page width should be updated from user input'
mgn2_page_width_msg_end

mgn2_page_height_msg:
       TEXT 'Page height should be updated from user input'
mgn2_page_height_msg_end

mgn2_larger_margin_list_msg:
       TEXT 'Margin list should now be larger'
mgn2_larger_margin_list_msg_end

mgn2_expected_margin_entries:
       DATA 10,>0006,>0C0C,>0808
       DATA 20,>00FA,>0A0C,>0606
       DATA 30,>0006,>0C0D,>0607
mgn2_expected_margin_entries_end

*
* Insert a margin-entry at the beginning of a non-empty list
*
MGN3
* -------
* User presses enter to split a
* paragraph.
* The original paragraph is earlier
* than any entry in the margin list.
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set up initial margin list
       LI   R0,mgn2_existing_margin_entries
       LI   R1,mgn2_existing_margin_entries_end
       BL   @setup_initial_margin_list
*
       LI   R0,4
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,mgn3_larger_margin_list_msg
       LI   R3,mgn3_larger_margin_list_msg_end-mgn3_larger_margin_list_msg
       BLWP @AEQ
*
       LI   R0,mgn3_expected_margin_entries
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,mgn3_expected_margin_entries_end-mgn3_expected_margin_entries
       LI   R3,list_contents_msg
       LI   R4,list_contents_msg_end-list_contents_msg
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

mgn3_larger_margin_list_msg:
       TEXT 'Margin list should now be larger'
mgn3_larger_margin_list_msg_end

mgn3_expected_margin_entries:
       DATA 4,>0006,>0C0D,>0607
       DATA 10,>0006,>0C0C,>0808
       DATA 20,>00FA,>0A0C,>0606
mgn3_expected_margin_entries_end

*
* Insert a margin-entry in between two entries, where this will not create a duplicate
*
MGN4
* -------
* User presses enter to split a
* paragraph.
* The original paragraph is earlier
* than any entry in the margin list.
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set up initial margin list
       LI   R0,mgn2_existing_margin_entries
       LI   R1,mgn2_existing_margin_entries_end
       BL   @setup_initial_margin_list
*
       LI   R0,15
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,mgn4_larger_margin_list_msg
       LI   R3,mgn4_larger_margin_list_msg_end-mgn4_larger_margin_list_msg
       BLWP @AEQ
*
       LI   R0,mgn4_expected_margin_entries
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,mgn4_expected_margin_entries_end-mgn4_expected_margin_entries
       LI   R3,list_contents_msg
       LI   R4,list_contents_msg_end-list_contents_msg
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

mgn4_larger_margin_list_msg:
       TEXT 'Margin list should now be larger'
mgn4_larger_margin_list_msg_end

mgn4_expected_margin_entries:
       DATA 10,>0006,>0C0C,>0808
       DATA 15,>0006,>0C0D,>0607
       DATA 20,>00FA,>0A0C,>0606
mgn4_expected_margin_entries_end

*
* Attempt to insert a margin-entry that would be identical to the one directly after it.
* The result is to edit the later entry, leaving the list size unchanged.
*
MGN5
* -------
* User presses enter to split a
* paragraph.
* The original paragraph is earlier
* than any entry in the margin list.
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Setup user input in form
       LI   R0,mgn5_user_input
       LI   R1,FLDVAL
       LI   R2,mgn5_user_input_end-mgn5_user_input
       BLWP @BUFCPY
* Set up initial margin list
       LI   R0,mgn5_existing_margin_entries
       LI   R1,mgn5_existing_margin_entries_end
       BL   @setup_initial_margin_list
*
       LI   R0,15
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,mgn5_unchanged_margin_list_msg
       LI   R3,mgn5_unchanged_margin_list_msg_end-mgn5_unchanged_margin_list_msg
       BLWP @AEQ
*
       LI   R0,mgn5_expected_margin_entries
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,mgn5_expected_margin_entries_end-mgn5_expected_margin_entries
       LI   R3,list_contents_msg
       LI   R4,list_contents_msg_end-list_contents_msg
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

*
* User-typed field values
*
* (note that these values are identical to what is specified for the paragraph at index 20)
mgn5_user_input:
       TEXT '96 '   * Page width
       TEXT '66 '   * Page height
       TEXT '12 '   * Left margin
       TEXT '12 '   * Right margin
       TEXT '6  '   * indent
       TEXT 'F'     * First line/hanging
       TEXT '8  '   * Top margin
       TEXT '8  '   * Bottom margin
mgn5_user_input_end

mgn5_existing_margin_entries:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>0006,>0C0C,>0808
       DATA 30,>00F1,>0F0F,>0709
mgn5_existing_margin_entries_end

mgn5_unchanged_margin_list_msg:
       TEXT 'Margin list size should remain unchanged'
mgn5_unchanged_margin_list_msg_end

mgn5_expected_margin_entries:
       DATA 10,>0005,>0A0A,>0606
       DATA 15,>0006,>0C0C,>0808
       DATA 30,>00F1,>0F0F,>0709
mgn5_expected_margin_entries_end

*
* Attempt to insert a margin-entry that would be identical to the one directly before it.
* The result is to edit the earlier entry, leaving the list size unchanged.
*
MGN6
* -------
* User presses enter to split a
* paragraph.
* The original paragraph is earlier
* than any entry in the margin list.
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Setup user input in form
       LI   R0,mgn6_user_input
       LI   R1,FLDVAL
       LI   R2,mgn6_user_input_end-mgn6_user_input
       BLWP @BUFCPY
* Set up initial margin list
       LI   R0,mgn6_existing_margin_entries
       LI   R1,mgn6_existing_margin_entries_end
       BL   @setup_initial_margin_list
*
       LI   R0,25
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,3
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,mgn6_unchanged_margin_list_msg
       LI   R3,mgn6_unchanged_margin_list_msg_end-mgn6_unchanged_margin_list_msg
       BLWP @AEQ
*
       LI   R0,mgn6_expected_margin_entries
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,mgn6_expected_margin_entries_end-mgn6_expected_margin_entries
       LI   R3,list_contents_msg
       LI   R4,list_contents_msg_end-list_contents_msg
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

*
* User-typed field values
*
* (note that these values are identical to what is specified for the paragraph at index 20)
mgn6_user_input:
       TEXT '96 '   * Page width
       TEXT '66 '   * Page height
       TEXT '11 '   * Left margin
       TEXT '13 '   * Right margin
       TEXT '6  '   * indent
       TEXT 'H'     * First line/hanging
       TEXT '8  '   * Top margin
       TEXT '8  '   * Bottom margin
mgn6_user_input_end

mgn6_existing_margin_entries:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>00FA,>0B0D,>0808
       DATA 30,>00F1,>0F0F,>0709
mgn6_existing_margin_entries_end

mgn6_unchanged_margin_list_msg:
       TEXT 'Margin list should remain unchanged'
mgn6_unchanged_margin_list_msg_end

mgn6_expected_margin_entries:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>00FA,>0B0D,>0808
       DATA 30,>00F1,>0F0F,>0709
mgn6_expected_margin_entries_end

*
* Edit an existing margin-entry (same paragraph index).
*
EDIT1
* -------
* User presses enter to split a
* paragraph.
* The original paragraph is earlier
* than any entry in the margin list.
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Setup user input in form
       LI   R0,edit1_user_input
       LI   R1,FLDVAL
       LI   R2,edit1_user_input_end-edit1_user_input
       BLWP @BUFCPY
* Set up initial margin list
       LI   R0,edit1_existing_margin_entries
       LI   R1,edit1_existing_margin_entries_end
       BL   @setup_initial_margin_list
* Set initial page width and height
       LI   R0,50*>100
       MOVB R0,@PGWDTH
       LI   R0,40*>100
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
       LI   R2,edit1_unchanged_margin_list_msg
       LI   R3,edit1_unchanged_margin_list_msg_end-edit1_unchanged_margin_list_msg
       BLWP @AEQ
*
       LI   R0,edit1_expected_margin_entries
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,edit1_expected_margin_entries_end-edit1_expected_margin_entries
       LI   R3,list_contents_msg
       LI   R4,list_contents_msg_end-list_contents_msg
       BLWP @ABLCK
*
       CLR  R1
       MOVB @PGWDTH,R1
       SRL  R1,8
       LI   R0,96
       LI   R2,edit1_page_width_msg
       LI   R3,edit1_page_width_msg_end-edit1_page_width_msg
       BLWP @AEQ
*
       CLR  R1
       MOVB @PGHGHT,R1
       SRL  R1,8
       LI   R0,66
       LI   R2,edit1_page_height_msg
       LI   R3,edit1_page_height_msg_end-edit1_page_height_msg
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* User-typed field values
*
* (note that these values differ from every entry already in the margin list)
edit1_user_input:
       TEXT '96 '   * Page width
       TEXT '66 '   * Page height
       TEXT '15 '   * Left margin
       TEXT '17 '   * Right margin
       TEXT '4  '   * indent
       TEXT 'H'     * First line/hanging
       TEXT '9  '   * Top margin
       TEXT '11 '   * Bottom margin
edit1_user_input_end

edit1_existing_margin_entries:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>0006,>0C0C,>0808
       DATA 30,>00F1,>0F0F,>0709
edit1_existing_margin_entries_end

edit1_page_width_msg:
       TEXT 'Page width should be updated from user input'
edit1_page_width_msg_end

edit1_page_height_msg:
       TEXT 'Page height should be updated from user input'
edit1_page_height_msg_end

edit1_unchanged_margin_list_msg:
       TEXT 'Margin list size should remain unchanged'
edit1_unchanged_margin_list_msg_end

edit1_expected_margin_entries:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>00FC,>0F11,>090B
       DATA 30,>00F1,>0F0F,>0709
edit1_expected_margin_entries_end

*
* Edit an existing margin-entry such that it will be identical to the following entry.
* The result will be to delete the following entry, shrinking the list size by one.
*
EDIT2
* -------
* User presses enter to split a
* paragraph.
* The original paragraph is earlier
* than any entry in the margin list.
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Setup user input in form
       LI   R0,edit2_user_input
       LI   R1,FLDVAL
       LI   R2,edit2_user_input_end-edit2_user_input
       BLWP @BUFCPY
* Set up initial margin list
       LI   R0,edit2_existing_margin_entries
       LI   R1,edit2_existing_margin_entries_end
       BL   @setup_initial_margin_list
*
       LI   R0,20
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,2
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,edit2_smaller_margin_list_msg
       LI   R3,edit2_smaller_margin_list_msg_end-edit2_smaller_margin_list_msg
       BLWP @AEQ
*
       LI   R0,edit2_expected_margin_entries
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,edit2_expected_margin_entries_end-edit2_expected_margin_entries
       LI   R3,list_contents_msg
       LI   R4,list_contents_msg_end-list_contents_msg
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

*
* User-typed field values
*
* (note that these values match the entry at paragraph index 30)
edit2_user_input:
       TEXT '96 '   * Page width
       TEXT '66 '   * Page height
       TEXT '15 '   * Left margin
       TEXT '15 '   * Right margin
       TEXT '15 '   * indent
       TEXT 'H'     * First line/hanging
       TEXT '7  '   * Top margin
       TEXT '9  '   * Bottom margin
edit2_user_input_end

edit2_existing_margin_entries:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>0006,>0C0C,>0808
       DATA 30,>00F1,>0F0F,>0709
edit2_existing_margin_entries_end

edit2_smaller_margin_list_msg:
       TEXT 'Margin list should shrink by one entry'
edit2_smaller_margin_list_msg_end

edit2_expected_margin_entries:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>00F1,>0F0F,>0709
edit2_expected_margin_entries_end

*
* Edit an existing margin-entry such that it will be identical to the preceding entry.
* The result will be to delete the later entry, shrinking the list size by one.
*
EDIT3
* -------
* User presses enter to split a
* paragraph.
* The original paragraph is earlier
* than any entry in the margin list.
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Setup user input in form
       LI   R0,edit3_user_input
       LI   R1,FLDVAL
       LI   R2,edit3_user_input_end-edit3_user_input
       BLWP @BUFCPY
* Set up initial margin list
       LI   R0,edit3_existing_margin_entries
       LI   R1,edit3_existing_margin_entries_end
       BL   @setup_initial_margin_list
*
       LI   R0,20
       MOV  R0,@PARINX
* Act
       BL   @EDTMGN
* Assert
       LI   R0,2
       MOV  @MGNLST,R1
       MOV  *R1,R1
       LI   R2,edit3_smaller_margin_list_msg
       LI   R3,edit3_smaller_margin_list_msg_end-edit3_smaller_margin_list_msg
       BLWP @AEQ
*
       LI   R0,edit3_expected_margin_entries
       MOV  @MGNLST,R1
       C    *R1+,*R1+
       LI   R2,edit3_expected_margin_entries_end-edit3_expected_margin_entries
       LI   R3,list_contents_msg
       LI   R4,list_contents_msg_end-list_contents_msg
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

*
* User-typed field values
*
* (note that these values match the entry at paragraph index 10)
edit3_user_input:
       TEXT '96 '   * Page width
       TEXT '66 '   * Page height
       TEXT '10 '   * Left margin
       TEXT '10 '   * Right margin
       TEXT '5  '   * indent
       TEXT 'F'     * First line/hanging
       TEXT '6  '   * Top margin
       TEXT '6  '   * Bottom margin
edit3_user_input_end

edit3_existing_margin_entries:
       DATA 10,>0005,>0A0A,>0606
       DATA 20,>0006,>0C0C,>0808
       DATA 30,>00F1,>0F0F,>0709
edit3_existing_margin_entries_end

edit3_smaller_margin_list_msg:
       TEXT 'Margin list should shrink by one entry'
edit3_smaller_margin_list_msg_end

edit3_expected_margin_entries:
       DATA 10,>0005,>0A0A,>0606
       DATA 30,>00F1,>0F0F,>0709
edit3_expected_margin_entries_end

*****************************

SPACE  BSS  >1000
SPCEND

       END