       DEF  TSTLST,RSLTFL
* Assert Routine
       REF  AEQ,AZC,AOC
* Update visual position indicators
       REF  POSUPD
* Document Status
       REF  STSWIN
* Vars
       REF  PARLST,MGNLST
       REF  PARINX,CHRPAX
       REF  LININX,CHRLIX
       REF  WINOFF,WINPAR,WINLIN,WINMGN
       REF  CURSCN,WINMOD

       COPY '../Src/EQUKEY.asm'

TSTLST DATA TSTEND-TSTLST-2/8
* SUSPECT: LININX and CHRLIX are just implementation details now.
*    Should we really have unit tests for their calculation?
*
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
* cursor is on the first line of a
* first-line indented paragraph.
       DATA POSB
       TEXT 'POSB  '
* Calculate LININX and CHRLIX when
* cursor is on the first line of a
* first-line indented paragraph, and
* just past the right edge of the screen.
       DATA POSC
       TEXT 'POSC  '
* Calculate LININX and CHRLIX
* when cursor is at the beginning of a
* line besides first line, in a
* first-line indented paragraph.
       DATA POSD
       TEXT 'POSD  '
* Calculate LININX and CHRLIX when
* cursor is on the first line of an
* indented paragraph, in vertical mode,
* and an index is larger than 20.
       DATA POSE
       TEXT 'POSE  '
* Calculate LININX and CHRLIX when
* cursor is on the second line of a
* hanging indented paragraph.
       DATA POSF
       TEXT 'POSF  '
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
* Presumably after switching to horizontal
* mode, WINLIN is not a valid line
* index. Assert that it is changed to
* the maximum valid line.
       DATA WUP6
       TEXT 'WUP6  '
* ---
* Top of screen displays paragraph 2, line 0
* The cursor is on the bottom row of the screen.
* The cursor is on the first line of a paragraph.
* Expect: The screen should not scroll down.
       DATA WDWN1
       TEXT 'WDWN1 '
* Top of screen displays paragraph 1, line 0
* The cursor is on the bottom row of the screen.
* The cursor is in the middle line of a paragraph.
* Expect: The screen should not scroll down.
       DATA WDWN2
       TEXT 'WDWN2 '
* Top of screen displays paragraph 1, line 0
* The cursor is on the bottom row of the screen.
* The cursor is in the last line of a paragraph.
* Expect: The screen should not scroll down.
       DATA WDWN3
       TEXT 'WDWN3 '
* Top of screen displays paragraph 2, line 0
* The cursor is below screen.
* The cursor is on the first line of a paragraph.
* Expect: The screen should scroll down.
       DATA WDWN4
       TEXT 'WDWN4 '
* Top of screen displays paragraph 1, line 0
* The cursor is in a paragraph below the screen.
* The cursor is in a middle line of a paragraph.
* Expect: The screen should scroll down
*         but within the same paragraph.
       DATA WDWN5
       TEXT 'WDWN5 '
* Top of screen displays paragraph 2, line 2
* The cursor is in the middle of screen.
* The cursor is fewer than 21 rows from document start.
* Expect: The screen should not scroll down.
       DATA WDWN6
       TEXT 'WDWN6 '
* Top of screen displays paragraph 1, line 1
* The cursor is in the same paragraph, but below-screen.
* Expect: The screen should scroll down
*         but within the same paragraph.
       DATA WDWN7
       TEXT 'WDWN7 '
* The cursor is low enough, that the window
* must scroll down.
* The top paragraph will have a margin entry
* and the user will be able to see it.
       DATA WDWN8
       TEXT 'WDWN8 '
* The cursor is low enough, that the window
* must scroll down.
* The top paragraph will have a margin entry
* and the user will be able to see the
* paragraph's top line, but not the margin entry.
       DATA WDWN9
       TEXT 'WDWN9 '
* The cursor is low enough, that the window
* must scroll down.
* The top paragraph will have a margin entry
* but top visible line of the paragaph is line 1.
       DATA WDWN10
       TEXT 'WDWN10'
* ---
* Calculate cursor position,
* when the first line on screen is the first line of a paragraph,
* there is no window offset,
* and the cursor is in a different paragraph further down screen.
       DATA CUR1
       TEXT 'CUR1  '
* Calculate cursor position,
* when the first line on screen is in the middle of a paragraph,
* there is no window offset,
* and the cursor is in a different paragraph further down screen.
       DATA CUR2
       TEXT 'CUR2  '
* Calculate cursor position,
* when the first line on screen is in the middle of a paragraph,
* there is a window offset of 20,
* and the cursor is in a different paragraph further down screen.
       DATA CUR3
       TEXT 'CUR3  '
* Calculate cursor position,
* when the cursor is in the first paragraph visible on screen,
* there is no window offset.
       DATA CUR4
       TEXT 'CUR4  '
* Calculate cursor position,
* when two visible paragraphs have margin entries,
* both margin entries are visible,
* and the cursor is in the second of those two paragraphs.
       DATA CUR5
       TEXT 'CUR5  '
* Calculate cursor position,
* when two visible paragraphs have margin entries,
* only the second margin entry is visible,
* and the cursor is a paragraph later than either.
       DATA CUR6
       TEXT 'CUR6  '
* Calculate cursor position,
* when top visible paragraph has a margin entry,
* but margin entry is not visible,
* and the cursor is in that same paragraph.
       DATA CUR7
       TEXT 'CUR7  '
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
* Margin List with 5-char indent
*
MGN32  DATA 1,3
       DATA 0,>0020,>0A0A,>0A0A
*
* Margin List with hanging indent
*
MGNHNG DATA 1,3
       DATA 0,>00FB,>0A0A,>0A0A
*
* Margin List with two entries
*
MGNTWO DATA 2,3
       DATA 4,>0000,>0A0B,>0A0A
       DATA 6,>0000,>0D0C,>0A0A

*
* Calculate LININX and CHRLIX
* based on PARINX and CHRPAX
*
POS1
* Arrange
       LI   R0,POS1L
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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
*paragraph list
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
       MOV  R0,@PARLST
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

*paragraph list
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
       MOV  R0,@PARLST
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

*paragraph list
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
       MOV  R0,@PARLST
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

*paragraph list
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
       MOV  R0,@PARLST
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
       
*paragraph list
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
       MOV  R0,@PARLST
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
       
*paragraph list
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
* Calculate LININX and CHRLIX when
* cursor is on the first line of a
* first-line indented paragraph.
*
POSB
       LI   R0,POS1L
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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
* Calculate LININX and CHRLIX
* when cursor is at the beginning of a
* line besides the first line in and
* indented paragraph.
*
POSD
       LI   R0,POS1L
       MOV  R0,@PARLST
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
* when cursor is at the beginning of a
* line.
*
POSE
       LI   R0,POS1L
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,2
       MOV  R0,@CHRPAX
       LI   R0,MGN32
       MOV  R0,@MGNLST
       SETO @WINMOD
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,0
       MOV  @LININX,R1
       LI   R2,POS1MS
       LI   R3,POS1ME-POS1MS
       BLWP @AEQ
       LI   R0,2+MAXIDT
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
       RT

*
* Calculate LININX and CHRLIX when
* cursor is on the second line of a
* hanging indented paragraph.
*
POSF
       LI   R0,POS1L
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,45+35                 * Place cursor on line 1 (second line).
       MOV  R0,@CHRPAX               * Horizontal offset will be required
*                                    * because the hanging indent is five.
       LI   R0,MGNHNG
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
       LI   R0,5+35
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
       RT

*
* When CHRLIX is 12 and horizontal
* offset is 0, offset should not change.
*
HOF1
* Arrange
       LI   R0,HOF1L
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,112
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,EMPLST
       MOV  R0,@MGNLST
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
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,159
       MOV  R0,@CHRPAX
       LI   R0,20
       MOV  R0,@WINOFF
       LI   R0,EMPLST
       MOV  R0,@MGNLST
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
       MOV  R0,@PARLST
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

*paragraph list
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
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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
       MOV  R0,@PARLST
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

*
* Presumably after switching to horizontal
* mode, WINLIN is not a valid line
* index. Assert that it is changed to
* the maximum valid line.
*
WUP6
* Arrange
       LI   R0,UP1L
       MOV  R0,@PARLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,70+68+72+69
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,7                      * This is not a valid line index
*                                     * The max is 6 for this paragraph.
       MOV  R0,@WINLIN
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,1
       MOV  @WINPAR,R1
       LI   R2,WUPM1
       LI   R3,WUPM1E-WUPM1
       BLWP @AEQ
*
       LI   R0,6
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
*paragraph list
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


*
* Scroll down test DATA
*
* One line paragraph
PARD1  DATA 0
       DATA WRP1
       TEXT '.'
WRP1   DATA 0,1
* Five line paragraph
PARD5  DATA 0
       DATA WRP5
       TEXT '.'
WRP5   DATA 4,1
       DATA 60,120,180,240
* Eight line paragraph
PARD8  DATA 0
       DATA WRP8
       TEXT '.'
WRP8   DATA 7,1
       DATA 60,120,180,240,300
       DATA 360,420
* Twenty-six line paragraph
PARD26 DATA 0
       DATA WRP26
       TEXT '.'
WRP26  DATA 25,1
       DATA 60,120,180,240,300
       DATA 360,420,480,540,600
       DATA 660,720,780,840,900
       DATA 960,1020,1080,1140,1200
       DATA 1260,1320,1380,1440,1500

BADP   TEXT 'Windows paragraph index is wrong.'
BADPE
BADL   TEXT 'Windows line index is wrong.'
BADLE
BADM   TEXT 'The value for displaying margin '
       TEXT 'entry is wrong.'
BADME

*
* Top of screen displays paragraph 2, line 0
* The cursor is on the bottom row of the screen.
* The cursor is on the first line of a paragraph.
* Expect: The screen should not scroll down.
*
*paragraph list
LIND1  DATA (LIND1E-LIND1-4)/2,1
       DATA PARD5
       DATA PARD8
       DATA PARD5         * This is the first paragraph on screen
       DATA PARD8
       DATA PARD8
       DATA PARD5         * Cursor is in line 0
       DATA PARD8
       DATA PARD5
LIND1E
WDWN1 
* Arrange
       LI   R0,LIND1
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       CLR  @WINMGN
       LI   R0,5
       MOV  R0,@PARINX
       LI   R0,17
       MOV  R0,@CHRPAX
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,2
       MOV  @WINPAR,R1
       LI   R2,BADP
       LI   R3,BADPE-BADP
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINLIN,R1
       LI   R2,BADL
       LI   R3,BADLE-BADL
       BLWP @AEQ
*
       RT

*
* Top of screen displays paragraph 1, line 0
* The cursor is on the bottom row of the screen.
* The cursor is in the middle row of a paragraph.
* Expect: The screen should not scroll down.
*
*paragraph list
LIND2  DATA (LIND2E-LIND2-4)/2,1
       DATA PARD5
       DATA PARD5         * This is the first paragraph on screen
       DATA PARD1
       DATA PARD8
       DATA PARD5
       DATA PARD8         * Cursor is in line 2
       DATA PARD8
       DATA PARD5
LIND2E
WDWN2 
* Arrange
       LI   R0,LIND2
       MOV  R0,@PARLST
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       CLR  @WINMGN
       LI   R0,5
       MOV  R0,@PARINX
       LI   R0,60*2+17
       MOV  R0,@CHRPAX
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,1
       MOV  @WINPAR,R1
       LI   R2,BADP
       LI   R3,BADPE-BADP
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINLIN,R1
       LI   R2,BADL
       LI   R3,BADLE-BADL
       BLWP @AEQ
*
       RT

* Top of screen displays paragraph 1, line 0
* The cursor is on the bottom row of the screen.
* The cursor is in the last line of a paragraph.
* Expect: The screen should not scroll down.
LIND3  DATA (LIND3E-LIND3-4)/2,1
       DATA PARD1
       DATA PARD8         * This is the first paragraph on screen
       DATA PARD5
       DATA PARD1
       DATA PARD8         * Cursor is in line 7
       DATA PARD8
       DATA PARD5
LIND3E
WDWN3 
* Arrange
       LI   R0,LIND3
       MOV  R0,@PARLST
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       CLR  @WINMGN
       LI   R0,4
       MOV  R0,@PARINX
       LI   R0,60*7+17
       MOV  R0,@CHRPAX
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window didn't move
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,1
       MOV  @WINPAR,R1
       LI   R2,BADP
       LI   R3,BADPE-BADP
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINLIN,R1
       LI   R2,BADL
       LI   R3,BADLE-BADL
       BLWP @AEQ
*
       RT

*
* Top of screen displays paragraph 2, line 0
* The cursor is in a paragraph below the screen.
* The cursor is on the first line of a paragraph.
* Expect: The screen should scroll down
*         and to a new paragraph.
*
*paragraph list
LIND4  DATA (LIND4E-LIND4-4)/2,1
       DATA PARD5
       DATA PARD8
       DATA PARD5         * This is the first paragraph on screen
       DATA PARD8
       DATA PARD5
       DATA PARD1
       DATA PARD8
       DATA PARD5         * Cursor is in line 0
       DATA PARD8
       DATA PARD5
LIND4E
WDWN4 
* Arrange
       LI   R0,LIND4
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       CLR  @WINMGN
       LI   R0,7
       MOV  R0,@PARINX
       LI   R0,17
       MOV  R0,@CHRPAX
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
       LI   R0,3
       MOV  @WINPAR,R1
       LI   R2,BADP
       LI   R3,BADPE-BADP
       BLWP @AEQ
*
       LI   R0,1
       MOV  @WINLIN,R1
       LI   R2,BADL
       LI   R3,BADLE-BADL
       BLWP @AEQ
*
       RT

*
* Top of screen displays paragraph 1, line 0
* The cursor is in a paragraph below the screen.
* The cursor is in a middle line of a paragraph.
* Expect: The screen should scroll down
*         but within the same paragraph.
*
*paragraph list
LIND5  DATA (LIND5E-LIND5-4)/2,1
       DATA PARD5
       DATA PARD8         * This is the first paragraph on screen
       DATA PARD8
       DATA PARD5
       DATA PARD1
       DATA PARD1
       DATA PARD5         * Cursor is in line 2
       DATA PARD8
       DATA PARD5
LIND5E
WDWN5 
* Arrange
       LI   R0,LIND5
       MOV  R0,@PARLST
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       CLR  @WINMGN
       LI   R0,6
       MOV  R0,@PARINX
       LI   R0,2*60+17
       MOV  R0,@CHRPAX
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
       LI   R2,BADP
       LI   R3,BADPE-BADP
       BLWP @AEQ
*
       LI   R0,4
       MOV  @WINLIN,R1
       LI   R2,BADL
       LI   R3,BADLE-BADL
       BLWP @AEQ
*
       RT

*
* Top of screen displays paragraph 2, line 2
* The cursor is in the middle of screen.
* The cursor is fewer than 21 rows from document start.
* Expect: The screen should not scroll down.
*
*paragraph list
LIND6  DATA (LIND6E-LIND6-4)/2,1
       DATA PARD1
       DATA PARD1
       DATA PARD5         * This is the first paragraph on screen
       DATA PARD1
       DATA PARD8         * Cursor is in line 1
       DATA PARD1
       DATA PARD5
LIND6E
WDWN6 
* Arrange
       LI   R0,LIND6
       MOV  R0,@PARLST
       LI   R0,2
       MOV  R0,@WINPAR
       LI   R0,2
       MOV  R0,@WINLIN
       CLR  @WINMGN
       LI   R0,4
       MOV  R0,@PARINX
       LI   R0,1*60+17
       MOV  R0,@CHRPAX
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
* Document status reports window moved
       MOV  R0,R1
       MOV  @STSWIN,R0
       LI   R2,MWINM
       LI   R3,MWINME-MWINM
       BLWP @AZC
*
       LI   R0,2
       MOV  @WINPAR,R1
       LI   R2,BADP
       LI   R3,BADPE-BADP
       BLWP @AEQ
*
       LI   R0,2
       MOV  @WINLIN,R1
       LI   R2,BADL
       LI   R3,BADLE-BADL
       BLWP @AEQ
*
       RT

*
* Top of screen displays paragraph 1, line 1
* The cursor is in the same paragraph, but below-screen.
* Expect: The screen should scroll down
*         but within the same paragraph.
*
*paragraph list
LIND7  DATA (LIND7E-LIND7-4)/2,1
       DATA PARD5
       DATA PARD26        * This is the first paragraph on screen
*                         * Cursor is in line 24
       DATA PARD8
       DATA PARD5
LIND7E
WDWN7 
* Arrange
       LI   R0,LIND7
       MOV  R0,@PARLST
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,1
       MOV  R0,@WINLIN
       CLR  @WINMGN
       LI   R0,1
       MOV  R0,@PARINX
       LI   R0,24*60+17
       MOV  R0,@CHRPAX
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
       LI   R2,BADP
       LI   R3,BADPE-BADP
       BLWP @AEQ
*
       LI   R0,3
       MOV  @WINLIN,R1
       LI   R2,BADL
       LI   R3,BADLE-BADL
       BLWP @AEQ
*
       RT

*
* The cursor is low enough, that the window
* must scroll down.
* The top paragraph will have a margin entry
* and the user will be able to see it.
*
LIND8  DATA (LIND8E-LIND8-4)/2,1
       DATA PARD5          * Initial screen position
       DATA PARD8
       DATA PARD5
       DATA PARD1
       DATA PARD5          * Final screen position
       DATA PARD5
       DATA PARD8
       DATA PARD5          * Cursor on line 1
       DATA PARD5
LIND8E
WDWN8 
* Arrange
       LI   R0,LIND8
       MOV  R0,@PARLST
       LI   R0,0
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       CLR  @WINMGN
       LI   R0,7
       MOV  R0,@PARINX
       LI   R0,60+32
       MOV  R0,@CHRPAX
       LI   R0,MGNTWO
       MOV  R0,@MGNLST
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
       LI   R0,4
       MOV  @WINPAR,R1
       LI   R2,BADP
       LI   R3,BADPE-BADP
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINLIN,R1
       LI   R2,BADL
       LI   R3,BADLE-BADL
       BLWP @AEQ
*
       SETO R0
       MOV  @WINMGN,R1
       LI   R2,BADM
       LI   R3,BADME-BADM
       BLWP @AEQ
*
       RT

*
* The cursor is low enough, that the window
* must scroll down.
* The top paragraph will have a margin entry
* and the user will be able to see the
* paragraph's top line, but not the margin entry.
*
LIND9  DATA (LIND9E-LIND9-4)/2,1
       DATA PARD5          * Initial screen position
       DATA PARD8
       DATA PARD5
       DATA PARD1
       DATA PARD5          * Final screen position
       DATA PARD5
       DATA PARD8
       DATA PARD5          * Cursor on line 2
       DATA PARD5
LIND9E
WDWN9
* Arrange
       LI   R0,LIND9
       MOV  R0,@PARLST
       LI   R0,0
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       SETO @WINMGN
       LI   R0,7
       MOV  R0,@PARINX
       LI   R0,120+32
       MOV  R0,@CHRPAX
       LI   R0,MGNTWO
       MOV  R0,@MGNLST
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
       LI   R0,4
       MOV  @WINPAR,R1
       LI   R2,BADP
       LI   R3,BADPE-BADP
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINLIN,R1
       LI   R2,BADL
       LI   R3,BADLE-BADL
       BLWP @AEQ
*
       CLR  R0
       MOV  @WINMGN,R1
       LI   R2,BADM
       LI   R3,BADME-BADM
       BLWP @AEQ
*
       RT

*
* The cursor is low enough, that the window
* must scroll down.
* The top paragraph will have a margin entry
* but top visible line of the paragaph is line 1.
*
LIND10 DATA (LIN10E-LIND10-4)/2,1
       DATA PARD5          * Initial screen position
       DATA PARD8
       DATA PARD5
       DATA PARD1
       DATA PARD5          * Final screen position
       DATA PARD5
       DATA PARD8
       DATA PARD5          * Cursor on line 3
       DATA PARD5
LIN10E
WDWN10
* Arrange
       LI   R0,LIND10
       MOV  R0,@PARLST
       LI   R0,0
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       CLR  @WINMGN
       LI   R0,7
       MOV  R0,@PARINX
       LI   R0,180+32
       MOV  R0,@CHRPAX
       LI   R0,MGNTWO
       MOV  R0,@MGNLST
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
       LI   R0,4
       MOV  @WINPAR,R1
       LI   R2,BADP
       LI   R3,BADPE-BADP
       BLWP @AEQ
*
       LI   R0,1
       MOV  @WINLIN,R1
       LI   R2,BADL
       LI   R3,BADLE-BADL
       BLWP @AEQ
*
       RT

*
* Cursor On Screen Test Data
*

*
* Paragraphs
*
* One line short paragraph
PARC1S DATA 23
       DATA WRPC1S
       TEXT '.'
       EVEN
WRPC1S DATA 0,1
* One line long paragraph
PARC1L DATA 58
       DATA WRPC1L
       TEXT '.'
       EVEN
WRPC1L DATA 0,1
* Three line paragraph
PARC3  DATA 48+57+32
       DATA WRPC3
       TEXT '.'
       EVEN
WRPC3  DATA 2,1
       DATA 48,48+57
* Five line paragraph
PARC5  DATA 48+57+54+60+51
       DATA WRPC5
       TEXT '.'
       EVEN
WRPC5  DATA 4,1
       DATA 48,48+57,48+57+54,48+57+54+60
* Nine line paragraph
PARC9  DATA 55+49+60+59+53+51+58+56+41
       DATA WRPC9
       TEXT '.'
       EVEN
WRPC9  DATA 8,1
       DATA 55,55+49,55+49+60,55+49+60+59
       DATA 55+49+60+59+53,55+49+60+59+53+51,55+49+60+59+53+51+58
       DATA 55+49+60+59+53+51+58+56
*
WCURM  TEXT 'Cursors position on screen is wrong.'
WCURME EVEN

*
* Calculate cursor position,
* when the first line on screen is the first line of a paragraph,
* there is no window offset,
* and the cursor is in a different paragraph further down screen.
*
* paragraph list
LINC1  DATA (LINC1E-LINC1-4)/2,1
       DATA PARC5
       DATA PARC9     * First paragraph on screen
       DATA PARC1S
       DATA PARC3
       DATA PARC1L
       DATA PARC5     * Cursor is in line 3, column 5
       DATA PARC9
LINC1E
*
CUR1
* Arrange
       LI   R0,LINC1
       MOV  R0,@PARLST
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       CLR  @WINMGN
       LI   R0,5
       MOV  R0,@PARINX
       LI   R0,48+57+54+(5)
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,5
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINOFF,R1
       LI   R2,OFCNS
       LI   R3,OFCNSE-OFCNS
       BLWP @AEQ
* Cursor should be in row 17, column 5 of text area
* add two more rows for the screen header
       LI   R0,(HDRHGT*40)+(17*40)+5
       MOV  @CURSCN,R1
       LI   R2,WCURM
       LI   R3,WCURME-WCURM
       BLWP @AEQ
*
       RT

*
* Calculate cursor position,
* when the first line on screen is in the middle of a paragraph,
* there is no window offset,
* and the cursor is in a different paragraph further down screen.
*
* paragraph list
LINC2  DATA (LINC2E-LINC2-4)/2,1
       DATA PARC5
       DATA PARC9     * Line 5 of this paragraph is at top of the screen
       DATA PARC1S
       DATA PARC3
       DATA PARC1L
       DATA PARC5     * Cursor is in line 3, column 12
       DATA PARC9
LINC2E
*
CUR2
* Arrange
       LI   R0,LINC2
       MOV  R0,@PARLST
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,5
       MOV  R0,@WINLIN
       CLR  @WINMGN
       LI   R0,5
       MOV  R0,@PARINX
       LI   R0,48+57+54+(12)
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,12
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINOFF,R1
       LI   R2,OFCNS
       LI   R3,OFCNSE-OFCNS
       BLWP @AEQ
* Cursor should be in row 12, column 12 of text area
* add two more rows for the screen header
       LI   R0,(HDRHGT*40)+(12*40)+12
       MOV  @CURSCN,R1
       LI   R2,WCURM
       LI   R3,WCURME-WCURM
       BLWP @AEQ
*
       RT

*
* Calculate cursor position,
* when the first line on screen is in the middle of a paragraph,
* there is a window offset of 20,
* and the cursor is in a different paragraph further down screen.
*
* paragraph list
LINC3  DATA (LINC3E-LINC3-4)/2,1
       DATA PARC5
       DATA PARC1L
       DATA PARC1S
       DATA PARC5     * Line 2 of this paragraph is at top of the screen
       DATA PARC1S
       DATA PARC3
       DATA PARC9     * Cursor is in line 7, column 49
       DATA PARC5
       DATA PARC9
LINC3E
*
CUR3
* Arrange
       LI   R0,LINC3
       MOV  R0,@PARLST
       LI   R0,3
       MOV  R0,@WINPAR
       LI   R0,2
       MOV  R0,@WINLIN       
       CLR  @WINMGN
       LI   R0,6
       MOV  R0,@PARINX
       LI   R0,55+49+60+59+53+51+58+(49)
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,49
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
*
       LI   R0,20
       MOV  @WINOFF,R1
       LI   R2,OFCNS
       LI   R3,OFCNSE-OFCNS
       BLWP @AEQ
* Cursor should be in row 14, column 29 of text area
* add two more rows for the screen header
       LI   R0,(HDRHGT*40)+(14*40)+49-20
       MOV  @CURSCN,R1
       LI   R2,WCURM
       LI   R3,WCURME-WCURM
       BLWP @AEQ
*
       RT

*
* Calculate cursor position,
* when the cursor is in the first paragraph visible on screen,
* there is no window offset.
*
* paragraph list
LINC4  DATA (LINC4E-LINC4-4)/2,1
       DATA PARC5
       DATA PARC1L
       DATA PARC9
       DATA PARC9     * screen starts with line 1
*                     * cursor is on line 7, column 25
       DATA PARC1S
       DATA PARC3
       DATA PARC1L
       DATA PARC9
LINC4E
*
CUR4
* Arrange
       LI   R0,LINC4
       MOV  R0,@PARLST
       LI   R0,3
       MOV  R0,@WINPAR
       LI   R0,1
       MOV  R0,@WINLIN
       CLR  @WINMGN
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,55+49+60+59+53+51+58+(25)
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,25
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINOFF,R1
       LI   R2,OFCNS
       LI   R3,OFCNSE-OFCNS
       BLWP @AEQ
* Cursor should be in row 17, column 5 of text area
* add two more rows for the screen header
       LI   R0,(HDRHGT*40)+(6*40)+25
       MOV  @CURSCN,R1
       LI   R2,WCURM
       LI   R3,WCURME-WCURM
       BLWP @AEQ
*
       RT

*
* Calculate cursor position,
* when two visible paragraphs have margin entries,
* both margin entries are visible,
* and the cursor is in the second of those two paragraphs.
*
* paragraph list
LINC5  DATA (LINC5E-LINC5-4)/2,1
       DATA PARC5
       DATA PARC1L
       DATA PARC9
       DATA PARC1S
       DATA PARC5       * Top visible paragraph
       DATA PARC3
       DATA PARC9       * Cursor paragraph
       DATA PARC3
LINC5E
*
CUR5
* Arrange
       LI   R0,LINC5
       MOV  R0,@PARLST
       LI   R0,4
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       SETO @WINMGN
       LI   R0,6
       MOV  R0,@PARINX
       LI   R0,55+(25)
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,MGNTWO
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,25
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINOFF,R1
       LI   R2,OFCNS
       LI   R3,OFCNSE-OFCNS
       BLWP @AEQ
* Cursor should be in row 11, column 25 of text area
* add two more rows for the screen header
       LI   R0,(HDRHGT*40)+(11*40)+25
       MOV  @CURSCN,R1
       LI   R2,WCURM
       LI   R3,WCURME-WCURM
       BLWP @AEQ
*
       RT

*
* Calculate cursor position,
* when two visible paragraphs have margin entries,
* only the second margin entry is visible,
* and the cursor is a paragraph later than either.
*
* paragraph list
LINC6  DATA (LINC6E-LINC6-4)/2,1
       DATA PARC5
       DATA PARC1L
       DATA PARC9
       DATA PARC1S
       DATA PARC5       * Top visible paragraph
       DATA PARC3
       DATA PARC9       * Has mgn entry
       DATA PARC3       * Cursor paragraph
LINC6E
*
CUR6
* Arrange
       LI   R0,LINC6
       MOV  R0,@PARLST
       LI   R0,4
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       CLR  @WINMGN
       LI   R0,7
       MOV  R0,@PARINX
       LI   R0,12
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,MGNTWO
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,12
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINOFF,R1
       LI   R2,OFCNS
       LI   R3,OFCNSE-OFCNS
       BLWP @AEQ
* Cursor should be in row 18, column 28 of text area
* add two more rows for the screen header
       LI   R0,(HDRHGT*40)+(18*40)+12
       MOV  @CURSCN,R1
       LI   R2,WCURM
       LI   R3,WCURME-WCURM
       BLWP @AEQ
*
       RT

*
* Calculate cursor position,
* when top visible paragraph has a margin entry,
* but margin entry is not visible,
* and the cursor is in that same paragraph.
*
* paragraph list
LINC7  DATA (LINC7E-LINC7-4)/2,1
       DATA PARC5
       DATA PARC1L
       DATA PARC9
       DATA PARC1S
       DATA PARC5       * Top visible paragraph
       DATA PARC3
       DATA PARC9
       DATA PARC3
LINC7E
*
CUR7
* Arrange
       LI   R0,LINC7
       MOV  R0,@PARLST
       LI   R0,4
       MOV  R0,@WINPAR
       LI   R0,1
       MOV  R0,@WINLIN
       CLR  @WINMGN
       LI   R0,4
       MOV  R0,@PARINX
       LI   R0,48+57+54+(14)
       MOV  R0,@CHRPAX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,MGNTWO
       MOV  R0,@MGNLST
* Act
       CLR  R0
       BLWP @POSUPD
* Assert
       LI   R0,14
       MOV  @CHRLIX,R1
       LI   R2,POS1NS
       LI   R3,POS1NE-POS1NS
       BLWP @AEQ
*
       LI   R0,0
       MOV  @WINOFF,R1
       LI   R2,OFCNS
       LI   R3,OFCNSE-OFCNS
       BLWP @AEQ
* Cursor should be in row 2, column 14 of text area
* add two more rows for the screen header
       LI   R0,(HDRHGT*40)+(2*40)+14
       MOV  @CURSCN,R1
       LI   R2,WCURM
       LI   R3,WCURME-WCURM
       BLWP @AEQ
*
       RT

       END