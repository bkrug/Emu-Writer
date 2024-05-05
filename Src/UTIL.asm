*
* Misc. Utils
*
       DEF  INCKRD
       DEF  GETMGN,GETIDT
       DEF  BYTSTR
       DEF  PARADR,GETLIN
       DEF  LOOKUP,MGNADR
*
       REF  MGNLST,PARLST                 From VAR.asm
       REF  KEYSTR,KEYEND,KEYRD           "    
       REF  WINMOD                        "
       REF  PARINX,CHRPAX                 "
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
* Output:
*   R0 - address of margin data
*
GETMGN DECT R10
       MOV  R1,*R10
       DECT R10
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
       MOV  *R10+,R1
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
* Does this paragraph have a margin?
       BL   @GETMGN
       MOV  R0,R2
       JEQ  GOTIDT
* Yes, let R0 = indent from MGNLST entry.
       MOVB @INDENT(R2),R0
       SRA  R0,8
       JEQ  GOTIDT
* Is the indent positive, and is this
* the first line of the paragraph?
       JLT  GI0
       MOV  R1,R1
       JEQ  GI1
* No, treat indent as zero.
CLRIDT CLR  R0       
       JMP  GOTIDT
* No, the indent is negative. Is this
* a later line?
GI0    MOV  R1,R1
       JEQ  CLRIDT
* Yes, find absolute value of indent
       ABS  R0
* Is this vertical mode?
GI1    MOV  @WINMOD,@WINMOD
       JEQ  GOTIDT
* Yes, is indent greater than the max
* for vertical mode?
       CI   R0,MAXIDT
       JLE  GOTIDT
* Yes, decrease indent.
       LI   R0,MAXIDT
* R0 now contains the correct indent
GOTIDT
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

*
* Get paragraph address and wrap list
* address.
*
* Input:
* R3 - paragraph index
* Output:
* R3 - paragraph address
* R4 - wrap list address
PARADR
* Set R3
       MOV  @PARINX,R3
       SLA  R3,1
       A    @PARLST,R3
       C    *R3+,*R3+
       MOV  *R3,R3
* Set R4
       MOV  R3,R4
       INCT R4
       MOV  *R4,R4
*
       RT

*
* Given CHRPAX and address of wrap list,
* find the paragraph-line index
* and the horizontal position within the line (including indents).
*
* Input:
*   CHRPAX
*   R4 - address of wrap list
* Output:
*   R2 - line index
*   R6 - horizontal position
* Changed:
*   R5
GETLIN
       DECT R10
       MOV  R11,*R10
* Let R3 = Address of paragraph
* Let R4 = Wrap list address
       BL   @PARADR
* Let R5 = current location in wrap list
* Let R6 = end of wrap list
       MOV  R4,R5
       C    *R5+,*R5+
       MOV  *R4,R6
       SLA  R6,1
       A    R5,R6
* Let R2 = line index
       SETO R2
       DECT R5
* Increment line index until we find an entry >= CHRPAX
LIN1   INC  R2
       INCT R5
       C    R5,R6
       JEQ  LIN2
       C    *R5,@CHRPAX
       JLE  LIN1
* Let R6 = horizontal position
LIN2   MOV  @CHRPAX,R6
* Is the current line, the first line?
       MOV  R2,R2
       JEQ  LIN3
* No, subtract the previous line break from R6
       DECT R5
       S    *R5,R6
* Let R0 = the indent for this line
LIN3   MOV  @PARINX,R0
       MOV  R2,R1
       BL   @GETIDT
* Increase horizontal position by indent
       A    R0,R6
*
       MOV  *R10+,R11
       RT

*
* Find paragraph and line index a certain number of lines upwards.
*
* Input:
*   R2 = original paragraph index
*   R3 = original line index
*   R4 = number of lines to look upwards
* Output:
*   R2 = earlier paragraph index
*   R3 = earlier line index
*   R4 = value for WINMGN earlier in document
LOOKUP DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R5,*R10
* Let R5 = value of WINMGN if screen actually scrolls
       CLR  R5
CD1
* Does the paragraph have a margin entry?
       MOV  R2,R0
       BL   @MGNADR
       MOV  R1,R1
       JEQ  CD2
* Yes, increase reported size of paragraph by one line
       INC  R3
CD2
* Is number of remaining lines moving backwards
* smaller than remaining lines in this paragraph?
       C    R4,R3
       JLE  CD3
* No, look upwards by at least one paragraph.
* Decrease R4 by this paragraph's line count.
       S    R3,R4
       DEC  R4
* Point to earlier paragraph
       DEC  R2
       JLT  CD4
* Let R1 = address in PARLST
       MOV  @PARLST,R0
       MOV  R2,R1
       BLWP @ARYADR
* Let R1 = address of paragraph
       MOV  *R1,R1
* Let R1 = address of wrap list
       MOV  @2(R1),R1
* Let R3 = index of last line in paragraph
       MOV  *R1,R3
* Try next paragraph
       JMP  CD1
* Earliest acceptable line is in this paragraph
CD3    S    R4,R3
* Is this a paragraph with a Margin Entry?       
       MOV  R1,R1
       JEQ  CD5
* Yes, so R3 is one line too large.
       DEC  R3
       JGT  CD5
       JEQ  CD5
* Actually, R3 was fine,
* but we need to display the margin entry. 
       CLR  R3       
       SETO R5
       JMP  CD5
* Earliest acceptable line is the beginning of the document
CD4    CLR  R2
       CLR  R3
* Move value of WINMGN to R4
CD5    MOV  R5,R4
*
       MOV  *R10+,R5
       MOV  *R10+,R11
       RT

*
* Get address of paragraph's
* Margin entry
*
* Input:
*   R0: paragraph index
* Output:
*   R1: address of margin entry, if any
*       holds 0, if the margin entry is not exact
*
MGNADR DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R0,*R10
* Get MGNLST entry for this paragraph
       BL   @GETMGN
       MOV  R0,R1
       JEQ  MA1
* Is the entry pointing to an earlier paragraph?
* top of stack contains original input for R0
       C    *R1,*R10
       JEQ  MA1
* No, the entry is for a different paragraph.
       CLR  R1
*
MA1
       MOV  *R10+,R0
       MOV  *R10+,R11
       RT

       END