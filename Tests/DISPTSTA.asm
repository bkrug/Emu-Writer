       DEF  TSTLST,RSLTFL
* Mocked methods
       DEF  VDPADR,VDPWRT,VDPSPC
*
       REF  ABLCK,AOC,AZC
       REF  AEQ,ANEQ,AL
       REF  DISP,LINLST,FMTLST,MGNLST
       REF  PARINX
       REF  WINOFF,WINPAR,WINLIN
       REF  STSTYP,STSENT,STSDCR
       REF  STSPAR,STSWIN
       REF  ERRMEM

*
* Simulated screen
*
       TEXT 'SIMULATED SCREEN'
MKSCRN BSS  24*40
SCRNED

TSTLST DATA TSTEND-TSTLST-2/8
* User deleted a carriage return.
       DATA DSP12
       TEXT 'DSP12 '
TSTEND
RSLTFL BYTE RSLTFE-RSLTFL-1
       TEXT 'DSK2.TESTRESULT.TXT'
RSLTFE
       EVEN

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