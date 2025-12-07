       DEF  TSTLST,RSLTFL
* Mocks
       DEF  VDPADR,VDPWRT
       DEF  MNUHK
       DEF  MNUINT,PRINT

* Assert Routine
       REF  AEQ,AZC,AOC,ABLCK,ASTR

*
       REF  INPUT

* from VAR.asm
       REF  PARLST,FMTLST,MGNLST
       REF  UNDLST,UNDOIDX
       REF  PREV_ACTION
       REF  MAKETX,PRINTL,OPENF,CLOSEF
       REF  ARYALC,ARYADD,ARYINS,ARYDEL
       REF  ARYADR
       REF  BUFALC,BUFINT,BUFCPY
       REF  KEYSTR,KEYEND,KEYWRT,KEYRD       
       REF  DOCSTS

* variables just for INPUT
       REF  PARINX,CHRPAX
       REF  INSTMD

* constants
       REF  STSTYP,STSENT,STSDCR
       REF  STSPAR,STSWIN,STSARW

       COPY '../Src/EQUADDR.asm'
       COPY '../Src/EQUVAL.asm'

TSTLST DATA (TSTEND-TSTLST-2)/8
*
* Test implementation details.
* Assert undo list looks right.
       DATA LIST1
       TEXT 'LIST1 '
* Assert that an invalid key doesn't hurt anything.
       DATA LIST2
       TEXT 'LIST2 '
* Assert that the undo/redo list will not exceed 16
       DATA LIST3
       TEXT 'LIST3 '
* Assert that an undo object larger than 255 bytes will split in two
       DATA LIST4
       TEXT 'LIST4 '
* Assert that text is deleted when undo is not pressed.
       DATA DEL2
       TEXT 'DEL2  '
* Assert that text is restored when undo is pressed once.
       DATA DEL3
       TEXT 'DEL3  '
* Assert that text is restored when undo is pressed twice.
       DATA DEL4
       TEXT 'DEL4  '
* Assert that only some text is restored when undo, undo, and redo are pressed.
       DATA DEL5
       TEXT 'DEL5  '
* Assert that a redo action inbetween two undo actions, does not result in repeated redos.
       DATA DEL6
       TEXT 'DEL6  '
* Assert that deleting a carriage return can be undone.
       DATA DEL7
       TEXT 'DEL7  '
* Assert that deleting a carriage return can be redone.
       DATA DEL8
       TEXT 'DEL8  '
* Assert that deletion of two non-consequtive CRs can be undone.
       DATA DEL9
       TEXT 'DEL9  '
* Assert that replacing one redo replaces all later redos.
       DATA DEL10
       TEXT 'DEL10 '
* Assert that text is restored when undo is pressed once.
       DATA BACK1
       TEXT 'BACK1 '
* Assert that text is re-deleted when undo and redo are pressed.
       DATA BACK2
       TEXT 'BACK2 '
* Assert that text is backspace-delting a carriage return can be undone.
       DATA BACK3
       TEXT 'BACK3 '
* Assert that a carriage return is re-deleted when backspace-delete is undone and redone.
       DATA BACK4
       TEXT 'BACK4 '
* Assert that inserted text is removed when undo is pressed once.
       DATA INS1
       TEXT 'INS1  '
* Assert that inserted text is restored when undo and redo are pressed.
       DATA INS2
       TEXT 'INS2  '
* Assert that inserted carriage returns can be undone.
       DATA INS3
       TEXT 'INS3  '
* Assert that a carriage return is re-inserted after pressing undo and redo.
       DATA INS4
       TEXT 'INS4  '
* Assert that overwritten text is restored when undo is pressed once.
       DATA OVER1
       TEXT 'OVER1 '
* Assert that overwritten text is again replaced when undo and redo are pressed.
       DATA OVER2
       TEXT 'OVER2 '
* Assert that pressing the undo button with an empty undo list doesn't hurt anything.
       DATA EMPTY1
       TEXT 'EMPTY1'
* Assert that pressing the undo button after all operations have ben undone
* won't hurt anything.
       DATA EMPTY2
       TEXT 'EMPTY2'
* Assert that pressing the redo button with an empty undo list doesn't hurt anything.
       DATA EMPTY3
       TEXT 'EMPTY3'
* Assert that pressing the redo button after everything has been redone doesn't hurt anything.
       DATA EMPTY4
       TEXT 'EMPTY4'
*
TSTEND
RSLTFL BYTE RSLTFE-RSLTFL-1
       TEXT 'DSK.EMUTEST.TESTRESULT'
RSLTFE
       EVEN

****************************************
*
* Test initialization
*
****************************************
TSTINT
       CLR  @PREV_ACTION
* Initialize buffer.
       LI   R0,SPACE
       LI   R1,SPCEND-SPACE
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
       MOV  R0,@PARLST
* Initialize undo/redo list
       LI   R0,1
       BLWP @ARYALC
       MOV  R0,@UNDLST
* With an empty list, the current index is -1,
* (no entry to point at).
       SETO @UNDOIDX
*
       LI   R6,INTADR
* Copy a paragraph into buffer
TSTIN1
       MOV  *R6+,R0
       MOV  R0,R2
       BLWP @BUFALC
       MOV  R0,R1
       MOV  *R6+,R0
       BLWP @BUFCPY
       MOV  R1,R4
* and a wrap list
       MOV  *R6+,R0
       MOV  R0,R2
       BLWP @BUFALC
       MOV  R0,R1
       MOV  *R6+,R0
       BLWP @BUFCPY
       MOV  R1,R5
* Put the paragraph into the
* paragraph list
       MOV  @PARLST,R0
       BLWP @ARYADD
       MOV  R0,@PARLST
       MOV  R4,*R1
* Put the wrap list in the paragraph
* header
       INCT R4
       MOV  R5,*R4
* Loop
       CI   R6,INTADE
       JL   TSTIN1
       RT

****************************************
*
* Starting Data
*
****************************************

* paragraph size, paragraph address,
* wrap list size, wrap list address
INTADR DATA PAR0A-PAR0,PAR0,PAR0-WRAP0,WRAP0
       DATA PAR1A-PAR1,PAR1,PAR1-WRAP1,WRAP1
       DATA PAR2A-PAR2,PAR2,PAR2-WRAP2,WRAP2
       DATA PAR3A-PAR3,PAR3,PAR3-WRAP3,WRAP3
       DATA PAR4A-PAR4,PAR4,PAR4-WRAP4,WRAP4
INTADE

WRAP0  DATA 20,1
       DATA 40,38,40,37,34,41,34,39,39,33
       DATA 39,40,39,39,37,30,39,40,39,38
PAR0   DATA PAR0A-PAR0-4,WRAP0
       TEXT 'Madison"s modern origins begin in 1829, '
       TEXT 'when former federal judge James Duane '
       TEXT 'Doty purchased over a thousand acres (4 '
       TEXT 'km2) of swamp and forest land on the '
       TEXT 'isthmus between Lakes Mendota and '
       TEXT 'Monona, with the intention of building a '
       TEXT 'city in the Four Lakes region. He '
       TEXT 'purchased 1,261 acres for $1,500. When '
       TEXT 'the Wisconsin Territory was created in '
       TEXT '1836 the territorial legislature '
       TEXT 'convened in Belmont, Wisconsin. One of '
       TEXT 'the legislature"s tasks was to select a '
       TEXT 'permanent location for the territory"s '
       TEXT 'capital. Doty lobbied aggressively for '
       TEXT 'Madison as the new capital, offering '
       TEXT 'buffalo robes to the freezing '
       TEXT 'legislators and choice lots in Madison '
       TEXT 'at discount prices to undecided voters. '
       TEXT 'He had James Slaughter plat two cities '
       TEXT 'in the area, Madison and "The City of '
       TEXT 'Four Lakes", near present-day Middleton.'
PAR0A
       EVEN

WRAP1  DATA 0,1
PAR1   DATA PAR1A-PAR1-4,WRAP1
       TEXT 'That"s all I have to say about that.'
PAR1A

WRAP2  DATA 0,1
PAR2   DATA PAR2A-PAR2-4,WRAP2
       TEXT '1'
PAR2A

WRAP3  DATA 0,1
PAR3   DATA PAR3A-PAR3-4,WRAP3
       TEXT '2'
PAR3A

WRAP4  DATA 0,1
PAR4   DATA PAR4A-PAR4-4,WRAP4
       TEXT '3'
PAR4A

UNDLEN TEXT 'UNDLST length'
       EVEN

****************************************
*
* Each Test
*
****************************************

* Undo List 1
* -----------
* Assert the undo list has two entries
LIST1  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,143
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL1
       LI   R1,KEYL1E
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Expect two undo-operations in the list
       LI   R0,2
       MOV  @UNDLST,R1
       MOV  *R1,R1
       LI   R2,UNDLEN
       LI   R3,13
       BLWP @AEQ
* Assert first undo operation records correct deleted letters
       MOV  @UNDLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
*
       LI   R0,EXPECT_LIST1_UNDO1
       LI   R2,EXPECT_LIST1_UNDO2-EXPECT_LIST1_UNDO1
       LI   R3,FAIL_UNDO1+2
       MOV  @FAIL_UNDO1,R4
       BLWP @ABLCK
* Assert first undo operation records correct deleted letters
       MOV  @UNDLST,R0
       LI   R1,1
       BLWP @ARYADR
       MOV  *R1,R1
*
       LI   R0,EXPECT_LIST1_UNDO2
       LI   R2,EXPECT_LIST1_UNDO2_END-EXPECT_LIST1_UNDO2
       LI   R3,FAIL_UNDO2+2
       MOV  @FAIL_UNDO2,R4
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEYL1  BYTE DELKEY,DELKEY,DELKEY,DELKEY
*
       BYTE BCKKEY,BCKKEY,BCKKEY
*
       BYTE DELKEY,DELKEY
KEYL1E EVEN

EXPECT_LIST1_UNDO1
       DATA UNDO_DEL        * Undo Operation Type
       DATA 0,143           * Paragraph index, character index (before action)
       DATA 0,143           * Paragraph index, character index (ater action)
       DATA 4               * String length
       TEXT 'land'          * Deleted Bytes

EXPECT_LIST1_UNDO2
       DATA UNDO_DEL        * Undo Operation Type
       DATA 0,140           * Paragraph index, character index (before action)
       DATA 0,140           * Paragraph index, character index (ater action)
       DATA 2               * String length
       TEXT 'st'            * Deleted Bytes
EXPECT_LIST1_UNDO2_END

FAIL_UNDO1
       DATA 27
       TEXT '1ST undo block has bad data'
       EVEN
FAIL_UNDO2
       DATA 27
       TEXT '2ND undo block has bad data'
       EVEN

* Undo List 2
* -----------
* Assert that an invalid key doesn't hurt anything.
LIST2  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,10
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEY_LIST2
       LI   R1,KEY_LIST2E
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
* Assert
* Expect zero undo-operations in the list
       CLR  R0
       MOV  @UNDLST,R1
       MOV  *R1,R1
       LI   R2,UNDLEN
       LI   R3,13
       BLWP @AEQ
* Assert first undo operation records correct deleted letters
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,EXPECT_LIST2_TEXT+2
       MOV  @EXPECT_LIST2_TEXT,R2
       LI   R3,FAIL_LIST2+2
       MOV  @FAIL_LIST2,R4
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_LIST2
       BYTE -4
KEY_LIST2E
       EVEN       

EXPECT_LIST2_TEXT
       DATA 40
       TEXT 'Madison"s modern origins begin in 1829, '       
FAIL_LIST2
       DATA 29
       TEXT 'Text should not have changed.'

* Undo List 3
* -----------
* Assert that the undo/redo list will not exceed 16 elements
LIST3  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Populate undo list with 16 items
* Let R3 = element index
* Let R4 = address of most recent entry in undo-list
       CLR  R3
LIST3_POPULATE_LOOP
       MOV  @UNDLST,R0
       BLWP @ARYADD
       JEQ  LIST3_DONE
       MOV  R0,@UNDLST
       MOV  R1,R4
*
       LI   R0,UNDO_PAYLOAD+1
       BLWP @BUFALC
       JEQ  LIST3_DONE
       MOV  R0,*R4
*
       LI   R0,LIST3_OLD_UNDO_OBJ
       MOV  *R4,R1
       LI   R2,LIST3_OLD_UNDO_OBJ_END-LIST3_OLD_UNDO_OBJ
       BLWP @BUFCPY
* Use the character index as a UK for each object
       MOV  R3,@UNDO_ANY_CHAR(R1)
*
       INC  R3
       CI   R3,MAX_UNDO_LIST_LENGTH
       JL   LIST3_POPULATE_LOOP
* Set undo index to the end of the undo-list
       LI   R0,15
       MOV  R0,@UNDOIDX
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,44
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL3
       LI   R1,KEYL3E
       CLR  R2
       BL   @CPYKEY
* Act
       BL   @INPUT
       BL   @INPUT
* Assert
* Expect number of undo operations to remain unchanged
       LI   R0,MAX_UNDO_LIST_LENGTH
       MOV  @UNDLST,R1
       MOV  *R1,R1
       LI   R2,LIST3_LENGTH_MSG+2
       MOV  @LIST3_LENGTH_MSG,R3
       BLWP @AEQ
* Expect oldest undo-object to be what was previously the second oldest
       MOV  @UNDLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       MOV  @UNDO_ANY_CHAR(R1),R1
*
       LI   R0,1
       LI   R2,LIST3_OLDEST_MSG+2
       MOV  @LIST3_OLDEST_MSG,R3
       BLWP @AEQ
* Expect second youngest undo-object to be what previously the youngest
       MOV  @UNDLST,R0
       LI   R1,14
       BLWP @ARYADR
       MOV  *R1,R1
       MOV  @UNDO_ANY_CHAR(R1),R1
*
       LI   R0,15
       LI   R2,LIST3_SECOND_YOUNGEST_MSG+2
       MOV  @LIST3_SECOND_YOUNGEST_MSG,R3
       BLWP @AEQ
* Assert that the most recent undo-object is the letter we just deleted
       MOV  @UNDLST,R0
       LI   R1,15
       BLWP @ARYADR
       MOV  *R1,R1
*
       LI   R0,LIST3_EXPECTED_UNDO_OBJ
       LI   R2,LIST3_EXPECTED_UNDO_OBJ_END-LIST3_EXPECTED_UNDO_OBJ
       LI   R3,LIST3_YOUNGEST_MSG+2
       MOV  @LIST3_YOUNGEST_MSG,R4
       BLWP @ABLCK
*
LIST3_DONE
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEYL3  BYTE FWDKEY
       BYTE DELKEY,DELKEY,DELKEY,DELKEY,DELKEY,DELKEY
KEYL3E EVEN

LIST3_OLD_UNDO_OBJ
       DATA UNDO_DEL        * Undo Operation Type
       DATA 1,5             * Paragraph index, character index (before action)
       DATA 1,5             * Paragraph index, character index (ater action)
       DATA 1               * String length
       TEXT '$'             * Deleted Bytes
       BYTE 0
LIST3_OLD_UNDO_OBJ_END

LIST3_EXPECTED_UNDO_OBJ
       DATA UNDO_DEL        * Undo Operation Type
       DATA 0,45            * Paragraph index, character index (before action)
       DATA 0,45            * Paragraph index, character index (ater action)
       DATA 6               * String length
       TEXT 'former'        * Deleted Bytes
       EVEN
LIST3_EXPECTED_UNDO_OBJ_END

LIST3_LENGTH_MSG
       DATA 37
       TEXT 'Undo list was not of expected length.'
       EVEN
LIST3_OLDEST_MSG
       DATA 35
       TEXT 'Oldest undo-object not as expected.'
       EVEN
LIST3_SECOND_YOUNGEST_MSG
       DATA 42
       TEXT 'Second oldest undo-object not as expected.'
       EVEN
LIST3_YOUNGEST_MSG
       DATA 32
       TEXT 'New undo-object not as expected.'
       EVEN

* Undo List 4
* -----------
* Assert that an undo object larger than 255 bytes will split in two
LIST4  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Populate undo list with 1 item containing 254 characters
       MOV  @UNDLST,R0
       BLWP @ARYADD
       MOV  R0,@UNDLST
       MOV  R1,R4
*
       LI   R0,UNDO_PAYLOAD+254
       BLWP @BUFALC
       MOV  R0,*R4
*
       LI   R0,LIST4_OLD_UNDO_OBJ
       MOV  *R4,R1
       LI   R2,LIST4_OLD_UNDO_OBJ_END-LIST4_OLD_UNDO_OBJ
       BLWP @BUFCPY
* Set undo index to the end of the undo-list
       LI   R0,0
       MOV  R0,@UNDOIDX
* Set prev action to imply that user has already been deleting text
       LI   R0,UNDO_DEL
       MOV  R0,@PREV_ACTION
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,45
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEY_LIST4
       LI   R1,KEY_LIST4E
       CLR  R2
       BL   @CPYKEY
* Act
       BL   @INPUT
       BL   @INPUT
* Assert
* Expect number of undo operations to increase
       LI   R0,2
       MOV  @UNDLST,R1
       MOV  *R1,R1
       LI   R2,LIST4_LIST_LENGTH_MSG+2
       MOV  @LIST4_LIST_LENGTH_MSG,R3
       BLWP @AEQ
* Expect old undo-object to now have 255 characters
       MOV  @UNDLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       MOV  @UNDO_ANY_LEN(R1),R1
*
       LI   R0,255
       LI   R2,LIST4_CHANGED_LEN_MSG+2
       MOV  @LIST4_CHANGED_LEN_MSG,R3
       BLWP @AEQ
* Assert that the most new undo-object contains what we expect
       MOV  @UNDLST,R0
       LI   R1,1
       BLWP @ARYADR
       MOV  *R1,R1
*
       LI   R0,LIST4_EXPECTED_UNDO_OBJ
       LI   R2,LIST4_EXPECTED_UNDO_OBJ_END-LIST4_EXPECTED_UNDO_OBJ
       LI   R3,LIST4_NEW_OBJECT_MSG+2
       MOV  @LIST4_NEW_OBJECT_MSG,R4
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_LIST4
       BYTE DELKEY,DELKEY,DELKEY,DELKEY,DELKEY
KEY_LIST4E
       EVEN

LIST4_OLD_UNDO_OBJ
       DATA UNDO_DEL        * Undo Operation Type
       DATA 0,45            * Paragraph index, character index (before action)
       DATA 0,45            * Paragraph index, character index (ater action)
       DATA 254             * String length
       TEXT 'some text...'  * Deleted Bytes
       EVEN
LIST4_OLD_UNDO_OBJ_END

LIST4_EXPECTED_UNDO_OBJ
       DATA UNDO_DEL        * Undo Operation Type
       DATA 0,45            * Paragraph index, character index (before action)
       DATA 0,45            * Paragraph index, character index (ater action)
       DATA 4               * String length
       TEXT 'orme'          * Deleted Bytes
       EVEN
LIST4_EXPECTED_UNDO_OBJ_END

LIST4_LIST_LENGTH_MSG
       DATA 46
       TEXT 'Undo list should have increased to 2 elements.'
       EVEN
LIST4_CHANGED_LEN_MSG
       DATA 47
       TEXT 'Old object should have increased by 1 character.'
       EVEN
LIST4_NEW_OBJECT_MSG
       DATA 32
       TEXT 'New undo-object not as expected.'
       EVEN

* Delete 2
* --------
* Assert that text is deleted when undo is not pressed.
DEL2   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,40
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL2
       LI   R1,KEYL2E
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that expected letters are deleted
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,DEL2_EXPECTED_TEXT
       LI   R2,80
       LI   R3,DEL2_FAIL+2
       MOV  @DEL2_FAIL,R4
       BLWP @ABLCK
*
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,44
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEYL2  BYTE DELKEY,DELKEY,DELKEY,DELKEY,DELKEY
*
       BYTE FWDKEY,FWDKEY,FWDKEY,FWDKEY
*
       BYTE DELKEY,DELKEY,DELKEY
KEYL2E EVEN

* First 80 characters of the paragraph after delting
DEL2_EXPECTED_TEXT
       TEXT 'Madison"s modern origins begin in 1829, '
       TEXT 'formfederal judge James Duane Doty purch'
       EVEN
DEL2_FAIL
       DATA 49
       TEXT 'Not all of the characters were deleted correctly.'
       EVEN

PARA_IDX_FAIL
       DATA 21
       TEXT 'Wrong paragraph index'
       EVEN
CHAR_IDX_FAIL
       DATA 38
       TEXT 'Wrong character index within paragraph'
       EVEN

* Delete 3
* --------
* Assert that text is restored when undo is pressed once.
DEL3   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,40
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEY_DEL3
       LI   R1,KEY_DEL3E
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that expected letters are deleted
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,DEL3_EXPECTED_TEXT
       LI   R2,80
       LI   R3,DEL3_FAIL+2
       MOV  @DEL3_FAIL,R4
       BLWP @ABLCK
*
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,44
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_DEL3
       BYTE DELKEY,DELKEY,DELKEY,DELKEY,DELKEY
       BYTE FWDKEY,FWDKEY,FWDKEY,FWDKEY
       BYTE DELKEY,DELKEY,DELKEY
       BYTE UNDKEY
KEY_DEL3E
       EVEN

* First 80 characters of the paragraph after delting
DEL3_EXPECTED_TEXT
       TEXT 'Madison"s modern origins begin in 1829, '
       TEXT 'former federal judge James Duane Doty pu'
DEL3_FAIL
       DATA 49
       TEXT 'Some characters should have been restored.'

* Test 4
* ------
* Assert that text is restored when undo is pressed twice.
DEL4   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,40
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL4
       LI   R1,KEYL4E
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that expected letters are deleted
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,DEL4_EXPECTED_TEXT
       LI   R2,80
       LI   R3,DEL4_FAIL+2
       MOV  @DEL4_FAIL,R4
       BLWP @ABLCK
*
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,40
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEYL4  BYTE DELKEY,DELKEY,DELKEY,DELKEY,DELKEY
*
       BYTE FWDKEY,FWDKEY,FWDKEY,FWDKEY
*
       BYTE DELKEY,DELKEY,DELKEY
       BYTE UNDKEY,UNDKEY
KEYL4E EVEN

* First 80 characters of the paragraph after delting
DEL4_EXPECTED_TEXT
       TEXT 'Madison"s modern origins begin in 1829, '
       TEXT 'when former federal judge James Duane Do'
DEL4_FAIL
       DATA 50
       TEXT 'Not all of the characters were restored correctly.'

* Test 5
* ------
* Assert that only some text is restored when undo, undo, and redo are pressed.
DEL5   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,10
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL5
       LI   R1,KEYL5E
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that expected letters are deleted
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,DEL5_EXPECTED_TEXT
       LI   R2,40
       LI   R3,DEL5_FAIL+2
       MOV  @DEL5_FAIL,R4
       BLWP @ABLCK
* Assert cursor is at the same position
* as the action we redid.
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,10
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEYL5  BYTE DELKEY,DELKEY
*
       BYTE FWDKEY
*
       BYTE DELKEY,DELKEY
       BYTE UNDKEY,UNDKEY,RDOKEY
KEYL5E EVEN

* First 40 characters of the paragraph after delting
DEL5_EXPECTED_TEXT
       TEXT 'Madison"s dern origins begin in 1829, wh'
DEL5_FAIL
       DATA 50
       TEXT 'Not all of the characters were restored correctly.'

* Delete 6
* --------
* Assert that a redo action inbetween two undo actions, does not result in repeated redos.
DEL6   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,40
       MOV  R0,@CHRPAX
*
* Act
*
* Copy test keypresses to stream
       LI   R0,KEY_DEL6A
       LI   R1,KEY_DEL6B
       CLR  R2
       BL   @CPYKEY
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Copy test keypresses to stream
       LI   R0,KEY_DEL6B
       LI   R1,KEY_DEL6E
       CLR  R2
       BL   @CPYKEY
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
*
* Assert
*
* Assert that expected letters are deleted
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,DEL6_EXPECTED_TEXT+2
       MOV  @DEL6_EXPECTED_TEXT,R2
       LI   R3,DEL6_FAIL+2
       MOV  @DEL6_FAIL,R4
       BLWP @ABLCK
* Assert cursor is at the same position
* as the action we redid.
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,34
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_DEL6A
       BYTE DELKEY,DELKEY
*
       BYTE UNDKEY,RDOKEY
KEY_DEL6B
*
       BYTE BCKKEY,BCKKEY,BCKKEY,BCKKEY,BCKKEY,BCKKEY
*
       BYTE DELKEY,DELKEY,DELKEY,DELKEY
       BYTE UNDKEY,RDOKEY,RDOKEY
KEY_DEL6E
       EVEN

* First 40 characters of the paragraph after delting
DEL6_EXPECTED_TEXT
       DATA 72
       TEXT 'Madison"s modern origins begin in , '
       TEXT 'en former federal judge James Duane '
       EVEN
DEL6_FAIL
       DATA 49
       TEXT 'All actions should have been redone exactly once.'
       EVEN

* Delete 7
* --------
* Assert that deleting a carriage return can be undone.
DEL7   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set cursor postion to the end of a paragraph
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       MOV  @PAR0,@CHRPAX
*
* Act
*
* Copy test keypresses to stream
       LI   R0,KEY_DEL7
       LI   R1,KEY_DEL7E
       CLR  R2
       BL   @CPYKEY
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
*
* Assert
*
       LI   R0,(INTADE-INTADR)/8
       MOV  @PARLST,R1
       MOV  *R1,R1
       LI   R2,DEL7_PARA_COUNT+2
       MOV  @DEL7_PARA_COUNT,R3
       BLWP @AEQ
*
       MOV  @PARLST,R0
       LI   R1,1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,DEL7_EXPECTED_TEXT+2
       MOV  @DEL7_EXPECTED_TEXT,R2
       LI   R3,DEL7_FAIL+2
       MOV  @DEL7_FAIL,R4
       BLWP @ABLCK
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_DEL7
       BYTE DELKEY,DELKEY,DELKEY,DELKEY
*
       BYTE UNDKEY
KEY_DEL7E
       EVEN

DEL7_PARA_COUNT
       DATA 45
       TEXT 'Expected original paragraph count after undo.'
       EVEN
* First 40 characters of the paragraph after delting
DEL7_EXPECTED_TEXT
       DATA 36
       TEXT 'That"s all I have to say about that.'
       EVEN
DEL7_FAIL
       DATA 55
       TEXT 'Text in the second paragraph should have been restored.'
       EVEN

* Delete 8
* --------
* Assert that deleting a carriage return can be redone.
DEL8   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set cursor postion to the end of a paragraph
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       MOV  @PAR0,@CHRPAX
*
* Act
*
* Copy test keypresses to stream
       LI   R0,KEY_DEL8
       LI   R1,KEY_DEL8E
       CLR  R2
       BL   @CPYKEY
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
*
* Assert
*
       LI   R0,(INTADE-INTADR)/8-1
       MOV  @PARLST,R1
       MOV  *R1,R1
       LI   R2,DEL8_PARA_COUNT+2
       MOV  @DEL8_PARA_COUNT,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_DEL8
       BYTE DELKEY,DELKEY,DELKEY,DELKEY
*
       BYTE UNDKEY,RDOKEY
KEY_DEL8E
       EVEN

DEL8_PARA_COUNT
       DATA 40
       TEXT 'Expected one fewer paragraph after redo.'
       EVEN

* Delete 9
* --------
* Assert that deletion of two non-consequtive CRs can be undon.
DEL9   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set cursor the beginning of a one character paragraph
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       CLR  @CHRPAX
* Copy test keypresses to stream
       LI   R0,KEY_DEL9
       LI   R1,KEY_DEL9E
       CLR  R2
       BL   @CPYKEY
*
* Act
*
* Run the input routine 3 times.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
*
* Assert
*
* Assert that paragraph at index 2 contains "1"
       MOV  @PARLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
       MOVB *R1,R1
       ANDI R1,>FF00
*
       CLR  R0
       MOVB @PAR2+PARAGRAPH_TEXT_OFFSET,R0
       LI   R2,DEL9_ONE_MSG+2
       MOV  @DEL9_ONE_MSG,R3
       BLWP @AEQ
* Assert that paragraph at index 3 contains "2"
       MOV  @PARLST,R0
       LI   R1,3
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
       MOVB *R1,R1
       ANDI R1,>FF00
*
       CLR  R0
       MOVB @PAR3+PARAGRAPH_TEXT_OFFSET,R0
       LI   R2,DEL9_TWO_MSG+2
       MOV  @DEL9_TWO_MSG,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_DEL9
       BYTE DELKEY,DELKEY,DELKEY,DELKEY
*
       BYTE UNDKEY
KEY_DEL9E
       EVEN

DEL9_ONE_MSG
       DATA 23
       TEXT 'Expected character "1".'
       EVEN
DEL9_TWO_MSG
       DATA 23
       TEXT 'Expected character "2".'
       EVEN

* Delete 10
* ---------
* Assert that replacing one redo replaces all later redos.
DEL10  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set cursor the beginning of a one character paragraph
       CLR  @INSTMD
       CLR  @PARINX
       CLR  @CHRPAX
* Copy test keypresses to stream
       LI   R0,KEY_DEL10
       LI   R1,KEY_DEL10E
       CLR  R2
       BL   @CPYKEY
*
* Act
*
* Run the input routine 3 times.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
*
* Assert
*
* Assert text at beginning of first paragraph
       MOV  @PARLST,R0
       LI   R1,0
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,DEL10_EXPECTED+2
       MOV  @DEL10_EXPECTED,R2
       LI   R3,DEL10_TEXT_MSG+2
       MOV  @DEL10_TEXT_MSG,R4
       BLWP @ASTR
*
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,2
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_DEL10
* Delete 'M' 'd' 's' from 'Madison"s'
       BYTE DELKEY,FWDKEY,DELKEY,FWDKEY,DELKEY
* Restore 's' and 'd'
       BYTE UNDKEY,UNDKEY
* Delete 'i'
       BYTE FWDKEY,DELKEY
* Redo should not delete anything
       BYTE RDOKEY
KEY_DEL10E
       EVEN

DEL10_EXPECTED
       DATA 7
       TEXT 'adson"s'
       EVEN

DEL10_TEXT_MSG
       DATA 67
       TEXT '"d" and first "s" should be restored. "s" should not be re-deleted.'
       EVEN

* Backspace Delete 1
* ------------------
* Assert that text is restored when undo is pressed once.
BACK1  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,71
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEY_BACK1
       LI   R1,KEY_BACK1E
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that expected letters are deleted
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,BACK1_EXPECTED_TEXT+2
       MOV  @BACK1_EXPECTED_TEXT,R2
       LI   R3,BACK1_FAIL+2
       MOV  @BACK1_FAIL,R4
       BLWP @ABLCK
*
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,71
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_BACK1
       BYTE ERSKEY,ERSKEY,ERSKEY,ERSKEY,ERSKEY
       BYTE FWDKEY,FWDKEY,FWDKEY,FWDKEY
       BYTE UNDKEY
KEY_BACK1E
       EVEN

* First 80 characters of the paragraph after delting
BACK1_EXPECTED_TEXT
       DATA 78
       TEXT 'Madison"s modern origins begin in 1829, '
       TEXT 'when former federal judge James Duane '
BACK1_FAIL
       DATA 42
       TEXT 'Some characters should have been restored.'

* Backspace Delete 2
* ------------------
* Assert that text is re-deleted when undo and redo are pressed.
BACK2  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,71
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEY_BACK2
       LI   R1,KEY_BACK2E
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that expected letters are deleted
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,BACK2_EXPECTED_TEXT+2
       MOV  @BACK2_EXPECTED_TEXT,R2
       LI   R3,BACK2_FAIL+2
       MOV  @BACK2_FAIL,R4
       BLWP @ABLCK
*
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,66
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_BACK2
       BYTE ERSKEY,ERSKEY,ERSKEY,ERSKEY,ERSKEY
       BYTE FWDKEY,FWDKEY
       BYTE UNDKEY,RDOKEY
KEY_BACK2E
       EVEN

* First 80 characters of the paragraph after delting
BACK2_EXPECTED_TEXT
       DATA 72
       TEXT 'Madison"s modern origins begin in 1829, '
       TEXT 'when former federal judge  Duane '
       EVEN
BACK2_FAIL
       DATA 42
       TEXT 'All characters should have been redeleted.'

* Backspace Delete 3
* ------------------
* Assert that text is backspace-delting a carriage return can be undone.
BACK3  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values to early in the second paragraph
       CLR  @INSTMD
       LI   R0,1
       MOV  R0,@PARINX
       LI   R0,1
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEY_BACK3
       LI   R1,KEY_BACK3E
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that pargraph count was restored
       LI   R0,(INTADE-INTADR)/8
       MOV  @PARLST,R1
       MOV  *R1,R1
       LI   R3,BACK3_PARAGRAPH_COUNT+2
       MOV  @BACK3_PARAGRAPH_COUNT,R3
       BLWP @AEQ
* Assert that expected letters
* Let R1 = address of close to end of 1st paragraph.
* Let R2 = length of pargraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       MOV  *R1,R2
       AI   R1,PARAGRAPH_TEXT_OFFSET
       A    R2,R1
       S    @BACK3_EXPECTED_TEXT,R1
*
       LI   R0,BACK3_EXPECTED_TEXT+2
       MOV  @BACK3_EXPECTED_TEXT,R2
       LI   R3,BACK3_TEXT_MSG+2
       MOV  @BACK3_TEXT_MSG,R4
       BLWP @ASTR
*
       LI   R0,1
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,1
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_BACK3
       BYTE ERSKEY,ERSKEY,ERSKEY,ERSKEY,ERSKEY,ERSKEY
       BYTE FWDKEY,FWDKEY
       BYTE UNDKEY
KEY_BACK3E
       EVEN

* First 80 characters of the paragraph after delting
BACK3_EXPECTED_TEXT
       DATA 10
       TEXT 'Middleton.'
       EVEN
BACK3_TEXT_MSG
       DATA 63
       TEXT 'Characters at end of first paragraph should have been restored.'
       EVEN
BACK3_PARAGRAPH_COUNT
       DATA 42
       TEXT 'Paragraph count should have been restored.'
       EVEN

* Backspace Delete 4
* ------------------
* Assert that a carriage return is re-deleted when backspace-delete is undone and redone.
BACK4  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values to early in the second paragraph
       CLR  @INSTMD
       LI   R0,1
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEY_BACK4
       LI   R1,KEY_BACK4E
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that pargraph count is one less than before
       LI   R0,(INTADE-INTADR)/8
       AI   R0,-1
       MOV  @PARLST,R1
       MOV  *R1,R1
       LI   R3,BACK4_PARAGRAPH_COUNT+2
       MOV  @BACK4_PARAGRAPH_COUNT,R3
       BLWP @AEQ
* Assert that paragraph has expected new length
* Let R1 = length of first paragraph.
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       MOV  *R1,R1
*
       MOV  @PAR0,R0
       A    @PAR1,R0
       AI   R0,-4
       LI   R2,BACK4_PARA_LENGTH+2
       MOV  @BACK4_PARA_LENGTH,R3
       BLWP @AEQ
*
       LI   R0,0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  @PAR0,R0
       AI   R0,-4
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_BACK4
       BYTE ERSKEY,ERSKEY,ERSKEY,ERSKEY,ERSKEY
       BYTE FWDKEY,FWDKEY
       BYTE UNDKEY,RDOKEY
KEY_BACK4E
       EVEN

* First 80 characters of the paragraph after delting
BACK4_PARA_LENGTH
       DATA 50
       TEXT 'Paragraph should be shorter after redoing deletes.'
       EVEN
BACK4_PARAGRAPH_COUNT
       DATA 42
       TEXT 'There should be one less paragraph.'
       EVEN

* Insert 1
* --------
* Assert that inserted text is removed when undo is pressed once.
INS1   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,10
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEY_INS1
       LI   R1,KEY_INS1E
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that expected letters are deleted
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,INS1_EXPECTED_TEXT+2
       MOV  @INS1_EXPECTED_TEXT,R2
       LI   R3,INS1_FAIL+2
       MOV  @INS1_FAIL,R4
       BLWP @ASTR
*
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,10
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_INS1
       TEXT 'SNOOPY '
       BYTE UNDKEY
KEY_INS1E
       EVEN

* First 80 characters of the paragraph after delting
INS1_EXPECTED_TEXT
       DATA 78
       TEXT 'Madison"s modern origins begin in 1829, '
       TEXT 'when former federal judge James Duane '
INS1_FAIL
       DATA 35
       TEXT '"SNOOPY " should have been removed.'

* Insert 2
* --------
* Assert that inserted text is restored when undo and redo are pressed.
INS2   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,10
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEY_INS2
       LI   R1,KEY_INS2E
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that expected letters are deleted
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,INS2_EXPECTED_TEXT+2
       MOV  @INS2_EXPECTED_TEXT,R2
       LI   R3,INS2_FAIL+2
       MOV  @INS2_FAIL,R4
       BLWP @ASTR
*
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,17
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_INS2
       TEXT 'SNOOPY '
       BYTE FWDKEY,UNDKEY,RDOKEY
KEY_INS2E
       EVEN

* First 80 characters of the paragraph after delting
INS2_EXPECTED_TEXT
       DATA 85
       TEXT 'Madison"s SNOOPY modern origins begin in 1829, '
       TEXT 'when former federal judge James Duane '
       EVEN
INS2_FAIL
       DATA 36
       TEXT '"SNOOPY " should have been restored.'
       EVEN

* Insert 3
* --------
* Assert that inserted carriage returns can be undone.
INS3   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,10
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEY_INS3
       LI   R1,KEY_INS3E
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that expected letters are deleted
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,INS3_EXPECTED_TEXT+2
       MOV  @INS3_EXPECTED_TEXT,R2
       LI   R3,INS3_FAIL+2
       MOV  @INS3_FAIL,R4
       BLWP @ASTR
*
       MOV  @PARLST,R0
       MOV  *R0,R0
       LI   R1,(INTADE-INTADR)/8
       LI   R2,INS3_PARA_COUNT+2
       MOV  @INS3_PARA_COUNT,R3
       BLWP @AEQ
*
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,10
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_INS3
       TEXT 'AB'
       BYTE ENTER
       TEXT 'CD'
       BYTE FWDKEY,UNDKEY
KEY_INS3E
       EVEN

* First 80 characters of the paragraph after delting
INS3_EXPECTED_TEXT
       DATA 78
       TEXT 'Madison"s modern origins begin in 1829, '
       TEXT 'when former federal judge James Duane '
INS3_FAIL
       DATA 29
       TEXT 'Text should not have changed.'
INS3_PARA_COUNT
       DATA 47
       TEXT 'Number of paragraphs should have been restored.'

* Insert 4
* --------
* Assert that a carriage return is re-inserted after pressing undo and redo.
INS4   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,10
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEY_INS4
       LI   R1,KEY_INS4E
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that expected letters are restored
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,INS4_EXPECTED_TEXT1+2
       MOV  @INS4_EXPECTED_TEXT1,R2
       LI   R3,INS4_FAIL+2
       MOV  @INS4_FAIL,R4
       BLWP @ASTR
*
* Assert that expected letters are restored
* Let R1 = address of text in the second paragraph
       MOV  @PARLST,R0
       LI   R1,1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,INS4_EXPECTED_TEXT2+2
       MOV  @INS4_EXPECTED_TEXT2,R2
       LI   R3,INS4_FAIL+2
       MOV  @INS4_FAIL,R4
       BLWP @ASTR
*
       MOV  @PARLST,R0
       MOV  *R0,R0
       LI   R1,(INTADE-INTADR)/8+1
       LI   R2,INS4_PARA_COUNT+2
       MOV  @INS4_PARA_COUNT,R3
       BLWP @AEQ
*
       LI   R0,1
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,2
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_INS4
       TEXT 'AB'
       BYTE ENTER
       TEXT 'CD'
       BYTE FWDKEY,UNDKEY,FWDKEY,RDOKEY
KEY_INS4E
       EVEN

* First 80 characters of the paragraph after delting
INS4_EXPECTED_TEXT1
       DATA 12
       TEXT 'Madison"s AB'
       EVEN
INS4_EXPECTED_TEXT2
       DATA 70
       TEXT 'CDmodern origins begin in 1829, '
       TEXT 'when former federal judge James Duane '
       EVEN
INS4_FAIL
       DATA 39
       TEXT 'Deleted text should have been restored.'
       EVEN
INS4_PARA_COUNT
       DATA 43
       TEXT 'Number of paragraphs should have increased.'
       EVEN

* Overwrite 1
* -----------
* Assert that inserted text is removed when undo is pressed once.
OVER1  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set to overwrite mode
       SETO @INSTMD
* Set position values
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,10
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEY_OVER1
       LI   R1,KEY_OVER1E
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that expected letters are deleted
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,OVER1_EXPECTED_TEXT+2
       MOV  @OVER1_EXPECTED_TEXT,R2
       LI   R3,OVER1_FAIL+2
       MOV  @OVER1_FAIL,R4
       BLWP @ASTR
*
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,10
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_OVER1
       TEXT 'SNOOPY'
       BYTE UNDKEY
KEY_OVER1E
       EVEN

* First 80 characters of the paragraph after delting
OVER1_EXPECTED_TEXT
       DATA 78
       TEXT 'Madison"s modern origins begin in 1829, '
       TEXT 'when former federal judge James Duane '
OVER1_FAIL
       DATA 44
       TEXT 'The text "modern" should have been restored.'

* Overwrite 2
* -----------
* Assert that overwritten text is again replaced when undo and redo are pressed.
OVER2  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set to overwrite mode
       SETO @INSTMD
* Set position values
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,10
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEY_OVER2
       LI   R1,KEY_OVER2E
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that expected letters are deleted
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,OVER2_EXPECTED_TEXT+2
       MOV  @OVER2_EXPECTED_TEXT,R2
       LI   R3,OVER2_FAIL+2
       MOV  @OVER2_FAIL,R4
       BLWP @ASTR
*
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,16
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEY_OVER2
       TEXT 'SNOOPY'
       BYTE UNDKEY,RDOKEY
KEY_OVER2E
       EVEN

* First 80 characters of the paragraph after delting
OVER2_EXPECTED_TEXT
       DATA 78
       TEXT 'Madison"s SNOOPY origins begin in 1829, '
       TEXT 'when former federal judge James Duane '
       EVEN
OVER2_FAIL
       DATA 47
       TEXT 'The text "modern" should have been re-replaced.'
       EVEN

* Empty 1
* -------
* Assert that pressing the undo button with an empty undo list doesn't hurt anything.
EMPTY1 DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,40
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL_EMPTY1
       LI   R1,KEYL_EMPTY1_END
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that expected letters are deleted
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,EMPTY1_EXPECTED_TEXT+2
       MOV  @EMPTY1_EXPECTED_TEXT,R2
       LI   R3,EMPTY1_FAIL+2
       MOV  @EMPTY1_FAIL,R4
       BLWP @ASTR
*
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,40
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEYL_EMPTY1
       BYTE FWDKEY,BCKKEY,UNDKEY
KEYL_EMPTY1_END
       EVEN

* First 80 characters of the paragraph after delting
EMPTY1_EXPECTED_TEXT
       DATA 78
       TEXT 'Madison"s modern origins begin in 1829, '
       TEXT 'when former federal judge James Duane '
       EVEN
EMPTY1_FAIL
       DATA 29
       TEXT 'Text should not have changed.'
       EVEN

* Empty 2
* -------
* Assert that pressing the undo button after all operations have ben undone
* won't hurt anything.
EMPTY2 DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,40
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL_EMPTY2
       LI   R1,KEYL_EMPTY2_END
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that expected letters are deleted
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,EMPTY2_EXPECTED_TEXT+2
       MOV  @EMPTY2_EXPECTED_TEXT,R2
       LI   R3,EMPTY2_FAIL+2
       MOV  @EMPTY2_FAIL,R4
       BLWP @ASTR
*
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,40
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEYL_EMPTY2
       BYTE DELKEY,DELKEY
*
       BYTE FWDKEY,FWDKEY
*
       BYTE DELKEY
       BYTE UNDKEY,UNDKEY,UNDKEY
KEYL_EMPTY2_END
       EVEN

* First 80 characters of the paragraph after delting
EMPTY2_EXPECTED_TEXT
       DATA 78
       TEXT 'Madison"s modern origins begin in 1829, '
       TEXT 'when former federal judge James Duane '
EMPTY2_FAIL
       DATA 50
       TEXT 'Not all of the characters were restored correctly.'

* Empty 3
* -------
* Assert that pressing the redo button with an empty undo list doesn't hurt anything.
EMPTY3 DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,40
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL_EMPTY3
       LI   R1,KEYL_EMPTY3_END
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that expected letters are deleted
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,EMPTY3_EXPECTED_TEXT+2
       MOV  @EMPTY3_EXPECTED_TEXT,R2
       LI   R3,EMPTY3_FAIL+2
       MOV  @EMPTY3_FAIL,R4
       BLWP @ABLCK
*
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,40
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEYL_EMPTY3
       BYTE FWDKEY,BCKKEY,RDOKEY
KEYL_EMPTY3_END
       EVEN

* First 80 characters of the paragraph after delting
EMPTY3_EXPECTED_TEXT
       DATA 78
       TEXT 'Madison"s modern origins begin in 1829, '
       TEXT 'when former federal judge James Duane '
       EVEN
EMPTY3_FAIL
       DATA 29
       TEXT 'Text should not have changed.'
       EVEN

* Empty 4
* -------
* Assert that pressing the redo button after everything has been redone doesn't hurt anything.
EMPTY4 DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,40
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL_EMPTY4
       LI   R1,KEYL_EMPTY4_END
       CLR  R2
       BL   @CPYKEY
* Act
* Run the input routine 3 times.
* because it will exit when switching between delete and arrow keys.
       BL   @INPUT
       BL   @INPUT
       BL   @INPUT
* Assert
* Assert that expected letters are deleted
* Let R1 = address of text in the first paragraph
       MOV  @PARLST,R0
       CLR  R1
       BLWP @ARYADR
       MOV  *R1,R1
       AI   R1,PARAGRAPH_TEXT_OFFSET
*
       LI   R0,EMPTY4_EXPECTED_TEXT+2
       MOV  @EMPTY4_EXPECTED_TEXT,R2
       LI   R3,EMPTY4_FAIL+2
       MOV  @EMPTY4_FAIL,R4
       BLWP @ABLCK
*
       CLR  R0
       MOV  @PARINX,R1
       LI   R2,PARA_IDX_FAIL+2
       MOV  @PARA_IDX_FAIL,R3
       BLWP @AEQ
*
       LI   R0,40
       MOV  @CHRPAX,R1
       LI   R2,CHAR_IDX_FAIL+2
       MOV  @CHAR_IDX_FAIL,R3
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEYL_EMPTY4
       BYTE DELKEY,DELKEY,UNDKEY,FWDKEY,RDOKEY,RDOKEY
KEYL_EMPTY4_END
       EVEN

* First 80 characters of the paragraph after delting
EMPTY4_EXPECTED_TEXT
       DATA 76
       TEXT 'Madison"s modern origins begin in 1829, '
       TEXT 'en former federal judge James Duane '
       EVEN
EMPTY4_FAIL
       DATA 29
       TEXT 'Text should not have changed.'
       EVEN



*** Test Utils *******************************

* Copy test keypresses to the key stream
* R0 = Address of first test key
* R1 = Address following last test key
* R2 = Offset within key stream
CPYKEY
* Prohibit keystreams longer than 14 bytes
       CI   R2,14
       JL   CPY0
       LI   R2,14
*
CPY0   AI   R2,KEYSTR
       MOV  R2,@KEYRD
CPYLP  MOVB *R0+,*R2+
       CI   R2,KEYEND
       JL   CPY1
       LI   R2,KEYSTR
CPY1   C    R0,R1
       JL   CPYLP
CPYRT
       MOV  R2,@KEYWRT
       RT

******* MOCKS **************
MNUHK
MNUINT
PRINT
* These VDP routines should do nothing
VDPADR
VDPWRT RT

****************************************

SPACE  EQU  >2800
SPCEND EQU  SPACE+>1000

       END