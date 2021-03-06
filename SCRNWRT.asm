       DEF  GETLIN
       REF  LINLST,FMTLST,MGNLST
       REF  BUFINT,BUFALC,BUFCPY,BUFREE
* Workspace
       REF  SCRNWS
* Constants
       REF  SPACE,LF,CR
* Variables
*
* Address of the begining of a string 
* that hold source data. This address
* is one byte later than the length
* byte.
       REF  SRCLIN
* Current margin
       REF  INDENT
* Number between 0 and 7
       REF  CPI
* Next Format Address
       REF  NXTFMT
* Stores the address of the string of
* text that will be displayed.
       REF  DSPSTR
* Stores the address of the string of
* text representing the areas where a
* cursor may go.
       REF  CURSTR

* General Concepts:
*
* Character Position - position of a 
*    character within a string
* Display Position - position that a
*    a character should occupy on screen
*    Tabs and indents changes this.
*    Format changes occupy a display
*    position even though they do not
*    occupy a character position.
*
* LINLST - an array of addresses of
*    all the lines in the document.
*    The first entry is a word of 
*    memory containing the total number
*    of lines. Every other entry is a
*    word representing the the address
*    of a string comprising one line.
* FMTLST - an array of data describing
*    the character formats of text in
*    the document. Each entry is four
*    words long. The first word is the
*    index of the line in LINLST. The
*    third byte is the index of the 
*    character in the line. The fourth
*    byte describes bold, italic, 
*    underline, superscript, subscript,
*    and characters per inch.
* MGNLST - an array of data descrbing
*    margins at various points in the
*    document. SCRNWRT only cares about
*    the indent of first line and 
*    hanging indent. All margins are
*    unsigned accept first line indent.
*    Each entry is 6 bytes long. The
*    first word is a line index. The
*    third byte is the left margin. The
*    fourth byte is the right margin.
*    The fifth byte is the top/bottom
*    margin. The sixth byte is the
*    first line indent.
*    The third byte's first bit is
*    set if the paragraph is justified.
*    The fourth byte's first bit is
*    set if the paragraph is centered.

*
* GETLIN
* Get a Line of text to display.
*
* Look at a line in the writer's memory
* and create a version displayable on 
* screen.
*
* Input:
* R0 - paragraph index
* R1 - line index
* Output:
* R0 - address of created line
* R2 - length of created line
*
* R0 will contain >FFFF if we could not
* allocate space for the output strings.
GETLIN DATA SCRNWS,GETLIN+4
       MOV  *R13,R0
* Convert Line Index to string address
       LI   R1,LINLST
       MOV  *R1,R1
       INCT R1
       A    R0,R1
       A    R0,R1
* R1 now points to a location in LINLST
* that contains the string address
       MOV  *R1,R1
* R1 now contains the string address
       MOVB *R1+,R2
       SRL  R2,8
       MOV  R2,R4
* R2 and R4 now contain string length.
* Copy address of source line's start.
       MOV  R1,@SRCLIN
* Allocate space for the output strings
       BL   @ALCSPC
       MOV  R0,@DSPSTR
       MOV  R0,R3
       BL   @ALCSPC
       MOV  R0,@CURSTR
       MOV  R0,R10
* Restore line number to R0
       MOV  *R13,R0
* Initialization for copy-loop
       BL   @MGNWRT
       BL   @GETCPI
       BL   @DOINDT
       BL   @GETFMT
* Copy the string now
GTLN1  C    R1,R9
       JNE  GTLN2
       BL   @WRTFMT
GTLN2  CB   *R1,@SPACE
       JL   HDLCR
GTLN4  MOVB *R1+,*R3+
       MOVB @ALWCUR,*R10+
       DEC  R4
       JNE  GTLN1
* Setup output parameters
GTLN5
       MOV  @DSPSTR,*R13
       MOV  @CURSTR,@2(13)
       S    *R13,R3
       MOV  R3,@4(13)
       RTWP

*
* Allocate space for output
* strings.
ALCSPC LI   R0,>100
       BLWP @BUFALC
       CI   R0,>FFFF
       JEQ  ALCSP2
       RT
ALCSP2 SETO *R13
       RTWP

* 
* Handle CR/LF:
* If source line contains CRLF, replace
* it with a space and end processing.
*
* Input: R1,R3,R10
* Output: R5,R6
* Conditional Output: R3,R10
HDLCR  MOV  R1,R5
       MOVB *R5+,R6
       SWPB R6
       MOVB *R5,R6
       SWPB R6
       CI   R6,>0A0D
       JEQ  HDLCR1
       CI   R6,>0D0A
       JEQ  HDLCR1
       CB   R6,@CR
       JNE  GTLN4
HDLCR1 MOVB @SPACE,*R3+
       MOVB @ALWCUR,*R10+
       JMP  GTLN5

* Character code for inverted symbols
INVPL  BYTE >AB
INVMN  BYTE >AD
INV0   BYTE >B0
INV1   BYTE >B1
INV2   BYTE >B2
INV5   BYTE >B5
INV6   BYTE >B6
INV7   BYTE >B7
INVB   BYTE >C2
INVC   BYTE >C3
INVI   BYTE >C9
INVJ   BYTE >CA
INVL   BYTE >CC
INVM   BYTE >CD
INVN   BYTE >CE
INVR   BYTE >D2
INVU   BYTE >D5
INVLB  BYTE >E2
INVLE  BYTE >E5

* Allow Cursor
ALWCUR BYTE >00
* Prohibit Cursor
PBTCUR BYTE >FF
       EVEN

*
* If margin settings have changed,
* display notification of changes
* Store Indent amount at @INDENT.
* Store flag representing if the 
* paragraph is centered or not @CENTER.
*
* Input: R0,R3,R10
* Conditional Output: R3,R10
* Output: R5,R6,R7,R8
MGNWRT LI   R6,MGNLST
       MOV  *R6,R5
MGNW1  AI   R6,6
       C    *R6,R0
       JHE  MGNW2
       DEC  R5
       JNE  MGNW1
* R5 will look at previous margin entry.
* R6 will look at next margin entry.
MGNW2  MOV  R6,R5
       AI   R5,>FFFA
       CI   R5,MGNLST
       JH   MGNW3
       LI   R5,DFTMGN-2
* Is there a margin entry for the
* current line of text?
MGNW3  C    *R6,R0
       JEQ  MGNW3A
* No, so store old indent and return
       AI   R5,5
       MOVB *R5,R7
       SRA  R7,8
       MOV  R7,@INDENT
       RT
* Yes, look for changes from previous
* margin entry.
MGNW3A INCT R5
       INCT R6
* See if justification changed.
       MOV  *R5,R7
       MOV  *R6,R8
       SZC  @CLRMGN,R7
       SZC  @CLRMGN,R8
       C    R7,R8
       JEQ  MGNW6
* If newly left justified
       MOV  R8,R8
       JNE  MGNW4
       MOVB @INVL,*R3+
       MOVB @INVJ,*R3+
       MOVB @ALWCUR,*R10+
       MOVB @PBTCUR,*R10+
       JMP  MGNW6
* If newly justified
MGNW4  CI   R8,>8000
       JNE  MGNW5
       MOVB @INVJ,*R3+
       MOVB @INVU,*R3+
       MOVB @ALWCUR,*R10+
       MOVB @PBTCUR,*R10+
       JMP  MGNW6
* If newly centered
MGNW5  
       CI   R8,>0080
       JNE  MGNW6
       MOVB @INVC,*R3+
       MOVB @INVN,*R3+
       MOVB @ALWCUR,*R10+
       MOVB @PBTCUR,*R10+
* See if left margin changed
MGNW6  MOVB *R5+,R7
       MOVB *R6+,R8
       SZC  @CLRJ,R7
       SZC  @CLRJ,R8
       C    R7,R8
       JEQ  MGNW7
       MOVB @INVL,*R3+
       MOVB @INVM,*R3+
       MOVB @ALWCUR,*R10+
       MOVB @PBTCUR,*R10+
* See if right margin changed
MGNW7  MOVB *R5+,R7
       MOVB *R6+,R8
       SZC  @CLRJ,R7
       SZC  @CLRJ,R8
       C    R7,R8
       JEQ  MGNW8
       MOVB @INVR,*R3+
       MOVB @INVM,*R3+
       MOVB @ALWCUR,*R10+
       MOVB @PBTCUR,*R10+
* See if top/bottom margin changed
MGNW8  MOVB *R5+,R7
       MOVB *R6+,R8
       C    R7,R8
       JEQ  MGNW9
       MOVB @INVB,*R3+
       MOVB @INVM,*R3+
       MOVB @ALWCUR,*R10+
       MOVB @PBTCUR,*R10+
* Store indent
MGNW9  INC  R5
       MOVB *R6+,R8
       SRA  R8,8
       MOV  R8,@INDENT
       RT

*
* Indent if nessecary
*
* Input:
* R0 - Index of the current line of text
* R3 - Address within output string
* R10 - Address within cursor string
* Conditional Output:
* R3 - Advanced by one or more positions
* R10 - Advanced by one or more positions
* Output:
* R5,R6,R7,R8,R9
*
DOINDT 
* Find out if this is the begining of a
* paragraph.
       MOV  R0,R0
* If line index is zero, then yes.
       JEQ  DOIND4
* Calculate the address of prior line of
* text and place it in R6.
       LI   R6,LINLST
       MOV  *R6,R6
       A    R0,R6
       A    R0,R6
       MOV  *R6,R6
* Did previous line end in Carrg Return?
       MOVB *R6,R5
       SRL  R5,8
* If previous line is empty, then no.
       JEQ  DOIND3
       A    R5,R6
* Check last byte of string.
       CB   *R6,@CR
       JEQ  DOIND4
* Check last two bytes of string.
       CB   *R6,@LF
       JNE  DOIND3
       DEC  R6
       CB   *R6,@CR
       JEQ  DOIND4
* No, not begining of paragraph.
* If configured indent is negative,
* display it.
DOIND3 MOV  @INDENT,R6
       JGT  DOIND7
       JEQ  DOIND7
       NEG  R6
       JMP  DOIND5
* Yes, begining of paragraph.
* If configured indent is positive,
* display it.
DOIND4 MOV  @INDENT,R6
       JLT  DOIND7
       JEQ  DOIND7
* Find the number of characters
* required by indent.
* Convert Indent from n/20 to n/120 of
* an inch.
DOIND5 MPY  @SIX,R6
* Get width of one character.
       LI   R8,PITCH
       A    @CPI,R8
       A    @CPI,R8
       MOV  *R8,R8
* Increase indent by enough to allow
* rounding to nearest integer.
       MOV  R8,R9
       SRL  R9,1
       A    R9,R7
* Divide Indent by char width.
       DIV  R8,R6
* Return if indent is 0 chars.
       MOV  R6,R6
       JEQ  DOIND7
DOIND6 MOVB @SPACE,*R3+
       MOVB @PBTCUR,*R10+
       DEC  R6
       JNE  DOIND6
DOIND7 RT

* Default Margin settings
DFTMGN DATA >1414,>2800
* Used in SZC to extract justification
CLRMGN DATA >7F7F
* Used in SZC to extract left or right
* margin
CLRJ   DATA >80FF
* Current margin
*      REF  INDENT
* Number between 0 and 7 representing 
* current CPI.
* 0 through 7 respectively mean:
* 20, 17.14, 15, 12, 10, 7.5, 6, 5
*      REF  CPI

* Describe each of these CPIs as n/120
* of an inch.
* 20, 17.14, 15, 12, 10, 7.5, 6, 5
PITCH  DATA 6
       DATA 7
       DATA 8
       DATA 10
       DATA 12
       DATA 16
       DATA 20
       DATA 24
PITCHE
ONETWT DATA 120
SIX    DATA 6

*
* Get Initial CPI
*
* Input:
* R0 - Index of current line of text.
* Output:
* R5,R6
GETCPI MOV  R0,R0
       JEQ  GTCPI4
       LI   R5,FMTLST
       MOV  *R5,R5
* Set R6 to the end of FMTLST
       MOV  *R5,R6
       INC  R6
       SLA  R6,2
       A    R5,R6
* Find first Format for current line or
* later.
GTCPI1 AI   R5,4
       C    R5,R6
       JHE  GTCPI2
       C    *R5,R0
       JL   GTCPI1
* Save CPI of previous format
       MOV  R5,R6
       DEC  R6
       MOVB *R6,R6
GTCPI3 SLA  R6,5
       SRL  R6,13
       MOV  R6,@CPI
GTCPI2 RT
* R0 is in the first line, so assume
* default format.
GTCPI4 MOVB @DFTFMT,R6
       JMP  GTCPI3

*
* Find first point in current line
* where the character format will change
*
* Input: 
* R0 - Index of current line of text.
* Output:
* R5
* R6
* R9 the position in source string where
*    a string the format is going to 
*    apply.
* NXTFMT
GETFMT LI   R5,FMTLST
       MOV  *R5,R5
* Set R6 to the end of FMTLST
       MOV  *R5,R6
       INC  R6
       SLA  R6,2
       A    R5,R6
* Find first Format for current line or
* later.
FMT1   AI   R5,4
       C    R5,R6
       JHE  FMT2
       C    *R5,R0
       JL   FMT1
       JH   FMT2
* Store address of located format.
FMT3   MOV  R5,@NXTFMT
* Store address within source string at
* which next format will apply
       INCT R5
       MOVB *R5,R9
       SRL  R9,8
       A    @SRCLIN,R9
       RT
* No format affects current line.
FMT2   CLR  R9
       CLR  @NXTFMT
       RT

* 
* Write format characters
WRTFMT MOV  R11,R12
* Give R6 address of new format entry.
       MOV  @NXTFMT,R6
* Is this the first format entry?
       LI   R5,FMTLST
       MOV  *R5,R5
       AI   R5,4
       C    R6,R5
       JEQ  WFMT1
* No.
* Give R5 address of previous format.
       MOV  R6,R5
       DEC  R5
       JMP  WFMT2
* Yes, R6 points to first format entry.
* Give R5 address of DFTFMT.
WFMT1  LI   R5,DFTFMT
* Point R6 to format byte.
WFMT2  AI   R6,3
* Set R8 such that set bits represent
* newly turned on formats.
       MOVB *R5,R7
       MOVB *R6,R8
       SZC  R7,R8
* Write the on-format characters into
* the display string
       LI   R7,BLDBIT
       LI   R9,FMTON
       BL   @WFMT3
* Set R8 such that set bits represent
* newly turned off formats.
       MOVB *R5,R8
       MOVB *R6,R7
       SZC  R7,R8
* Write the off-format characters into
* the display scring
       LI   R7,BLDBIT
       LI   R9,FMTOFF
       BL   @WFMT3
* Look for change in CPI
       MOVB *R5,R7
       MOVB *R6,R8
       SLA  R7,5
       SRL  R7,13
       SLA  R8,5
       SRL  R8,13
* Save CPI
       MOV  R8,@CPI
*
       C    R7,R8
       JEQ  WFMT5
* The CPI changed.
* Get address of text representing
* the new value.
       LI   R7,CPITXT
       A    R8,R7
       A    R8,R7
* Add to display string
       MOVB @INVC,*R3+
       MOVB *R7+,*R3+
       MOVB *R7+,*R3+
       MOVB @ALWCUR,*R10+
       MOVB @PBTCUR,*R10+
       MOVB @PBTCUR,*R10+
* Set R6 to next format position.
WFMT5  INC  R6
* See if R6 has gone past the end of the
* format list
       LI   R7,FMTLST
       MOV  *R7,R7
       MOV  *R7,R8
       INC  R8
       SLA  R8,2
       A    R7,R8
       C    R6,R8
       JHE  WFMT8
* There is another format entry. Does
* it reference the current line?
       C    *R6,R0
       JNE  WFMT8
* Yes, so do same routine as GETFMT.
       MOV  R6,R5
       MOV  R12,R11
       B    @FMT3
* Return to main routine such
* that we know the current line will not
* have any more format changes.
WFMT8  MOV  R12,R11
       B    @FMT2

WFMT3  COC  *R7,R8
       JNE  WFMT4
       MOVB *R9+,*R3+
       MOVB *R9+,*R3+
       MOVB @ALWCUR,*R10+
       MOVB @PBTCUR,*R10+
       JMP  WFMT4A
WFMT4  INCT R9
WFMT4A INCT R7
       CI   R7,FMTON
       JL   WFMT3
       RT

* Default Formating
DFTFMT BYTE >04
       EVEN
* Next Format Address
*NXTFMT


* Bits for comparisons
*
* Bold bit
BLDBIT DATA >8000
* Italic bit
ITCBIT DATA >4000
* Underline bit
UDLBIT DATA >2000
* Superscript bit
SPRBIT DATA >1000
* Subscript bit
SBTBIT DATA >0800

* Characters for turning format on
*
* Bold
FMTON  DATA >C2E2
* Italic
       DATA >C9E2
* Underline
       DATA >D5E2
* Superscript
       DATA >ABE2
* Subscript
       DATA >ADE2

* Characters for turning format off
*
* Bold
FMTOFF DATA >C2E5
* Italic
       DATA >C9E5
* Underline
       DATA >D5E5
* Superscript
       DATA >ABE5
* Subscript
       DATA >ADE5
       
* CPIs as text
CPITXT DATA >B2B0
       DATA >B1B7
       DATA >B1B5
       DATA >B1B2
       DATA >B1B0
       DATA >B0B7
       DATA >B0B6
       DATA >B0B5
       END