       DEF  LNDIFF
*
       REF  LOOKWS,LINLST
*

* Methods that look backwards or
* forwards by an arbitrary number of
* document lines. Given a paragraph and
* paragraph-line, the routines can
* determine which paragraph and
* paragraph-line is a given number of
* document-lines earlier or later.

       TEXT 'LNDIFF'
*
* Find the number of document lines 
* between two paragraph lines.
*
* R0&R1 must point to earlier document
* line than R2&R3.
*
*Input:
* R0 - Paragraph Index 1
* R1 - Paragraph-Line 1
* R2 - Paragraph Index 2
* R3 - Paragraph-Line 2
*Output:
* R0 - Line Count
LNDIFF DATA LOOKWS,LNDIFF+4
* Let R0 be the destination paragraph
* Let R1 be lines to ignore in 
*        destination paragraph
* Let R2 be current paragraph index
* Let R3 be number of lines counted
       MOV  *R13+,R0
       MOV  *R13+,R1
       MOV  *R13+,R2
       MOV  *R13+,R3
       AI   R13,-8
* Let R4 be an address in the paragraph
* list
       MOV  R2,R4
       SLA  R4,1
       C    *R4+,*R4+
       A    @LINLST,R4
* Stop when R2 < R0
DIF1   C    R2,R0
       JLE  DIF2
* Move to previous paragraph
       DECT R4
       DEC  R2
* Let R5 be the address of a paragraph
       MOV  *R4,R5
* Let R5 be the address of the wrap list
       INCT R5
       MOV  *R5,R5
* Let R5 be the number of paragraph-lines
       MOV  *R5,R5
       INC  R5
* Increase the line-count
       A    R5,R3
       JMP  DIF1
* Subtract paragraph-lines of earlier
* paragraph
DIF2   S    R1,R3
* Return result
       MOV  R3,*R13
       RTWP

       END