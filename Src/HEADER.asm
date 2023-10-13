       DEF  WRTHDR,ADJHDR
*
       REF  VDPADR
       REF  VDPINV,VDPSPI
       REF  STSWIN,STSDSH,ERRMEM
       REF  GETMGN                From UTIL.asm
       REF  PARINX                From VAR.asm

       COPY 'EQUKEY.asm'
       COPY 'CPUADR.asm'

ADJHDR
       LI   R2,MEMFUL
       COC  @ERRMEM,R0
       JEQ  WRTHDR
*
       LI   R2,TEXT1
       COC  @STSWIN,R0
       JEQ  WRTHDR
       COC  @STSDSH,R0
       JEQ  WRTHDR
       RT
*
WRTHDR
       DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R0,*R10
* Clear header
       CLR  R0
       BL   @VDPADR
       LI   R1,2*SCRNWD
       BL   @VDPSPI
* Draw first line
       CLR  R0
       BL   @VDPADR
       MOV  R2,R0
       BL   @VDPINV
* Draw second line
       LI   R0,SCRNWD
       BL   @VDPADR
*
       LI   R0,TEXT2
       BL   @VDPINV
* Get address of margin data
       MOV  @PARINX,R0
       BL   @GETMGN
* If R0 = 0, then use defaults.
       MOV  R0,R0
       JNE  CONMGN
       LI   R0,DFLTMG-2
* Let R0 = address of indent
CONMGN AI   R0,3
* Convert Indent to ASCII
       LI   R3,SCRNWD+15
       MOVB *R0+,R2
       BL   @DRWNUM
* Convert Left Margin to ASCII
* Let R4 = copy of left margin
       LI   R3,SCRNWD+3
       MOVB *R0+,R2
       MOVB R2,R4
       BL   @DRWNUM
* Let R2 = page width - paragraph width - left margin
       LI   R2,DFLTPG*>100
       SB   *R0+,R2
       SB   R4,R2
* Convert Right Margin to ASCII
       LI   R3,SCRNWD+9
       BL   @DRWNUM
*
       MOV  *R10+,R0
       MOV  *R10+,R11
       RT

*
* Draw a two digit number
*
* Input:
*   R2 (high byte) - number to draw
*   R3 - address on screen
*
DRWNUM DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R0,*R10
*
       SRL  R2,8
       CLR  R1
       DIV  @TEN,R1
       AI   R1,'0'
       AI   R2,'0'
* Set screen address to Second Line, Fourth Column
       MOV  R3,R0
       BL   @VDPADR
* Draw number as inverted char
       AI   R1,>80
       SLA  R1,8
       MOVB R1,@VDPWD
       AI   R2,>80
       SLA  R2,8
       MOVB R2,@VDPWD
*
       MOV  *R10+,R0
       MOV  *R10+,R11
       RT

TEN    DATA 10
* Empty Byte, Default Indent, Left Margin, Paragraph Width, Top Margin, Document Height
DFLTMG DATA >0000,>0A3C,>0A36
TEXT1  TEXT 'FCTN+9: Menu  CTRL+Y: Hot Keys'
       BYTE 0
TEXT2  TEXT 'LM:   RM:   IN:'
       BYTE 0
MEMFUL TEXT 'Memory Full'
       BYTE 0
       EVEN