       DEF  WRTHDR,ADJHDR,DRWMGN
*
       REF  VDPADR,VDPWRT            From VDP.asm
       REF  VDPINV,VDPSPI            "
       REF  STSWIN,STSDSH,ERRMEM
       REF  PGWDTH
       REF  GETMGN                   From UTIL.asm
       REF  PARINX,DOCSTS            From VAR.asm
       REF  TWODIG

       COPY 'EQUKEY.asm'
       COPY 'CPUADR.asm'

ADJHDR
       LI   R2,MEMFUL
       COC  @ERRMEM,R0
       JEQ  WRTHDR
*
       LI   R2,TEXT1
       MOV  @DOCSTS,R13
       COC  @STSWIN,R13
       JEQ  WRTHDR
       COC  @STSDSH,R13
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
* Let R0 = Get address of margin data
       MOV  @PARINX,R0
       BL   @GETMGN
* Write margin data
       BL   @DRWMGN
*
       MOV  *R10+,R0
       MOV  *R10+,R11
       RT

*
* Draw Margin data
*
* Input:
*   VDP write address must have alredy been set
*   R0 - address of margin entry
*        or zero, if we should display defaults
*
DRWMGN DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R2,*R10
* Let R3 = address of indent
* If R3 = 0, then use defaults.
       MOV  R0,R3
       JNE  CONMGN
       LI   R3,ORGMGN-2
CONMGN
* Draw left margin label
       LI   R0,TXTLM
       BL   @VDPINV
* Convert Left Margin to ASCII
       MOVB @LEFT(R3),R2
       BL   @DRWNUM
* Draw right margin label
       LI   R0,TXTRM
       BL   @VDPINV
* Convert Right Margin to ASCII
       MOVB @RIGHT(R3),R2
       BL   @DRWNUM
* Draw indented label
       LI   R0,TXTIN
       BL   @VDPINV
* Convert Indent to ASCII
       MOVB @INDENT(R3),R2
       BL   @DRWNUM
* Draw top margin label
       LI   R0,TXTTM
       BL   @VDPINV
* Convert Top Margin to ASCII
       MOVB @TOP(R3),R2
       BL   @DRWNUM
* Draw bottom margin label
       LI   R0,TXTBM
       BL   @VDPINV
* Convert Bottom Margin to ASCII
       MOVB @BOTTOM(R3),R2
       BL   @DRWNUM
* Draw one more inverted space
       LI   R1,1
       BL   @VDPSPI
*
       MOV  *R10+,R2
       MOV  *R10+,R11
       RT

*
* Draw a two digit number
*
* Input:
*   R2 (high byte) - number to draw
*
DRWNUM DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R0,*R10
* Place tens digit in R1 and ones digit in R2
       SRL  R2,8
       CLR  R1
       DIV  @TEN,R1
* Convert each digit to the ASCII for an inverted digit
       AI   R1,'0'+INV
       AI   R2,'0'+INV
* shift numbers to high byte, and send to screen
       LI   R0,TWODIG
       SLA  R1,8
       MOVB R1,*R0+
       SLA  R2,8
       MOVB R2,*R0+
       DECT R0
       LI   R1,2
       BL   @VDPWRT
*
       MOV  *R10+,R0
       MOV  *R10+,R11
       RT

TEN    DATA 10
* Default Margin entry
* Empty Byte, Indent, Left Margin, Right Margin, Top Margin, Bottom Margin
ORGMGN DATA >0000,>0A0A,>0606
TEXT1  TEXT 'FCTN+9: Menu  CTRL+Y: Hot Keys'
       BYTE 0
TXTLM  TEXT 'LM:'
       BYTE 0
TXTRM  TEXT ' RM:'
       BYTE 0
TXTIN  TEXT ' IN:'
       BYTE 0
TXTTM  TEXT ' TM:'
       BYTE 0
TXTBM  TEXT ' BM:'
       BYTE 0
MEMFUL TEXT 'Memory Full'
       BYTE 0
       EVEN