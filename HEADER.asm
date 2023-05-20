       DEF  WRTHDR,ADJHDR
*
       REF  VDPADR
       REF  VDPINV,VDPSPI
       REF  STSWIN
       REF  SCRNWD

ADJHDR
       COC  @STSWIN,R0
       JEQ  WRTHDR
       RT
*
WRTHDR
       DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R0,*R10
*
       CLR  R0
       BL   @VDPADR
       MOV  @SCRNWD,R1
       SLA  R1,1
       BL   @VDPSPI
*
       CLR  R0
       BL   @VDPADR
       LI   R0,TEXT1
       BL   @VDPINV
*
       MOV  *R10+,R0
       MOV  *R10+,R11
       RT

TEXT1  TEXT 'FCTN+9: Menu'
       BYTE 0
       EVEN