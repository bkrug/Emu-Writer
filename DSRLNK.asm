       DEF  DSRLCL
*
       REF  A2032                  cru base for dsr
       REF  A2034                  dsr address   "
       REF  A2036                  name size     "
       REF  A2038                  e o name ptr  "
       REF  A203A                  counts        "
       REF  A208C                  dsr name buffer
       REF  DSRLWS
       REF  VDPRAD                 Ref from VDP

       COPY 'CPUADR.asm'

*
* As far as I can tell,
* This code uses Scratch PAD address >8354-8357
* and areas above >83C0 which we already know
* belong to the Interrpreter and GPL workspaces.
*

* TODO: confirm that these are constants
A20FC  DATA >2000
A20FE  TEXT '.'
A20FF  BYTE >AA
       EVEN

* This program's "local" version of DSRLNK
DSRLCL
A2120  DATA DSRLWS,A22B2           dsrlnk wp,pc
*                                  dsrlnk wp DSRLWS
A22B2  MOV  *14+,5                 ======
       SZCB @A20FC,15              >20 eq=0
       MOV  @>8356,0
       MOV  0,9
       AI   9,-8                   pab status
*       BLWP @VSBR                  vsbr: read size
       BL   @VDPRAD
       MOVB @VDPRD,1
       MOVB 1,3
       SRL  3,8
       SETO 4
       LI   2,A208C                name buffer
A22D0  INC  0
       INC  4
       C    4,3
       JEQ  A22E4                  full size
*       BLWP @VSBR                 vsbr
       BL   @VDPRAD
       MOVB @VDPRD,1
       MOVB 1,*2+                  copy 1 char
       CB   1,@A20FE               is it .
       JNE  A22D0
A22E4  MOV  4,4
       JEQ  A238C                  size=0
       CI   4,>0007
       JGT  A238C                  size>7
       CLR  @>83D0
       MOV  4,@>8354
       MOV  4,@A2036               save size
       INC  4
       A    4,@>8356
       MOV  @>8356,@A2038          e o name ptr
       LWPI >83E0                  call dsr
       CLR  1
       LI   12,>0F00
A2310  MOV  12,12
       JEQ  A2316
       SBZ  0                      card off
A2316  AI   12,>0100
       CLR  @>83D0
       CI   12,>2000
       JEQ  A2388                  last
       MOV  12,@>83D0              save cru base
       SBO  0                      card on
       LI   2,>4000
       CB   *2,@A20FF              >AA = header
       JNE  A2310                  no: next card
       LI   R0,DSRLWS
       AI   R0,10
       A    *R0,2                  old r5: offset
       JMP  A2340
A233A  MOV  @>83D2,2               next sub
       SBO  0                      card on
A2340  MOV  *2,2                   link to next
       JEQ  A2310                  last: next card
       MOV  2,@>83D2               save link
       INCT 2
       MOV  *2+,9                  save address
       MOVB @>8355,5
       JEQ  A2364                  size=0
       CB   5,*2+
       JNE  A233A                  diff size: next
       SRL  5,8
       LI   6,A208C                name buffer
A235C  CB   *6+,*2+                check name
       JNE  A233A                  diff name: next
       DEC  5
       JNE  A235C                  ok: next char
A2364  INC  1                      same name
       MOV  1,@A203A               save # of calls
       MOV  9,@A2034               save address
       MOV  12,@A2032              save cru base
       BL   *9                     link
       JMP  A233A                  skip or next
*PA
       SBZ  0                      card off
       LWPI DSRLWS
       MOV  9,0
*       BLWP @VSBR                  read pab status
       BL   @VDPRAD
       MOVB @VDPRD,1       
       SRL  1,13
       JNE  A238E                  err
       RTWP
A2388  LWPI DSRLWS                  errors
A238C  CLR  1                      code 0
A238E  SWPB 1
       MOVB 1,*13                  code in r0
       SOCB @A20FC,15              eq=1
       RTWP