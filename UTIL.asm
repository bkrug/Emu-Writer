*
* Misc. Utils
*
       DEF  GETMGN
*
       REF  MGNLST
       REF  ARYADR

*
* Get address of margin data for a paragraph
*
* Input:
*   R0 - index of paragraph
* Output:
*   R0 - address of margin data
*
GETMGN DECT R10
       MOV  R2,*R10
       DECT R10
       MOV  R3,*R10
* Let R2 = desired paragraph
* Let R3 = index of MGNLST
       MOV  R0,R2
       MOV  @MGNLST,R0
       MOV  *R0,R3
* Look at next lower element
GM1    DEC  R3
       JLT  GMNONE
* Get address of Margin List element
       MOV  R3,R1
       BLWP @ARYADR
* Does element point to an later paragraph?
       C    *R1,R2
       JH   GM1
* No, we found the margins for current or earlier paragraph
       MOV  R1,R0
       JMP  GMRT
*
GMNONE CLR  R0
*
GMRT   MOV  *R10+,R3
       MOV  *R10+,R2
       RT

       END