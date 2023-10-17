       DEF  TSTLST,RSLTFL
* Mock of code from LOOK.TXT
       DEF  LOOKUP,LNDIFF
* Assert Routine
       REF  AEQ,AZC,AOC
* Update visual position indicators
       REF  POSUPD
* Document Status
       REF  STSWIN
* Vars
       REF  LINLST,MGNLST
       REF  PARINX,CHRPAX
       REF  LININX,CHRLIX
       REF  WINOFF,WINPAR,WINLIN
       REF  CURSCN

TSTLST DATA TSTEND-TSTLST-2/8
* Calculate LININX and CHRLIX
* based on PARINX and CHRPAX
       DATA POS1
       TEXT 'POS1  '
* Calculate LININX and CHRLIX
* when cursor is at the beginning of
* paragraph.
       DATA POS2
       TEXT 'POS2  '
* Calculate LININX and CHRLIX
* when cursor is at the end of the
* paragraph.
       DATA POS3
       TEXT 'POS3  '
* Calculate LININX and CHRLIX
* when cursor is at the beginning of a
* line.
       DATA POS4
       TEXT 'POS4  '
* Calculate LININX and CHRLIX
* when cursor is at the end of a
* line.
       DATA POS5
       TEXT 'POS5  '
* Calculate LININX and CHRLIX
* based on first paragraph in the
* document.
       DATA POS6
       TEXT 'POS6  '
* Calculate LININX and CHRLIX
* based on last paragraph in the
* document.
       DATA POS7
       TEXT 'POS7  '
* Calculate LININX and CHRLIX
* based on only paragraph in the
* document.
       DATA POS8
       TEXT 'POS8  '
* Calculate LININX and CHRLIX
* based on a one-line paragraph.
       DATA POS9
       TEXT 'POS9  '
* Calculate LININX and CHRLIX
* based on an empty paragraph.
       DATA POSA
       TEXT 'POSA  '
* Calculate LININX and CHRLIX when
* cursor is on the first line of an
* indented paragraph.
       DATA POSB
       TEXT 'POSB  '
* Calculate LININX and CHRLIX when
* cursor is on the first line of an
* indented paragraph, and just past
* the right edge of the screen.
       DATA POSC
       TEXT 'POSC  '
* When CHRLIX is 12 and horizontal
* offset is 0, offset should not change.
       DATA HOF1
       TEXT 'HOF1  '
* When CHRLIX is 12 and horizontal
* offset is 20, offset should move left.
       DATA HOF2
       TEXT 'HOF2  '
* When CHRLIX is 12 and horizontal
* offset is 40, offset should move left.
       DATA HOF3
       TEXT 'HOF3  '
* When CHRLIX is 27 and horizontal
* offset is 0, offset should not change.
       DATA HOF4
       TEXT 'HOF4  '
* When CHRLIX is 27 and horizontal
* offset is 20, offset should not change.
       DATA HOF5
       TEXT 'HOF5  '
* When CHRLIX is 27 and horizontal
* offset is 40, offset should move left.
       DATA HOF6
       TEXT 'HOF6  '
* When CHRLIX is 66 and horizontal
* offset is 0, offset should move right.
       DATA HOF7
       TEXT 'HOF7  '
* When CHRLIX is 66 and horizontal
* offset is 20, offset should move right.
       DATA HOF8
       TEXT 'HOF8  '
* When CHRLIX is 66 and horizontal
* offset is 40, offset should not move.
       DATA HOF9
       TEXT 'HOF9  '
* When CHRLIX is 66 and horizontal
* offset is 60, offset should not move.
       DATA HOF10
       TEXT 'HOF10 '
* When CHRLIX is 59 and horizontal
* offset is 20, offset should not move.
       DATA HOF11
       TEXT 'HOF11 '
* When CHRLIX is 20 and horizontal
* offset is 20, offset should not move.
       DATA HOF12
       TEXT 'HOF12 '
* ---
* When cursor is at earlier paragraph
* than the screen's first paragraph, 
* scroll up.
       DATA WUP1
       TEXT 'WUP1  '
* When cursor is at a later paragraph
* than the screen, don't scroll up.
       DATA WUP2
       TEXT 'WUP2  '
* When the cursor and screen start at
* the same paragraph, but the cursor is
* on an earlier line, scroll up.
       DATA WUP3
       TEXT 'WUP3  '
* When the cursor and screen start at
* the same paragraph, but the cursor is
* on a later line, don't scroll up.
       DATA WUP4
       TEXT 'WUP4  '
* When the cursor and screen start at
* the same paragraph and line,
* don't scroll up.
       DATA WUP5
       TEXT 'WUP5  '
* ---
* When cursor-21 lines points to a 
* paragraph later than screen,
* scroll down.
       DATA WDWN1
       TEXT 'WDWN1 '
* When cursor-21 lines points to a 
* paragraph earlier than screen,
* don't scroll down.
       DATA WDWN2
       TEXT 'WDWN2 '
* When cursor-21 lines points to a 
* the same paragraph and a later line
* than the screen, scroll down.
       DATA WDWN3
       TEXT 'WDWN3 '
* When cursor-21 lines points to a 
* the same paragraph and a earlier line
* than the screen, don't scroll down.
       DATA WDWN4
       TEXT 'WDWN4 '
* When cursor-21 lines points to a 
* the same paragraph and same line
* as the screen, don't scroll down.
       DATA WDWN5
       TEXT 'WDWN5 '
* When cursor-21 lines points to before
* the document start, don't scroll up.
       DATA WDWN6
       TEXT 'WDWN6 '
* Calculate cursor's screen position
       DATA CUR1
       TEXT 'CUR1  '
TSTEND
RSLTFL BYTE RSLTFE-RSLTFL-1
       TEXT 'DSK2.TESTRESULT.TXT'
RSLTFE
       EVEN
FAKEAD DATA >FFFE

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
* Calculate LININX and CHRLIX
* based on PARINX and CHRPAX
*
POS1
* Arrange
       LI   R0,POS1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,53
       MOV  R0,@CHRPAX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,1
       MOV  @LININX,R1
       LI   R2,POS1MS
       LI   R3,POS1ME-POS1MS
       BLWP @AEQ
       LI   R0,8
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
       RT

*
* Calculate LININX and CHRLIX
* when cursor is at the beginning of
* paragraph.
*
POS2
       LI   R0,POS1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@CHRPAX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,0
       MOV  @LININX,R1
       LI   R2,POS1MS
       LI   R3,POS1ME-POS1MS
       BLWP @AEQ
*
       LI   R0,0
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
       RT

*
* Calculate LININX and CHRLIX
* when cursor is at the end of the
* paragraph.
*
POS3
       LI   R0,POS1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,45+41+45+46+33-1
       MOV  R0,@CHRPAX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,4
       MOV  @LININX,R1
       LI   R2,POS1MS
       LI   R3,POS1ME-POS1MS
       BLWP @AEQ
       LI   R0,32
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
       RT

*
* Calculate LININX and CHRLIX
* when cursor is at the beginning of a
* line.
*
POS4
       LI   R0,POS1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,45+41+45+46
       MOV  R0,@CHRPAX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,4
       MOV  @LININX,R1
       LI   R2,POS1MS
       LI   R3,POS1ME-POS1MS
       BLWP @AEQ
       LI   R0,0
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
       RT

*
* Calculate LININX and CHRLIX
* when cursor is at the end of a
* line.
*
POS5
       LI   R0,POS1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,45+41+45-1
       MOV  R0,@CHRPAX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,2
       MOV  @LININX,R1
       LI   R2,POS1MS
       LI   R3,POS1ME-POS1MS
       BLWP @AEQ
       LI   R0,44
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
       RT

POS1MS TEXT 'Incorrect index of line within paragraph.'
POS1ME EVEN
POS1NS TEXT 'Incorrect index of character within line.'
POS1NE EVEN
*Line List
POS1L  DATA 4,1
       DATA FAKEAD
       DATA FAKEAD
       DATA POS1P
       DATA FAKEAD
POS1LE
POS1P  DATA 45+41+45+46+33
       DATA POS1W
       TEXT 'The Phoenician alphabet is an alphabet (more '
       TEXT 'specifically, an abjad) consisting of 22 '
       TEXT 'consonant letters only, leaving vowel sounds '
       TEXT 'implicit, although certain late varieties use '
       TEXT 'matres lectionis for some vowels.'
       EVEN
POS1PE
POS1PP DATA 44+40+28
       DATA POS1WB
       TEXT 'abc ... xyz'
POS1W  DATA 4,1
       DATA 45
       DATA 45+41
       DATA 45+41+45
       DATA 45+41+45+46
POS1WB DATA 2,1
       DATA 44
       DATA 44+40

*
* Calculate LININX and CHRLIX
* based on first paragraph in the
* document.
*
POS6
       LI   R0,POS6L
       MOV  R0,@LINLST
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,90
       MOV  R0,@CHRPAX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,2
       MOV  @LININX,R1
       LI   R2,POS1MS
       LI   R3,POS1ME-POS1MS
       BLWP @AEQ
*
       LI   R0,4
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
       RT

*Line List
POS6L  DATA 3,1
       DATA POS6P
       DATA FAKEAD
       DATA FAKEAD
POS6LE
POS6P  DATA 45+41+45+46+33
       DATA POS6W
       TEXT 'The Phoenician alphabet is an alphabet (more '
       TEXT 'specifically, an abjad) consisting of 22 '
       TEXT 'consonant letters only, leaving vowel sounds '
       TEXT 'implicit, although certain late varieties use '
       TEXT 'matres lectionis for some vowels.'
       EVEN
POS6PE
POS6W  DATA 4,1
       DATA 45
       DATA 45+41
       DATA 45+41+45
       DATA 45+41+45+46
       
*
* Calculate LININX and CHRLIX
* based on last paragraph in the
* document.
*
POS7
       LI   R0,POS7L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,55
       MOV  R0,@CHRPAX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,1
       MOV  @LININX,R1
       LI   R2,POS1MS
       LI   R3,POS1ME-POS1MS
       BLWP @AEQ
*
       LI   R0,10
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
       RT

*Line List
POS7L  DATA 3,1
       DATA FAKEAD
       DATA FAKEAD
       DATA POS7P
POS7LE
POS7P  DATA 45+41+45+46+33
       DATA POS7W
       TEXT 'The Phoenician alphabet is an alphabet (more '
       TEXT 'specifically, an abjad) consisting of 22 '
       TEXT 'consonant letters only, leaving vowel sounds '
       TEXT 'implicit, although certain late varieties use '
       TEXT 'matres lectionis for some vowels.'
       EVEN
POS7PE
POS7W  DATA 4,1
       DATA 45
       DATA 45+41
       DATA 45+41+45
       DATA 45+41+45+46
       
*
* Calculate LININX and CHRLIX
* based on only paragraph in the
* document.
*
POS8
       LI   R0,POS8L
       MOV  R0,@LINLST
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,45+41+17
       MOV  R0,@CHRPAX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,2
       MOV  @LININX,R1
       LI   R2,POS1MS
       LI   R3,POS1ME-POS1MS
       BLWP @AEQ
*
       LI   R0,17
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
       RT

*Line List
POS8L  DATA 1,1
       DATA POS8P
POS8LE
POS8P  DATA 45+41+45+46+33
       DATA POS8W
       TEXT 'The Phoenician alphabet is an alphabet (more '
       TEXT 'specifically, an abjad) consisting of 22 '
       TEXT 'consonant letters only, leaving vowel sounds '
       TEXT 'implicit, although certain late varieties use '
       TEXT 'matres lectionis for some vowels.'
       EVEN
POS8PE
POS8W  DATA 4,1
       DATA 45
       DATA 45+41
       DATA 45+41+45
       DATA 45+41+45+46
       
*
* Calculate LININX and CHRLIX
* based on a one-line paragraph.
*
POS9
       LI   R0,POS9L
       MOV  R0,@LINLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,6
       MOV  R0,@CHRPAX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,0
       MOV  @LININX,R1
       LI   R2,POS1MS
       LI   R3,POS1ME-POS1MS
       BLWP @AEQ
       LI   R0,6
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
       RT
       
*Line List
POS9L  DATA 6,1
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA POS9P
       DATA FAKEAD
       DATA FAKEAD
POS9LE
POS9P  DATA 11
       DATA POS9W
       TEXT 'Jesus wept.'
       EVEN
POS9PE
POS9W  DATA 0,1

*
* Calculate LININX and CHRLIX
* based on an empty paragraph.
*
POSA
       LI   R0,POSAL
       MOV  R0,@LINLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@CHRPAX
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,0
       MOV  @LININX,R1
       LI   R2,POS1MS
       LI   R3,POS1ME-POS1MS
       BLWP @AEQ
       LI   R0,0
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
       RT
       
*Line List
POSAL  DATA 6,1
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA POSAP
       DATA FAKEAD
       DATA FAKEAD
POSALE
POSAP  DATA 11
       DATA POSAW
       TEXT ''
       EVEN
POSAPE
POSAW  DATA 0,1

*
* Calculate LININX and CHRLIX
* when cursor is at the beginning of a
* line.
*
POSB
       LI   R0,POS1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,2
       MOV  R0,@CHRPAX
       LI   R0,MGN5
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,0
       MOV  @LININX,R1
       LI   R2,POS1MS
       LI   R3,POS1ME-POS1MS
       BLWP @AEQ
       LI   R0,2+5
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
       RT

*
* Calculate LININX and CHRLIX
* when cursor is at the beginning of a
* line.
*
POSC
       LI   R0,POS1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,38
       MOV  R0,@CHRPAX
       LI   R0,MGN5
       MOV  R0,@MGNLST
       CLR  @WINOFF
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,0
       MOV  @LININX,R1
       LI   R2,POS1MS
       LI   R3,POS1ME-POS1MS
       BLWP @AEQ
       LI   R0,38+5
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
       LI   R0,20
       MOV  @WINOFF,R1
       LI   R2,OFRGT
       LI   R3,OFRGTE-OFRGT
       BLWP @AEQ
       RT

*
* When CHRLIX is 12 and horizontal
* offset is 0, offset should not change.
*
HOF1
* Arrange
       LI   R0,HOF1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,112
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window
* didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,0
       MOV  @WINOFF,R1
       LI   R2,OFCNS
       LI   R3,OFCNSE-OFCNS
       BLWP @AEQ
       RT
       
*
* When CHRLIX is 12 and horizontal
* offset is 20, offset should move left.
*
HOF2
* Arrange
       LI   R0,HOF1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,112
       MOV  R0,@CHRPAX
       LI   R0,20
       MOV  R0,@WINOFF
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window moved
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINN
       LI   R3,MWINNE-MWINN
       BLWP @AOC
*
       LI   R0,0
       MOV  @WINOFF,R1
       LI   R2,OFLFT
       LI   R3,OFLFTE-OFLFT
       BLWP @AEQ
       RT
       
*
* When CHRLIX is 12 and horizontal
* offset is 40, offset should move left.
*
HOF3
* Arrange
       LI   R0,HOF1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,112
       MOV  R0,@CHRPAX
       LI   R0,40
       MOV  R0,@WINOFF
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window moved
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINN
       LI   R3,MWINNE-MWINN
       BLWP @AOC
*
       LI   R0,0
       MOV  @WINOFF,R1
       LI   R2,OFLFT
       LI   R3,OFLFTE-OFLFT
       BLWP @AEQ
       RT       

*
* When CHRLIX is 27 and horizontal
* offset is 0, offset should not change.
*
HOF4
* Arrange
       LI   R0,HOF1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,127
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window
* didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,0
       MOV  @WINOFF,R1
       LI   R2,OFCNS
       LI   R3,OFCNSE-OFCNS
       BLWP @AEQ
       RT
       
*
* When CHRLIX is 27 and horizontal
* offset is 20, offset should not change.
*
HOF5
* Arrange
       LI   R0,HOF1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,127
       MOV  R0,@CHRPAX
       LI   R0,20
       MOV  R0,@WINOFF
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window
* didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,20
       MOV  @WINOFF,R1
       LI   R2,OFCNS
       LI   R3,OFCNSE-OFCNS
       BLWP @AEQ
       RT       

*
* When CHRLIX is 27 and horizontal
* offset is 40, offset should move left.
*
HOF6
* Arrange
       LI   R0,HOF1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,127
       MOV  R0,@CHRPAX
       LI   R0,40
       MOV  R0,@WINOFF
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window moved
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINN
       LI   R3,MWINNE-MWINN
       BLWP @AOC
*
       LI   R0,20
       MOV  @WINOFF,R1
       LI   R2,OFLFT
       LI   R3,OFLFTE-OFLFT
       BLWP @AEQ
       RT

*
* When CHRLIX is 66 and horizontal
* offset is 0, offset should move right.
*
HOF7
* Arrange
       LI   R0,HOF1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,166
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window moved
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINN
       LI   R3,MWINNE-MWINN
       BLWP @AOC
*
       LI   R0,40
       MOV  @WINOFF,R1
       LI   R2,OFRGT
       LI   R3,OFRGTE-OFRGT
       BLWP @AEQ
       RT

*
* When CHRLIX is 66 and horizontal
* offset is 20, offset should move right.
*
HOF8
* Arrange
       LI   R0,HOF1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,166
       MOV  R0,@CHRPAX
       LI   R0,20
       MOV  R0,@WINOFF
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window moved
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINN
       LI   R3,MWINNE-MWINN
       BLWP @AOC
*
       LI   R0,40
       MOV  @WINOFF,R1
       LI   R2,OFRGT
       LI   R3,OFRGTE-OFRGT
       BLWP @AEQ
       RT

*
* When CHRLIX is 66 and horizontal
* offset is 40, offset should not move.
*
HOF9
* Arrange
       LI   R0,HOF1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,166
       MOV  R0,@CHRPAX
       LI   R0,40
       MOV  R0,@WINOFF
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window
* didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,40
       MOV  @WINOFF,R1
       LI   R2,OFCNS
       LI   R3,OFCNSE-OFCNS
       BLWP @AEQ
       RT
       
*
* When CHRLIX is 66 and horizontal
* offset is 60, offset should not move.
*
HOF10
* Arrange
       LI   R0,HOF1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,166
       MOV  R0,@CHRPAX
       LI   R0,60
       MOV  R0,@WINOFF
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window
* didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,60
       MOV  @WINOFF,R1
       LI   R2,OFCNS
       LI   R3,OFCNSE-OFCNS
       BLWP @AEQ
       RT    

*
* When CHRLIX is 59 and horizontal
* offset is 20, offset should not move.
*
HOF11
* Arrange
       LI   R0,HOF1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,159
       MOV  R0,@CHRPAX
       LI   R0,20
       MOV  R0,@WINOFF
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window
* didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,20
       MOV  @WINOFF,R1
       LI   R2,OFCNS
       LI   R3,OFCNSE-OFCNS
       BLWP @AEQ
       RT           

*
* When CHRLIX is 20 and horizontal
* offset is 20, offset should not move.
*
HOF12
* Arrange
       LI   R0,HOF1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,120
       MOV  R0,@CHRPAX
       LI   R0,20
       MOV  R0,@WINOFF
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window
* didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,20
       MOV  @WINOFF,R1
       LI   R2,OFCNS
       LI   R3,OFCNSE-OFCNS
       BLWP @AEQ
       RT           

OFLFT  TEXT 'Horizontal offset should have moved left.'
OFLFTE 
OFCNS  TEXT 'Horizontal offset should not have changed.'
OFCNSE 
OFRGT  TEXT 'Horizontal offset should have moved right.'
OFRGTE 
MWINM  TEXT 'Window should not have moved.'
MWINME
MWINN  TEXT 'Window should have moved.'
MWINNE EVEN

*Line List
HOF1L  DATA 4,1
       DATA FAKEAD
       DATA FAKEAD
       DATA HOF1P
       DATA FAKEAD
HOF1LE
HOF1P  DATA 100+73
       DATA HOF1W
       TEXT '++++5++++1++++5++++2++++5++++3'
       TEXT '++++5++++4++++5++++5++++5++++6'
       TEXT '++++5++++7++++5++++8++++5++++9'
       TEXT '++++5++++ '
       TEXT 'Play-fighting is fun for many puppies '
       TEXT 'and helps them bond with other dogs.'
       EVEN
HOF1PE
HOF1W  DATA 1,1
       DATA 100

*
* When cursor is at earlier paragraph
* than the screen's first paragraph, 
* scroll up.
*
WUP1
* Arrange
       LI   R0,UP1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
* Line 3
       LI   R0,69+71+65+10
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,3
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window moved
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINN
       LI   R3,MWINNE-MWINN
       BLWP @AOC
*
       LI   R0,2
       MOV  @WINPAR,R1
       LI   R2,WUPM1
       LI   R3,WUPM1E-WUPM1
       BLWP @AEQ
*
       LI   R0,3
       MOV  @WINLIN,R1
       LI   R2,WUPM2
       LI   R3,WUPM2E-WUPM2
       BLWP @AEQ
       RT

*
* When cursor is at a later paragraph
* than the screen, don't scroll up.
*
WUP2
* Arrange
       LI   R0,UP1L
       MOV  R0,@LINLST
       LI   R0,2
       MOV  R0,@PARINX
* Line 3
       LI   R0,69+71+65+10
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,2
       MOV  R0,@WINPAR
       LI   R0,2
       MOV  R0,@WINLIN
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window
* didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,2
       MOV  @WINPAR,R1
       LI   R2,WUPM1
       LI   R3,WUPM1E-WUPM1
       BLWP @AEQ
*
       LI   R0,2
       MOV  @WINLIN,R1
       LI   R2,WUPM2
       LI   R3,WUPM2E-WUPM2
       BLWP @AEQ
       RT

*
* When the cursor and screen start at
* the same paragraph, but the cursor is
* on an earlier line, scroll up.
*
WUP3
* Arrange
       LI   R0,UP1L
       MOV  R0,@LINLST
       LI   R0,1
       MOV  R0,@PARINX
* Line Index 5
       LI   R0,70+66+69+72+67+3
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,6
       MOV  R0,@WINLIN
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window moved
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINN
       LI   R3,MWINNE-MWINN
       BLWP @AOC
*
       LI   R0,1
       MOV  @WINPAR,R1
       LI   R2,WUPM1
       LI   R3,WUPM1E-WUPM1
       BLWP @AEQ
*
       LI   R0,5
       MOV  @WINLIN,R1
       LI   R2,WUPM2
       LI   R3,WUPM2E-WUPM2
       BLWP @AEQ
       RT

*
* When the cursor and screen start at
* the same paragraph, but the cursor is
* on a later line, don't scroll up.
*
WUP4
* Arrange
       LI   R0,UP1L
       MOV  R0,@LINLST
       LI   R0,1
       MOV  R0,@PARINX
* Line Index 5
       LI   R0,70+66+69+72+67+3
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,4
       MOV  R0,@WINLIN
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window
* didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,1
       MOV  @WINPAR,R1
       LI   R2,WUPM1
       LI   R3,WUPM1E-WUPM1
       BLWP @AEQ
*
       LI   R0,4
       MOV  @WINLIN,R1
       LI   R2,WUPM2
       LI   R3,WUPM2E-WUPM2
       BLWP @AEQ
       RT

*
* When the cursor and screen start at
* the same paragraph and line,
* don't scroll up.
*
WUP5
* Arrange
       LI   R0,UP1L
       MOV  R0,@LINLST
       LI   R0,1
       MOV  R0,@PARINX
* Line Index 5
       LI   R0,70+66+69+72+67+3
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,5
       MOV  R0,@WINLIN
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window
* didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,1
       MOV  @WINPAR,R1
       LI   R2,WUPM1
       LI   R3,WUPM1E-WUPM1
       BLWP @AEQ
*
       LI   R0,5
       MOV  @WINLIN,R1
       LI   R2,WUPM2
       LI   R3,WUPM2E-WUPM2
       BLWP @AEQ
       RT

WUPM1  TEXT 'Window Paragraph Index was '
       TEXT 'updated correctly.'
WUPM1E
WUPM2  TEXT 'Window Paragraph-Line index '
       TEXT 'was not updated correctly.'
WUPM2E
*Line List
UP1L   DATA 4,1
       DATA UP1P0
       DATA UP1P1
       DATA UP1P2
       DATA UP1P3
       DATA FAKEAD
       DATA FAKEAD
UP1LE
*paragraphs
UP1P0  DATA 68+71+9
       DATA UP1W0
       TEXT 'In the beg...end.'
       EVEN
UP1P1  DATA 70+66+69+72+67+71+24
       DATA UP1W1
       TEXT 'In the beg...end.'
       EVEN
UP1P2  DATA 69+71+65+42
       DATA UP1W2
       TEXT 'In the beg...end.'
       EVEN
UP1P3  DATA 70+68+72+69+66+4
       DATA UP1W3
       TEXT 'In the beg...end.'
       EVEN
*A wrap list
UP1W0  DATA 2,1
       DATA 68
       DATA 68+71
UP1W1  DATA 6,1
       DATA 70
       DATA 70+66
       DATA 70+66+69
       DATA 70+66+69+72
       DATA 70+66+69+72+67
       DATA 70+66+69+72+67+71
UP1W2  DATA 3,1
       DATA 69
       DATA 69+71
       DATA 69+71+65
UP1W3  DATA 5,1
       DATA 70
       DATA 70+68
       DATA 70+68+72
       DATA 70+68+72+69
       DATA 70+68+72+69+66

* Mock of LOOKUP
MCKPAR DATA 0
MCKLIN DATA 0
LOOKWS BSS  >20
LOOKUP DATA LOOKWS,LOOKUP+4
* If current test did not specify
* mock values, then just use currently
* defined WINPAR and WINLIN, so that
* no scroll down occurs.
       MOV  @WINPAR,*R13
       MOV  @WINLIN,@2(13)
       MOV  @MCKPAR,@MCKPAR
       JEQ  LOOKRT
* Assert that the caller is looking
* backwards by one screen.
       LI   R0,21
       MOV  @4(R13),R1
       LI   R2,LOOKM
       LI   R3,LOOKME-LOOKM
       BLWP @AEQ
* Pass mock return values
       MOV  @MCKPAR,*R13
       MOV  @MCKLIN,@2(13)
* Reset mock values
* Next test may not wish to mock this.
       CLR  @MCKPAR
       CLR  @MCKLIN
LOOKRT RTWP
*
LOOKM  TEXT 'The caller should try to look '
       TEXT 'back by 21 lines'
LOOKME EVEN

*
* When cursor-21 lines points to a 
* paragraph later than screen,
* scroll down.
*
WDWN1  
* Arrange
       LI   R0,UP1L
       MOV  R0,@LINLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@CHRPAX
* Pretend that this paragraph and line
* are 21 lines before the cursor
       LI   R0,2
       MOV  R0,@MCKPAR
       LI   R0,0
       MOV  R0,@MCKLIN
* Pretend that this is the first line
* and paragraph on screen.
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,2
       MOV  R0,@WINLIN       
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window moved
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINN
       LI   R3,MWINNE-MWINN
       BLWP @AOC
*
       LI   R0,2
       MOV  @WINPAR,R1
       LI   R2,WUPM1
       LI   R3,WUPM1E-WUPM1
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINLIN,R1
       LI   R2,WUPM2
       LI   R3,WUPM2E-WUPM2
       BLWP @AEQ
       RT

*
* When cursor-21 lines points to a 
* paragraph earlier than screen,
* don't scroll down.
*
WDWN2
* Arrange
       LI   R0,UP1L
       MOV  R0,@LINLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@CHRPAX
* Pretend that this paragraph and line
* are 21 lines before the cursor
       LI   R0,1
       MOV  R0,@MCKPAR
       LI   R0,2
       MOV  R0,@MCKLIN
* Pretend that this is the first line
* and paragraph on screen.
       LI   R0,2
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN       
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window
* didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,2
       MOV  @WINPAR,R1
       LI   R2,WUPM1
       LI   R3,WUPM1E-WUPM1
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINLIN,R1
       LI   R2,WUPM2
       LI   R3,WUPM2E-WUPM2
       BLWP @AEQ
       RT

*
* When cursor-21 lines points to a 
* the same paragraph and a later line
* than the screen, scroll down.
*
WDWN3
* Arrange
       LI   R0,UP1L
       MOV  R0,@LINLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@CHRPAX
* Pretend that this paragraph and line
* are 21 lines before the cursor
       LI   R0,1
       MOV  R0,@MCKPAR
       LI   R0,3
       MOV  R0,@MCKLIN
* Pretend that this is the first line
* and paragraph on screen.
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,1
       MOV  R0,@WINLIN       
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window moved
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINN
       LI   R3,MWINNE-MWINN
       BLWP @AOC
*
       LI   R0,1
       MOV  @WINPAR,R1
       LI   R2,WUPM1
       LI   R3,WUPM1E-WUPM1
       BLWP @AEQ
*
       LI   R0,3
       MOV  @WINLIN,R1
       LI   R2,WUPM2
       LI   R3,WUPM2E-WUPM2
       BLWP @AEQ
       RT

*
* When cursor-21 lines points to a 
* the same paragraph and a earlier line
* than the screen, don't scroll down.
*
WDWN4
* Arrange
       LI   R0,UP1L
       MOV  R0,@LINLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@CHRPAX
* Pretend that this paragraph and line
* are 21 lines before the cursor
       LI   R0,0
       MOV  R0,@MCKPAR
       LI   R0,2
       MOV  R0,@MCKLIN
* Pretend that this is the first line
* and paragraph on screen.
       LI   R0,0
       MOV  R0,@WINPAR
       LI   R0,3
       MOV  R0,@WINLIN       
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window
* didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,0
       MOV  @WINPAR,R1
       LI   R2,WUPM1
       LI   R3,WUPM1E-WUPM1
       BLWP @AEQ
*
       LI   R0,3
       MOV  @WINLIN,R1
       LI   R2,WUPM2
       LI   R3,WUPM2E-WUPM2
       BLWP @AEQ
       RT

*
* When cursor-21 lines points to a 
* the same paragraph and same line
* as the screen, don't scroll down.
*
WDWN5
* Arrange
       LI   R0,UP1L
       MOV  R0,@LINLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@CHRPAX
* Pretend that this paragraph and line
* are 21 lines before the cursor
       LI   R0,1
       MOV  R0,@MCKPAR
       LI   R0,4
       MOV  R0,@MCKLIN
* Pretend that this is the first line
* and paragraph on screen.
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,4
       MOV  R0,@WINLIN       
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window
* didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,1
       MOV  @WINPAR,R1
       LI   R2,WUPM1
       LI   R3,WUPM1E-WUPM1
       BLWP @AEQ
*
       LI   R0,4
       MOV  @WINLIN,R1
       LI   R2,WUPM2
       LI   R3,WUPM2E-WUPM2
       BLWP @AEQ
       RT
	   
* When cursor-21 lines points to before
* the document start, don't scroll up.
WDWN6
* Arrange
       LI   R0,UP1L
       MOV  R0,@LINLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,3
       MOV  R0,@CHRPAX
* Pretend that this paragraph and line
* are 21 lines before the cursor
       LI   R0,-1
       MOV  R0,@MCKPAR
       LI   R0,0
       MOV  R0,@MCKLIN
* Pretend that this is the first line
* and paragraph on screen.
       LI   R0,0
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN       
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window
* didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,0
       MOV  @WINPAR,R1
       LI   R2,WUPM1
       LI   R3,WUPM1E-WUPM1
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINLIN,R1
       LI   R2,WUPM2
       LI   R3,WUPM2E-WUPM2
       BLWP @AEQ
       RT

*Line List
CUR1L  DATA 4,1
       DATA CUR1P0
       DATA CUR1P1
       DATA CUR1P2
       DATA CUR1P3
       DATA FAKEAD
       DATA FAKEAD
CUR1LE
*paragraphs
CUR1P0 DATA 68+71+9
       DATA CUR1W0
       TEXT 'In the beg...end.'
       EVEN
CUR1P1 DATA 70+66+69+72+67+71+24
       DATA CUR1W1
       TEXT 'In the beg...end.'
       EVEN
CUR1P2 DATA 69+71+65+42
       DATA CUR1W2
       TEXT 'In the beg...end.'
       EVEN
CUR1P3 DATA 70+68+72+69+66+4
       DATA CUR1W3
       TEXT 'In the beg...end.'
       EVEN
*A wrap list
CUR1W0 DATA 2,1
       DATA 68
       DATA 68+71
CUR1W1 DATA 6,1
       DATA 70
       DATA 70+66
       DATA 70+66+69
       DATA 70+66+69+72
       DATA 70+66+69+72+67
       DATA 70+66+69+72+67+71
CUR1W2 DATA 3,1
       DATA 69
       DATA 69+71
       DATA 69+71+65
CUR1W3 DATA 5,1
       DATA 70
       DATA 70+68
       DATA 70+68+72
       DATA 70+68+72+69
       DATA 70+68+72+69+66
WCURM  TEXT 'Cursors position on screen is wrong.'
WCURME EVEN

* Mock of LNDIFF
MCKCNT DATA 0
LNDIFF DATA LOOKWS,LNDIFF+4
* If current test did not specify
* mock values, then return 0.
       CLR  *R13
       MOV  @MCKCNT,@MCKCNT
       JEQ  DIFFRT
* Pass mock return values
       MOV  @MCKCNT,*R13
* Reset mock values
* Next test may not wish to mock this.
       CLR  @MCKCNT
DIFFRT RTWP

* Calculate cursor's screen position
CUR1
* Arrange
       LI   R0,UP1L
       MOV  R0,@LINLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,70+68+47
       MOV  R0,@CHRPAX
	   LI   R0,20
	   MOV  R0,@WINOFF
* The screen starts on the third line
* of the first paragraph.
       LI   R0,0
       MOV  R0,@WINPAR
       LI   R0,2
       MOV  R0,@WINLIN       
* There should be 14 lines between
* Para 0 Line 2 & Para 3 Line 2
       LI   R0,14
	   MOV  R0,@MCKCNT
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,47
	   MOV  @CHRLIX,R1
       LI   R2,WCURM
       LI   R3,7
       BLWP @AEQ
       LI   R0,20
	   MOV  @WINOFF,R1
       LI   R2,WCURM
       LI   R3,14
       BLWP @AEQ
* Cursor should be at 15th row of text,
* 17th row on screen, 27th column
       LI   R0,16*40+27
       MOV  @CURSCN,R1
       LI   R2,WCURM
       LI   R3,WCURME-WCURM
       BLWP @AEQ
*
       RT

       END