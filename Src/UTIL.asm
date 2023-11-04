*
* Misc. Utils
*
       DEF  INCKRD
       DEF  GETMGN,GETIDT
       DEF  BYTSTR
*
       REF  MGNLST,PARLST                 From VAR.asm
       REF  KEYSTR,KEYEND,KEYRD           "    
       REF  WINMOD
       REF  ARYADR                        From ARRAY
       REF  WRAP                          From WRAP.asm

       COPY 'EQUKEY.asm'

*
* Move position in key stream forwards
* by one address.
*
INCKRD MOV  @KEYRD,R0
       INC  R0
       CI   R0,KEYEND
       JL   UPDBUF
       LI   R0,KEYSTR
UPDBUF MOV  R0,@KEYRD
       RT

*
* Get address of margin data for a paragraph
*
* Input:
*   R0 - index of paragraph
* Changed: R1
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
* Get the indent size of a paragraph
*      and line within the paragraph
*
* Input:
*    R0 = paragraph index
*    R1 = line within paragraph
* Output:
*    R0 = indent
*
GETIDT DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R1,*R10
       DECT R10
       MOV  R2,*R10
* Let R2 = desired paragrah
* Let R0 = indent of zero
       MOV  R0,R2
       CLR  R0
* Is this the first line of a paragraph?
       MOV  R1,R1
       JNE  GI2
* Yes, is this paragraph indented?
       MOV  R2,R0
       BL   @GETMGN
       MOV  R0,R1
       JEQ  GI2
* Yes, let R0 = indent from MGNLST entry.
       MOVB @INDENT(R1),R0
       SRL  R0,8
* Is this vertical mode?
       MOV  @WINMOD,@WINMOD
       JEQ  GI2
* Yes, is indent greater than the max
* for vertical mode?
       CI   R0,MAXIDT
       JLE  GI2
* Yes, decrease indent.
       LI   R0,MAXIDT
* R0 now contains the correct indent
GI2
       MOV  *R10+,R2
       MOV  *R10+,R1
       MOV  *R10+,R11
       RT

*
* Convert Byte to String
*
* Input:
*    R1 - byte to convert
*    R2 - Address of 3-char string
* Changed:
*    R3,R4,R5
*
TEN    DATA 10
ZERO   TEXT '0'
       EVEN
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
*
* Trim leading zeros
* Let R5 = left-most char
* Let R4 = right-most char
       MOV  R2,R5
       MOV  R2,R4
       INCT R4
* Let R5 = left-most non-zero
BS2    CB   *R5,@ZERO
       JNE  BS3
       INC  R5
       C    R5,R4
       JL   BS2
* Is left-most non-zero also left-most char?
BS3    C    R5,R2
       JEQ  BS6
* No, Copy characters left from R5
* Let R3 = left-most char
       MOV  R2,R3
BS4    MOVB *R5+,*R3+
       C    R5,R4
       JLE  BS4
* Fill remaining spaces with nulls
BS5    SB   *R3,*R3
       INC  R3
       C    R3,R4
       JLE  BS5
*
BS6    RT

       END