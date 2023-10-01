       DEF  TSTLST,RSLTFL
       REF  ABLCK,AOC,AZC,AEQ,ANEQ
*
       REF  WRAP,LINLST,FMTLST,MGNLST
       REF  WINMOD
       REF  BUFINT,BUFALC,BUFCPY
       REF  STSPAR,ERRMEM


TSTLST DATA TSTEND-TSTLST-2/8
       DATA WRP1
       TEXT 'WRP1  '
       DATA WRP2
       TEXT 'WRP2  '
       DATA WRP3
       TEXT 'WRP3  '
       DATA WRP4
       TEXT 'WRP4  '
       DATA WRP5
       TEXT 'WRP5  '
       DATA WRP7
       TEXT 'WRP7  '
       DATA WRP8
       TEXT 'WRP8  '
       DATA WRP9
       TEXT 'WRP9  '
       DATA WRP10
       TEXT 'WRP10 '
       DATA WRP11
       TEXT 'WRP11 '
       DATA WRP12
       TEXT 'WRP12 '
       DATA WRP13
       TEXT 'WRP13 '
TSTEND
RSLTFL BYTE RSLTFE-RSLTFL-1
       TEXT 'DSK2.TESTRESULT.TXT'
RSLTFE
       EVEN

* PARAGRAPH FORMAT
*
* Data Format:
* Byte 0&1: Length of string (paragraph)
* Byte 2&3: Address of Wrap List
* Byte >=4: The string
*
* At 10 CPI bytes 1&2 will normally be
* equal to either (byte0 - 1)*12 or
* (byte0 - 2)*12. Each character is
* 12/120 inch wide. And spaces or line
* endings are not included in text
* length.
*

MNERR  TEXT 'No error should have been '
       TEXT 'detected.'
MNERRE
MWRP   TEXT 'Wrap lists do not match '
MWRPE  EVEN
MPARC  TEXT 'Number of paragraph lines '
       TEXT 'should have changed.'
MPARCE
MPAR   TEXT 'Number of paragraph lines '
       TEXT 'should not have changed.'
MPARE
FAKEAD DATA >FFFE

*
* The entire paragraph will be
* re-wrapped. A word will be brought
* down to the next line.
*
* Assume a page width of eight inches
* with two inch margins, no indent,
* 10 CPI
*
WRP1
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* The wrap list must go in the block
* of memory allocated to the chunck
* manager because it may be deallocated.
       LI   R2,WRPL1
       LI   R3,WRPE1-WRPL1
       LI   R4,PAR1A
       BL   @CPYWRP
*
       LI   R0,PARL1
       MOV  R0,@LINLST
       LI   R0,FMT1
       MOV  R0,@FMTLST
       LI   R0,MRGN1
       MOV  R0,@MGNLST
* Turn off vertical mode
       CLR  @WINMOD
* Act
       LI   R0,0
       LI   R1,0
       BLWP @WRAP
* Assert
*  No error should be detected
* R1 contains document status
       MOV  @ERRMEM,R0
       LI   R2,MNERR
       LI   R3,MNERRE-MNERR
       BLWP @AZC
* Document status reports linecount is
* unchanged
* R1 contains document status
       MOV  @STSPAR,R0
       LI   R2,MPARC
       LI   R3,MPARCE-MPARC
       BLWP @AZC
* Wrap list should match expected
       LI   R0,WRPE1
       MOV  @PAR1A+2,R1
       LI   R2,WRPE1E-WRPE1
       LI   R3,MWRP
       LI   R4,MWRPE-MWRP
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT


* Paragraph List
PARL1  DATA 5,1
       DATA PAR1A
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD

PAR1A  DATA 47+41+6
       DATA WRPL1
       TEXT 'Wuhan is the capital of Hubei province, '
       TEXT 'China, and is the most populous city in '
       TEXT 'Central China.'
       EVEN
WRPL1  DATA 2,1,47,47+41
WRPE1  DATA 2,1,40,40+40
WRPE1E

FMT1   DATA 0,3

MRGN1  DATA 1,3
* 20-char left margin, 40-char paragraph width
       DATA 0,>0000,>1428,>0000

*
* The entire paragraph will be
* re-wrapped. Some words will be brought
* down to the next line, and a new line
* will be created.
*
* Assume a page width of eight inches
* with two inch margins, no indent,
* 10 CPI
*
WRP2
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* The wrap list must go in the block
* of memory allocated to the chunck
* manager because it may be deallocated.
       LI   R2,WRPL2
       LI   R3,WRPE2-WRPL2
       LI   R4,PAR2A
       BL   @CPYWRP
*
       LI   R0,PARL2
       MOV  R0,@LINLST
       LI   R0,FMT2
       MOV  R0,@FMTLST
       LI   R0,MRGN2
       MOV  R0,@MGNLST
* Turn off vertical mode
       CLR  @WINMOD
* Act
       LI   R0,1
       LI   R1,0
       BLWP @WRAP
* Assert
* R1 contains document status
       MOV  @ERRMEM,R0
       LI   R2,MNERR
       LI   R3,MNERRE-MNERR
       BLWP @AZC
* Document status reports line count
* changed
* R1 contains document status
       MOV  @STSPAR,R0
       LI   R2,MPARC
       LI   R3,MPARCE-MPARC
       BLWP @AOC
* Wrap list should match expected
       LI   R0,WRPE2
       MOV  @PAR2A+2,R1
       LI   R2,WRPE2E-WRPE2
       LI   R3,MWRP
       LI   R4,MWRPE-MWRP
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

* Paragraph List
PARL2  DATA 3,1
       DATA FAKEAD
       DATA PAR2A
       DATA FAKEAD

PAR2A  DATA 60+41+30
       DATA WRPL2
       TEXT 'It lies in the eastern Jianghan Plain on '
       TEXT 'the middle reaches of the Yangtze River '
       TEXT 'at the intersection of the Yangtze and '
       TEXT 'Han rivers.'
       EVEN
WRPL2  DATA 2,1,60,60+41
WRPE2  DATA 3,1,41,41+40,41+40+39
WRPE2E

FMT2   DATA 0,3

MRGN2  DATA 1,3
* 20-char left margin, 40-char paragraph width
       DATA 0,>0000,>1428,>0000
	   
*
* The entire paragraph will be
* re-wrapped. Some words will be brought
* up to the first line.
*
* Assume a page width of eight inches
* with two inch margins, no indent,
* 10 CPI
*
WRP3
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* The wrap list must go in the block
* of memory allocated to the chunck
* manager because it may be deallocated.
       LI   R2,WRPL3
       LI   R3,WRPE3-WRPL3
       LI   R4,PAR3A
       BL   @CPYWRP
*
       LI   R0,PARL3
       MOV  R0,@LINLST
       LI   R0,FMT3
       MOV  R0,@FMTLST
       LI   R0,MRGN3
       MOV  R0,@MGNLST
* Turn off vertical mode
       CLR  @WINMOD
* Act
       LI   R0,2
       LI   R1,0
       BLWP @WRAP
* Assert
*  No error should be detected
* R1 contains document status
       MOV  @ERRMEM,R0
       LI   R2,MNERR
       LI   R3,MNERRE-MNERR
       BLWP @AZC
* Document status reports linecount is
* unchanged
* R1 contains document status
       MOV  @STSPAR,R0
       LI   R2,MPARC
       LI   R3,MPARCE-MPARC
       BLWP @AZC
* Wrap list should match expected
       LI   R0,WRPE3
       MOV  @PAR3A+2,R1
       LI   R2,WRPE3E-WRPE3
       LI   R3,MWRP
       LI   R4,MWRPE-MWRP
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL3  DATA 4,1
       DATA FAKEAD
       DATA FAKEAD
       DATA PAR3A
       DATA FAKEAD

PAR3A  DATA 19+32+39+32
       DATA WRPL3
       TEXT 'Arising out of the conglomeration of '
       TEXT 'three cities, Wuchang, Hankou, and '
       TEXT 'Hanyang, Wuhan is known as "China"s '
       TEXT 'Thoroughfare".'
       EVEN
WRPL3  DATA 3,1,19,19+32,19+32+39
WRPE3  DATA 3,1,37,37+35,37+35+36
WRPE3E

FMT3   DATA 0,3

MRGN3  DATA 1,3
* 20-char left margin, 40-char paragraph width
       DATA 0,>0000,>1428,>0000

*
* The entire paragraph will be
* re-wrapped. Some words will be brought
* up to the first line. The final line
* of the paragraph will be removed.
*
* Assume a page width of eight inches
* with two inch margins, no indent,
* 10 CPI
WRP4
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* The wrap list must go in the block
* of memory allocated to the chunck
* manager because it may be deallocated.
       LI   R2,WRPL4
       LI   R3,WRPE4-WRPL4
       LI   R4,PAR4A
       BL   @CPYWRP
*
       LI   R0,PARL4
       MOV  R0,@LINLST
       LI   R0,FMT4
       MOV  R0,@FMTLST
       LI   R0,MRGN4
       MOV  R0,@MGNLST
* Turn off vertical mode
       CLR  @WINMOD
* Act
       LI   R0,3
       LI   R1,0
       BLWP @WRAP
* Assert
* R1 contains document status
       MOV  @ERRMEM,R0
       LI   R2,MNERR
       LI   R3,MNERRE-MNERR
       BLWP @AZC
* Document status reports line count
* changed
* R1 contains document status
       MOV  @STSPAR,R0
       LI   R2,MPARC
       LI   R3,MPARCE-MPARC
       BLWP @AOC
* Wrap list should match expected
       LI   R0,WRPE4
       MOV  @PAR4A+2,R1
       LI   R2,WRPE4E-WRPE4
       LI   R3,MWRP
       LI   R4,MWRPE-MWRP
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL4  DATA 6,1
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA PAR4A
       DATA FAKEAD
       DATA FAKEAD

PAR4A  DATA 29+36+36+35+7
       DATA WRPL4
       TEXT 'It is a major transportation '
       TEXT 'hub, with dozens of railways, roads '
       TEXT 'and expressways passing through the '
       TEXT 'city and connecting to other major '
       TEXT 'cities.'
       EVEN
WRPL4  DATA 4,1,29,29+36,29+36+36,29+36+36+35
WRPE4  DATA 3,1,39,39+30,39+30+41
WRPE4E

FMT4   DATA 1,3
* 12-Cpi at paragraph start
       DATA 4,0,0,10

MRGN4  DATA 2,3
* 20-char left margin, 40-char paragraph width
       DATA 0,>0000,>1428,>0000
* 12-char left margin, 72-char paragraph width
       DATA 4,>0000,>0C48,>0000

*
* Assume a page width of eight inches
* with two inch margins, no indent,
* 12 CPI
*
WRP5
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* The wrap list must go in the block
* of memory allocated to the chunck
* manager because it may be deallocated.
       LI   R2,WRPL5
       LI   R3,WRPE5-WRPL5
       LI   R4,PAR5A
       BL   @CPYWRP
*
       LI   R0,PARL5
       MOV  R0,@LINLST
       LI   R0,FMT5
       MOV  R0,@FMTLST
       LI   R0,MRGN5
       MOV  R0,@MGNLST
* Turn off vertical mode
       CLR  @WINMOD
* Act
       LI   R0,4
       LI   R1,0
       BLWP @WRAP
* Assert
* R1 contains document status
       MOV  @ERRMEM,R0
       LI   R2,MNERR
       LI   R3,MNERRE-MNERR
       BLWP @AZC
* Document status reports line count
* changed
* R1 contains document status
       MOV  @STSPAR,R0
       LI   R2,MPARC
       LI   R3,MPARCE-MPARC
       BLWP @AOC
* Wrap list should match expected
       LI   R0,WRPE5
       MOV  @PAR5A+2,R1
       LI   R2,WRPE5E-WRPE5
       LI   R3,MWRP
       LI   R4,MWRPE-MWRP
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL5  DATA 8,1
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA PAR5A
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD

PAR5A  DATA 36+47+45
       DATA WRPL5
       TEXT 'Because of its key role in domestic '
       TEXT 'transportation, Wuhan is sometimes referred '
       TEXT 'to '
       TEXT 'as "the Chicago of China" by foreign sources.'
       EVEN
WRPL5  DATA 4,1,36,36+44,36+44+11,36+44+11+11
WRPE5  DATA 2,1,36,36+47
WRPE5E

FMT5   DATA 1,3
* 12-Cpi at paragraph start
       DATA 4,0,0,10

MRGN5  DATA 2,3
* 20-char left margin, 40-char paragraph width
       DATA 0,>0000,>1428,>0000
* 24-char left margin, 48-char paragraph width
       DATA 4,>0000,>1830,>0000

*
* Assume a page width of eight inches
* with two inch margins, no indent,
* 5 CPI
*
WRP7
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* The wrap list must go in the block
* of memory allocated to the chunck
* manager because it may be deallocated.
       LI   R2,WRPL7
       LI   R3,WRPE7-WRPL7
       LI   R4,PAR7A
       BL   @CPYWRP
*
       LI   R0,PARL7
       MOV  R0,@LINLST
       LI   R0,FMT7
       MOV  R0,@FMTLST
       LI   R0,MRGN7
       MOV  R0,@MGNLST
* Turn off vertical mode
       CLR  @WINMOD
* Act
       LI   R0,6
       LI   R1,0
       BLWP @WRAP
* Assert
* R1 contains document status
       MOV  @ERRMEM,R0
       LI   R2,MNERR
       LI   R3,MNERRE-MNERR
       BLWP @AZC
* Document status reports line count
* changed
* R1 contains document status
       MOV  @STSPAR,R0
       LI   R2,MPARC
       LI   R3,MPARCE-MPARC
       BLWP @AOC
* Wrap list should match expected
       LI   R0,WRPE7
       MOV  @PAR7A+2,R1
       LI   R2,WRPE7E-WRPE7
       LI   R3,MWRP
       LI   R4,MWRPE-MWRP
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL7  DATA 8,1
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA PAR7A
       DATA FAKEAD

PAR7A  DATA 36+47+45
       DATA WRPL7
       TEXT 'In 1927, Wuhan was '
       TEXT 'briefly the capital '
       TEXT 'of China under the '
       TEXT 'left wing of the '
       TEXT 'Kuomintang (KMT) '
       TEXT 'government led by '
       TEXT 'Wang Jingwei.'
       EVEN
WRPL7  DATA 2,1,40,39
WRPE7  DATA 6,1
       DATA 19
       DATA 19+20
       DATA 19+20+19
       DATA 19+20+19+17
       DATA 19+20+19+17+17
       DATA 19+20+19+17+17+18
WRPE7E

FMT7   DATA 2,3
* 12-Cpi at paragraph start
       DATA 4,0,0,10
* 5-Cpi in middle of second line of 
* paragraph
       DATA 5,64,0,24

MRGN7  DATA 3,3
* 20-char left margin, 40-char paragraph width
       DATA 0,>0000,>1428,>0000
* 12-char left margin, 72-char paragraph width
       DATA 4,>0000,>0C48,>0000
* 10-char left margin, 20-char paragraph width
       DATA 6,>0000,>0A14,>0000

*
* Assume a page width of eight inches
* with one inch margins, no indent,
* 12 CPI
*
WRP8
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* The wrap list must go in the block
* of memory allocated to the chunck
* manager because it may be deallocated.
       LI   R2,WRPL8
       LI   R3,WRPE8-WRPL8
       LI   R4,PAR8A
       BL   @CPYWRP
*
       LI   R0,PARL8
       MOV  R0,@LINLST
       LI   R0,FMT8
       MOV  R0,@FMTLST
       LI   R0,MRGN8
       MOV  R0,@MGNLST
* Turn off vertical mode
       CLR  @WINMOD
* Act
       LI   R0,7
       LI   R1,0
       BLWP @WRAP
* Assert
* R1 contains document status
       MOV  @ERRMEM,R0
       LI   R2,MNERR
       LI   R3,MNERRE-MNERR
       BLWP @AZC
* Document status reports line count
* changed
* R1 contains document status
       MOV  @STSPAR,R0
       LI   R2,MPARC
       LI   R3,MPARCE-MPARC
       BLWP @AOC
* Wrap list should match expected
       LI   R0,WRPE8
       MOV  @PAR8A+2,R1
       LI   R2,WRPE8E-WRPE8
       LI   R3,MWRP
       LI   R4,MWRPE-MWRP
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL8  DATA 8,1
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA PAR8A

PAR8A  DATA 62
       DATA WRPL8
       TEXT 'The city later served as the wartime '
       TEXT 'capital of China in 1937.'
       EVEN
WRPL8  DATA 1,1,40
WRPE8  DATA 0,1
WRPE8E

FMT8   DATA 3,3
* 12-Cpi at paragraph start
       DATA 4,0,0,10
* 5-Cpi in middle of second line of 
* paragraph
       DATA 5,64,0,24
* 12-Cpi at paragraph start
       DATA 7,0,0,10

MRGN8  DATA 3,3
* 20-char left margin, 40-char paragraph width
       DATA 0,>0000,>1428,>0000
* 12-char left margin, 72-char paragraph width
       DATA 4,>0000,>0C48,>0000

*
* Assume a page width of eight inches
* with one inch margins, no indent,
* 12 CPI
*
WRP9
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* The wrap list must go in the block
* of memory allocated to the chunck
* manager because it may be deallocated.
       LI   R2,WRPL9
       LI   R3,WRPE9-WRPL9
       LI   R4,PAR9A
       BL   @CPYWRP
*
       LI   R0,PARL9
       MOV  R0,@LINLST
       LI   R0,FMT9
       MOV  R0,@FMTLST
       LI   R0,MRGN9
       MOV  R0,@MGNLST
* Turn off vertical mode
       CLR  @WINMOD
* Act
       LI   R0,8
       LI   R1,0
       BLWP @WRAP
* Assert
* R1 contains document status
       MOV  @ERRMEM,R0
       LI   R2,MNERR
       LI   R3,MNERRE-MNERR
       BLWP @AZC
* Document status reports line count
* changed
* R1 contains document status
       MOV  @STSPAR,R0
       LI   R2,MPARC
       LI   R3,MPARCE-MPARC
       BLWP @AOC
* Wrap list should match expected
       LI   R0,WRPE9
       MOV  @PAR9A+2,R1
       LI   R2,WRPE9E-WRPE9
       LI   R3,MWRP
       LI   R4,MWRPE-MWRP
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL9  DATA 11,1
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA PAR9A
       DATA FAKEAD
       DATA FAKEAD

PAR9A  DATA 126
       DATA WRPL9
       TEXT 'The Wuhan Gymnasium held the 2011 FIBA Asia '
       TEXT 'Championship and will be one '
       TEXT 'of the venues for the 2019 FIBA '
       TEXT 'Basketball World Cup.'
       EVEN
WRPL9  DATA 2,1,74,98
WRPE9  DATA 1,1,73
WRPE9E

FMT9   DATA 3,3
* 12-Cpi at paragraph start
       DATA 4,0,0,10
* 5-Cpi in middle of second line of 
* paragraph
       DATA 5,64,0,24
* 12-Cpi at paragraph start
       DATA 7,0,0,10

MRGN9  DATA 4,3
* 20-char left margin, 40-char paragraph width
       DATA 0,>0000,>1428,>0000
* 12-char left margin, 72-char paragraph width
       DATA 4,>0000,>0C48,>0000
* 10-char left margin, 20-char paragraph width, 5-char indent
       DATA 9,>0005,>0A14,>0000
* 2.5-inch margins,
* 0.5-inch hanging indent
       DATA 10,>00FA,>1E1E,>0000

*
* Assume a page width of eight inches
* with two inch margins, 1 inch indent,
* 12 CPI
*
WRP10
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* The wrap list must go in the block
* of memory allocated to the chunck
* manager because it may be deallocated.
       LI   R2,WRPL10
       LI   R3,WRE10E-WRPL10
       LI   R4,PAR10A
       BL   @CPYWRP
*
       LI   R0,PARL10
       MOV  R0,@LINLST
       LI   R0,FMT10
       MOV  R0,@FMTLST
       LI   R0,MRGN10
       MOV  R0,@MGNLST
* Turn off vertical mode
       CLR  @WINMOD
* Act
       LI   R0,9
       LI   R1,0
       BLWP @WRAP
* Assert
* R1 contains document status
       MOV  @ERRMEM,R0
       LI   R2,MNERR
       LI   R3,MNERRE-MNERR
       BLWP @AZC
* Document status reports line count
* changed
* R1 contains document status
       MOV  @STSPAR,R0
       LI   R2,MPARC
       LI   R3,MPARCE-MPARC
       BLWP @AOC
* Wrap list should match expected
       LI   R0,WRPE10
       MOV  @PAR10A+2,R1
       LI   R2,WRE10E-WRPE10
       LI   R3,MWRP
       LI   R4,MWRPE-MWRP
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL10 DATA 11,1
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA PAR10A
       DATA FAKEAD

PAR10A DATA 297
       DATA WRPL10
       TEXT '"Wuhan" is derived from the pinyin '
       TEXT 'romanization of the Standard Mandarin '
       TEXT 'pronunciation of the name of the city '
       TEXT '(Wu3han4). '
       TEXT 'In 1926, the Northern Expedition reached the '
       TEXT 'Wuhan area and decided to merge Hankou, '
       TEXT 'Wuchang '
       TEXT 'and Hanyang into one city in order to make a '
       TEXT 'new capital for Nationalist China.'
       EVEN
WRPL10 DATA 2,1,74,98
WRPE10 DATA 6,1
       DATA 35
       DATA 35+38
       DATA 35+38+49
       DATA 35+38+49+45
       DATA 35+38+49+45+48
       DATA 35+38+49+45+48+49
WRE10E

FMT10  DATA 3,3
* 12-Cpi at paragraph start
       DATA 4,0,0,10
* 5-Cpi in middle of second line of 
* paragraph
       DATA 5,64,0,24
* 12-Cpi at paragraph start
       DATA 7,0,0,10

MRGN10 DATA 4,3
* 20-char left margin, 40-char paragraph width
       DATA 0,>0000,>1428,>0000
* 24-char left margin, 48-char paragraph width, 12-char indent
       DATA 4,>000C,>1830,>0000
* 2.5-inch margins,
* 0.5-inch hanging indent
       DATA 10,>00FA,>1E1E,>0000

*
* Assume a page width of eight inches
* with 2.5 inch margins,
* 0.5 inch hanging indent,
* 12 CPI
*
WRP11
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* The wrap list must go in the block
* of memory allocated to the chunck
* manager because it may be deallocated.
       LI   R2,WRPL11
       LI   R3,WRE11E-WRPL11
       LI   R4,PAR11A
       BL   @CPYWRP
*
       LI   R0,PARL11
       MOV  R0,@LINLST
       LI   R0,FMT11
       MOV  R0,@FMTLST
       LI   R0,MRGN11
       MOV  R0,@MGNLST
* Turn off vertical mode
       CLR  @WINMOD
* Act
       LI   R0,10
       LI   R1,0
       BLWP @WRAP
* Assert
* R1 contains document status
       MOV  @ERRMEM,R0
       LI   R2,MNERR
       LI   R3,MNERRE-MNERR
       BLWP @AZC
* Document status reports line count
* changed
* R1 contains document status
       MOV  @STSPAR,R0
       LI   R2,MPARC
       LI   R3,MPARCE-MPARC
       BLWP @AOC
* Wrap list should match expected
       LI   R0,WRPE11
       MOV  @PAR11A+2,R1
       LI   R2,WRE11E-WRPE11
       LI   R3,MWRP
       LI   R4,MWRPE-MWRP
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL11 DATA 11,1
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA PAR11A

PAR11A DATA 253
       DATA WRPL11
       TEXT 'The city was named Wuhan, which was '
       TEXT 'later simplified (Wuhan). The '
       TEXT '"Wu" in "Wuhan" is derived '
       TEXT 'from the "Wu" in "Wuchang" '
       TEXT '(literally prospering from '
       TEXT 'military, regarding its '
       TEXT 'logistics role of the military '
       TEXT 'bases established before the '
       TEXT 'Battle of Red Cliffs).'
       EVEN
WRPL11 DATA 2,1,74,98,148
WRPE11 DATA 8,1
       DATA 36,66,93,120
       DATA 147,171,202,231
WRE11E

FMT11  DATA 3,3
* 12-Cpi at paragraph start
       DATA 4,0,0,10
* 5-Cpi in middle of second line of 
* paragraph
       DATA 5,64,0,24
* 12-Cpi at paragraph start
       DATA 7,0,0,10

MRGN11 DATA 4,3
* 20-char left margin, 40-char paragraph width
       DATA 0,>0000,>1428,>0000
* 12-char left margin, 72-char paragraph width
       DATA 4,>0000,>0C48,>0000
* 10-char left margin, 20-char paragraph width, 5-char indent
       DATA 9,>0005,>0A14,>0000
* 30-char left margin, 36-char paragraph width, 6-char hanging indent
       DATA 10,>00FA,>1E24,>0000

*
* Assume a page width of eight inches
* with 2 inch margins,
* 10 CPI,
* One word is longer than 40 characters.
*
WRP12
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* The wrap list must go in the block
* of memory allocated to the chunck
* manager because it may be deallocated.
       LI   R2,WRPL12
       LI   R3,WRE12E-WRPL12
       LI   R4,PAR12A
       BL   @CPYWRP
*
       LI   R0,PARL12
       MOV  R0,@LINLST
       LI   R0,FMT12
       MOV  R0,@FMTLST
       LI   R0,MRGN12
       MOV  R0,@MGNLST
* Turn off vertical mode
       CLR  @WINMOD
* Act
       LI   R0,2
       LI   R1,0
       BLWP @WRAP
* Assert
* R1 contains document status
       MOV  @ERRMEM,R0
       LI   R2,MNERR
       LI   R3,MNERRE-MNERR
       BLWP @AZC
* Document status reports line count
* changed
* R1 contains document status
       MOV  @STSPAR,R0
       LI   R2,MPARC
       LI   R3,MPARCE-MPARC
       BLWP @AOC
* Wrap list should match expected
       LI   R0,WRPE12
       MOV  @PAR12A+2,R1
       LI   R2,WRE12E-WRPE12
       LI   R3,MWRP
       LI   R4,MWRPE-MWRP
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT

PARL12 DATA 4,1
       DATA FAKEAD
       DATA FAKEAD
       DATA PAR12A
       DATA FAKEAD

PAR12A DATA 240
       DATA WRPL12
       TEXT 'The alphabet is '
       TEXT 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmn'
       TEXT 'opqrstuvwxyz. That is a different '
       TEXT 'alphabet than some languages. German '
       TEXT 'includes more letters, and the imaginary '
       TEXT 'language chut-in-puut-orange has letters '
       TEXT 'that have not been inveted yet.'
       EVEN
WRPL12 DATA 4,1
       DATA 38,104,157,221
WRPE12 DATA 6,1
       DATA 16
       DATA 16+40
       DATA 16+40+34
       DATA 16+40+34+37
       DATA 16+40+34+37+41
       DATA 16+40+34+37+41+41
WRE12E

FMT12  DATA 0,3

MRGN12 DATA 1,3
* 10-char left margin, 60-char paragraph width
       DATA 0,>0000,>1428,>0000

*
* Wrap the paragraph in vertical mode.
* Configured paragraph width ignored.
* Use width of 39-char instead.
*
* Assume a page width of eight inches
* with two inch margins, no indent,
* 10 CPI
*
WRP13
* Arrange
       LI   R12,STACK
       DECT R12
       MOV  R11,*R12
* The wrap list must go in the block
* of memory allocated to the chunck
* manager because it may be deallocated.
       LI   R2,WRPL13
       LI   R3,WRPE13-WRPL13
       LI   R4,PAR13A
       BL   @CPYWRP
*
       LI   R0,PARL13
       MOV  R0,@LINLST
       LI   R0,FMT13
       MOV  R0,@FMTLST
       LI   R0,MRGN13
       MOV  R0,@MGNLST
* Turn on vertical mode
       SETO @WINMOD
* Act
       LI   R0,0
       LI   R1,0
       BLWP @WRAP
* Assert
*  No error should be detected
* R1 contains document status
       MOV  @ERRMEM,R0
       LI   R2,MNERR
       LI   R3,MNERRE-MNERR
*       BLWP @AZC
* Document status reports linecount is
* unchanged
* R1 contains document status
       MOV  @STSPAR,R0
       LI   R2,MPARC
       LI   R3,MPARCE-MPARC
*       BLWP @AZC
* Wrap list should match expected
       LI   R0,WRPE13
       MOV  @PAR13A+2,R1
       LI   R2,WRE13E-WRPE13
       LI   R3,MWRP
       LI   R4,MWRPE-MWRP
       BLWP @ABLCK
*
       MOV  *R12+,R11
       RT


* Paragraph List
PARL13 DATA 5,1
       DATA PAR13A
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD
       DATA FAKEAD

PAR13A DATA 58+56+57+58+11
       DATA WRPL13
       TEXT 'Other historical events taking place in '
       TEXT 'Wuhan include the Wuchang Uprising of 1911, '
       TEXT 'which led to the end of 2,000 years of '
       TEXT 'dynastic rule. Wuhan was briefly the capital '
       TEXT 'of China in 1927 under the left wing of '
       TEXT 'the Kuomintang (KMT) government.'
       EVEN
WRPL13 DATA 4,1
       DATA 58
       DATA 58+56
       DATA 58+56+57
       DATA 58+56+57+58
WRPE13 DATA 6,1
       DATA 40
       DATA 40+38
       DATA 40+38+36
       DATA 40+38+36+34
       DATA 40+38+36+34+37
       DATA 40+38+36+34+37+38
WRE13E

FMT13  DATA 0,3

MRGN13 DATA 1,3
* 10-char left margin, 50-char paragraph width
       DATA 0,>0000,>0A3C,>0000

********

*
* Copy Wrap Address to buffer.
* Register its location in
* paragraph object.
* Input:
*  R2 - Wrap list source address
*  R3 - length of wrap list
*  R4 - address of paragraph
* Output:
*  R0-R2,R4 will change
CPYWRP
       LI   R0,SPACE
       LI   R1,SPCEND-SPACE
       BLWP @BUFINT
*
       MOV  R3,R0
       BLWP @BUFALC
*
       MOV  R0,R1
       MOV  R2,R0
       MOV  R3,R2
       BLWP @BUFCPY
* Update paragraph object's wrap address
       INCT R4
       MOV  R1,*R4
*
       RT

SPACE  BSS  >400
SPCEND
STACKS BSS  >10
STACK
       END