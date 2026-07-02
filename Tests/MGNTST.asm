* TODO: The test that I've written will not run yet
* Part of the problem is the AORG statement in EDTMGN.
* But even if I remove that, the test is ending up in an infinite loop.


* Insert a margin in an empty margin list
* Insert a margin-entry at the end of a non-empty list
* Insert a margin-entry at the beginning of a non-empty list
* Insert a margin-entry in between two entries, where this will not create a duplicate
* Attempt to insert a margin-entry that would be identical to the one directly after it. The result is to edit the later entry, leaving the list size unchanged.
* Attempt to insert a margin-entry that would be identical to the one directly before it. The result is to edit the earlier entry, leaving the list size unchanged.
* Edit an existing margin-entry (same paragraph index).
* Edit an existing margin-entry such that it will be identical to the following entry. The result will be to delete the following entry, shrinking the list size by one.
* Edit an existing margin-entry such that it will be identical to the preceding entry. The result will be to delete the later entry, shrinking the list size by one.
* Undo a margin entry insertion that grew the list size.  (create an entry)
* Undo a margin entry insertion that really just edit a later entry to point to the current paragraph.  (edit previous entry)
* Undo a margin entry edit.  (edit current entry)
* Undo a margin entry edit that resulted in deleting a later margin entry.   (edit current entry, delete next entry)
* Undo a margin entry edit that resulted in mergin (deleting) that entry into an earlier entry.    (delete the current entry)

       DEF  TSTLST,RSLTFL
       DEF  WRAP,WRAPDW

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
* Insert a margin-entry at the end of a non-empty list
       DATA MGN2
       TEXT 'MGN2  '
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
WRAP
WRAPDW
       RT

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
       MOV  *R10+,R11
       RT

mgn2_existing_margin_entries:
       DATA 10,>0006,>0C0C,>0808
       DATA 20,>00FA,>0A0C,>0606
mgn2_existing_margin_entries_end

mgn2_larger_margin_list_msg:
       TEXT 'Margin list should now be larger'
mgn2_larger_margin_list_msg_end

mgn2_expected_margin_entries:
       DATA 10,>0006,>0C0C,>0808
       DATA 20,>00FA,>0A0C,>0606
       DATA 30,>0006,>0C0D,>0607
mgn2_expected_margin_entries_end

SPACE  BSS  >1000
SPCEND

       END