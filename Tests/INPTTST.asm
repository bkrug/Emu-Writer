       DEF  TSTLST,RSLTFL
* Mocks
       DEF  VDPADR,VDPWRT
       DEF  MNUHK
       DEF  MNUINT,PRINT

* Assert Routine
       REF  AEQ,AZC,AOC,ABLCK

*
       REF  INPUT

* from VAR.asm
       REF  LINLST,FMTLST,MGNLST
       REF  MAKETX,PRINTL,OPENF,CLOSEF
       REF  ARYALC,ARYADD,ARYINS,ARYDEL
       REF  ARYADR
       REF  BUFALC,BUFINT,BUFCPY
       REF  KEYSTR,KEYEND,KEYWRT,KEYRD       

* variables just for INPUT
       REF  PARINX,CHRPAX
       REF  INSTMD

* constants
       REF  STSTYP,STSENT,STSDCR
       REF  STSPAR,STSWIN,STSARW

*
INSKEY EQU  >04
DELKEY EQU  >03
FNCTN3 EQU  >07
FNCTN4 EQU  >02
FNCTN5 EQU  >0E
FNCTN6 EQU  >0C
FNCTN7 EQU  >01
FNCTN8 EQU  >06
FNCTN9 EQU  >0F
FNCTN0 EQU  >BC
*
BCKKEY EQU  >08
FWDKEY EQU  >09
UPPKEY EQU  >0B
DWNKEY EQU  >0A
*
ENTER  EQU  >0D

TSTLST DATA TSTEND-TSTLST-2/8
*
* User inserted some text and overwrote
* some other text
       DATA TST1
       TEXT 'TST1  '
* User inserted some text.
* Outputs STSTYP set, STSENT reset.
       DATA TST2
       TEXT 'TST2  '
* User inserted some text and pressed
* an arrow key. The arrow key is not
* immediately processed.
       DATA TST3
       TEXT 'TST3  '
* User inserted some text.
* The key stream will wrap around.
       DATA TST4
       TEXT 'TST4  '
* User inserted some text at the end of 
* a paragraph
       DATA TST5
       TEXT 'TST5  '
* User inserted some text at the end of 
* a paragraph, while in overwrite mode
       DATA TST6
       TEXT 'TST6  '
* Insert a character that the system
* doesn't recognize. Output should not
* be affected.
       DATA TST7
       TEXT 'TST7  '
* Delete the character at the cursor
* position.
       DATA TST18
       TEXT 'TST18 '
* Delete a carriage return
       DATA TST19
       TEXT 'TST19 '
* ---
* User pressed the backspace from middle
* of paragraph.
       DATA TST8
       TEXT 'TST8  '
* User pressed the backspace from start
* of paragraph.
       DATA TST9
       TEXT 'TST9  '
* ---
* User pressed forward space from middle
* of paragraph.
       DATA TST10
       TEXT 'TST10 '
* User pressed forward space from end
* of paragraph.
       DATA TST11
       TEXT 'TST11 '
* User pressed forward space and a 
* letter, but letter is not initially
* processed.
       DATA TST15
       TEXT 'TST15 '
* ---
* User presses enter from paragraph start
       DATA TST12
       TEXT 'TST12 '
* User presses enter from paragraph middle
       DATA TST13
       TEXT 'TST13 '
* User presses enter from paragraph end
       DATA TST14
       TEXT 'TST14 '
* User presses enter and one letter, but
* letter is not initially processed.
       DATA TST16
       TEXT 'TST16 '
* User presses enter and nothing else.
* Enter-Pressed status bit should be set.
       DATA TST17
       TEXT 'TST17 '
* ---
* User splits two paragraphs that are
* before the first margin entry.
       DATA TST20
       TEXT 'TST20 '
* User splits two paragraphs that are
* between margin entries.
       DATA TST21
       TEXT 'TST21 '
* User splits two paragraphs that are
* after all margin entries.
       DATA TST22
       TEXT 'TST22 '
* User merges two paragraphs.
* No margin list entries are deleted.
       DATA TST23
       TEXT 'TST23 '
* User merges two paragraphs.
* Delete an extra margin list entry.
       DATA TST24
       TEXT 'TST24 '
TSTEND
RSLTFL BYTE RSLTFE-RSLTFL-1
       TEXT 'DSK2.TESTRESULT.TXT'
RSLTFE
       EVEN

****************************************
*
* Initialization for individual test.
*
****************************************

TSTINT
* Initialize buffer.
       LI   R0,SPACE
       LI   R1,SPCEND-SPACE
       BLWP @BUFINT
* Reserve space for margin and format
* and paragraph list.
       LI   R0,3
       BLWP @ARYALC
       MOV  R0,@FMTLST
       LI   R0,3
       BLWP @ARYALC
       MOV  R0,@MGNLST
       LI   R0,1
       BLWP @ARYALC
       MOV  R0,@LINLST
*
       LI   R6,INTADR
* Copy a paragraph into buffer
TSTIN1
       MOV  *R6+,R0
       MOV  R0,R2
       BLWP @BUFALC
       MOV  R0,R1
       MOV  *R6+,R0
       BLWP @BUFCPY
       MOV  R1,R4
* and a wrap list
       MOV  *R6+,R0
       MOV  R0,R2
       BLWP @BUFALC
       MOV  R0,R1
       MOV  *R6+,R0
       BLWP @BUFCPY
       MOV  R1,R5
* Put the paragraph into the
* paragraph list
       MOV  @LINLST,R0
       BLWP @ARYADD
       MOV  R0,@LINLST
       MOV  R4,*R1
* Put the wrap list in the paragraph
* header
       INCT R4
       MOV  R5,*R4
* Loop
       CI   R6,INTADE
       JL   TSTIN1
       RT

* paragraph size, paragraph address,
* wrap list size, wrap list address
INTADR DATA PAR0A-PAR0,PAR0,PAR0-WRAP0,WRAP0
       DATA PAR1A-PAR1,PAR1,PAR1-WRAP1,WRAP1
       DATA PAR2A-PAR2,PAR2,PAR2-WRAP2,WRAP2
       DATA PAR3A-PAR3,PAR3,PAR3-WRAP3,WRAP3
INTADE

****************************************
*
* Starting Data
*
****************************************

WRAP0  DATA 0,1
PAR0   DATA PAR0A-PAR0-4,WRAP0
       TEXT 'History'
PAR0A
       EVEN
WRAP1  DATA 0,1
PAR1   DATA PAR1A-PAR1-4,WRAP1
       TEXT 'Antiquity'
PAR1A
       EVEN
WRAP2  DATA 0,1
PAR2   DATA PAR2A-PAR2-4,WRAP2
       TEXT 'With a history, Wuhan is one of the most '
       TEXT 'ancient and civilized '
       TEXT 'metropolitan cities in China. Panlongcheng '
       TEXT 'is located in '
       TEXT 'modern-day Huangpi District. During the '
       TEXT 'Western Zhou, the E '
       TEXT 'state controlled the present-day '
       TEXT 'Wuchang area south of the Yangtze River. '
       TEXT 'After the conquest of the E state, the '
       TEXT 'present-day Wuhan area was controlled by the '
       TEXT 'Chu state for the rest of the Western Zhou '
       TEXT 'and Eastern Zhou periods.'
PAR2A
       EVEN
*3,500-year-long 
*, an archaeological site associated with the Erligang culture,
WRAP3  DATA 0,1
PAR3   DATA PAR3A-PAR3-4,WRAP3
       TEXT 'During the Han dynasty, Hanyang became a '
       TEXT 'fairly busy port. '
       TEXT 'The Battle of Xiakou in AD 203 and Battle '
       TEXT 'of Jiangxia five '
       TEXT 'years later were fought over control of '
       TEXT 'Jiangxia Commandery '
       TEXT '(present-day Xinzhou District in northeast '
       TEXT 'Wuhan). In the '
       TEXT 'winter of 208/9, one of the most famous '
       TEXT 'battles in Chinese '
       TEXT 'history and a central event in the Romance '
       TEXT 'of the Three '
       TEXT 'Kingdoms the Battle of Red Cliffs took '
       TEXT 'place in the vicinity '
       TEXT 'of the cliffs near Wuhan. Around that '
       TEXT 'time, walls were built '
       TEXT 'to protect Hanyang (AD 206) and '
       TEXT 'Wuchang (AD 223). The latter '
       TEXT 'event marks the foundation of Wuhan. '
       TEXT 'In AD 223, the Yellow '
       TEXT 'Crane Tower, one of the Four Great '
       TEXT 'Towers of China, was '
       TEXT 'constructed on the Wuchang side of the '
       TEXT 'Yangtze River by '
       TEXT 'order of Sun Quan, leader of the Eastern Wu. '
       TEXT 'The tower '
       TEXT 'become a sacred site of Taoism.'
PAR3A
       EVEN

LPRINX TEXT 'PARINX'
LCRPAX TEXT 'CHRPAX'
LKEYRD TEXT 'KEYRD '
PARLEN TEXT 'PARLEN'

****************************************
*
* Each Test
*
****************************************

* Test 1
* ------
* User inserted some text and overwrote
* some other text such that
* "With a history, Wuhan"
* became
* "With a long HIStory, Wuhan"
TST1   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,7
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL1
       LI   R1,KEYL1E
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
* Get updated address of paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* Test paragraph contents
       AI   R1,4
       LI   R2,EXP1A+4
       LI   R0,EXP1B
       LI   R3,1
       BL   @STRCMP
* Test position values.
* Only CHRPAX should have
* changed due to cursor moving.
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,7+12
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT



* input from the keyboard.
KEYL1  TEXT 'long '
       BYTE INSKEY
       TEXT 'HISTORY'
KEYL1E EVEN

EXP1A DATA 0,0
      TEXT 'With a long HISTORY, Wuhan is '
      TEXT 'one of '
      TEXT 'the most '
      TEXT 'ancient and civilized metropolitan cities '
      TEXT 'in China. Panlongcheng is located in '
      TEXT 'modern-day '
      TEXT 'Huangpi District. During the Western Zhou, '
      TEXT 'the E state controlled the present-day '
      TEXT 'Wuchang area south of the Yangtze River. '
      TEXT 'After the conquest of the E state, the '
      TEXT 'present-day Wuhan area was controlled by the '
      TEXT 'Chu state for the rest of the Western Zhou '
      TEXT 'and Eastern Zhou periods.'
EXP1B
      EVEN


* Test 2
* ------
* User inserted some text.
* Outputs STSTYP set, STSENT reset.
TST2   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,100
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL2
       LI   R1,KEYL2E
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Store document status
       MOV  R0,R5
* Assert
* Get updated address of paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* Test paragraph contents
       AI   R1,4
       LI   R2,EXP2A+4
       LI   R0,EXP2B
       LI   R3,2
       BL   @STRCMP
* Test position values.
* CHRPAX should have increasd.
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,108
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
* Check document status bits in R5
       MOV  @STSTYP,R0
       MOV  R5,R1
       LI   R2,TST2M
       LI   R3,TST2ME-TST2M
       BLWP @AOC
*
       MOV  @STSENT,R0
       MOV  R5,R1
       LI   R2,TST2N
       LI   R3,TST2NE-TST2N
       BLWP @AZC
*
       MOV  @STSARW,R0
       MOV  R5,R1
       LI   R2,TST2O
       LI   R3,TST2OE-TST2O
       BLWP @AZC
*
       MOV  *R10+,R11
       RT

TST2M  TEXT 'Text-Typed bit should have been set.'
TST2ME
TST2N  TEXT 'Enter-Pressed bit should not have been set.'
TST2NE 
TST2O  TEXT 'Arrow-Key-Pressed bit should not '
       TEXT 'have been set.'
TST2OE EVEN

* input from the keyboard.
KEYL2  TEXT ' abcdef '
KEYL2E EVEN

EXP2A  DATA 0,0
       TEXT 'With a history, Wuhan is one of the most '
       TEXT 'ancient and civilized '
       TEXT 'metropolitan cities in China. Panlong '
       TEXT 'abcdef cheng '
       TEXT 'is located in '
       TEXT 'modern-day Huangpi District. During the '
       TEXT 'Western Zhou, the E '
       TEXT 'state controlled the present-day '
       TEXT 'Wuchang area south of the Yangtze River. '
       TEXT 'After the conquest of the E state, the '
       TEXT 'present-day Wuhan area was controlled by the '
       TEXT 'Chu state for the rest of the Western Zhou '
       TEXT 'and Eastern Zhou periods.'
EXP2B 
       EVEN

* Test 3
* ------
* User inserted some text and pressed
* an arrow key. The arrow key is not
* immediately processed.
TST3   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,100
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL3
       LI   R1,KEYL3E
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
* Get updated address of paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* Test paragraph contents
       AI   R1,4
       LI   R2,EXP3A+4
       LI   R0,EXP3B
       LI   R3,3
       BL   @STRCMP
* Test position values.
* CHRPAX should have increasd, but
* only due to text inserts.
* Forward keys should be ignored.
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,104
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

KEYL3  TEXT ' :) '
       BYTE FWDKEY,FWDKEY
KEYL3E EVEN

EXP3A  DATA 0,0
       TEXT 'With a history, Wuhan is one of the most '
       TEXT 'ancient and civilized '
       TEXT 'metropolitan cities in China. Panlong '
       TEXT ':) cheng '
       TEXT 'is located in '
       TEXT 'modern-day Huangpi District. During the '
       TEXT 'Western Zhou, the E '
       TEXT 'state controlled the present-day '
       TEXT 'Wuchang area south of the Yangtze River. '
       TEXT 'After the conquest of the E state, the '
       TEXT 'present-day Wuhan area was controlled by the '
       TEXT 'Chu state for the rest of the Western Zhou '
       TEXT 'and Eastern Zhou periods.'
EXP3B
       EVEN


* Test 4
* ------
* User inserted some text.
* The key stream will wrap around.
TST4   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,109
       MOV  R0,@CHRPAX
* Copy test keypresses to stream.
* The key steam will wrap around.
       LI   R0,KEYL4
       LI   R1,KEYL4E
       LI   R2,12
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
* Get updated address of paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* Test paragraph contents
       AI   R1,4
       LI   R2,EXP4A+4
       LI   R0,EXP4B
       LI   R3,4
       BL   @STRCMP
* Test position values.
* CHRPAX should have
* increasd.
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,121
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT


* input from the keyboard.
KEYL4  TEXT 'essentially '
KEYL4E EVEN

EXP4A  DATA 0,0
       TEXT 'With a history, Wuhan is one of the most '
       TEXT 'ancient and civilized '
       TEXT 'metropolitan cities in China. Panlongcheng '
       TEXT 'is essentially located in '
       TEXT 'modern-day Huangpi District. During the '
       TEXT 'Western Zhou, the E '
       TEXT 'state controlled the present-day '
       TEXT 'Wuchang area south of the Yangtze River. '
       TEXT 'After the conquest of the E state, the '
       TEXT 'present-day Wuhan area was controlled by the '
       TEXT 'Chu state for the rest of the Western Zhou '
       TEXT 'and Eastern Zhou periods.'
EXP4B
       EVEN

* Test 5
* ------
* User inserted some text at the end of
* the paragraph.
TST5   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
TST5A  LI   R0,2
       MOV  R0,@PARINX
       LI   R0,406
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL5
       LI   R1,KEYL5E
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
* Get updated address of paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* Test paragraph contents
       AI   R1,4
       LI   R2,EXP5A+4
       LI   R0,EXP5B
       BL   @STRCMP
* Test position values.
* CHRPAX should have
* increasd.
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,420
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT


* input from the keyboard.
KEYL5  TEXT ' During the Ha'
KEYL5E EVEN

EXP5A  DATA 0,0
       TEXT 'With a history, Wuhan is one of the most '
       TEXT 'ancient and civilized '
       TEXT 'metropolitan cities in China. Panlongcheng '
       TEXT 'is located in '
       TEXT 'modern-day Huangpi District. During the '
       TEXT 'Western Zhou, the E '
       TEXT 'state controlled the present-day '
       TEXT 'Wuchang area south of the Yangtze River. '
       TEXT 'After the conquest of the E state, the '
       TEXT 'present-day Wuhan area was controlled by the '
       TEXT 'Chu state for the rest of the Western Zhou '
       TEXT 'and Eastern Zhou periods. During the Ha'
EXP5B
       EVEN

* Test 6
* ------
* User added text at the end of
* the paragraph in overwrite mode.
TST6   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
*
       SETO @INSTMD
*
       B    @TST5A

* Test 7
* ------
* Insert a character that the system
* doesn't recognize. Output should not
* be affected.
TST7   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,2
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL7
       LI   R1,KEYL7E
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
* Get updated address of paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* Test paragraph contents
       AI   R1,4
       LI   R2,PAR2+4
       LI   R0,PAR2A
       BL   @STRCMP
* Test position values.
* CHRPAX should have increasd.
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,2
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEYL7  BYTE >F0
KEYL7E

* Test 18
* -------
* Delete a character mid paragraph
TST18  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,8
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KYDEL
       LI   R1,KYDELE
       CLR  R2
       BL   @CPYKEY
* Run routine
       BLWP @INPUT
* Get updated address of paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* Test paragraph contents
       AI   R1,4
       LI   R2,EXP18+4
       LI   R0,EXP18A
       BL   @STRCMP
* Test position values.
* CHRPAX should be unchanged.
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,8
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
* Let R1 = address of element in
* LINLST containing paragraph address.
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
* Let R1 = length of paragraph
* Paragraph should be shorter.
       MOV  @EXP18,R0
       MOV  *R1,R1
       MOV  *R1,R1
       LI   R2,PARLEN
       LI   R3,6
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
* Delete key.
KYDEL  BYTE DELKEY
KYDELE

* Deleted the "i" from "history"
EXP18  DATA EXP18A-EXP18-4,WRAP2
       TEXT 'With a hstory, Wuhan is one of the most '
       TEXT 'ancient and civilized '
       TEXT 'metropolitan cities in China. Panlongcheng '
       TEXT 'is located in '
       TEXT 'modern-day Huangpi District. During the '
       TEXT 'Western Zhou, the E '
       TEXT 'state controlled the present-day '
       TEXT 'Wuchang area south of the Yangtze River. '
       TEXT 'After the conquest of the E state, the '
       TEXT 'present-day Wuhan area was controlled by the '
       TEXT 'Chu state for the rest of the Western Zhou '
       TEXT 'and Eastern Zhou periods.'
EXP18A
       EVEN

* Test 19
* -------
* Delete a carriage return.
* Merge two paragraphs.
TST19  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,0
       MOV  R0,@PARINX
       LI   R0,7
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KYL19
       LI   R1,KYL19E
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
* Save document status
       MOV  R0,R5
* Get updated address of paragraph
       MOV  @LINLST,R0
       LI   R1,0
       BLWP @ARYADR
       MOV  *R1,R1
* Test paragraph contents
       AI   R1,4
       LI   R2,EXP19+4
       LI   R0,EXP19A
       BL   @STRCMP
* Test position values.
* CHRPAX should be unchanged.
       LI   R0,0
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,7
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
* Paragraph should be longer
* Get updated address of paragraph
       MOV  @LINLST,R0
       LI   R1,0
       BLWP @ARYADR
       MOV  *R1,R1
       MOV  *R1,R1
       MOV  @EXP19,R0
       LI   R2,PARLEN
       LI   R3,6
       BLWP @AEQ
*
       MOV  @STSDCR,R0
       MOV  R5,R1
       LI   R2,TST19M
       LI   R3,TST19N-TST19M
       BLWP @AOC
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
* Delete key.
KYL19  BYTE DELKEY
KYL19E

* Merged two paragraphs
EXP19  DATA EXP19A-EXP19-4,WRAP0
       TEXT 'History'
       TEXT 'Antiquity'
EXP19A
TST19M TEXT 'Delete Carriage Return '
       TEXT 'bit should be set.'
TST19N EVEN

* Test 8
* ------
* User pressed the backspace from middle
* of paragraph.
TST8   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,129
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL8
       LI   R1,KEYL8E
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
* Save document status
       MOV  R0,R5
* Get updated address of paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* Test paragraph contents
       AI   R1,4
       LI   R2,PAR2+4
       LI   R0,PAR2A
       BL   @STRCMP
* Test position values.
* CHRPAX should have
* increasd.
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,128
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
*
       MOV  @STSARW,R0
       MOV  R5,R1
       LI   R2,TST8M
       LI   R3,TST8ME-TST8M
       BLWP @AOC
*
       MOV  *R10+,R11
       RT

* input from the keyboard.
KEYL8  BYTE BCKKEY
KEYL8E
TST8M  TEXT 'Arrow-Key-Pressed bit should be set.'
TST8ME EVEN

* Test 9
* ------
* User pressed the backspace from the
* beginning of the paragraph.
TST9   DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL8
       LI   R1,KEYL8E
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
* Get updated address of paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* Test paragraph contents
       AI   R1,4
       LI   R2,PAR2+4
       LI   R0,PAR2A
       BL   @STRCMP
* Test position values.
* CHRPAX should have
* increasd.
       LI   R0,1
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,9
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* Test 10
* -------
* User pressed the forward space onto
* another line in the middle of the
* paragraph.
TST10  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,167
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL10
       LI   R1,KEY10E
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
* Save document status
       MOV  R0,R5
* Get updated address of paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* Test paragraph contents
       AI   R1,4
       LI   R2,PAR2+4
       LI   R0,PAR2A
       BL   @STRCMP
* Test position values.
* CHRPAX should have
* increasd.
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,168
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
*
       MOV  @STSARW,R0
       MOV  R5,R1
       LI   R2,TST8M
       LI   R3,TST8ME-TST8M
       BLWP @AOC
*
       MOV  *R10+,R11
       RT

* Pretend that "_" means there was no
* input from the keyboard.
KEYL10 BYTE FWDKEY
KEY10E

* Test 11
* -------
* User pressed the forward space onto
* another paragraph.
TST11  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,406
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL10
       LI   R1,KEY10E
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
* Get updated address of paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* Test paragraph contents
       AI   R1,4
       LI   R2,PAR2+4
       LI   R0,PAR2A
       BL   @STRCMP
* Test position values.
* CHRPAX should have
* increasd.
       LI   R0,3
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,0
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT
       
* Test 15
* -------
* User pressed the forward space and
* a letter, but we leave the INPUT
* routine before processing the letter.
TST15  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,167
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL15
       LI   R1,KEY15E
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
* Get updated address of paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* Test paragraph contents
       AI   R1,4
       LI   R2,PAR2+4
       LI   R0,PAR2A
       BL   @STRCMP
* Test position values.
* CHRPAX should have increasd,
* but only due to arrow key.
       LI   R0,2
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,168
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

* Pretend that "_" means there was no
* input from the keyboard.
KEYL15 BYTE FWDKEY
       TEXT 'ab'
KEY15E

* Test 12
* -------
* User presses enter from the beginning
* of a paragraph.
TST12  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYENT
       LI   R1,KEYENU
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
* Get address of old paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* Paragraph should be empty
       MOV  *R1,R1
       JNE  ERR12
* Get address of new paragraph
       MOV  @LINLST,R0
       LI   R1,3
       BLWP @ARYADR
       MOV  *R1,R1
* The new paragraph should be the same
* as the original one
       AI   R1,4
       LI   R2,PAR2+4
       LI   R0,PAR2A
       BL   @STRCMP
* Test position values.
* CHRPAX should have
* increasd.
       LI   R0,3
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,0
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT


* input from the keyboard.
KEYENT BYTE ENTER
KEYENU

ERR12  MOV  R1,R0
       LI   R1,ERR12N
       BLWP @MAKETX
*
       LI   R0,ERR12M
       LI   R1,ERR12O-ERR12M
       BLWP @PRINTL
*
       MOV  *R10+,R11
       RT
ERR12M TEXT 'Test 000C failed. '
       TEXT 'The old paragraph is not empty: '
ERR12N TEXT '....'
ERR12O
       EVEN

* Test 13
* -------
* User presses enter from the middle
* of a paragraph.
TST13  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,149
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYENT
       LI   R1,KEYENU
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
* Get address of earlier paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* Test earlier paragraph
       AI   R1,4
       LI   R2,EXP13A
       LI   R0,EXP13B
       BL   @STRCMP
* Get address of later paragraph
       MOV  @LINLST,R0
       LI   R1,3
       BLWP @ARYADR
       MOV  *R1,R1
* Test later paragraph
       AI   R1,4
       LI   R2,EXP13C
       LI   R0,EXP13D
       BL   @STRCMP
* Test position values.
* CHRPAX should have
* increasd.
       LI   R0,3
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,0
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

EXP13A TEXT 'With a history, Wuhan is one of the most '
       TEXT 'ancient and civilized '
       TEXT 'metropolitan cities in China. Panlongcheng '
       TEXT 'is located in '
       TEXT 'modern-day Huangpi District. '
EXP13B
       EVEN
EXP13C TEXT 'During the '
       TEXT 'Western Zhou, the E '
       TEXT 'state controlled the present-day '
       TEXT 'Wuchang area south of the Yangtze River. '
       TEXT 'After the conquest of the E state, the '
       TEXT 'present-day Wuhan area was controlled by the '
       TEXT 'Chu state for the rest of the Western Zhou '
       TEXT 'and Eastern Zhou periods.'
EXP13D
       EVEN

* Test 14
* -------
* User presses enter from the end
* of a paragraph.
TST14  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,406
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYENT
       LI   R1,KEYENU
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
* Get address of new paragraph
       MOV  @LINLST,R0
       LI   R1,3
       BLWP @ARYADR
       MOV  *R1,R1
* Paragraph should be empty
       CLR  R0
       MOV  *R1,R1
       LI   R2,ERR14M
       LI   R3,ERR14O-ERR14M       
       BLWP @AEQ
* Get address of old paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* The new paragraph should be the same
* as the original one
       AI   R1,4
       LI   R2,PAR2+4
       LI   R0,PAR2A
       BL   @STRCMP
* Test position values.
* CHRPAX should point to paragraph start.
       LI   R0,3
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,0
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

ERR14M TEXT 'The old paragraph is not empty: '
ERR14O
       EVEN
       
* Test 16
* -------
* User presses enter and one letter, but
* letter is not initially processed.
TST16  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,406
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL16
       LI   R1,KEY16E
       CLR  R2
       BL   @CPYKEY
* Run routine
       BLWP @INPUT
* Get address of new paragraph
       MOV  @LINLST,R0
       LI   R1,3
       BLWP @ARYADR
       MOV  *R1,R1
* Paragraph should be empty
       CLR  R0
       MOV  *R1,R1
       LI   R2,ERR16M
       LI   R3,ERR16O-ERR16M
       BLWP @AEQ
* Get address of old paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* The new paragraph should be the same
* as the original one
       AI   R1,4
       LI   R2,PAR2+4
       LI   R0,PAR2A
       BL   @STRCMP
* Test position values.
* CHRPAX point to paragraph start.
       LI   R0,3
       MOV  @PARINX,R1
       LI   R2,LPRINX
       LI   R3,6
       BLWP @AEQ
*
       LI   R0,0
       MOV  @CHRPAX,R1
       LI   R2,LCRPAX
       LI   R3,6
       BLWP @AEQ
* The Enter key was at the beginning of
* the keystream. Keystream position
* should have advanced one.
       LI   R0,KEYSTR
       INC  R0
       MOV  @KEYRD,R1
       LI   R2,LKEYRD
       LI   R3,6
       BLWP @AEQ
*
       MOV  *R10+,R11
       RT

ERR16M TEXT 'The old paragraph is not empty: '
ERR16O

* input from the keyboard.
KEYL16 BYTE ENTER
       TEXT 'xy'
KEY16E
       EVEN


* Test 17
* -------
* User presses enter and nothing else.
* Enter-Pressed status bit should be set.
TST17  DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,231
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYENT
       LI   R1,KEYENU
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
* Store document status in R2
       MOV  R0,R5
* Check document status bits in R2
       MOV  @STSTYP,R0
       MOV  R5,R1
       LI   R2,TST17M
       LI   R3,TST17N-TST17M
       BLWP @AZC
*
       MOV  @STSENT,R0
       MOV  R2,R1
       LI   R2,TST17O
       LI   R3,TST17P-TST17O
       BLWP @AOC
*
       MOV  *R10+,R11
       RT

TST17M TEXT 'Text-Typed bit should not have been set.'
TST17N
TST17O TEXT 'Enter-Pressed bit should have been set.'
TST17P EVEN


*
* Effects of carriage return on margins
*
TST20
* Test 20
* -------
* User presses enter to split a
* paragraph.
* The original paragraph is earlier
* than any entry in the margin list.
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,149
       MOV  R0,@CHRPAX
* Set up margin list.
* There are 2 entries following old
* paragraph.
       MOV  @MGNLST,R0
       BLWP @ARYADD
       BLWP @ARYADD
       MOV  R0,@MGNLST
       LI   R1,MGN20D
TXT20A MOV  *R1+,*R0+
       CI   R1,MGN20D+20
       JL   TXT20A
* Copy test keypresses to stream
       LI   R0,KEYENT
       LI   R1,KEYENU
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
       LI   R0,MGN20N+20
       MOV  @MGNLST,R1
       LI   R2,MGN20N
       LI   R3,20
       BL   @STRCMP
*
       MOV  *R10+,R11
       RT

* I know there are not 5 paragraphs in
* the document. Go with it.
MGN20D DATA 2,3
       DATA 3,>1112,>1314,>1516
       DATA 5,>2122,>2324,>2526
MGN20N DATA 2,3
       DATA 4,>1112,>1314,>1516
       DATA 6,>2122,>2324,>2526

TST21
* Test 21
* -------
* User presses enter to split a
* paragraph.
* The original paragraph is between
* entries in the margin list, and
* also has its own entry.
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,149
       MOV  R0,@CHRPAX
* Set up margin list.
* There are 2 entries following old
* paragraph.
       MOV  @MGNLST,R0
       BLWP @ARYADD
       BLWP @ARYADD
       BLWP @ARYADD
       BLWP @ARYADD
       BLWP @ARYADD
       MOV  R0,@MGNLST
       LI   R1,MGN21D
TXT21A MOV  *R1+,*R0+
       CI   R1,5*8+4+MGN21D
       JL   TXT21A
* Copy test keypresses to stream
       LI   R0,KEYENT
       LI   R1,KEYENU
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
       LI   R0,5*8+4+MGN21N
       MOV  @MGNLST,R1
       LI   R2,MGN21N
       LI   R3,5*8+4
       BL   @STRCMP
*
       MOV  *R10+,R11
       RT

* I know there are not 5 paragraphs in
* the document. Go with it.
MGN21D DATA 5,3
       DATA 0,>1112,>1314,>1516
       DATA 1,>2122,>2324,>2526
       DATA 2,>3132,>3334,>3536
       DATA 3,>4142,>4344,>4546
       DATA 4,>5152,>5354,>5556
MGN21N DATA 5,3
       DATA 0,>1112,>1314,>1516
       DATA 1,>2122,>2324,>2526
       DATA 2,>3132,>3334,>3536
       DATA 4,>4142,>4344,>4546
       DATA 5,>5152,>5354,>5556

TST22
* Test 22
* -------
* User presses enter to split a
* paragraph.
* The original paragraph follows all
* entries in the margin list.
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,149
       MOV  R0,@CHRPAX
* Set up margin list.
* There are 2 entries following old
* paragraph.
       MOV  @MGNLST,R0
       BLWP @ARYADD
       BLWP @ARYADD
       MOV  R0,@MGNLST
       LI   R1,MGN22D
TXT22A MOV  *R1+,*R0+
       CI   R1,2*8+4+MGN22D
       JL   TXT22A
* Copy test keypresses to stream
       LI   R0,KEYENT
       LI   R1,KEYENU
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
       LI   R0,2*8+4+MGN22N
       MOV  @MGNLST,R1
       LI   R2,MGN22N
       LI   R3,2*8+4
       BL   @STRCMP
*
       MOV  *R10+,R11
       RT

* I know there are not 5 paragraphs in
* the document. Go with it.
MGN22D DATA 2,3
       DATA 0,>1112,>1314,>1516
       DATA 1,>2122,>2324,>2526
MGN22N DATA 2,3
       DATA 0,>1112,>1314,>1516
       DATA 1,>2122,>2324,>2526

TST23
* Test 23
* -------
* User presses delete to merge two
* paragraphs. Later paragraph has no
* margin entry
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,1
       MOV  R0,@PARINX
       LI   R0,9
       MOV  R0,@CHRPAX
* Set up margin list.
* There are 2 entries following old
* paragraph.
       MOV  @MGNLST,R0
       BLWP @ARYADD
       BLWP @ARYADD
       MOV  R0,@MGNLST
       LI   R1,MGN23D
TXT23A MOV  *R1+,*R0+
       CI   R1,3*8+4+MGN23D
       JL   TXT23A
* Copy test keypresses to stream
       LI   R0,KYDEL
       LI   R1,KYDELE
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
       LI   R0,3*8+4+MGN23N
       MOV  @MGNLST,R1
       LI   R2,MGN23N
       LI   R3,3*8+4
       BL   @STRCMP
*
       MOV  *R10+,R11
       RT

* I know there are not 5 paragraphs in
* the document. Go with it.
MGN23D DATA 3,3
       DATA 0,>1112,>1314,>1516
       DATA 2,>2122,>2324,>2526
       DATA 4,>3122,>3334,>3536
MGN23N DATA 3,3
       DATA 0,>1112,>1314,>1516
       DATA 2,>2122,>2324,>2526
       DATA 3,>3122,>3334,>3536

TST24
* Test 24
* -------
* User presses delete to merge two
* paragraphs. Later paragraph has a
* margin entry, that must be deleted
       DECT R10
       MOV  R11,*R10
* Initialize Test Data
       BL   @TSTINT
* Set position values
       CLR  @INSTMD
       LI   R0,1
       MOV  R0,@PARINX
       LI   R0,9
       MOV  R0,@CHRPAX
* Set up margin list.
* There are 2 entries following old
* paragraph.
       MOV  @MGNLST,R0
       BLWP @ARYADD
       BLWP @ARYADD
       BLWP @ARYADD
       MOV  R0,@MGNLST
       LI   R1,MGN24D
TXT24A MOV  *R1+,*R0+
       CI   R1,3*8+4+MGN24D
       JL   TXT24A
* Copy test keypresses to stream
       LI   R0,KYDEL
       LI   R1,KYDELE
       CLR  R2
       BL   @CPYKEY
* Act
       BLWP @INPUT
* Assert
       LI   R0,2*8+4+MGN24N
       MOV  @MGNLST,R1
       LI   R2,MGN24N
       LI   R3,2*8+4
       BL   @STRCMP
*
       MOV  *R10+,R11
       RT

* I know there are not 5 paragraphs in
* the document. Go with it.
MGN24D DATA 3,3
       DATA 1,>1112,>1314,>1516
       DATA 2,>2122,>2324,>2526
       DATA 3,>3122,>3334,>3536
MGN24N DATA 2,3
       DATA 1,>1112,>1314,>1516
       DATA 2,>3122,>3334,>3536

*** Test Utils *******************************

* Copy test keypresses to the key stream
* R0 = Address of first test key
* R1 = Address following last test key
* R2 = Offset within key stream
CPYKEY
* Prohibit keystreams longer than 14 bytes
       CI   R2,14
       JL   CPY0
       LI   R2,14
*
CPY0   AI   R2,KEYSTR
       MOV  R2,@KEYRD
CPYLP  MOVB *R0+,*R2+
       CI   R2,KEYEND
       JL   CPY1
       LI   R2,KEYSTR
CPY1   C    R0,R1
       JL   CPYLP
CPYRT
       MOV  R2,@KEYWRT
       RT

*
* Check that the strings match.
*
* Input:
* R0 - end of expected contents
* R1 - address of actual paragraph
*      contents
* R2 - address of expected paragraph
*      contents
* R3 - test number
STRCMP MOV  R2,R4
STRCM1 CB   *R1+,*R2+
       JNE  STRERR
       C    R2,R0
       JL   STRCM1
       RT

STRERR S    R4,R2
*
       MOV  R3,R0
       LI   R1,STRMS+5
       BLWP @MAKETX
*
       MOV  R2,R0
       DEC  R0
       LI   R1,STRMS2
       BLWP @MAKETX
*
       LI   R0,STRMS
       LI   R1,STRMS1-STRMS
       BLWP @PRINTL
*
       MOV  *R10+,R11
       RT
STRMS  TEXT 'Test .... failed. '
       TEXT 'Strings do not match at index '
STRMS2 TEXT '....'
STRMS1 EVEN

******* MOCKS **************
MNUHK
MNUINT
PRINT
* These VDP routines should do nothing
VDPADR
VDPWRT RT

****************************************

SPACE  BSS  >1000
SPCEND

       END