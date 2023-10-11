*
* Misc. Utils
*
       DEF  GETMGN
       DEF  WRAPDC,WRAPDW
       DEF  BYTSTR
*
       REF  MGNLST,LINLST
       REF  ARYADR
       REF  WRAP

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

*
* WRAPDC = Wrap all paragraphs in document
* No Input
*
* WRAPDW = Wrap all paragraphs down from given paragraph
* Input
*   R0 = starting paragraph
*
WRAPDC CLR  R0
WRAPDW MOV  @LINLST,R2
WRAPLP C    R0,*R2
       JHE  WRAPDN
       CLR  R1
       BLWP @WRAP
       JEQ  WRAPDN             * If memory error occurs, stop wrapping
       INC  R0
       JMP  WRAPLP
WRAPDN
       RT

*
* Convert Byte to String
*
* Input:
*    R1 - byte to convert
*    R2 - Address of 3-char string
*
TEN    DATA 10
BYTSTR
* Let R5 = address of char (starting from end)
       MOV  R2,R5
       INCT R5
* Let R3 & R4 be used to divide byte value by 10
       CLR  R3
       MOVB R1,R4
       SRL  R4,8
* Divide value by 10
BS1    DIV  @TEN,R3
* Convert remainder to ASCII
       AI   R4,'0'
       SLA  R4,8
* Store new char
       MOVB R4,*R5
* Prepare for next iteration
       DEC  R5
       MOV  R3,R4
       CLR  R3
* Check if we should loop
       C    R5,R2
       JHE  BS1
       RT

       END