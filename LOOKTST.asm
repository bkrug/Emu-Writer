       DEF  TSTLST,RSLTFL
       REF  AEQ
*
       REF  LOOKUP,LNDIFF
*
       REF  LINLST
       REF  PARINX,CHRPAX
       REF  LININX,CHRLIX
       REF  WINOFF,WINPAR,WINLIN

TSTLST DATA TSTEND-TSTLST-2/8
* Calculate relative document-line
* looking backwards within the same
* paragraph
       DATA UP1
       TEXT 'UP1   '
* Calculate relative document-line
* looking backwards between 
* non-consecutive paragraphs.
       DATA UP2
       TEXT 'UP2   '
* Calculate relative document-line
* looking backwards from first line in
* a paragraph to last line in another.
       DATA UP3
       TEXT 'UP3   '
* Calculate relative document-line
* looking backwards from last line in
* a paragraph to first line in another.
       DATA UP4
       TEXT 'UP4   '
* Look backwards beyond document start.
       DATA UP5
       TEXT 'UP5   '
* Calculate difference between lines
* in different paragraphs.
       DATA DIFF1
       TEXT 'DIFF1 '
* Calculate difference between lines
* in same paragraphs.
       DATA DIFF2
       TEXT 'DIFF2 '

* Calculate relative document-line 
* looking forwards within the same
* paragraph

* Calculate relative document-line
* looking forwards between 
* non-consecutive paragraphs.

* Calculate relative document-line
* looking forwards from first line in
* a paragraph to last line in another.

* Calculate relative document-line
* looking forwards from last line in
* a paragraph to first line in another.

* Look forwards past document end.

TSTEND
RSLTFL BYTE RSLTFE-RSLTFL-1
       TEXT 'DSK2.TESTRESULT.TXT'
RSLTFE
       EVEN
FAKEAD DATA >FFFE
*
ACTUPA BSS  2
ACTULN BSS  2

*
* Calculate relative document-line
* looking backwards within the same
* paragraph
*
UP1
* Arrange
       LI   R0,UP1L
       MOV  R0,@LINLST
* Act
* Let R0 = paragraph index
* Let R1 = line in paragraph index
* Let R2 = number of lines up/down
       LI   R0,2
       LI   R1,5
       LI   R2,4
       BLWP @LOOKUP
* Assert
       MOV  R0,@ACTUPA
       MOV  R1,@ACTULN
*
       LI   R0,2
       MOV  @ACTUPA,R1
       LI   R2,UPM1
       LI   R3,UPM1E-UPM1
       BLWP @AEQ
*
       LI   R0,1
       MOV  @ACTULN,R1
       LI   R2,UPM2
       LI   R3,UPM2E-UPM2
       BLWP @AEQ
       RT


UPM1   TEXT 'Paragraph wrong when looking '
       TEXT 'backwards.'
UPM1E  EVEN
UPM2   TEXT 'Paragraph-line wrong when '
       TEXT 'looking backwards.'
UPM2E
UPM3   TEXT 'Response should be -1 because '
       TEXT 'the request looks past the '
       TEXT 'beginning of the document.'
UPM3E  EVEN
*Line List
UP1L   DATA 4,1
       DATA FAKEAD
       DATA FAKEAD
       DATA UP1P1
       DATA FAKEAD
UP1LE
*A paragraph
UP1P1  DATA 70+66+69+72+67+71+24
       DATA UP1W1
       TEXT 'In the beg...end.'
       EVEN
*A wrap list
UP1W1  DATA 6,1
       DATA 70
       DATA 70+66
       DATA 70+66+69
       DATA 70+66+69+72
       DATA 70+66+69+72+67
       DATA 70+66+69+72+67+71

*
* Calculate relative document-line
* looking backwards between 
* non-consecutive paragraphs.
*
UP2
* Arrange
       LI   R0,UP2L
       MOV  R0,@LINLST
* Act
* Let R0 = paragraph index
* Let R1 = line in paragraph index
* Let R2 = number of lines up/down
       LI   R0,3
       LI   R1,2
       LI   R2,9
       BLWP @LOOKUP
* Assert
       MOV  R0,@ACTUPA
       MOV  R1,@ACTULN
*
       LI   R0,1
       MOV  @ACTUPA,R1
       LI   R2,UPM1
       LI   R3,UPM1E-UPM1
       BLWP @AEQ
*
       LI   R0,4
       MOV  @ACTULN,R1
       LI   R2,UPM2
       LI   R3,UPM2E-UPM2
       BLWP @AEQ
       RT
       
*
* Calculate relative document-line
* looking backwards from first line in
* a paragraph to last line in another.
*
UP3
* Arrange
       LI   R0,UP2L
       MOV  R0,@LINLST
* Act
* Let R0 = paragraph index
* Let R1 = line in paragraph index
* Let R2 = number of lines up/down
       LI   R0,3
       LI   R1,0
       LI   R2,5
       BLWP @LOOKUP
* Assert
       MOV  R0,@ACTUPA
       MOV  R1,@ACTULN
*
       LI   R0,1
       MOV  @ACTUPA,R1
       LI   R2,UPM1
       LI   R3,UPM1E-UPM1
       BLWP @AEQ
*
       LI   R0,6
       MOV  @ACTULN,R1
       LI   R2,UPM2
       LI   R3,UPM2E-UPM2
       BLWP @AEQ
       RT
       
*
* Calculate relative document-line
* looking backwards from last line in
* a paragraph to first line in another.
*
UP4
* Arrange
       LI   R0,UP2L
       MOV  R0,@LINLST
* Act
* Let R0 = paragraph index
* Let R1 = line in paragraph index
* Let R2 = number of lines up/down
       LI   R0,3
       LI   R1,5
       LI   R2,16
       BLWP @LOOKUP
* Assert
       MOV  R0,@ACTUPA
       MOV  R1,@ACTULN
*
       LI   R0,1
       MOV  @ACTUPA,R1
       LI   R2,UPM1
       LI   R3,UPM1E-UPM1
       BLWP @AEQ
*
       LI   R0,0
       MOV  @ACTULN,R1
       LI   R2,UPM2
       LI   R3,UPM2E-UPM2
       BLWP @AEQ
       RT
       
*
* Look backwards beyond document start.
*
UP5
* Arrange
       LI   R0,UP2L
       MOV  R0,@LINLST
* Act
* Let R0 = paragraph index
* Let R1 = line in paragraph index
* Let R2 = number of lines up/down
       LI   R0,2
       LI   R1,2
       LI   R2,22
       BLWP @LOOKUP
* Assert
* Let R0 = expected
* Let R1 = actual
       MOV  R0,R1
       LI   R0,>FFFF
       LI   R2,UPM3
       LI   R3,UPM3E-UPM3
       BLWP @AEQ
*
       RT

*Line List
UP2L   DATA 4,1
       DATA UP2P0
       DATA UP2P1
       DATA UP2P2
       DATA UP2P3
       DATA FAKEAD
       DATA FAKEAD
UP2LE
*paragraphs
UP2P0  DATA 68+71+9
       DATA UP2W0
       TEXT 'In the beg...end.'
       EVEN
UP2P1  DATA 70+66+69+72+67+71+24
       DATA UP2W1
       TEXT 'In the beg...end.'
       EVEN
UP2P2  DATA 69+71+65
       DATA UP2W2
       TEXT 'In the beg...end.'
       EVEN
UP2P3  DATA 70+68+72+69+66
       DATA UP2W3
       TEXT 'In the beg...end.'
       EVEN
*A wrap list
UP2W0  DATA 2,1
       DATA 68
       DATA 68+71
UP2W1  DATA 6,1
       DATA 70
       DATA 70+66
       DATA 70+66+69
       DATA 70+66+69+72
       DATA 70+66+69+72+67
       DATA 70+66+69+72+67+71
UP2W2  DATA 3,1
       DATA 69
       DATA 69+71
       DATA 69+71+65
UP2W3  DATA 5,1
       DATA 70
       DATA 70+68
       DATA 70+68+72
       DATA 70+68+72+69
       DATA 70+68+72+69+66

*
* Count the number of lines between two
* lines in different paragraphs.
* (Find the line difference)
*
DIFF1  
* Arrange
       LI   R0,UP2L
       MOV  R0,@LINLST
* Act
       LI   R0,1
       LI   R1,4
       LI   R2,3
       LI   R3,1
       BLWP @LNDIFF
* Assert
       MOV  R0,R1
       LI   R0,8
       LI   R2,DFFM1
       LI   R3,DFFM1E-DFFM1
       BLWP @AEQ
*
       RT
*
DFFM1  TEXT 'Line count is wrong.'
DFFM1E

*
* Count the number of lines between two
* lines in same paragraphs.
* (Find the line difference)
*
DIFF2
* Arrange
       LI   R0,UP2L
       MOV  R0,@LINLST
* Act
       LI   R0,1
       LI   R1,2
       LI   R2,1
       LI   R3,5
       BLWP @LNDIFF
* Assert
       MOV  R0,R1
       LI   R0,3
       LI   R2,DFFM1
       LI   R3,DFFM1E-DFFM1
       BLWP @AEQ
*
       RT

       END