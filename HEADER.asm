       DEF  WRTHDR,ADJHDR
*
       REF  VDPADR
       REF  VDPINV,VDPSPI
       REF  STSWIN,ERRMEM
       REF  SCRNWD
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
       MOV  @SCRNWD,R1
       SLA  R1,1
       BL   @VDPSPI
* Draw first line
       CLR  R0
       BL   @VDPADR
       MOV  R2,R0
       BL   @VDPINV
* Draw second line
       MOV  @SCRNWD,R0
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
       LI   R0,DFLTMG-4
* Let R0 = address of left margin
CONMGN AI   R0,4
* Convert Left Margin to ASCII
* Let R4 = copy of left margin
       MOV  @SCRNWD,R3
       AI   R3,3
       MOVB *R0+,R2
       MOVB R2,R4
       BL   @DRWNUM
* Let R2 = page width - paragraph width - left margin
       LI   R2,DFLTPG*>100
       SB   *R0+,R2
       SB   R4,R2
* Convert Right Margin to ASCII
       AI   R3,6
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
* Default Left Margin, Paragraph Width, Top Margin, Document Height
DFLTMG DATA >0A3C,>0A36
TEXT1  TEXT 'FCTN+9: Menu  CTRL+Y: Hot Keys'
       BYTE 0
TEXT2  TEXT 'LM:   RM:'
       BYTE 0
MEMFUL TEXT 'Memory Full'
       BYTE 0
       EVEN