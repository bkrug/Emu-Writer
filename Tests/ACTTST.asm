       DEF  TSTLST,RSLTFL
*
       REF  PARLST,MGNLST
       REF  PARINX,CHRPAX,LININX,CHRLIX
       REF  STSARW
       REF  WINMOD
* Assert methods
       REF  AEQ,AOC
* Tested methods
       REF  UPUPSP,DOWNSP

TSTLST DATA TSTEND-TSTLST-2/8
* Move from 3rd to 2nd line
       DATA UP1
       TEXT 'UP1   '
* Move from 2nd to 1st line
       DATA UP2
       TEXT 'UP2   '
* Move from bottom line
       DATA UP3
       TEXT 'UP3   '
* Move to previous paragraph
       DATA UP4
       TEXT 'UP4   '
* Move up to one-line paragraph
       DATA UP5
       TEXT 'UP5   '
* Move up from one-line paragraph
       DATA UP6
       TEXT 'UP6   '
* Move from 4th to 3rd line.
* 3rd line too short.
       DATA UP7
       TEXT 'UP7   '
* Move from bottom line.
* next line too short.
       DATA UP8
       TEXT 'UP8   '
* Move up to previous paragraph.
* next line too short.
       DATA UP9
       TEXT 'UP9   '
* Move up from first line in document
       DATA UP10
       TEXT 'UP10  '
* STSARW should be set to true
       DATA UP11
       TEXT 'UP11  '
* Move up to 1st line when paragraph is indented
       DATA UP12
       TEXT 'UP12  '
* Move up to 1st line when paragraph is indented.
* Cursor forced to the right
       DATA UP13
       TEXT 'UP13  '
* Move from 3rd to 2nd line.
* First line is indented, but indent does not effect 2nd line.
       DATA UP14
       TEXT 'UP14  '
* Move up to end of 1st line when paragraph is indented
       DATA UP15
       TEXT 'UP15  '
* Move up to 1st line when paragraph is indented
* by more than 20 chars in vertical mode.
       DATA UP16
       TEXT 'UP16  '
* Move to previous paragraph with hanging indent.
       DATA UP17
       TEXT 'UP17  '
* Move down within a paragraph.
       DATA DOWN1
       TEXT 'DOWN1 '
* Move down within a paragraph,
* left-most column
       DATA DOWN2
       TEXT 'DOWN2 '
* Move down to next paragraph.
       DATA DOWN3
       TEXT 'DOWN3 '
* Move down and left within a paragraph.
       DATA DOWN4
       TEXT 'DOWN4 '
* Move down and left to next paragraph.
       DATA DOWN5
       TEXT 'DOWN5 '
* Move down from last line in document
       DATA DOWN6
       TEXT 'DOWN6 '
* STSARW should be set to true
       DATA DOWN7
       TEXT 'DOWN7 '
* Move down from first line of hanging indent
       DATA DOWN8
       TEXT 'DOWN8 '
TSTEND
RSLTFL BYTE RSLTFE-RSLTFL-1
       TEXT 'DSK2.TESTRESULT.TXT'
RSLTFE
       EVEN
FRAMRT DATA 0

*
* Empty Margin List
*
EMPLST DATA 0,3
*
* Margin List with 5-char indent
*
MGN5   DATA 1,3
       DATA 0,>0005,>0A0A,>0A0A
*
* Margin List with 30-char indent
*
MGN30  DATA 1,3
       DATA 0,>001E,>0A0A,>0A0A
*
* Margin List with hanging indent
*
MGNHNG DATA 1,3
       DATA 0,>00F8,>0A0A,>0A0A

**** Mock document ****

DOC1   DATA 4,1
       DATA PAR1A,PAR1B,PAR1C,PAR1D
PAR1A  DATA 56+60+59+25
       DATA WRP1A
       TEXT 'Beg..End'
WRP1A  DATA 3,1
       DATA 56
       DATA 56+60
       DATA 56+60+59
PAR1B  DATA 32
       DATA WRP1B
       TEXT 'Beg..End'
WRP1B  DATA 0,1
PAR1C  DATA 61+57+48+56+60
       DATA WRP1C
       TEXT 'Beg..End'
WRP1C  DATA 4,1
       DATA 61
       DATA 61+57
       DATA 61+57+48
       DATA 61+57+48+56
PAR1D  DATA 57+58+40
       DATA WRP1D
       TEXT 'Beg..End'
WRP1D  DATA 2,1
       DATA 57
       DATA 57+58

* Mock return workspace address
MOCKWS DATA 0

PARM   TEXT 'Paragraph index is wrong.'
PARME
CHRM   TEXT 'Character index within '
       TEXT 'paragraph is wrong.'
CHRME
LINM   TEXT 'Line index within '
       TEXT 'paragraph is wrong.'
LINME
CHRLM  TEXT 'Character index within '
       TEXT 'is wrong.'
CHRLME
TYPM   TEXT 'STSARW should be set.'
TYPME  EVEN

*
* Move from third to second line in the
* same paragraph.
* Upper line is long enough so that
* cursor need not move left.
*
UP1    MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+57+40
       MOV  R0,@CHRPAX
       LI   R0,2
       MOV  R0,@LININX
       LI   R0,40
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @UPUPSP
* Assert
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,61+40
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move from second to first line in the
* same paragraph.
* Upper line is long enough so that
* cursor need not move left.
*
UP2    MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+25
       MOV  R0,@CHRPAX
       LI   R0,1
       MOV  R0,@LININX
       LI   R0,25
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @UPUPSP
* Assert
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,25
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move from bottom to second from
* bottom line in the same paragraph.
* Upper line is long enough so that
* cursor need not move left.
*
UP3    MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+57+48+56+3
       MOV  R0,@CHRPAX
       LI   R0,4
       MOV  R0,@LININX
       LI   R0,3
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @UPUPSP
* Assert
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,61+57+48+3
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move from one paragraph to previous
* paragraph.
* Upper line is long enough so that
* cursor need not move left.
*
UP4    MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,15
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@LININX
       LI   R0,15
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @UPUPSP
* Assert
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,61+57+48+56+15
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move up to one-line paragraph.
* Upper line is long enough so that
* cursor need not move left.
*
UP5    MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,5
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@LININX
       LI   R0,5
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @UPUPSP
* Assert
       LI   R0,1
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,5
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move up from one-line paragraph.
* Upper line is long enough so that
* cursor need not move left.
*
UP6    MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,1
       MOV  R0,@PARINX
       LI   R0,8
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@LININX
       LI   R0,8
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @UPUPSP
* Assert
       LI   R0,0
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,56+60+59+8
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move from fourth to third line in the
* same paragraph.
* New line too short.
*
UP7    MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+57+48+51
       MOV  R0,@CHRPAX
       LI   R0,3
       MOV  R0,@LININX
       LI   R0,51
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @UPUPSP
* Assert
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,61+57+48-1
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move from fourth to third line in the
* same paragraph.
* New line too short.
*
UP8    MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
* index 56 on 5th line.
* 4th line is shorter.
       LI   R0,61+57+48+56+56
       MOV  R0,@CHRPAX
       LI   R0,4
       MOV  R0,@LININX
       LI   R0,56
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @UPUPSP
* Assert
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,61+57+48+56-1
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move up to previous paragraph.
* New line too short.
*
UP9    MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,40
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@LININX
       LI   R0,40
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @UPUPSP
* Assert
       LI   R0,1
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
* Cursor should be one position past
* then end of the paragraph in order to
* add more characters at the end.
       LI   R0,32
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Attempt to move up from first line 
* in document, but don't go anywhere.
*
UP10   MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,15
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@LININX
       LI   R0,15
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @UPUPSP
* Assert
       LI   R0,0
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,15
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* STSARW should be set after moving
* the cursor up.
*
UP11   MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+57+40
       MOV  R0,@CHRPAX
       LI   R0,2
       MOV  R0,@LININX
       LI   R0,40
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* R0 of the caller's workspace is a
* document status byte
	LI   R13,MOCKWS
	CLR  *R13
* Act
       BL   @UPUPSP
* Assert
       MOV  @STSARW,R0
	   MOV  *R13,R1
       LI   R2,TYPM
       LI   R3,TYPME-TYPM
       BLWP @AOC
*
       MOV  @FRAMRT,R11
       RT

*
* Move from second to first line in the
* same paragraph.
* Paragraph's first line is indented.
*
UP12   MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+25
       MOV  R0,@CHRPAX
       LI   R0,1
       MOV  R0,@LININX
       LI   R0,25
       MOV  R0,@CHRLIX
       LI   R0,MGN5
       MOV  R0,@MGNLST
* Act
       BL   @UPUPSP
* Assert
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,25-5
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move from second to first line in the
* same paragraph.
* Paragraph's first line is indented.
* Cursor is not allowed to enter the indent.
*
UP13   MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+2
       MOV  R0,@CHRPAX
       LI   R0,1
       MOV  R0,@LININX
       LI   R0,2
       MOV  R0,@CHRLIX
       LI   R0,MGN5
       MOV  R0,@MGNLST
* Act
       BL   @UPUPSP
* Assert
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move from third to second line in the
* same paragraph.
* First line is indented, but that does
* not effect the 2nd line.
*
UP14   MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+57+40
       MOV  R0,@CHRPAX
       LI   R0,2
       MOV  R0,@LININX
       LI   R0,40
       MOV  R0,@CHRLIX
       LI   R0,MGN5
       MOV  R0,@MGNLST
* Act
       BL   @UPUPSP
* Assert
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,61+40
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move from second to end of first line
* in the same paragraph.
* Without indent 1st line is shorter
* than 2nd.
* With indent 1st line is longer than
* 2nd.
* Cursor should appear to user to go
* straight up.
*
UP15   MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,0
       MOV  R0,@PARINX
* 1st line has 56 characters without indent,
* 61 characters with indent.
* Cursor is at position 58 on 2nd line.
       LI   R0,56+58
       MOV  R0,@CHRPAX
       LI   R0,1
       MOV  R0,@LININX
       LI   R0,58
       MOV  R0,@CHRLIX
       LI   R0,MGN5
       MOV  R0,@MGNLST
* Act
       BL   @UPUPSP
* Assert
       LI   R0,0
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,58-5
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move from second to first line in the
* same paragraph.
* Paragraph's first line is indented by
* more than 20 characters.
* This is vertical mode so indent only
* appears to be 20 characters.
*
UP16   MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+25
       MOV  R0,@CHRPAX
       LI   R0,1
       MOV  R0,@LININX
       LI   R0,25
       MOV  R0,@CHRLIX
       LI   R0,MGN30
       MOV  R0,@MGNLST
       SETO @WINMOD
* Act
       BL   @UPUPSP
* Assert
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,25-20
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move from one paragraph to previous
* paragraph with hanging indent.
* Indent will force cursor right to the
* beginning of the line.
*
UP17   DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,6
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@LININX
       LI   R0,6
       MOV  R0,@CHRLIX
       LI   R0,MGNHNG
       MOV  R0,@MGNLST
* Act
       BL   @UPUPSP
* Assert
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,61+57+48+56
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* Move down within a paragraph.
*
DOWN1  MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+40
       MOV  R0,@CHRPAX
       LI   R0,1
       MOV  R0,@LININX
       LI   R0,40
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @DOWNSP
* Assert
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,61+57+40
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move down from leftmost column.
*
DOWN2  MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61
       MOV  R0,@CHRPAX
       LI   R0,1
       MOV  R0,@LININX
       LI   R0,0
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @DOWNSP
* Assert
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,61+57
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move down to next paragraph.
*
DOWN3  MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+57+48+56+24
       MOV  R0,@CHRPAX
       LI   R0,4
       MOV  R0,@LININX
       LI   R0,24
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @DOWNSP
* Assert
       LI   R0,3
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,24
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move down within a paragraph, but
* the next line is shorter and forces
* the cursor left.
*
DOWN4  MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+53
       MOV  R0,@CHRPAX
       LI   R0,1
       MOV  R0,@LININX
       LI   R0,53
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @DOWNSP
* Assert
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,61+57+48-1
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Move down to next paragraph, but
* the next line is shorter and forces
* the cursor left.
*
DOWN5  MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+57+48+56+57
       MOV  R0,@CHRPAX
       LI   R0,4
       MOV  R0,@LININX
       LI   R0,57
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @DOWNSP
* Assert
       LI   R0,3
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,57-1
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* Attempt to move down past end of 
* document, but don't go anywhere.
*
DOWN6  MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,57+58+15
       MOV  R0,@CHRPAX
       LI   R0,2
       MOV  R0,@LININX
       LI   R0,15
       MOV  R0,@CHRLIX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @DOWNSP
* Assert
       LI   R0,3
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,57+58+15
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  @FRAMRT,R11
       RT

*
* STSARW should be set after moving
* cursor down.
*
DOWN7  MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+40
       MOV  R0,@CHRPAX
       LI   R0,1
       MOV  R0,@LININX
       LI   R0,40
       MOV  R0,@CHRLIX
* R0 of the caller's workspace is a
* document status byte
	   LI   R13,MOCKWS
	   CLR  *R13
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       BL   @DOWNSP
* Assert
       MOV  @STSARW,R0
       MOV  *R13,R1
       LI   R2,TYPM
       LI   R3,TYPME-TYPM
       BLWP @AOC
*
       MOV  @FRAMRT,R11
       RT

*
* Move down from first line of a
* paragraph with a hanging indent.
* The cursor must move right so
* that it does not land in indent
* area.
*
DOWN8  DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,4
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@LININX
       LI   R0,4
       MOV  R0,@CHRLIX
       LI   R0,MGNHNG
       MOV  R0,@MGNLST
* Act
       BL   @DOWNSP
* Assert
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,61
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

       END