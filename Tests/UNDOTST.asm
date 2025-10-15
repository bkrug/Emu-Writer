       DEF  TSTLST,RSLTFL
* Mocks
       DEF  VDPADR,VDPWRT
       DEF  MNUHK
       DEF  MNUINT,PRINT

* Assert Routine
       REF  AEQ,AZC,AOC,ABLCK

*
       REF  INPUT
       REF  INPTS,INPTE

* from VAR.asm
       REF  PARLST,FMTLST,MGNLST
       REF  UNDLST,UNDIDX
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

       COPY '../Src/CPUADR.asm'
       COPY '../Src/EQUKEY.asm'

TSTLST DATA (TSTEND-TSTLST-2)/8
*
* User inserted some text and overwrote
* some other text
       DATA TST1
       TEXT 'TST1  '
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
* In production, the code that we are testing
* is initially loaded to address >E000,
* copied to the VDP cache,
* and then loaded to address LOADED when needed.
* For the purposes of the tests, copy it straight
* to address LOADED.
       LI   R0,INPTS
       LI   R1,LOADED
       LI   R2,INPTE
       S    R0,R2
       BLWP @BUFCPY
*
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
       CLR  @UNDIDX
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

UNDLEN TEXT 'UNDLST length'
       EVEN

****************************************
*
* Each Test
*
****************************************

* Test 1
* ------
TST1   DECT R10
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
       LI   R0,EXPECT_TST1_UNDO1
       LI   R2,EXPECT_TST1_UNDO2-EXPECT_TST1_UNDO1
       LI   R3,FAIL_UNDO1+2
       MOV  @FAIL_UNDO1,R4
       BLWP @ABLCK
* Assert first undo operation records correct deleted letters
       MOV  @UNDLST,R0
       LI   R1,1
       BLWP @ARYADR
       MOV  *R1,R1
*
       LI   R0,EXPECT_TST1_UNDO2
       LI   R2,EXPECT_TST1_UNDO2_END-EXPECT_TST1_UNDO2
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

EXPECT_TST1_UNDO1
       DATA UNDO_DEL        * Undo Operation Type
       DATA 0,143           * Paragraph index, character index
       DATA 4               * String length
       TEXT 'land'          * Deleted Bytes

EXPECT_TST1_UNDO2
       DATA UNDO_DEL        * Undo Operation Type
       DATA 0,140           * Paragraph index, character index
       DATA 2               * String length
       TEXT 'st'            * Deleted Bytes
EXPECT_TST1_UNDO2_END

FAIL_UNDO1
       DATA 27
       TEXT '1ST undo block has bad data'
       EVEN
FAIL_UNDO2
       DATA 27
       TEXT '2ND undo block has bad data'
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

SPACE  BSS  >1000
SPCEND

       END