       DEF  RUNTST,DSPTXT
*
       REF  LINLST,FMTLST,MGNLST
       REF  GETLIN
       REF  BUFINT,BUFALC,BUFREE,BUFCPY
       REF  MAKETX,PRINTL,OPENF,CLOSEF
       REF  VMBW,VMBR,VWTR

* Run all tests
* Keep RUNTST at the beginning of this
* program so that LSCRNTST can find italic
* easily.
RUNTST BLWP @OPENF
* Initialize the memory buffer.
       BL   @INTBUF
* Register mock line list and format
* list.
       LI   R0,LINES
       MOV  R0,@LINLST
       LI   R0,FMT0
       MOV  R0,@FMTLST
       LI   R0,MGN0
       MOV  R0,@MGNLST
* Create inverted characters
       BL   @CHRSET
* Write notification on screen.
       BL   @WRTST
* Loop through every test.
       BL   @TSTLP
* Write notification on screen.
       BL   @WREND
       BLWP @CLOSEF
LOOP   LIMI 2
       LIMI 0
       JMP  LOOP

* We define LINLST,FMTLST,MGN0 here as
* mocks. They would be defined in a 
* source file.

*
* This section is all of the lines of
* text in the document as they would
* appear in the memory buffer.
* They do not include formatting as that
* is stored in a separate location.
*
* This paragraph is indented in the
* first line.
WRAP1  DATA 4,1,48,108,163,215
LIN1   DATA 231,WRAP1
LIN1A  TEXT 'In physics, mass energy equivalence states '
       TEXT 'that '
LIN1B  TEXT 'anything having mass has an equivalent amount '
       TEXT 'of energy and '
LIN1C  TEXT 'vice versa, with these fundamental quantities '
       TEXT 'directly '
LIN1D  TEXT 'relating to one another by Albert Einstein,s '
       TEXT 'famous '
LIN1E  TEXT 'formulafootnote1'
       EVEN

WRAP2  DATA 0,1
LIN2   DATA 11,WRAP2
LIN2A  TEXT 'E=mc2   H2O'
       EVEN

* This paragraph has a hanging indent.
* Word "Similiarly" is bold and
* "having" is italic.
* "corresponding" is underlined.
* "c2" is italic with "2" superscript.
WRAP3  DATA 5,1,58,112,160,215,267
LIN3   DATA 178,WRAP3
LIN3A  TEXT 'This formula states that the equivalent '
       TEXT 'energy (E) can be '
LIN3B  TEXT 'calculated as the mass (m) multiplied by the '
       TEXT 'speed of '
LIN3C  TEXT 'light (c = about 3*108 m/s) squared. '
       TEXT 'Similarly, '
LIN3D  TEXT 'anything having energy exhibits a '
       TEXT 'corresponding mass m '
LIN3E  TEXT 'given by its energy E divided by the speed '
       TEXT 'of light '
LIN3F  TEXT 'squared c2.'
       EVEN

WRAP4  DATA 0,1
LIN4   DATA 0,WRAP4

WRAP5  DATA 6,1,LIN5B-LIN5A
       DATA LIN5C-LIN5B,LIN5D-LIN5C
       DATA LIN5D-LIN5C,LIN5E-LIN5D
       DATA LIN5F-LIN5E
LIN5   DATA LIN5G-LIN5A,WRAP5
LIN5A  TEXT 'The American Legion was a British provincial '
       TEXT 'militia '
LIN5B  TEXT 'unit raised for Loyalist service late in the '
       TEXT 'American '
LIN5C  TEXT 'Revolutionary War by Benedict Arnold, the '
       TEXT 'former Continental '
LIN5D  TEXT 'Army general who had crossed over from the '
       TEXT 'Patriots to the '
LIN5E  TEXT 'British. The unit was composed primarily of '
       TEXT 'deserters from '
LIN5F  TEXT 'the Continental Army.'
LIN5G
       EVEN

WRAP6  DATA 0,1
LIN6   DATA LIN6B-LIN6A,WRAP6
LIN6A  TEXT 'Regiment Formed'
LIN6B
       EVEN

WRAP7  DATA 0,1
LIN7   DATA LIN7B-LIN7A
LIN7A  TEXT 'Another line of text'
LIN7B
       EVEN

*
* This is a list of pointers to every
* line of text in the document.
* The running application would need
* this because each line takes up
* different amounts of space and are not
* stored in memory in order.
*
LINES  DATA 7,1
       DATA LIN1
       DATA LIN2
       DATA LIN3
       DATA LIN4
       DATA LIN5
       DATA LIN6
       DATA LIN7

*
* This is a list of all of the character
* formats in the document.
* The first word of memory is the number
* of entries in the list.
* The second word of memory is wasted
* space.
* The rest of the structure is made up
* of four byte entries:
*   bytes 0&1 - line index within LINLST
*   byte 2    - char position with line
*   byte 3    - charater formats
* Bits 0 through 4 represent these
* formats:
* bold, italic, underline, super, sub
*
* Bits 5 through 7 represent one of
* six possible CPIs.
BOLD   EQU  >80
ITALIC EQU  >40
UNDRLN EQU  >20
SUPSCR EQU  >10
SUBSCR EQU  >08
CPI05  EQU  24
CPI10  EQU  12
CPI15  EQU  8
*
FMT0   DATA 17,3
* Superscript
       DATA 0,LIN1E-LIN1A+7
       BYTE SUPSCR,0
       DATA CPI10
*
       DATA 0,LIN1E-LIN1A+16
       BYTE 0,0
       DATA CPI10
* Superscript
       DATA 1,4
       BYTE SUPSCR,0
       DATA CPI10
*
       DATA 1,5
       BYTE 0,0
       DATA CPI10
* Subscript
       DATA 1,9
       BYTE SUBSCR,0
       DATA CPI10
*
       DATA 1,10
       BYTE 0,0
       DATA CPI10
* Bold
       DATA 2,LIN3C-LIN3A+37
       BYTE BOLD,0
       DATA CPI10
*
       DATA 2,LIN3C-LIN3A+46
       BYTE 0,0
       DATA CPI10
* Italic
       DATA 2,LIN3D-LIN3A+9
       BYTE ITALIC,0
       DATA CPI10
*
       DATA 2,LIN3D-LIN3A+15
       BYTE 0,0
       DATA CPI10
* Underline
       DATA 2,LIN3D-LIN3A+34
       BYTE UNDRLN,0
       DATA CPI10
*
       DATA 2,LIN3D-LIN3A+47
       BYTE 0,0
       DATA CPI10
* Italic, then superscript
       DATA 2,LIN3F-LIN3A+8
       BYTE ITALIC,0
       DATA CPI10
*
       DATA 2,LIN3F-LIN3A+9
       BYTE ITALIC+SUPSCR,0
       DATA CPI10
*
       DATA 2,LIN3F-LIN3A+10
       BYTE 0,0
       DATA CPI10
* 5 CPI
       DATA 4,LIN5B-LIN5A+6
       BYTE 0,0
       DATA CPI05
* 15 CPI
       DATA 4,LIN5C-LIN5A+7
       BYTE 0,0
       DATA CPI15

*
* This is a list of all of the margins.
* Each entry is 6 bytes long.
* The first word is the number of
* entries.
* Bytes 2-5 are wasted space.
* In each entry:
*  Byte 0-1 - line index
*  Byte 2, bit 0 - Justified flag
*  Byte 2, bit 1-7 - left margin
*  Byte 3, bit 0 - Centered flag
*  Byte 3, bit 1-7 - right margin
*  Byte 4 - (signed) indent
*  Byte 5 - top/bottom margin combined
*
MGN0   DATA 6,3
* Default is >0000,>1414,>1414
*
* Indented half-inch,
* Half-inch left/right margin
       DATA 0,>000A,>0A0A,>1414
* End Indented,
* Top+Bottom margin 2.1 in.
       DATA 1,>0000,>0A0A,>1515
* Hanging Indent half-inch
* Justified
       DATA 2,>80F6,>0A0A,>1515
* Indented 7/10 inch
* 1-inch left/right margins
       DATA 3,>800E,>1414,>1515
* Centered
       DATA 5,>400E,>1414,>1515
* Non-Justified
       DATA 6,>000E,>1414,>1515

* Users will see inverse images of
* letters to represent changes in
* formatting.
* >B0   Inverted 0
* >B1   Inverted 1
* >B2   Inverted 2
* >B5   Inverted 5
* >B6   Inverted 6
* >B7   Inverted 7
* >C2   Inverted B
* >C3   Inverted C
* >C9   Inverted I
* >CA   Inverted J
* >CC   Inverted L
* >CD   Inverted M
* >CE   Inverted N
* >D2   Inverted R
* >D5   Inverted U
* >AB   Inverted +
* >AD   Inverted -
* >E2   Inverted b
* >E5   Inverted e

*
* Expected Display Lines
*
* Each line labeled "DSP.." contains
* text as it would appear on the screen.
*
* Each line labeled "CUR.." symbols for
* where a cursor may be placed.
* SCRNWRT returns a cursor string where
* a cursor can be placed over positions
* containing >00, but not >FF.
* Spaces below represent >00 and X
* represents >FF.
*
DSP1A  BYTE >CC,>CD,>D2,>CD
       TEXT '     In physics, mass energy equivalence '
       TEXT 'states that '
DSP1B  TEXT 'anything having mass has an equivalent amount '
       TEXT 'of energy and '
DSP1C  TEXT 'vice versa, with these fundamental quantities '
       TEXT 'directly '
DSP1D  TEXT 'relating to one another by Albert Einstein,s '
       TEXT 'famous '
DSP1E  TEXT 'formula'
       BYTE >AB,>E2
       TEXT 'footnote1'
       BYTE >AB,>E5
       TEXT ' '
DSP2   BYTE >C2,>CD
       TEXT 'E=mc'
       BYTE >AB,>E2
       TEXT '2'
       BYTE >AB,>E5
       TEXT '   H'
       BYTE >AD,>E2
       TEXT '2'
       BYTE >AD,>E5
       TEXT 'O '
* This paragraph has a hanging indent.
* Word "Similiarly" is bold and
* "having" is italic.
* "corresponding" is underlined.
* "c2" is italic with "2" superscript.
DSP3A  BYTE >CA,>D5
       TEXT 'This formula states that the equivalent '
       TEXT 'energy (E) can be '
DSP3B  TEXT '     calculated as the mass (m) multiplied by '
       TEXT 'the speed of '
DSP3C  TEXT '     light (c = about 3*108 m/s) squared. '
       BYTE >C2,>E2
       TEXT 'Similarly'
       BYTE >C2,>E5
       TEXT ', '
DSP3D  TEXT '     anything '
       BYTE >C9,>E2
       TEXT 'having'
       BYTE >C9,>E5
       TEXT ' energy exhibits a '
       BYTE >D5,>E2
       TEXT 'corresponding'
       BYTE >D5,>E5
       TEXT ' mass m '
DSP3E  TEXT '     given by its energy E divided by the '
       TEXT 'speed of light '
DSP3F  TEXT '     squared '
       BYTE >C9,>E2
       TEXT 'c'
       BYTE >AB,>E2
       TEXT '2'
       BYTE >C9,>E5,>AB,>E5
       TEXT '. '
DSP4   BYTE >CC,>CD,>D2,>CD
       TEXT '        '
DSP5A  TEXT '       The American Legion was a British '
       TEXT 'provincial militia '
DSP5B  TEXT 'unit r'
       BYTE >C3,>B0,>B5
       TEXT 'aised for Loyalist service late in the '
       TEXT 'American '
DSP5C  TEXT 'Revolut'
       BYTE >C3,>B1,>B5
       TEXT 'ionary War by Benedict Arnold, the former '
       TEXT 'Continental '
DSP5D  TEXT 'Army general who had crossed over from the '
       TEXT 'Patriots to the '
DSP5E  TEXT 'British. The unit was composed primarily of '
       TEXT 'deserters from '
DSP5F  TEXT 'the Continental Army. '
* CPI is 15 at this point.
* 7/10 inch indent should mean require 11 characters.
DSP6   BYTE >C3,>CE
       TEXT '           Regiment Formed '
DSP7   BYTE >CC,>CA
       TEXT '           Another line of text '
DSP8

*
* Initialize buffer.
*
INTBUF LI   R0,SPACE
       LI   R1,>500
       BLWP @BUFINT
       MOV  R0,R0
       JEQ  INTBF2
       LI   R0,INTMSG
       LI   R1,INTMSE-INTMSG
       BLWP @PRINTL
       B    @LOOP
INTBF2 RT
INTMSG TEXT 'Failed to initialize memory buffer.'
INTMSE EVEN
SPACE  BSS  >500

* Create inverted version of the 
* characters
INVCLR DATA >0101,>0101,>0101,>0101
       DATA >0101,>0101,>0101,>0101
HEX0   DATA >0020,>5255,>5555,>5522
HEXF   DATA >0070,>4744,>6446,>4444
CHRSET
* Copy character codes
       LI   R3,>800
       LI   R4,>C00
       LI   R1,INVCLR
       LI   R2,>10
* Pull definitions of two characters
* into RAM
CHRST1 MOV  R3,R0
       BLWP @VMBR
* Invert Characters
       LI   R5,INVCLR
CHRST2 INV  *R5
       INCT R5
       CI   R5,INVCLR+>10
       JL   CHRST2
* Return definitions back to VDP RAM
       MOV  R4,R0
       BLWP @VMBW
* Loop until inverting >FE an >FF.
       A    R2,R3
       A    R2,R4
       CI   R4,>1000
       JL   CHRST1
* Define >00 and >FF
       LI   R0,>800
       LI   R1,HEX0
       LI   R2,8
       BLWP @VMBW
       LI   R0,>0FF8
       LI   R1,HEXF
       LI   R2,8
       BLWP @VMBW
       RT

* Write notification
WRTST  LI   R0,STARTM
       LI   R1,ENDM-STARTM
       BLWP @PRINTL
       RT
 
* Finished testing
WREND  LI   R0,ENDM
       LI   R1,4
       BLWP @PRINTL
       RT

STARTM TEXT 'Testing'
ENDM   TEXT 'Done'
ENDME  EVEN

*
* Run each test on each string.
*
TSTLP  CLR  R7
       LI   R8,EXPST1
       LI   R10,EXPLNG
       LI   R12,TSTNAM
TSTLP1 MOV  R7,R0
       BLWP @GETLIN
       CI   R0,>FFFF
       JNE  TSTLP2
* Report error.
       LI   R0,ALCMG
       LI   R1,ALCMGE-ALCMG
       BLWP @PRINTL
       RT
* R0 Contains result string
* R2 Contains length
TSTLP2 MOV  *R8,R3
       MOV  *R10,R5
       MOV  R12,R6
       BLWP @MNTEST
* Move to the next set of tests.
       INC  R7
       INCT R8
       INCT R10
       AI   R12,6
* Free up the memory for previous test.
       BLWP @BUFREE
       MOV  R1,R0
       BLWP @BUFREE
* Loop
       CI   R8,EXPLNG
       JL   TSTLP1
       RT
ALCMG  TEXT 'Could not allocate strings'
ALCMGE EVEN

* Exptected Display strings
EXPST1 DATA DSP1A,DSP1B,DSP1C,DSP1D
       DATA DSP1E,DSP2
       DATA DSP3A,DSP3B,DSP3C,DSP3D
       DATA DSP3E,DSP3F,DSP4
       DATA DSP5A,DSP5B,DSP5C,DSP5D
       DATA DSP5E,DSP5F
       DATA DSP6,DSP7
* Expected string lengths
EXPLNG DATA DSP1B-DSP1A,DSP1C-DSP1B
       DATA DSP1D-DSP1C,DSP1E-DSP1D
       DATA DSP2-DSP1E
       DATA DSP3A-DSP2
       DATA DSP3B-DSP3A,DSP3C-DSP3B
       DATA DSP3D-DSP3C,DSP3E-DSP3D
       DATA DSP3F-DSP3E,DSP4-DSP3E
       DATA DSP5A-DSP4
       DATA DSP5B-DSP5A,DSP5C-DSP5B
       DATA DSP5D-DSP5C,DSP5E-DSP5D
       DATA DSP5F-DSP5E,DSP6-DSP5F
       DATA DSP7-DSP6
       DATA DSP8-DSP7
* Test Names
TSTNAM TEXT 'TST1A TST1B TST1C TST1D '
       TEXT 'TST1E TST2  '
       TEXT 'TST3A TST3B TST3C TST3D '
       TEXT 'TST3E TST3F TST4  '
       TEXT 'TST5A TST5B TST5C TST5D '
       TEXT 'TST5E TST5F '
       TEXT 'TST6  TST7  '

*
* Test results
* Input:
* R0 - Actual generated string
* R2 - Actual length
* R3 - Expected generated string
* R5 - Expected length
* R6 - Address of test name.
MNWS   BSS  >20
MNTEST DATA MNWS,MNTEST+4
       MOV  @4(13),R2
       MOV  @6(13),R3
       MOV  @10(13),R5
* Compare string length
       C    R2,R5
       JNE  MF1
* Compare display strings
       MOV  R3,R8
       MOV  *R13,R9
       MOV  R5,R10
       BL   @STREQU
       MOV  R8,R8
       JNE  MF2
* Test passed.
       MOV  @12(13),R6
       LI   R2,MPASS
       MOV  R2,R0
MTEST1 MOVB *R6+,*R2+
       CI   R2,MPASS+6
       JL   MTEST1
       LI   R1,MFMSG1-MPASS
       BLWP @PRINTL
       RTWP
* Length failed
MF1    MOV  R5,R0
       LI   R1,MFMSG1+>31
       BLWP @MAKETX
       MOV  R2,R0
       LI   R1,MFMSG2-4
       BLWP @MAKETX
       MOV  @12(13),R0
       LI   R1,6
       BLWP @PRINTL
       LI   R0,MFMSG1
       LI   R1,MFMSG2-MFMSG1
       BLWP @PRINTL
       JMP  MF2A
* Display strings failed.
* SZC command ensures a length
* no greater than >FF.
MF2    MOV  @12(13),R0
       LI   R1,6
       BLWP @PRINTL
       LI   R0,MFMSG2
       LI   R1,MFMSG3-MFMSG2
       BLWP @PRINTL
MF2A   MOV  R3,R0
       MOV  R5,R1
       SZC  @MXLGTH,R1
       BLWP @PRINTL
       MOV  *R13,R0
       MOV  R2,R1
       SZC  @MXLGTH,R1
       BLWP @PRINTL
       RTWP
MXLGTH DATA >FF00
MPASS  TEXT '       passed'
MFMSG1 TEXT 'failed:                         '
       TEXT 'Expected Length: ....           '
       TEXT 'Actual Length:   ....'
MFMSG2 TEXT 'failed: Strings do not match.   '
       TEXT 'Expected and Actual:'
MFMSG3 EVEN

* Compare strings
* Input:
* R8 - Expected string
* R9 - Actual string
* R10 - Expected Length
* Output:
* R8 - 0 if match >FFFF if not.
STREQU CB   *R8+,*R9+
       JNE  STREF
       DEC  R10
       JNE  STREQU
* Match
       CLR  R8
       RT
* No Match
STREF  SETO R8
       RT

*
* Display all of the formatted lines
*
DSPTXT CLR  @TIMER
*
       LI   R0,LINES
       MOV  R0,@LINLST
* Set to Text Mode
       LI   R0,>F001
       MOVB R0,@VDPCPY
       SWPB R0
       BLWP @VWTR
* Initialize Buffer and ASCII
       BL   @INTBUF
       BL   @CHRSET
* Define interrupt.
       LI   R0,TIMINT
       MOV  R0,@USRISR
* Clear Screen
DT3    LI   R0,0
       LI   R1,EMPTYL
       LI   R2,40
DT0    BLWP @VMBW
       LIMI 2
       LIMI 0
       A    R2,R0
       CI   R0,960
       JL   DT0
*
       CLR  R3
       CLR  R4
DT1    MOV  R3,R0
       LIMI 2
       BLWP @GETLIN
       LIMI 0
* R0 Contains result string
* R1 Contains cursor string
* R2 Contains length
       MOV  R0,R5
*
       MOV  R0,R1
       MOV  R4,R0
       CI   R2,40
       JLE  DT2
       LI   R2,40
DT2    BLWP @VMBW
* Free old space
       LIMI 2
       MOV  R5,R0
       BLWP @BUFREE
       LIMI 0
*
       AI   R4,40
       INC  R3
       C    R3,@LINES
       JL   DT1
*
       MOV  @TIMER,R0
       LI   R1,TIMMSG+9
       BLWP @MAKETX
       MOV  R4,R0
       LI   R1,TIMMSG
       LI   R2,20
       BLWP @VMBW
       AI   R4,40
LOOP1  LIMI 2
       LIMI 0
       MOV  @TIMER,R0
       LI   R1,OTHRM+6
       BLWP @MAKETX
       MOV  R4,R0
       LI   R1,OTHRM
       LI   R2,20
       BLWP @VMBW
       JMP  LOOP1
EMPTYL TEXT '                    '
       TEXT '                    '
TIMMSG TEXT 'Runtime: .... ticks '
OTHRM  TEXT 'Time: .... ticks    '
* Address from which value for VDP
* Register 1 is sometimes copied.
VDPCPY EQU  >83D4
* Address defining address of user-
* defined service routine
USRISR EQU  >83C4
TIMER  BSS  >2
LINCNT DATA 0

TIMINT INC  @TIMER
       RT
       END