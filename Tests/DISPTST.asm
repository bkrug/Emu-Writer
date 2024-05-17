       DEF  TSTLST,RSLTFL
* Mocked methods
       DEF  VDPADR,VDPWRT,VDPINV
       DEF  VDPSPC,VDPSPI
*
       REF  ABLCK,AOC,AZC
       REF  AEQ,ANEQ,AL
       REF  DISP,PARLST,FMTLST,MGNLST
       REF  PARINX,PARENT
       REF  WINOFF,WINPAR,WINLIN,WINMOD
       REF  STSTYP,STSENT,STSDCR
       REF  STSPAR,STSWIN
       REF  ERRMEM

*
* Simulated screen
*
       TEXT 'SIMULATED SCREEN'
MKSCRN BSS  24*40
SCRNED
*
* Empty Margin List
*
EMPLST DATA 0,3

TSTLST DATA TSTEND-TSTLST-2/8
* One paragraph. Middle Screen.
       DATA DSP1
       TEXT 'DSP1  '
* One paragraph. Top Screen.
       DATA DSP2
       TEXT 'DSP2  '
* One paragraph. Bottom Screen.
       DATA DSP3
       TEXT 'DSP3  '
* One-short-line paragraph.
       DATA DSP4
       TEXT 'DSP4  '
* One-long-line paragraph.
       DATA DSP5
       TEXT 'DSP5  '
* One paragraph. 
* Last line longer than screen.
       DATA DSP6
       TEXT 'DSP6  '
* One paragraph with horizontal offset.
       DATA DSP7
       TEXT 'DSP7  '
* One-line paragraph with horizontal offset.
       DATA DSP8
       TEXT 'DSP8  '
* Current paragraph has changed line-
* count. Update screen contents below
* the screen.
       DATA DSP9
       TEXT 'DSP9  '
* User pressed enter.
       DATA DSP10
       TEXT 'DSP10 '
TSTEND
RSLTFL BYTE RSLTFE-RSLTFL-1
       TEXT 'DSK2.TESTRESULT.TXT'
RSLTFE
       EVEN

*
* Only should redraw the current
* paragraph, which is in middle of the
* screen. Draw the left most portion.
*
DSP1
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* Clear simulated VDP RAM
       BL   @CLRVDP
* Imply that the cursor is currently in
* the paragraph PAR1E and that 
* paragraph is in the screen middle.
       LI   R0,PARL1
       MOV  R0,@PARLST
       LI   R0,4
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,2
       MOV  R0,@WINPAR
       LI   R0,3
       MOV  R0,@WINLIN
       CLR  @WINMOD
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
* Imply that the current paragraph
* recieved new characters, but line
* count is unchanged.
       CLR  R0
       SOC  @STSTYP,R0
       BLWP @DISP
* Assert
       LI   R0,SCRN1
       LI   R1,MKSCRN
       LI   R2,24*40
       LI   R3,MSCNW
       LI   R4,MSCNWE-MSCNW
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL1  DATA 6,1
       DATA PAR1A
       DATA PAR1B
       DATA PAR1C
       DATA PAR1D
       DATA PAR1E
       DATA PAR1F

PAR1A  DATA -1
       DATA WRP1A
       TEXT '...'
       EVEN
WRP1A  DATA 3,1,-1,-1,-1
PAR1B  DATA -1
       DATA WRP1B
       TEXT '...'
       EVEN
WRP1B  DATA 17,1
       DATA -1,-1,-1,-1,-1,-1,-1,-1,-1
       DATA -1,-1,-1,-1,-1,-1,-1,-1
PAR1C  DATA -1
       DATA WRP1C
       TEXT '...'
       EVEN
WRP1C  DATA 5,1,-1,-1,-1,-1,-1
PAR1D  DATA -1
       DATA WRP1D
       TEXT '...'
       EVEN
WRP1D  DATA 5,1,-1,-1,-1,-1,-1
PAR1E  DATA 468
       DATA WRP1E
       TEXT 'Marcus Mosiah Garvey Jr. ONH '
       TEXT '(17 August 1887 to 10 June 1940) '
       TEXT 'was a Jamaican political activist, '
       TEXT 'publisher, journalist, '
       TEXT 'entrepreneur, and orator. He was the '
       TEXT 'founder and first '
       TEXT 'President_General of the Universal '
       TEXT 'Negro Improvement '
       TEXT 'Association and African Communities '
       TEXT 'League (UNIA_ACL, '
       TEXT 'commonly known as UNIA), through which '
       TEXT 'he declared himself '
       TEXT 'Provisional President of Africa. '
       TEXT 'Ideologically a black '
       TEXT 'nationalist and Pan_Africanist, his '
       TEXT 'ideas came to be known '
       TEXT 'as Garveyism.'
       EVEN
WRP1E  DATA 8,1
       DATA 62
       DATA 62+58
       DATA 62+58+55
       DATA 62+58+55+53
       DATA 62+58+55+53+54
       DATA 62+58+55+53+54+59
       DATA 62+58+55+53+54+59+55
       DATA 62+58+55+53+54+59+55+59       
PAR1F  DATA -1
       DATA WRP1F
       TEXT '...'
       EVEN
WRP1F  DATA 6,1,-1,-1,-1,-1,-1

SCRN1  TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT 'Marcus Mosiah Garvey Jr. ONH (17 August '
       TEXT 'was a Jamaican political activist, publi'
       TEXT 'entrepreneur, and orator. He was the fou'
       TEXT 'President_General of the Universal Negro'
       TEXT 'Association and African Communities Leag'
       TEXT 'commonly known as UNIA), through which h'
       TEXT 'Provisional President of Africa. Ideolog'
       TEXT 'nationalist and Pan_Africanist, his idea'
       TEXT 'as Garveyism.                           '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '

*
* Only should redraw the current
* paragraph, which is at top of the
* screen. Draw the left most portion.
*
DSP2
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* Clear simulated VDP RAM
       BL   @CLRVDP
* Imply that the cursor is currently in
* the paragraph PAR1E and that 
* paragraph is at the top of scren.
       LI   R0,PARL2
       MOV  R0,@PARLST
       LI   R0,4
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,4
       MOV  R0,@WINPAR
       LI   R0,2
       MOV  R0,@WINLIN
       CLR  @WINMOD
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
* Imply that the current paragraph
* recieved new characters, but line
* count is unchanged.
       CLR  R0
       SOC  @STSTYP,R0
       BLWP @DISP
* Assert
       LI   R0,SCRN2
       LI   R1,MKSCRN
       LI   R2,24*40
       LI   R3,MSCNW
       LI   R4,MSCNWE-MSCNW
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL2  DATA 6,1
       DATA PAR2A
       DATA PAR2B
       DATA PAR2C
       DATA PAR2D
       DATA PAR2E
       DATA PAR2F

PAR2A  DATA -1
       DATA WRP2A
       TEXT '...'
       EVEN
WRP2A  DATA 3,1,-1,-1,-1
PAR2B  DATA -1
       DATA WRP2B
       TEXT '...'
       EVEN
WRP2B  DATA 17,1
       DATA -1,-1,-1,-1,-1,-1,-1,-1,-1
       DATA -1,-1,-1,-1,-1,-1,-1,-1
PAR2C  DATA -1
       DATA WRP2C
       TEXT '...'
       EVEN
WRP2C  DATA 5,1,-1,-1,-1,-1,-1
PAR2D  DATA -1
       DATA WRP2D
       TEXT '...'
       EVEN
WRP2D  DATA 5,1,-1,-1,-1,-1,-1
PAR2E  DATA 468
       DATA WRP2E
       TEXT 'Marcus Mosiah Garvey Jr. ONH '
       TEXT '(17 August 1887 to 10 June 1940) '
       TEXT 'was a Jamaican political activist, '
       TEXT 'publisher, journalist, '
       TEXT 'entrepreneur, and orator. He was the '
       TEXT 'founder and first '
       TEXT 'President_General of the Universal '
       TEXT 'Negro Improvement '
       TEXT 'Association and African Communities '
       TEXT 'League (UNIA_ACL, '
       TEXT 'commonly known as UNIA), through which '
       TEXT 'he declared himself '
       TEXT 'Provisional President of Africa. '
       TEXT 'Ideologically a black '
       TEXT 'nationalist and Pan_Africanist, his '
       TEXT 'ideas came to be known '
       TEXT 'as Garveyism.'
       EVEN
WRP2E  DATA 8,1
       DATA 62
       DATA 62+58
       DATA 62+58+55
       DATA 62+58+55+53
       DATA 62+58+55+53+54
       DATA 62+58+55+53+54+59
       DATA 62+58+55+53+54+59+55
       DATA 62+58+55+53+54+59+55+59       
PAR2F  DATA -1
       DATA WRP2F
       TEXT '...'
       EVEN
WRP2F  DATA 6,1,-1,-1,-1,-1,-1

SCRN2  TEXT '                                        '
       TEXT '                                        '
       TEXT 'entrepreneur, and orator. He was the fou'
       TEXT 'President_General of the Universal Negro'
       TEXT 'Association and African Communities Leag'
       TEXT 'commonly known as UNIA), through which h'
       TEXT 'Provisional President of Africa. Ideolog'
       TEXT 'nationalist and Pan_Africanist, his idea'
       TEXT 'as Garveyism.                           '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '

*
* Only should redraw the current
* paragraph, which is at the bottom of
* the screen. The last three lines are
* cut off.
*
DSP3
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* Clear simulated VDP RAM
       BL   @CLRVDP
* Imply that the cursor is currently in
* the paragraph PAR1E and that 
* paragraph is in the screen middle.
       LI   R0,PARL3
       MOV  R0,@PARLST
       LI   R0,4
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,14
       MOV  R0,@WINLIN
       CLR  @WINMOD
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
* Imply that the current paragraph
* recieved new characters, but line
* count is unchanged.
       CLR  R0
       SOC  @STSTYP,R0
       BLWP @DISP
* Assert
       LI   R0,SCRN3
       LI   R1,MKSCRN
       LI   R2,24*40
       LI   R3,MSCNW
       LI   R4,MSCNWE-MSCNW
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL3  DATA 6,1
       DATA PAR3A
       DATA PAR3B
       DATA PAR3C
       DATA PAR3D
       DATA PAR3E
       DATA PAR3F

PAR3A  DATA -1
       DATA WRP3A
       TEXT '...'
       EVEN
WRP3A  DATA 3,1,-1,-1,-1
PAR3B  DATA -1
       DATA WRP3B
       TEXT '...'
       EVEN
WRP3B  DATA 17,1
       DATA -1,-1,-1,-1,-1,-1,-1,-1,-1
       DATA -1,-1,-1,-1,-1,-1,-1,-1
PAR3C  DATA -1
       DATA WRP3C
       TEXT '...'
       EVEN
WRP3C  DATA 5,1,-1,-1,-1,-1,-1
PAR3D  DATA -1
       DATA WRP3D
       TEXT '...'
       EVEN
WRP3D  DATA 5,1,-1,-1,-1,-1,-1
PAR3E  DATA 468
       DATA WRP3E
       TEXT 'Marcus Mosiah Garvey Jr. ONH '
       TEXT '(17 August 1887 to 10 June 1940) '
       TEXT 'was a Jamaican political activist, '
       TEXT 'publisher, journalist, '
       TEXT 'entrepreneur, and orator. He was the '
       TEXT 'founder and first '
       TEXT 'President_General of the Universal '
       TEXT 'Negro Improvement '
       TEXT 'Association and African Communities '
       TEXT 'League (UNIA_ACL, '
       TEXT 'commonly known as UNIA), through which '
       TEXT 'he declared himself '
       TEXT 'Provisional President of Africa. '
       TEXT 'Ideologically a black '
       TEXT 'nationalist and Pan_Africanist, his '
       TEXT 'ideas came to be known '
       TEXT 'as Garveyism.'
       EVEN
WRP3E  DATA 8,1
       DATA 62
       DATA 62+58
       DATA 62+58+55
       DATA 62+58+55+53
       DATA 62+58+55+53+54
       DATA 62+58+55+53+54+59
       DATA 62+58+55+53+54+59+55
       DATA 62+58+55+53+54+59+55+59       
PAR3F  DATA -1
       DATA WRP3F
       TEXT '...'
       EVEN
WRP3F  DATA 6,1,-1,-1,-1,-1,-1

SCRN3  TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT 'Marcus Mosiah Garvey Jr. ONH (17 August '
       TEXT 'was a Jamaican political activist, publi'
       TEXT 'entrepreneur, and orator. He was the fou'
       TEXT 'President_General of the Universal Negro'
       TEXT 'Association and African Communities Leag'
       TEXT 'commonly known as UNIA), through which h'

*
* Redraw only the current paragraph.
* It has one line, shorter than screen-
* width, in the middle of the screen.
*
DSP4
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* Clear simulated VDP RAM
       BL   @CLRVDP
* Imply that the cursor is currently in
* the paragraph PAR1E and that 
* paragraph is in the screen middle.
       LI   R0,PARL4
       MOV  R0,@PARLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       CLR  @WINMOD
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
* Imply that the current paragraph
* recieved new characters, but line
* count is unchanged.
       CLR  R0
       SOC  @STSTYP,R0
       BLWP @DISP
* Assert
       LI   R0,SCRN4
       LI   R1,MKSCRN
       LI   R2,24*40
       LI   R3,MSCNW
       LI   R4,MSCNWE-MSCNW
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL4  DATA 6,1
       DATA PAR4A
       DATA PAR4B
       DATA PAR4C
       DATA PAR4D
       DATA PAR4E
       DATA PAR4F

PAR4A  DATA -1
       DATA WRP4A
       TEXT '...'
       EVEN
WRP4A  DATA 9,1,-1,-1,-1,-1,-1,-1,-1,-1,-1
PAR4B  DATA -1
       DATA WRP4B
       TEXT '...'
       EVEN
WRP4B  DATA 10,1
       DATA -1,-1,-1,-1,-1,-1,-1,-1,-1,-1
PAR4C  DATA -1
       DATA WRP4C
       TEXT '...'
       EVEN
WRP4C  DATA 5,1,-1,-1,-1,-1,-1
PAR4D  DATA 13
       DATA WRP4D
       TEXT 'Good morning.'
       EVEN
WRP4D  DATA 0,1
PAR4E  DATA -1
       DATA WRP4E
       TEXT '...'
       EVEN
WRP4E  DATA 8,1,-1,-1,-1,-1,-1,-1,-1,-1   
PAR4F  DATA -1
       DATA WRP4F
       TEXT '...'
       EVEN
WRP4F  DATA 6,1,-1,-1,-1,-1,-1

SCRN4  TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT 'Good morning.                           '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       
*
* Redraw only the current paragraph.
* It has one line, longer than screen-
* width, in the middle of the screen.
*
DSP5
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* Clear simulated VDP RAM
       BL   @CLRVDP
* Imply that the cursor is currently in
* the paragraph PAR1E and that 
* paragraph is in the screen middle.
       LI   R0,PARL5
       MOV  R0,@PARLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       CLR  @WINMOD
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
* Imply that the current paragraph
* recieved new characters, but line
* count is unchanged.
       CLR  R0
       SOC  @STSTYP,R0
       BLWP @DISP
* Assert
       LI   R0,SCRN5
       LI   R1,MKSCRN
       LI   R2,24*40
       LI   R3,MSCNW
       LI   R4,MSCNWE-MSCNW
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL5  DATA 6,1
       DATA PAR5A
       DATA PAR5B
       DATA PAR5C
       DATA PAR5D
       DATA PAR5E
       DATA PAR5F

PAR5A  DATA -1
       DATA WRP5A
       TEXT '...'
       EVEN
WRP5A  DATA 9,1,-1,-1,-1,-1,-1,-1,-1,-1,-1
PAR5B  DATA -1
       DATA WRP5B
       TEXT '...'
       EVEN
WRP5B  DATA 10,1
       DATA -1,-1,-1,-1,-1,-1,-1,-1,-1,-1
PAR5C  DATA -1
       DATA WRP5C
       TEXT '...'
       EVEN
WRP5C  DATA 5,1,-1,-1,-1,-1,-1
PAR5D  DATA 63
       DATA WRP5D
       TEXT 'SpaceX Nasa Mission: Astronaut capsule '
       TEXT 'docks with space station'
       EVEN
WRP5D  DATA 0,1
PAR5E  DATA -1
       DATA WRP5E
       TEXT '...'
       EVEN
WRP5E  DATA 8,1,-1,-1,-1,-1,-1,-1,-1,-1   
PAR5F  DATA -1
       DATA WRP5F
       TEXT '...'
       EVEN
WRP5F  DATA 6,1,-1,-1,-1,-1,-1

SCRN5  TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT 'SpaceX Nasa Mission: Astronaut capsule d'
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '

*
* Only redraw one paragraph.
* It's in the middle of the screen,
* and the last line is longer than
* the screen-width.
*
DSP6
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* Clear simulated VDP RAM
       BL   @CLRVDP
* Imply that the cursor is currently in
* the paragraph PAR1E and that 
* paragraph is in the screen middle.
       LI   R0,PARL6
       MOV  R0,@PARLST
       LI   R0,4
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,2
       MOV  R0,@WINPAR
       LI   R0,3
       MOV  R0,@WINLIN
       CLR  @WINMOD
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
* Imply that the current paragraph
* recieved new characters, but line
* count is unchanged.
       CLR  R0
       SOC  @STSTYP,R0
       BLWP @DISP
* Assert
       LI   R0,SCRN6
       LI   R1,MKSCRN
       LI   R2,24*40
       LI   R3,MSCNW
       LI   R4,MSCNWE-MSCNW
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL6  DATA 6,1
       DATA PAR6A
       DATA PAR6B
       DATA PAR6C
       DATA PAR6D
       DATA PAR6E
       DATA PAR6F

PAR6A  DATA -1
       DATA WRP6A
       TEXT '...'
       EVEN
WRP6A  DATA 3,1,-1,-1,-1
PAR6B  DATA -1
       DATA WRP6B
       TEXT '...'
       EVEN
WRP6B  DATA 17,1
       DATA -1,-1,-1,-1,-1,-1,-1,-1,-1
       DATA -1,-1,-1,-1,-1,-1,-1,-1
PAR6C  DATA -1
       DATA WRP6C
       TEXT '...'
       EVEN
WRP6C  DATA 5,1,-1,-1,-1,-1,-1
PAR6D  DATA -1
       DATA WRP6D
       TEXT '...'
       EVEN
WRP6D  DATA 5,1,-1,-1,-1,-1,-1
PAR6E  DATA 468
       DATA WRP6E
       TEXT 'Babylon was the capital city of '
       TEXT 'Babylonia, a kingdom in '
       TEXT 'ancient Mesopotamia, between the 18th '
       TEXT 'and 6th centuries BC. '
       TEXT 'It was built along the left and right '
       TEXT 'banks of the Euphrates '
       TEXT 'river with steep embankments to contain '
       TEXT 'the river,s seasonal '
       TEXT 'floods. Babylon was originally a small '
       TEXT 'Akkadian town dating '
       TEXT 'from the period of the Akkadian Empire '
       TEXT 'c. 2300 BC'
       EVEN
WRP6E  DATA 5,1
       DATA 56
       DATA 56+60
       DATA 56+60+61
       DATA 56+60+61+61
       DATA 56+60+61+61+60
PAR6F  DATA -1
       DATA WRP6F
       TEXT '...'
       EVEN
WRP6F  DATA 6,1,-1,-1,-1,-1,-1

SCRN6  TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT 'Babylon was the capital city of Babyloni'
       TEXT 'ancient Mesopotamia, between the 18th an'
       TEXT 'It was built along the left and right ba'
       TEXT 'river with steep embankments to contain '
       TEXT 'floods. Babylon was originally a small A'
       TEXT 'from the period of the Akkadian Empire c'
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '

*
* Redraw one paragraph.
* Middle of screen.
* Horizontal offset of 20.
*
DSP7
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* Clear simulated VDP RAM
       BL   @CLRVDP
* Imply that the cursor is currently in
* the paragraph PAR1E and that 
* paragraph is in the screen middle.
       LI   R0,PARL7
       MOV  R0,@PARLST
       LI   R0,4
       MOV  R0,@PARINX
       LI   R0,20
       MOV  R0,@WINOFF
       LI   R0,2
       MOV  R0,@WINPAR
       LI   R0,3
       MOV  R0,@WINLIN
       CLR  @WINMOD
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
* Imply that the current paragraph
* recieved new characters, but line
* count is unchanged.
       CLR  R0
       SOC  @STSTYP,R0
       BLWP @DISP
* Assert
       LI   R0,SCRN7
       LI   R1,MKSCRN
       LI   R2,24*40
       LI   R3,MSCNW
       LI   R4,MSCNWE-MSCNW
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL7  DATA 6,1
       DATA PAR7A
       DATA PAR7B
       DATA PAR7C
       DATA PAR7D
       DATA PAR7E
       DATA PAR7F

PAR7A  DATA -1
       DATA WRP7A
       TEXT '...'
       EVEN
WRP7A  DATA 3,1,-1,-1,-1
PAR7B  DATA -1
       DATA WRP7B
       TEXT '...'
       EVEN
WRP7B  DATA 17,1
       DATA -1,-1,-1,-1,-1,-1,-1,-1,-1
       DATA -1,-1,-1,-1,-1,-1,-1,-1
PAR7C  DATA -1
       DATA WRP7C
       TEXT '...'
       EVEN
WRP7C  DATA 5,1,-1,-1,-1,-1,-1
PAR7D  DATA -1
       DATA WRP7D
       TEXT '...'
       EVEN
WRP7D  DATA 5,1,-1,-1,-1,-1,-1
PAR7E  DATA 468
       DATA WRP7E
       TEXT 'Marcus Mosiah Garvey Jr. ONH '
       TEXT '(17 August 1887 to 10 June 1940) '
       TEXT 'was a Jamaican political activist, '
       TEXT 'publisher, journalist, '
       TEXT 'entrepreneur, and orator. He was the '
       TEXT 'founder and first '
       TEXT 'President_General of the Universal '
       TEXT 'Negro Improvement '
       TEXT 'Association and African Communities '
       TEXT 'League (UNIA_ACL, '
       TEXT 'commonly known as UNIA), through which '
       TEXT 'he declared himself '
       TEXT 'Provisional President of Africa. '
       TEXT 'Ideologically a black '
       TEXT 'nationalist and Pan_Africanist, his '
       TEXT 'ideas came to be known '
       TEXT 'as Garveyism.'
       EVEN
WRP7E  DATA 8,1
       DATA 62
       DATA 62+58
       DATA 62+58+55
       DATA 62+58+55+53
       DATA 62+58+55+53+54
       DATA 62+58+55+53+54+59
       DATA 62+58+55+53+54+59+55
       DATA 62+58+55+53+54+59+55+59       
PAR7F  DATA -1
       DATA WRP7F
       TEXT '...'
       EVEN
WRP7F  DATA 6,1,-1,-1,-1,-1,-1

SCRN7  TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT ' Jr. ONH (17 August 1887 to 10 June 1940'
       TEXT 'ical activist, publisher, journalist,   '
       TEXT 'ator. He was the founder and first      '
       TEXT ' the Universal Negro Improvement        '
       TEXT 'can Communities League (UNIA_ACL,       '
       TEXT 'IA), through which he declared himself  '
       TEXT 't of Africa. Ideologically a black      '
       TEXT 'Africanist, his ideas came to be known  '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '

*
* Redraw only the current paragraph.
* It has one line, longer than screen-
* width, in the middle of the screen.
*
DSP8
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* Clear simulated VDP RAM
       BL   @CLRVDP
* Imply that the cursor is currently in
* the paragraph PAR1E and that 
* paragraph is in the screen middle.
       LI   R0,PARL8
       MOV  R0,@PARLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,40
       MOV  R0,@WINOFF
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       CLR  @WINMOD
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
* Imply that the current paragraph
* recieved new characters, but line
* count is unchanged.
       CLR  R0
       SOC  @STSTYP,R0
       BLWP @DISP
* Assert
       LI   R0,SCRN8
       LI   R1,MKSCRN
       LI   R2,24*40
       LI   R3,MSCNW
       LI   R4,MSCNWE-MSCNW
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL8  DATA 6,1
       DATA PAR8A
       DATA PAR8B
       DATA PAR8C
       DATA PAR8D
       DATA PAR8E
       DATA PAR8F

PAR8A  DATA -1
       DATA WRP8A
       TEXT '...'
       EVEN
WRP8A  DATA 9,1,-1,-1,-1,-1,-1,-1,-1,-1,-1
PAR8B  DATA -1
       DATA WRP8B
       TEXT '...'
       EVEN
WRP8B  DATA 10,1
       DATA -1,-1,-1,-1,-1,-1,-1,-1,-1,-1
PAR8C  DATA -1
       DATA WRP8C
       TEXT '...'
       EVEN
WRP8C  DATA 5,1,-1,-1,-1,-1,-1
PAR8D  DATA 63
       DATA WRP8D
       TEXT 'SpaceX Nasa Mission: Astronaut capsule '
       TEXT 'docks with space station'
       EVEN
WRP8D  DATA 0,1
PAR8E  DATA -1
       DATA WRP8E
       TEXT '...'
       EVEN
WRP8E  DATA 8,1,-1,-1,-1,-1,-1,-1,-1,-1   
PAR8F  DATA -1
       DATA WRP8F
       TEXT '...'
       EVEN
WRP8F  DATA 6,1,-1,-1,-1,-1,-1

SCRN8  TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT 'ocks with space station                 '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '

*
* The paragraph length has changed.
* Redraw the current paragraph and all
* paragraphs after it.
*
DSP9
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* Clear simulated VDP RAM
       BL   @CLRVDP
* Imply that the cursor is currently in
* the paragraph PAR1E and that 
* paragraph is in the screen middle.
       LI   R0,PARL9
       MOV  R0,@PARLST
       LI   R0,4
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,2
       MOV  R0,@WINPAR
       LI   R0,3
       MOV  R0,@WINLIN
       CLR  @WINMOD
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
* Imply that the current paragraph's
* line count has changed.
       CLR  R0
       SOC  @STSPAR,R0
       BLWP @DISP
* Assert
       LI   R0,SCRN9
       LI   R1,MKSCRN
       LI   R2,24*40
       LI   R3,MSCNW
       LI   R4,MSCNWE-MSCNW
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL9  DATA 6,1
       DATA PAR9A
       DATA PAR9B
       DATA PAR9C
       DATA PAR9D
       DATA PAR9E
       DATA PAR9F

PAR9A  DATA -1
       DATA WRP9A
       TEXT '...'
       EVEN
WRP9A  DATA 3,1,-1,-1,-1
PAR9B  DATA -1
       DATA WRP9B
       TEXT '...'
       EVEN
WRP9B  DATA 17,1
       DATA -1,-1,-1,-1,-1,-1,-1,-1,-1
       DATA -1,-1,-1,-1,-1,-1,-1,-1
PAR9C  DATA -1
       DATA WRP9C
       TEXT '...'
       EVEN
WRP9C  DATA 5,1,-1,-1,-1,-1,-1
PAR9D  DATA -1
       DATA WRP9D
       TEXT '...'
       EVEN
WRP9D  DATA 5,1,-1,-1,-1,-1,-1
PAR9E  DATA 468
       DATA WRP9E
       TEXT 'Marcus Mosiah Garvey Jr. ONH '
       TEXT '(17 August 1887 to 10 June 1940) '
       TEXT 'was a Jamaican political activist, '
       TEXT 'publisher, journalist, '
       TEXT 'entrepreneur, and orator. He was the '
       TEXT 'founder and first '
       TEXT 'President_General of the Universal '
       TEXT 'Negro Improvement '
       TEXT 'Association and African Communities '
       TEXT 'League (UNIA_ACL, '
       TEXT 'commonly known as UNIA), through which '
       TEXT 'he declared himself '
       TEXT 'Provisional President of Africa. '
       TEXT 'Ideologically a black '
       TEXT 'nationalist and Pan_Africanist, his '
       TEXT 'ideas came to be known '
       TEXT 'as Garveyism.'
       EVEN
WRP9E  DATA 8,1
       DATA 62
       DATA 62+58
       DATA 62+58+55
       DATA 62+58+55+53
       DATA 62+58+55+53+54
       DATA 62+58+55+53+54+59
       DATA 62+58+55+53+54+59+55
       DATA 62+58+55+53+54+59+55+59       
PAR9F  DATA 316
       DATA WRP9F
       TEXT 'Garvey was born to a moderately '
       TEXT 'prosperous Afro-Jamaican '
       TEXT 'family in Saint Ann"s Bay, Colony '
       TEXT 'of Jamaica and apprenticed '
       TEXT 'into the print trade as a teenager. '
       TEXT 'Working in Kingston, he '
       TEXT 'became involved in trade unionism '
       TEXT 'before living briefly in '
       TEXT 'Costa Rica, Panama, and England. '
       TEXT 'Returning to Jamaica, he '
       TEXT 'founded UNIA in 1914.'
       EVEN
WRP9F  DATA 5,1
       DATA 57
       DATA 57+61
       DATA 57+61+60
       DATA 57+61+60+59
       DATA 57+61+60+59+58

SCRN9  TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT 'Marcus Mosiah Garvey Jr. ONH (17 August '
       TEXT 'was a Jamaican political activist, publi'
       TEXT 'entrepreneur, and orator. He was the fou'
       TEXT 'President_General of the Universal Negro'
       TEXT 'Association and African Communities Leag'
       TEXT 'commonly known as UNIA), through which h'
       TEXT 'Provisional President of Africa. Ideolog'
       TEXT 'nationalist and Pan_Africanist, his idea'
       TEXT 'as Garveyism.                           '
       TEXT 'Garvey was born to a moderately prospero'
       TEXT 'family in Saint Ann"s Bay, Colony of Jam'
       TEXT 'into the print trade as a teenager. Work'
       TEXT 'became involved in trade unionism before'

*
* The user pressed the enter key.
* Redraw the previous paragraph and all
* paragraphs after it.
*
DSP10
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* Clear simulated VDP RAM
       BL   @CLRVDP
* Imply that the cursor is currently in
* the paragraph PARF.
       LI   R0,PARL10
       MOV  R0,@PARLST
       LI   R0,5
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,3
       MOV  R0,@WINPAR
       LI   R0,5
       MOV  R0,@WINLIN
       CLR  @WINMOD
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
* Imply that the user pressed enter, once.
       CLR  R0
       SOC  @STSENT,R0
*
       MOV  @PARINX,@PARENT
       DEC  @PARENT
*
       BLWP @DISP
* Assert
       LI   R0,SCRN10
       LI   R1,MKSCRN
       LI   R2,24*40
       LI   R3,MSCNW
       LI   R4,MSCNWE-MSCNW
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL10 DATA 8,1
       DATA PAR10A
       DATA PAR10B
       DATA PAR10C
       DATA PAR10D
       DATA PAR10E
       DATA PAR10F
       DATA PAR10G
       DATA PAR10H

PAR10A DATA -1
       DATA WRP10A
       TEXT '...'
       EVEN
WRP10A DATA 3,1,-1,-1,-1
PAR10B DATA -1
       DATA WRP10B
       TEXT '...'
       EVEN
WRP10B DATA 17,1
       DATA -1,-1,-1,-1,-1,-1,-1,-1,-1
       DATA -1,-1,-1,-1,-1,-1,-1,-1
PAR10C DATA -1
       DATA WRP10C
       TEXT '...'
       EVEN
WRP10C DATA 5,1,-1,-1,-1,-1,-1
PAR10D DATA -1
       DATA WRP10D
       TEXT '...'
       EVEN
WRP10D DATA 5,1,-1,-1,-1,-1,-1
PAR10E DATA 468
       DATA WRP10E
       TEXT 'Marcus Mosiah Garvey Jr. ONH '
       TEXT '(17 August 1887 to 10 June 1940) '
       TEXT 'was a Jamaican political activist, '
       TEXT 'publisher, journalist, '
       TEXT 'entrepreneur, and orator. He was the '
       TEXT 'founder and first '
       TEXT 'President_General of the Universal '
       TEXT 'Negro Improvement '
       TEXT 'Association and African Communities '
       TEXT 'League (UNIA_ACL, '
       TEXT 'commonly known as UNIA), through which '
       TEXT 'he declared himself '
       TEXT 'Provisional President of Africa. '
       TEXT 'Ideologically a black '
       TEXT 'nationalist and Pan_Africanist, his '
       TEXT 'ideas came to be known '
       TEXT 'as Garveyism.'
       EVEN
WRP10E DATA 8,1
       DATA 62
       DATA 62+58
       DATA 62+58+55
       DATA 62+58+55+53
       DATA 62+58+55+53+54
       DATA 62+58+55+53+54+59
       DATA 62+58+55+53+54+59+55
       DATA 62+58+55+53+54+59+55+59       
PAR10F DATA 316
       DATA WRP10F
       TEXT 'Garvey was born to a moderately '
       TEXT 'prosperous Afro-Jamaican '
       TEXT 'family in Saint Ann"s Bay, Colony '
       TEXT 'of Jamaica and apprenticed '
       TEXT 'into the print trade as a teenager. '
       TEXT 'Working in Kingston, he '
       TEXT 'became involved in trade unionism '
       TEXT 'before living briefly in '
       TEXT 'Costa Rica, Panama, and England. '
       TEXT 'Returning to Jamaica, he '
       TEXT 'founded UNIA in 1914.'
       EVEN
WRP10F DATA 5,1
       DATA 57
       DATA 57+61
       DATA 57+61+60
       DATA 57+61+60+59
       DATA 57+61+60+59+58
PAR10G DATA 279
       DATA WRP10G
       TEXT 'In 1916, he moved to the United States and '
       TEXT 'established a '
       TEXT 'UNIA branch in New York City"s Harlem '
       TEXT 'district. Emphasising '
       TEXT 'unity between Africans and the African '
       TEXT 'diaspora, he '
       TEXT 'campaigned for an end to European colonial '
       TEXT 'rule across '
       TEXT 'Africa and the political unification of '
       TEXT 'the continent.'
WRP10G DATA 4,1
       DATA 57
       DATA 57+60
       DATA 57+60+52
       DATA 57+60+52+55
PAR10H DATA 274
       DATA WRP10H
       TEXT 'He envisioned a unified Africa as a '
       TEXT 'one_party state, '
       TEXT 'governed by himself, that would enact '
       TEXT 'laws to ensure black '
       TEXT 'racial purity. Although he never visited '
       TEXT 'the continent, he '
       TEXT 'was committed to the Back_to_Africa '
       TEXT 'movement, arguing that '
       TEXT 'many African_Americans should migrate '
       TEXT 'there.'
WRP10H DATA 4,1
       DATA 53
       DATA 53+59
       DATA 53+59+59
       DATA 53+59+59+59

SCRN10 TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT 'Marcus Mosiah Garvey Jr. ONH (17 August '
       TEXT 'was a Jamaican political activist, publi'
       TEXT 'entrepreneur, and orator. He was the fou'
       TEXT 'President_General of the Universal Negro'
       TEXT 'Association and African Communities Leag'
       TEXT 'commonly known as UNIA), through which h'
       TEXT 'Provisional President of Africa. Ideolog'
       TEXT 'nationalist and Pan_Africanist, his idea'
       TEXT 'as Garveyism.                           '
       TEXT 'Garvey was born to a moderately prospero'
       TEXT 'family in Saint Ann"s Bay, Colony of Jam'
       TEXT 'into the print trade as a teenager. Work'
       TEXT 'became involved in trade unionism before'
       TEXT 'Costa Rica, Panama, and England. Returni'
       TEXT 'founded UNIA in 1914.                   '
       TEXT 'In 1916, he moved to the United States a'
       TEXT 'UNIA branch in New York City"s Harlem di'
       TEXT 'unity between Africans and the African d'
       TEXT 'campaigned for an end to European coloni'
       TEXT 'Africa and the political unification of '
       TEXT 'He envisioned a unified Africa as a one_'

********

MSCNW  TEXT 'Screen contents are wrong'
MSCNWE EVEN

*
* Clear simulated screen
*
CLRVDP
       LI   R0,MKSCRN
       LI   R1,>2020
CLRV1  MOV  R1,*R0+
       CI   R0,SCRNED
       JL   CLRV1
       RT

* VDP Address
VADR   DATA 0

STACKS BSS  >10
STACK

* ------------------------
* Mocked methods
*

SAVER0 DATA 0
SAVER2 DATA 0

*
* Set VDP write address 
*
* Input:
* R0 - VDP address
VDPADR MOV  R0,@SAVER0
       AI   R0,MKSCRN
       MOV  R0,@VADR
       MOV  @SAVER0,R0
       RT

*
* Write multiple bytes to VDP
*
* Input:
* R0 - Address of text to copy
* R1 - Number of bytes
* Output:
* R0 - original value + R1's value
* R1 - 0
* R2
VDPWRT
* Save R2 incase caller needs it later
       MOV  R2,@SAVER2
* Get fake VDP address
       MOV  @VADR,R2
*
       MOV  R1,R1
       JEQ  WDPWED       
* Write to fake VDP RAM
WDPW1  CI   R2,SCRNED
       JHE  WDPWER
       MOVB *R0+,*R2+
       DEC  R1
       JH   WDPW1
* Update next write position
       MOV  R2,@VADR
*
WDPWED MOV  @SAVER2,R2
       RT

* Report logic error
* Wrote past end of the screen
WDPWER LI   R0,SCRNED
       MOV  R2,R1
       LI   R2,WDPWM
       LI   R3,WDPWME-WDPWM
       BLWP @AL
       RT
WDPWM  TEXT 'Routine attempted to write past '
       TEXT 'end of the screen.'
WDPWME

*
* Write Inverted Text
*
* R0 = address of text to write
VDPINV RT

*
* Write multiple spaces to VDP
*
* Input:
* R1 - Number of bytes
* Output:
* R0 - >2000
* R1 - 0
* R2
VDPSPC
* Save R2 incase caller needs it later
       MOV  R2,@SAVER2
*
       LI   R0,>2000
VDPSP0
* Get fake VDP address
       MOV  @VADR,R2
*
       MOV  R1,R1
       JEQ  VDPSED
* Write to fake VDP RAM
VDPS1  CI   R2,SCRNED
       JHE  WDPWER
       MOVB R0,*R2+
       DEC  R1
       JH   VDPS1
* Update next write position
       MOV  R2,@VADR
*
VDPSED MOV  @SAVER2,R2
       RT

*
* Write multiple inverted spaces to VDP
*
* Input:
* R1 - Number of bytes
* Output:
* R0 - >2000
* R1 - 0
* R2
VDPSPI
* Save R2 incase caller needs it later
       MOV  R2,@SAVER2
* Let R0 (high byte) = ASCII for inverted space
       LI   R0,>A000
*
       JMP  VDPSP0

       END