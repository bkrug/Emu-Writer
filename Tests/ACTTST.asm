       DEF  TSTLST,RSLTFL
*
       REF  LINLST
       REF  PARINX,CHRPAX,LININX,CHRLIX
       REF  STSARW
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
TSTEND
RSLTFL BYTE RSLTFE-RSLTFL-1
       TEXT 'DSK2.TESTRESULT.TXT'
RSLTFE
       EVEN
FRAMRT DATA 0

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
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+57+40
       MOV  R0,@CHRPAX
       LI   R0,2
       MOV  R0,@LININX
       LI   R0,40
       MOV  R0,@CHRLIX
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
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+25
       MOV  R0,@CHRPAX
       LI   R0,1
       MOV  R0,@LININX
       LI   R0,25
       MOV  R0,@CHRLIX
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
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+57+48+56+3
       MOV  R0,@CHRPAX
       LI   R0,4
       MOV  R0,@LININX
       LI   R0,3
       MOV  R0,@CHRLIX
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
       MOV  R0,@LINLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,15
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@LININX
       LI   R0,15
       MOV  R0,@CHRLIX
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
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,5
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@LININX
       LI   R0,5
       MOV  R0,@CHRLIX
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
       MOV  R0,@LINLST
       LI   R0,1
       MOV  R0,@PARINX
       LI   R0,8
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@LININX
       LI   R0,8
       MOV  R0,@CHRLIX
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
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+57+48+51
       MOV  R0,@CHRPAX
       LI   R0,3
       MOV  R0,@LININX
       LI   R0,51
       MOV  R0,@CHRLIX
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
       MOV  R0,@LINLST
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
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,40
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@LININX
       LI   R0,40
       MOV  R0,@CHRLIX
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
       MOV  R0,@LINLST
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,15
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@LININX
       LI   R0,15
       MOV  R0,@CHRLIX
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
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+57+40
       MOV  R0,@CHRPAX
       LI   R0,2
       MOV  R0,@LININX
       LI   R0,40
       MOV  R0,@CHRLIX
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
* Move down within a paragraph.
*
DOWN1  MOV  R11,@FRAMRT
* Arrange
       LI   R0,DOC1
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+40
       MOV  R0,@CHRPAX
       LI   R0,1
       MOV  R0,@LININX
       LI   R0,40
       MOV  R0,@CHRLIX
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
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61
       MOV  R0,@CHRPAX
       LI   R0,1
       MOV  R0,@LININX
       LI   R0,0
       MOV  R0,@CHRLIX
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
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+57+48+56+24
       MOV  R0,@CHRPAX
       LI   R0,4
       MOV  R0,@LININX
       LI   R0,24
       MOV  R0,@CHRLIX
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
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+53
       MOV  R0,@CHRPAX
       LI   R0,1
       MOV  R0,@LININX
       LI   R0,53
       MOV  R0,@CHRLIX
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
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,61+57+48+56+57
       MOV  R0,@CHRPAX
       LI   R0,4
       MOV  R0,@LININX
       LI   R0,57
       MOV  R0,@CHRLIX
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
       MOV  R0,@LINLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,57+58+15
       MOV  R0,@CHRPAX
       LI   R0,2
       MOV  R0,@LININX
       LI   R0,15
       MOV  R0,@CHRLIX
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
       MOV  R0,@LINLST
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



       END