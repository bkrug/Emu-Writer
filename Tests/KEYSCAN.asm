       DEF  RUNTST
       REF  VMBW,VSBW

* Demonstration of scanning the keyboard
* without using the console's SCAN routine.
*
* See Console CRU map here:
* http://www.unige.ch/medecine/nouspikel/ti99/cru.htm#console%20map

MSG1   TEXT '                  '
MSG2   TEXT '  CAP.LCK.01234567'
MSG3
       EVEN
CHRDAT DATA >0101,>0101,>0101,>01FF
       DATA >55AB,>55AB,>55AB,>55FF
CHREND

RUNTST
* Define chars
       LI   R0,>C00
       LI   R1,CHRDAT
       LI   R2,16
       BLWP @VMBW
* Print Columns
       LI   R0,0
       LI   R1,MSG1
       LI   R2,MSG2-MSG1
       BLWP @VMBW
       LI   R0,>20
       LI   R1,MSG2
       LI   R2,MSG3-MSG2
       BLWP @VMBW
* Print Rows
       LI   R0,>41
       LI   R1,>3000
DSPROW BLWP @VSBW
       AI   R0,>20
       AI   R1,>0100
       CI   R1,>3700
       JLE  DSPROW
* Print empty boxes
       LI   R0,>42
       LI   R1,>8000
DSPBOX BLWP @VSBW
       INC  R0
       MOV  R0,R2
       SLA  R2,11
       CI   R2,>9000
       JL   DSPBOX
       AI   R0,>10
       CI   R0,>142
       JL   DSPBOX
DOSCAN
* Scan
* R2 will store the keyboard column
       CLR  R2
* Select column to scan
DSPK0  LI   R12,>0024
       LDCR R2,4
* Put scaned keyboard rows in R3
       LI   R12,>0006
       CLR  R3
       STCR R3,8
       SWPB R3
* Write scans to screen
       MOV  R2,R0
       SRL  R0,8
       AI   R0,>42           * shift two columns right, two rows down
* Display empty or filed box
DSPK1  LI   R1,>8000
       SRL  R3,1
       JNC  DSPK2
       LI   R1,>8100
DSPK2  BLWP @VSBW
* Investigate next bit
       AI   R0,>20
       CI   R0,>140
       JL   DSPK1
* Investigate next column
       AI   R2,>0100
       CI   R2,>1000
       JL   DSPK0
       JMP  DOSCAN
       END
p