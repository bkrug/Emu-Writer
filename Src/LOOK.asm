       DEF  LOOKUP,LNDIFF
*
       REF  LOOKWS,LINLST
*

* This data is a work around for the "first DATA word is 0 bug"
       DATA >1234

* Methods that look backwards or
* forwards by an arbitrary number of
* document lines. Given a paragraph and
* paragraph-line, the routines can
* determine which paragraph and
* paragraph-line is a given number of
* document-lines earlier or later.

*
* Look backwards by a given number
* of document-lines.
*
* Input:
* R0 contains the original paragraph
*    index.
* R1 contains the original
*    paragraph-line index.
* R2 contains the number of
*    document-lines to move.
* Output:
* R0 contains the earlier paragraph
*    index.
* R1 contains the earlier paragraph-
*    line index.
       TEXT 'LOOKUP'
LOOKUP DATA LOOKWS,LOOKUP+4
* Let R0 be the paragraph index.
* Let R1 be the paragraph-line index.
* Let R2 be the number of lines we wish
*        to move.
* Let R3 be the number of lines counted
       MOV  *R13,R0
       CLR  R1
       MOV  @4(13),R2
       MOV  @2(13),R3
* Let R4 be an address in the paragraph
* list
       MOV  R0,R4
       SLA  R4,1
       C    *R4+,*R4+
       A    @LINLST,R4
* If we've counted too many lines,
*   reduce the distance we've moved.
* If we've counted the correct number
*   of lines, leave the loop.
UPLOOP C    R3,R2
       JH   UPREDU
       JEQ  UPDONE
* Move to the previous paragraph
       DECT R4
       DEC  R0
* If moving past document-start, quit.
       JLT  UPDONE
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
       JMP  UPLOOP

UPREDU
* We went to far.
* Let R1 be the number of lines too far.
       MOV  R3,R1
       S    R2,R1
* R1 now also contains the correct
* paragraph-line index representing the 
* destination.

UPDONE
* Now copy the paragraph index and
* paragraph-line index to the output
* parameters.
       MOV  R0,*R13
       MOV  R1,@2(13)
*
       RTWP

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