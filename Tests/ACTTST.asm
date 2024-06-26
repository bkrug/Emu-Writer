       DEF  TSTLST,RSLTFL
*
       REF  PARLST,MGNLST
       REF  PARINX,CHRPAX
       REF  WINPAR,WINLIN,WINMGN,PRFHRZ
       REF  STSARW,WINOFF
       REF  WINMOD
* Assert methods
       REF  AEQ,AOC
* Tested methods
       REF  UPUPSP,DOWNSP,PGUP,PGDOWN
       REF  NXTWIN

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
* Move down from indented to non-indented line
       DATA DOWN9
       TEXT 'DOWN9 '
* When PRFHRZ is non-negative and the cursor moves down one line,
* the new position will be PRFHRZ position (slightly to the left).
       DATA DOWN10
       TEXT 'DOWN10'
* When PRFHRZ is non-negative and the cursor moves down,
* the line is not long enought to reach PRFHRZ,
* but longer than the previous line,
* so the cursor moves to the end of the line.
       DATA DOWN11
       TEXT 'DOWN11'
* Scroll up. Cursor starts from the first line in some paragraph.
       DATA PGU1
       TEXT 'PGU1  '
* Scroll up. Cursor starts from the middle line in some paragraph.
       DATA PGU2
       TEXT 'PGU2  '
* Scroll up. Cursor starts from the last line in some paragraph.
* Window runs into the top of the screen.
       DATA PGU3
       TEXT 'PGU3  '
* Scroll up. Top of the screen originally shows a margin entry.
       DATA PGU4
       TEXT 'PGU4  '
* Scroll up. Top of the screen will ultimately show a margin entry.
       DATA PGU5
       TEXT 'PGU5  '
* Scroll up. Cursor runs into the beginning of the document.
       DATA PGU6
       TEXT 'PGU6  '
* Scroll up. Cursor can only scroll by 21 lines, otherwise it would land on a margin header.
       DATA PGU7
       TEXT 'PGU7  '
* Scroll down. Cursor starts from the first line in some paragraph.
       DATA PGD1
       TEXT 'PGD1  '
* Scroll down. Cursor starts from the middle line in some paragraph.
       DATA PGD2
       TEXT 'PGD2  '
* Scroll down. Cursor starts from the last line in some paragraph.
       DATA PGD3
       TEXT 'PGD3  '
* Scroll down. Top of the screen originally shows a margin entry.
       DATA PGD4
       TEXT 'PGD4  '
* Scroll down. Top of the screen will ultimately show a margin entry.
       DATA PGD5
       TEXT 'PGD5  '
* Scroll down. Cursor runs into the end of the document, but the top of the screen does not.
       DATA PGD6
       TEXT 'PGD6  '
* Scroll down. Cursor can only scroll by 21 lines, otherwise it would land on a margin header.
       DATA PGD7
       TEXT 'PGD7  '
* When mode is vertical mode, Next Window button does nothing.
       DATA NXWN1
       TEXT 'NXWN1 '
* When cursor can move 20 characters, both the cursor and the window move.
       DATA NXWN2
       TEXT 'NXWN2 '
* When the cursor is fewer than 20 characters from the line-end,
* but the window is more than 20 characters from the cursor,
* just the window moves.
       DATA NXWN3
       TEXT 'NXWN3 '
* When the window cannot move 20 characters without passing the cursor,
* the window moves to the first column, and the cursor moves left by the same amount.
       DATA NXWN4
       TEXT 'NXWN4 '
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
       DATA PARA,>00F8,>0A0A,>0A0A
*
* Margin List with 2 entries
*
MGN3ET DATA 2,3
       DATA PARC,>0000,>0A0A,>0A0A
       DATA PARF,>0000,>0A0A,>0A0A

**** Mock document ****

DOC1   DATA 8,1
       DATA PAR1A,PAR1B,PAR1C,PAR1D
       DATA PAR1E,PAR1F,PAR1G,PAR1H
PAR1A  DATA 56+60+59+25
       DATA WRP1A
       TEXT 'Beg..End'
* 4 lines
WRP1A  DATA 3,1
       DATA 56
       DATA 56+60
       DATA 56+60+59
PAR1B  DATA 32
       DATA WRP1B
       TEXT 'Beg..End'
* 1 line
WRP1B  DATA 0,1
PAR1C  DATA 61+57+48+56+60
       DATA WRP1C
       TEXT 'Beg..End'
* 6 lines (when including margin header)
WRP1C  DATA 4,1
       DATA 61
       DATA 61+57
       DATA 61+57+48
       DATA 61+57+48+56
PAR1D  DATA 57+58+40
       DATA WRP1D
       TEXT 'Beg..End'
* 3 lines
WRP1D  DATA 2,1
       DATA 57
       DATA 57+58
PAR1E  DATA 55+54+56+55+54+56+55+54+56+3
       DATA WRP1E
       TEXT 'Beg..End'
* 10 lines
WRP1E  DATA 9,1
       DATA 55
       DATA 55+54
       DATA 55+54+56
       DATA 55+54+56+55
       DATA 55+54+56+55+54
       DATA 55+54+56+55+54+56
       DATA 55+54+56+55+54+56+55
       DATA 55+54+56+55+54+56+55+54
       DATA 55+54+56+55+54+56+55+54+56
PAR1F  DATA 55+54+56+55+54+56+55+54+3
       DATA WRP1F
       TEXT 'Beg..End'
* 10 lines (including margin header)
WRP1F  DATA 8,1
       DATA 55
       DATA 55+54
       DATA 55+54+56
       DATA 55+54+56+55
       DATA 55+54+56+55+54
       DATA 55+54+56+55+54+56
       DATA 55+54+56+55+54+56+55
       DATA 55+54+56+55+54+56+55+54
PAR1G  DATA 55+54+56+55+54+56+55+54+56+55+3
       DATA WRP1G
       TEXT 'Beg..End'
* 12 lines
WRP1G  DATA 11,1
       DATA 55
       DATA 55+54
       DATA 55+54+56
       DATA 55+54+56+55
       DATA 55+54+56+55+54
       DATA 55+54+56+55+54+56
       DATA 55+54+56+55+54+56+55
       DATA 55+54+56+55+54+56+55+54
       DATA 55+54+56+55+54+56+55+54+56
       DATA 55+54+56+55+54+56+55+54+56+55
       DATA 55+54+56+55+54+56+55+54+56+55+54
PAR1H  DATA 57+58+40
       DATA WRP1H
       TEXT 'Beg..End'
* 3 lines
WRP1H  DATA 2,1
       DATA 57
       DATA 57+58

PARA   EQU  0
PARB   EQU  1
PARC   EQU  2
PARD   EQU  3
PARE   EQU  4
PARF   EQU  5
PARG   EQU  6
PARH   EQU  7

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
TYPME
WINM   TEXT 'Window paragraph is wrong.'
WINME
WINLM  TEXT 'Window paragraph-line is wrong.'
WINLME
WINMG  TEXT 'Window margin is wrong.'
WINMGE
WOFFM  TEXT 'Window offset is wrong.'
WOFFME
       EVEN

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
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* R0 of the caller's workspace is a
* document status byte
	LI   R13,MOCKWS
	CLR  *R13
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,MGN5
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,MGN5
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,MGN5
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,MGN5
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,MGN30
       MOV  R0,@MGNLST
       SETO @WINMOD
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,MGNHNG
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,7
       MOV  R0,@PARINX
       LI   R0,57+58+15
       MOV  R0,@CHRPAX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
* Act
       BL   @DOWNSP
* Assert
       LI   R0,7
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
* R0 of the caller's workspace is a
* document status byte
	LI   R13,MOCKWS
	CLR  *R13
       LI   R0,EMPLST
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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
       LI   R0,MGNHNG
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
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

*
* Move down from last line of a
* paragraph with a hanging indent
* to a non-indented line.
*
DOWN9  DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARC
       MOV  R0,@PARINX
       LI   R0,61+57+48+56+7      * This line has an 8-char indent
       MOV  R0,@CHRPAX
       LI   R0,MGNHNG
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
* Act
       BL   @DOWNSP
* Assert
       LI   R0,3
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
       MOV  *R10+,R11
       RT

*
* When PRFHRZ is non-negative and the cursor moves down one line,
* the new position will be PRFHRZ position (slightly to the left).
*
DOWN10 DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARD
       MOV  R0,@PARINX
       LI   R0,57+58        * This is the left-edge of line with an 8-char indent
       MOV  R0,@CHRPAX
       LI   R0,MGNHNG
       MOV  R0,@MGNLST
       LI   R0,0
       MOV  R0,@PRFHRZ
* Act
       BL   @DOWNSP
* Assert
       LI   R0,PARE
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,0           * Visually to the user this is further left than on the previous line
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* When PRFHRZ is non-negative and the cursor moves down,
* the line is not long enought to reach PRFHRZ,
* but longer than the previous line,
* so the cursor moves to the end of the line.
*
DOWN11 DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARC
       MOV  R0,@PARINX
       LI   R0,61+56                * End of second line
       MOV  R0,@CHRPAX
       LI   R0,MGNHNG
       MOV  R0,@MGNLST
       LI   R0,60
       MOV  R0,@PRFHRZ
* Act
       BL   @DOWNSP
* Assert
       LI   R0,PARC
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,61+57+47            * End of third line
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* Scroll up. Cursor starts from the first line in some paragraph.
*
PGU1   DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARF
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       LI   R0,0
       MOV  R0,@WINMGN
       LI   R0,PARG
       MOV  R0,@PARINX
       LI   R0,12
       MOV  R0,@CHRPAX
       LI   R0,MGN3ET
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
* Act
       BL   @PGUP
* Assert
       LI   R0,PARA
       MOV  @WINPAR,R1
       LI   R2,WINM
       LI   R3,WINME-WINM
       BLWP @AEQ
*
       LI   R0,3
       MOV  @WINLIN,R1
       LI   R2,WINLM
       LI   R3,WINLME-WINLM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINMGN,R1
       LI   R2,WINMG
       LI   R3,WINMGE-WINMG
       BLWP @AEQ
*
       LI   R0,PARD
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,57+12
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* Scroll down. Cursor starts from the middle line in some paragraph.
*
PGU2   DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARE
       MOV  R0,@WINPAR
       LI   R0,4
       MOV  R0,@WINLIN
       LI   R0,0
       MOV  R0,@WINMGN
       LI   R0,PARG
       MOV  R0,@PARINX
       LI   R0,55+54+56+55+54+12
       MOV  R0,@CHRPAX
       LI   R0,MGN3ET
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
* Act
       BL   @PGUP
* Assert
       LI   R0,PARA
       MOV  @WINPAR,R1
       LI   R2,WINM
       LI   R3,WINME-WINM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINLIN,R1
       LI   R2,WINLM
       LI   R3,WINLME-WINLM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINMGN,R1
       LI   R2,WINMG
       LI   R3,WINMGE-WINMG
       BLWP @AEQ
*
       LI   R0,PARE
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,55+54+56+12
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* Scroll down. Cursor starts from the last line in some paragraph.
* Window runs into the top of the screen.
*
PGU3   DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARD
       MOV  R0,@WINPAR
       LI   R0,2
       MOV  R0,@WINLIN
       LI   R0,0
       MOV  R0,@WINMGN
       LI   R0,PARF
       MOV  R0,@PARINX
       LI   R0,55+54+56+55+54+56+55+54+3
       MOV  R0,@CHRPAX
       LI   R0,MGN3ET
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
* Act
       BL   @PGUP
* Assert
       LI   R0,PARA
       MOV  @WINPAR,R1
       LI   R2,WINM
       LI   R3,WINME-WINM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINLIN,R1
       LI   R2,WINLM
       LI   R3,WINLME-WINLM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINMGN,R1
       LI   R2,WINMG
       LI   R3,WINMGE-WINMG
       BLWP @AEQ
*
       LI   R0,PARD
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,3
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* Scroll up. Top of the screen originally shows a margin entry.
*
PGU4   DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARF
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       LI   R0,-1
       MOV  R0,@WINMGN
       LI   R0,PARF
       MOV  R0,@PARINX
       LI   R0,55+54+56+55+54+56+55+54+3
       MOV  R0,@CHRPAX
       LI   R0,MGN3ET
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
* Act
       BL   @PGUP
* Assert
       LI   R0,PARA
       MOV  @WINPAR,R1
       LI   R2,WINM
       LI   R3,WINME-WINM
       BLWP @AEQ
*
       LI   R0,2
       MOV  @WINLIN,R1
       LI   R2,WINLM
       LI   R3,WINLME-WINLM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINMGN,R1
       LI   R2,WINMG
       LI   R3,WINMGE-WINMG
       BLWP @AEQ
*
       LI   R0,PARD
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,3
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* Scroll up. Top of the screen will ultimately show a margin entry.
*
PGU5   DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARF
       MOV  R0,@WINPAR
       LI   R0,2
       MOV  R0,@WINLIN
       LI   R0,0
       MOV  R0,@WINMGN
       LI   R0,PARF
       MOV  R0,@PARINX
       LI   R0,55+54+56+55+54+56+55+54+3
       MOV  R0,@CHRPAX
       LI   R0,MGN3ET
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
* Act
       BL   @PGUP
* Assert
       LI   R0,PARC
       MOV  @WINPAR,R1
       LI   R2,WINM
       LI   R3,WINME-WINM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINLIN,R1
       LI   R2,WINLM
       LI   R3,WINLME-WINLM
       BLWP @AEQ
*
       LI   R0,-1
       MOV  @WINMGN,R1
       LI   R2,WINMG
       LI   R3,WINMGE-WINMG
       BLWP @AEQ
*
       LI   R0,PARD
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,3
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* Scroll up. Cursor is runs into the beginning of the document.
*
PGU6   DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARB
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       LI   R0,0
       MOV  R0,@WINMGN
       LI   R0,PARC
       MOV  R0,@PARINX
       LI   R0,61+57+17
       MOV  R0,@CHRPAX
       LI   R0,MGN3ET
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
* Act
       BL   @PGUP
* Assert
       LI   R0,PARA
       MOV  @WINPAR,R1
       LI   R2,WINM
       LI   R3,WINME-WINM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINLIN,R1
       LI   R2,WINLM
       LI   R3,WINLME-WINLM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINMGN,R1
       LI   R2,WINMG
       LI   R3,WINMGE-WINMG
       BLWP @AEQ
*
       LI   R0,PARA
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,17
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* Scroll up. Cursor can only scroll by 21 lines, otherwise it would land on a margin header.
*
PGU7   DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARF
       MOV  R0,@WINPAR
       LI   R0,2
       MOV  R0,@WINLIN
       LI   R0,0
       MOV  R0,@WINMGN
       LI   R0,PARF
       MOV  R0,@PARINX
       LI   R0,55+54+2
       MOV  R0,@CHRPAX
       LI   R0,MGN3ET
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
* Act
       BL   @PGUP
* Assert
       LI   R0,PARC
       MOV  @WINPAR,R1
       LI   R2,WINM
       LI   R3,WINME-WINM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINLIN,R1
       LI   R2,WINLM
       LI   R3,WINLME-WINLM
       BLWP @AEQ
*
       LI   R0,-1
       MOV  @WINMGN,R1
       LI   R2,WINMG
       LI   R3,WINMGE-WINMG
       BLWP @AEQ
*
       LI   R0,PARC
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,2
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* Scroll down. Cursor starts from the first line in some paragraph.
*
PGD1   DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARB
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       LI   R0,0
       MOV  R0,@WINMGN
       LI   R0,PARE
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@CHRPAX
       LI   R0,MGN3ET
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
* Act
       BL   @PGDOWN
* Assert
       LI   R0,PARF
       MOV  @WINPAR,R1
       LI   R2,WINM
       LI   R3,WINME-WINM
       BLWP @AEQ
*
       LI   R0,1
       MOV  @WINLIN,R1
       LI   R2,WINLM
       LI   R3,WINLME-WINLM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINMGN,R1
       LI   R2,WINMG
       LI   R3,WINMGE-WINMG
       BLWP @AEQ
*
       LI   R0,PARG
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,55+54
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* Scroll down. Cursor starts from the middle line in some paragraph.
*
PGD2   DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARC
       MOV  R0,@WINPAR
       LI   R0,2
       MOV  R0,@WINLIN
       LI   R0,0
       MOV  R0,@WINMGN
       LI   R0,PARE
       MOV  R0,@PARINX
       LI   R0,55+54+56+55+54+42
       MOV  R0,@CHRPAX
       LI   R0,MGN3ET
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
* Act
       BL   @PGDOWN
* Assert
       LI   R0,PARF
       MOV  @WINPAR,R1
       LI   R2,WINM
       LI   R3,WINME-WINM
       BLWP @AEQ
*
       LI   R0,5
       MOV  @WINLIN,R1
       LI   R2,WINLM
       LI   R3,WINLME-WINLM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINMGN,R1
       LI   R2,WINMG
       LI   R3,WINMGE-WINMG
       BLWP @AEQ
*
       LI   R0,PARG
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,55+54+56+55+54+56+55+42
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* Scroll down. Cursor starts from the last line in some paragraph.
*
PGD3   DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARC
       MOV  R0,@WINPAR
       LI   R0,4
       MOV  R0,@WINLIN
       LI   R0,0
       MOV  R0,@WINMGN
       LI   R0,PARE
       MOV  R0,@PARINX
       LI   R0,55+54+56+55+54+56+55+54+56+1
       MOV  R0,@CHRPAX
       LI   R0,MGN3ET
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
* Act
       BL   @PGDOWN
* Assert
       LI   R0,PARF
       MOV  @WINPAR,R1
       LI   R2,WINM
       LI   R3,WINME-WINM
       BLWP @AEQ
*
       LI   R0,7
       MOV  @WINLIN,R1
       LI   R2,WINLM
       LI   R3,WINLME-WINLM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINMGN,R1
       LI   R2,WINMG
       LI   R3,WINMGE-WINMG
       BLWP @AEQ
*
       LI   R0,PARG
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,55+54+56+55+54+56+55+54+56+55+54+1
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* Scroll down. Top of the screen originally shows a margin entry.
*
PGD4   DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARC
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       LI   R0,-1
       MOV  R0,@WINMGN
       LI   R0,PARC
       MOV  R0,@PARINX
       LI   R0,14
       MOV  R0,@CHRPAX
       LI   R0,MGN3ET
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
       LI   R0,-1
       MOV  R0,@PRFHRZ
* Act
       BL   @PGDOWN
* Assert
       LI   R0,PARF
       MOV  @WINPAR,R1
       LI   R2,WINM
       LI   R3,WINME-WINM
       BLWP @AEQ
*
       LI   R0,2
       MOV  @WINLIN,R1
       LI   R2,WINLM
       LI   R3,WINLME-WINLM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINMGN,R1
       LI   R2,WINMG
       LI   R3,WINMGE-WINMG
       BLWP @AEQ
*
       LI   R0,PARF
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,55+54+56+14
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* Scroll down. Top of the screen will ultimately show a margin entry.
*
PGD5   DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARA
       MOV  R0,@WINPAR
       LI   R0,2
       MOV  R0,@WINLIN
       LI   R0,0
       MOV  R0,@WINMGN
       LI   R0,PARB
       MOV  R0,@PARINX
       LI   R0,17
       MOV  R0,@CHRPAX
       LI   R0,MGN3ET
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
* Act
       BL   @PGDOWN
* Assert
       LI   R0,PARF
       MOV  @WINPAR,R1
       LI   R2,WINM
       LI   R3,WINME-WINM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINLIN,R1
       LI   R2,WINLM
       LI   R3,WINLME-WINLM
       BLWP @AEQ
*
       LI   R0,-1
       MOV  @WINMGN,R1
       LI   R2,WINMG
       LI   R3,WINMGE-WINMG
       BLWP @AEQ
*
       LI   R0,PARF
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,55+17
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* Scroll down. Cursor runs into the end of the document, but the top of the screen does not.
*
PGD6   DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARF
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       LI   R0,-1
       MOV  R0,@WINMGN
       LI   R0,PARH
       MOV  R0,@PARINX
       LI   R0,43
       MOV  R0,@CHRPAX
       LI   R0,MGN3ET
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
* Act
       BL   @PGDOWN
* Assert
       LI   R0,PARH
       MOV  @WINPAR,R1
       LI   R2,WINM
       LI   R3,WINME-WINM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINLIN,R1
       LI   R2,WINLM
       LI   R3,WINLME-WINLM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINMGN,R1
       LI   R2,WINMG
       LI   R3,WINMGE-WINMG
       BLWP @AEQ
*
       LI   R0,PARH
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,57+58+40
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* Scroll down. Cursor can only scroll by 21 lines, otherwise it would land on a margin header.
*
PGD7   DECT R10
       MOV  R11,*R10
* Arrange
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,PARA
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       LI   R0,0
       MOV  R0,@WINMGN
       LI   R0,PARA
       MOV  R0,@PARINX
       LI   R0,56+17
       MOV  R0,@CHRPAX
       LI   R0,MGN3ET
       MOV  R0,@MGNLST
       LI   R0,-1
       MOV  R0,@PRFHRZ
* Act
       BL   @PGDOWN
* Assert
       LI   R0,PARE
       MOV  @WINPAR,R1
       LI   R2,WINM
       LI   R3,WINME-WINM
       BLWP @AEQ
*
       LI   R0,8
       MOV  @WINLIN,R1
       LI   R2,WINLM
       LI   R3,WINLME-WINLM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINMGN,R1
       LI   R2,WINMG
       LI   R3,WINMGE-WINMG
       BLWP @AEQ
*
       LI   R0,PARE
       MOV  @PARINX,R1
       LI   R2,PARM
       LI   R3,PARME-PARM
       BLWP @AEQ
*
       LI   R0,55+54+56+55+54+56+55+54+56+3
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* When mode is vertical mode, Next Window button does nothing.
*
NXWN1  DECT R10
       MOV  R11,*R10
* Arrange
       SETO @WINMOD
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,MGN5
       MOV  R0,@MGNLST
       LI   R0,PARA
       MOV  R0,@PARINX
       LI   R0,7             * There is a 5-char indent here
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
* Act
       BL   @NXTWIN
* Assert
       LI   R0,7             * Nothing changed
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINOFF,R1
       LI   R2,WOFFM
       LI   R3,WOFFME-WOFFM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* When cursor can move 20 characters, both the cursor and the window move.
*
NXWN2  DECT R10
       MOV  R11,*R10
* Arrange
       CLR  @WINMOD
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,MGN5
       MOV  R0,@MGNLST
       LI   R0,PARA
       MOV  R0,@PARINX
       LI   R0,7             * There is a 5-char indent here
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
* Act
       BL   @NXTWIN
* Assert
       LI   R0,27
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       LI   R0,20
       MOV  @WINOFF,R1
       LI   R2,WOFFM
       LI   R3,WOFFME-WOFFM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* When the cursor is fewer than 20 characters from the line-end,
* but the window is more than 20 characters from the cursor,
* just the window moves.
*
NXWN3  DECT R10
       MOV  R11,*R10
* Arrange
       CLR  @WINMOD
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,MGN5
       MOV  R0,@MGNLST
       LI   R0,PARA
       MOV  R0,@PARINX
       LI   R0,50             * This is horizontal position 55, due to index
       MOV  R0,@CHRPAX
       LI   R0,20
       MOV  R0,@WINOFF
* Act
       BL   @NXTWIN
* Assert
       LI   R0,50
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       LI   R0,40
       MOV  @WINOFF,R1
       LI   R2,WOFFM
       LI   R3,WOFFME-WOFFM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

*
* When the window cannot move 20 characters without passing the cursor,
* the window moves to the first column, and the cursor moves left by the same amount.
*
NXWN4  DECT R10
       MOV  R11,*R10
* Arrange
       CLR  @WINMOD
       LI   R0,DOC1
       MOV  R0,@PARLST
       LI   R0,MGN5
       MOV  R0,@MGNLST
       LI   R0,PARA
       MOV  R0,@PARINX
       LI   R0,50             * This is horizontal position 55, due to index
       MOV  R0,@CHRPAX
       LI   R0,40
       MOV  R0,@WINOFF
* Act
       BL   @NXTWIN
* Assert
       LI   R0,10
       MOV  @CHRPAX,R1
       LI   R2,CHRM
       LI   R3,CHRME-CHRM
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINOFF,R1
       LI   R2,WOFFM
       LI   R3,WOFFME-WOFFM
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

       END