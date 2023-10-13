       DEF  TSTLST,RSLTFL
* Mocked methods
       DEF  VDPADR,VDPWRT,VDPSPC
*
       REF  ABLCK,AOC,AZC
       REF  AEQ,ANEQ,AL
       REF  DISP,LINLST,FMTLST,MGNLST
       REF  PARINX
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
*
* Margin List with 5-char indent
*
MGN5   DATA 1,3
       DATA 0,>0005,>0A0A,>0A0A
*
* Margin List with 32-char indent
*
MGN32  DATA 1,3
       DATA 0,>0020,>0A0A,>0A0A

TSTLST DATA TSTEND-TSTLST-2/8
* Window moved.
       DATA DSP11
       TEXT 'DSP11 '
* User deleted a carriage return.
       DATA DSP12
       TEXT 'DSP12 '
* Display one indented paragraph. No horizontal offset.
       DATA DSP13
       TEXT 'DSP13 '
* Display one indented paragraph with horizontal offset.
       DATA DSP14
       TEXT 'DSP14 '
* One-line intented paragraph with horizontal offset.
       DATA DSP15
       TEXT 'DSP15 '
TSTEND
RSLTFL BYTE RSLTFE-RSLTFL-1
       TEXT 'DSK2.TESTRESULT.TXT'
RSLTFE
       EVEN

*
* Window has moved, draw to the end of
* the screen or document.
*
DSP11
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* Clear simulated VDP RAM
       BL   @CLRVDP
* Imply that the cursor is currently in
* the paragraph PARG and the window is 
* at PARE.
       LI   R0,PARL11
       MOV  R0,@LINLST
       LI   R0,6
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,4
       MOV  R0,@WINPAR
       LI   R0,4
       MOV  R0,@WINLIN
       CLR  @WINMOD
       LI   R0,EMPLST
       MOV  R0,@MGNLST
* Act
* Imply that the window has moved.
       CLR  R0
       SOC  @STSWIN,R0
       BLWP @DISP
* Assert
       LI   R0,SCRN11
       LI   R1,MKSCRN
       LI   R2,24*40
       LI   R3,MSCNW
       LI   R4,MSCNWE-MSCNW
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL11 DATA 8,1
       DATA PAR11A
       DATA PAR11B
       DATA PAR11C
       DATA PAR11D
       DATA PAR11E
       DATA PAR11F
       DATA PAR11G
       DATA PAR11H

PAR11A DATA -1
       DATA WRP11A
       TEXT '...'
       EVEN
WRP11A DATA 3,1,-1,-1,-1
PAR11B DATA -1
       DATA WRP11B
       TEXT '...'
       EVEN
WRP11B DATA 17,1
       DATA -1,-1,-1,-1,-1,-1,-1,-1,-1
       DATA -1,-1,-1,-1,-1,-1,-1,-1
PAR11C DATA -1
       DATA WRP11C
       TEXT '...'
       EVEN
WRP11C DATA 5,1,-1,-1,-1,-1,-1
PAR11D DATA -1
       DATA WRP11D
       TEXT '...'
       EVEN
WRP11D DATA 5,1,-1,-1,-1,-1,-1
PAR11E DATA 468
       DATA WRP11E
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
WRP11E DATA 8,1
       DATA 62
       DATA 62+58
       DATA 62+58+55
       DATA 62+58+55+53
       DATA 62+58+55+53+54
       DATA 62+58+55+53+54+59
       DATA 62+58+55+53+54+59+55
       DATA 62+58+55+53+54+59+55+59       
PAR11F DATA 316
       DATA WRP11F
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
WRP11F DATA 5,1
       DATA 57
       DATA 57+61
       DATA 57+61+60
       DATA 57+61+60+59
       DATA 57+61+60+59+58
PAR11G DATA 279
       DATA WRP11G
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
WRP11G DATA 4,1
       DATA 57
       DATA 57+60
       DATA 57+60+52
       DATA 57+60+52+55
PAR11H DATA 274
       DATA WRP11H
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
WRP11H DATA 4,1
       DATA 53
       DATA 53+59
       DATA 53+59+59
       DATA 53+59+59+59

SCRN11 TEXT '                                        '
       TEXT '                                        '
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
       TEXT 'governed by himself, that would enact la'
       TEXT 'racial purity. Although he never visited'
       TEXT 'was committed to the Back_to_Africa move'
       TEXT 'many African_Americans should migrate th'
       TEXT '                                        '

*
* The user pressed deleted a carriage
* return, and the unified paragraph is
* the same length as earlier.
* Previously, the next paragraph may
* have been blank or only one word long.
* Redraw the next paragraph and all
* paragraphs after it.
*
DSP12
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* Clear simulated VDP RAM
       BL   @CLRVDP
* Imply that the cursor is currently in
* the paragraph PARF.
       LI   R0,PARL12
       MOV  R0,@LINLST
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
* Imply that the user delted a CR.
       CLR  R0
       SOC  @STSDCR,R0
       BLWP @DISP
* Assert
       LI   R0,SCRN12
       LI   R1,MKSCRN
       LI   R2,24*40
       LI   R3,MSCNW
       LI   R4,MSCNWE-MSCNW
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL12 DATA 8,1
       DATA PAR12A
       DATA PAR12B
       DATA PAR12C
       DATA PAR12D
       DATA PAR12E
       DATA PAR12F
       DATA PAR12G
       DATA PAR12H

PAR12A DATA -1
       DATA WRP12A
       TEXT '...'
       EVEN
WRP12A DATA 3,1,-1,-1,-1
PAR12B DATA -1
       DATA WRP12B
       TEXT '...'
       EVEN
WRP12B DATA 17,1
       DATA -1,-1,-1,-1,-1,-1,-1,-1,-1
       DATA -1,-1,-1,-1,-1,-1,-1,-1
PAR12C DATA -1
       DATA WRP12C
       TEXT '...'
       EVEN
WRP12C DATA 5,1,-1,-1,-1,-1,-1
PAR12D DATA -1
       DATA WRP12D
       TEXT '...'
       EVEN
WRP12D DATA 5,1,-1,-1,-1,-1,-1
PAR12E DATA 468
       DATA WRP12E
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
WRP12E DATA 8,1
       DATA 62
       DATA 62+58
       DATA 62+58+55
       DATA 62+58+55+53
       DATA 62+58+55+53+54
       DATA 62+58+55+53+54+59
       DATA 62+58+55+53+54+59+55
       DATA 62+58+55+53+54+59+55+59       
PAR12F DATA 316
       DATA WRP12F
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
WRP12F DATA 5,1
       DATA 57
       DATA 57+61
       DATA 57+61+60
       DATA 57+61+60+59
       DATA 57+61+60+59+58
PAR12G DATA 279
       DATA WRP12G
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
WRP12G DATA 4,1
       DATA 57
       DATA 57+60
       DATA 57+60+52
       DATA 57+60+52+55
PAR12H DATA 274
       DATA WRP12H
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
WRP12H DATA 4,1
       DATA 53
       DATA 53+59
       DATA 53+59+59
       DATA 53+59+59+59

SCRN12 TEXT '                                        '
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

*
* Draw a single paragraph with no offset
* and an indent of 5.
*
DSP13
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* Clear simulated VDP RAM
       BL   @CLRVDP
* Imply that the cursor is currently in
* the paragraph PAR1E and that 
* paragraph is in the screen middle.
       LI   R0,PARL13
       MOV  R0,@LINLST
       LI   R0,4
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@WINOFF
       LI   R0,2
       MOV  R0,@WINPAR
       LI   R0,3
       MOV  R0,@WINLIN
       CLR  @WINMOD
       LI   R0,MGN5
       MOV  R0,@MGNLST
* Act
* Imply that the current paragraph
* recieved new characters, but line
* count is unchanged.
       CLR  R0
       SOC  @STSTYP,R0
       BLWP @DISP
* Assert
       LI   R0,SCRN13
       LI   R1,MKSCRN
       LI   R2,24*40
       LI   R3,MSCNW
       LI   R4,MSCNWE-MSCNW
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL13 DATA 6,1
       DATA PAR13A
       DATA PAR13B
       DATA PAR13C
       DATA PAR13D
       DATA PAR13E
       DATA PAR13F

PAR13A DATA -1
       DATA WRP13A
       TEXT '...'
       EVEN
WRP13A DATA 3,1,-1,-1,-1
PAR13B DATA -1
       DATA WRP13B
       TEXT '...'
       EVEN
WRP13B DATA 17,1
       DATA -1,-1,-1,-1,-1,-1,-1,-1,-1
       DATA -1,-1,-1,-1,-1,-1,-1,-1
PAR13C DATA -1
       DATA WRP13C
       TEXT '...'
       EVEN
WRP13C DATA 5,1,-1,-1,-1,-1,-1
PAR13D DATA -1
       DATA WRP13D
       TEXT '...'
       EVEN
WRP13D DATA 5,1,-1,-1,-1,-1,-1
PAR13E DATA 468
       DATA WRP13E
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
WRP13E DATA 8,1
       DATA 62
       DATA 62+58
       DATA 62+58+55
       DATA 62+58+55+53
       DATA 62+58+55+53+54
       DATA 62+58+55+53+54+59
       DATA 62+58+55+53+54+59+55
       DATA 62+58+55+53+54+59+55+59       
PAR13F DATA -1
       DATA WRP13F
       TEXT '...'
       EVEN
WRP13F DATA 6,1,-1,-1,-1,-1,-1

SCRN13 TEXT '                                        '
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
       TEXT '     Marcus Mosiah Garvey Jr. ONH (17 Au'
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
* Redraw one paragraph with first-line indent of 5.
* Horizontal offset of 20.
* You won't see the indent on screen, but the char are offset by 5.
*
DSP14
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* Clear simulated VDP RAM
       BL   @CLRVDP
* Imply that the cursor is currently in
* the paragraph PAR1E and that 
* paragraph is in the screen middle.
       LI   R0,PARL14
       MOV  R0,@LINLST
       LI   R0,4
       MOV  R0,@PARINX
       LI   R0,20
       MOV  R0,@WINOFF
       LI   R0,2
       MOV  R0,@WINPAR
       LI   R0,3
       MOV  R0,@WINLIN
       CLR  @WINMOD
       LI   R0,MGN5
       MOV  R0,@MGNLST
* Act
* Imply that the current paragraph
* recieved new characters, but line
* count is unchanged.
       CLR  R0
       SOC  @STSTYP,R0
       BLWP @DISP
* Assert
       LI   R0,SCRN14
       LI   R1,MKSCRN
       LI   R2,24*40
       LI   R3,MSCNW
       LI   R4,MSCNWE-MSCNW
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL14 DATA 6,1
       DATA PAR14A
       DATA PAR14B
       DATA PAR14C
       DATA PAR14D
       DATA PAR14E
       DATA PAR14F

PAR14A DATA -1
       DATA WRP14A
       TEXT '...'
       EVEN
WRP14A DATA 3,1,-1,-1,-1
PAR14B DATA -1
       DATA WRP14B
       TEXT '...'
       EVEN
WRP14B DATA 17,1
       DATA -1,-1,-1,-1,-1,-1,-1,-1,-1
       DATA -1,-1,-1,-1,-1,-1,-1,-1
PAR14C DATA -1
       DATA WRP14C
       TEXT '...'
       EVEN
WRP14C DATA 5,1,-1,-1,-1,-1,-1
PAR14D DATA -1
       DATA WRP14D
       TEXT '...'
       EVEN
WRP14D DATA 5,1,-1,-1,-1,-1,-1
PAR14E DATA 468
       DATA WRP14E
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
WRP14E DATA 8,1
       DATA 62
       DATA 62+58
       DATA 62+58+55
       DATA 62+58+55+53
       DATA 62+58+55+53+54
       DATA 62+58+55+53+54+59
       DATA 62+58+55+53+54+59+55
       DATA 62+58+55+53+54+59+55+59       
PAR14F DATA -1
       DATA WRP14F
       TEXT '...'
       EVEN
WRP14F DATA 6,1,-1,-1,-1,-1,-1

* Note the subtle difference between SCRN14 and SCRN7
* Only the first-line looks different because SCRN14
* has a 5-char indent.
SCRN14 TEXT '                                        '
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
       TEXT 'arvey Jr. ONH (17 August 1887 to 10 June'
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
DSP15
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* Clear simulated VDP RAM
       BL   @CLRVDP
* Imply that the cursor is currently in
* the paragraph PAR1E and that 
* paragraph is in the screen middle.
       LI   R0,PARL15
       MOV  R0,@LINLST
       LI   R0,3
       MOV  R0,@PARINX
       LI   R0,40
       MOV  R0,@WINOFF
       LI   R0,1
       MOV  R0,@WINPAR
       LI   R0,0
       MOV  R0,@WINLIN
       CLR  @WINMOD
       LI   R0,MGN5
       MOV  R0,@MGNLST
* Act
* Imply that the current paragraph
* recieved new characters, but line
* count is unchanged.
       CLR  R0
       SOC  @STSTYP,R0
       BLWP @DISP
* Assert
       LI   R0,SCRN15
       LI   R1,MKSCRN
       LI   R2,24*40
       LI   R3,MSCNW
       LI   R4,MSCNWE-MSCNW
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL15 DATA 6,1
       DATA PAR15A
       DATA PAR15B
       DATA PAR15C
       DATA PAR15D
       DATA PAR15E
       DATA PAR15F

PAR15A DATA -1
       DATA WRP15A
       TEXT '...'
       EVEN
WRP15A DATA 9,1,-1,-1,-1,-1,-1,-1,-1,-1,-1
PAR15B DATA -1
       DATA WRP15B
       TEXT '...'
       EVEN
WRP15B DATA 10,1
       DATA -1,-1,-1,-1,-1,-1,-1,-1,-1,-1
PAR15C DATA -1
       DATA WRP15C
       TEXT '...'
       EVEN
WRP15C DATA 5,1,-1,-1,-1,-1,-1
PAR15D DATA 63
       DATA WRP15D
       TEXT 'SpaceX Nasa Mission: Astronaut capsule '
       TEXT 'docks with space station'
       EVEN
WRP15D DATA 0,1
PAR15E DATA -1
       DATA WRP15E
       TEXT '...'
       EVEN
WRP15E DATA 8,1,-1,-1,-1,-1,-1,-1,-1,-1   
PAR15F DATA -1
       DATA WRP15F
       TEXT '...'
       EVEN
WRP15F DATA 6,1,-1,-1,-1,-1,-1

SCRN15 TEXT '                                        '
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
       TEXT 'ule docks with space station            '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '
       TEXT '                                        '

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

       END