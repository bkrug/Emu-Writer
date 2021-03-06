       DEF  RUNTST
* Mocks
       DEF  VDPADR,VDPWRT
*
       REF  INPUT

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

RUNTST BLWP @OPENF
* Write notification on screen.
       BL   @WRTST
* Run each test
*
* User inserted some text and overwrote
* some other text
       BL   @TSTINT
       BL   @TST1
* User inserted some text.
* Outputs STSTYP set, STSENT reset.
       BL   @TSTINT
       BL   @TST2
* User inserted some text and pressed
* an arrow key. The arrow key is not
* immediately processed.
       BL   @TSTINT
       BL   @TST3
* User inserted some text.
* The key stream will wrap around.
       BL   @TSTINT
       BL   @TST4
* User inserted some text at the end of 
* a paragraph
       BL   @TSTINT
       BL   @TST5
* User inserted some text at the end of 
* a paragraph, while in overwrite mode
       BL   @TSTINT
       BL   @TST6
* Insert a character that the system
* doesn't recognize. Output should not
* be affected.
       BL   @TSTINT
       BL   @TST7
* Delete the character at the cursor
* position.
       BL   @TSTINT
       BL   @TST18
* Delete a carriage return
       BL   @TSTINT
       BL   @TST19
* ---
* User pressed the backspace from middle
* of paragraph.
       BL   @TSTINT
       BL   @TST8
* User pressed the backspace from start
* of paragraph.
       BL   @TSTINT
       BL   @TST9
* ---
* User pressed forward space from middle
* of paragraph.
       BL   @TSTINT
       BL   @TST10
* User pressed forward space from end
* of paragraph.
       BL   @TSTINT
       BL   @TST11
* User pressed forward space and a 
* letter, but letter is not initially
* processed.
       BL   @TSTINT
       BL   @TST15
* ---
* User presses enter from paragraph start
       BL   @TSTINT
       BL   @TST12
* User presses enter from paragraph middle
       BL   @TSTINT
       BL   @TST13
* User presses enter from paragraph end
       BL   @TSTINT
       BL   @TST14
* User presses enter and one letter, but
* letter is not initially processed.
       BL   @TSTINT
       BL   @TST16
* User presses enter and nothing else.
* Enter-Pressed status bit should be set.
       BL   @TSTINT
       BL   @TST17
* ---
* Write notification on screen.
       BL   @WREND
       BLWP @CLOSEF
JMP    LIMI 2
       LIMI 0
       JMP  JMP

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
       LI   R10,INTADR
* Copy a paragraph into buffer
TSTIN1
       MOV  *R10+,R0
       MOV  R0,R2
       BLWP @BUFALC
       MOV  R0,R1
       MOV  *R10+,R0
       BLWP @BUFCPY
       MOV  R1,R4
* and a wrap list
       MOV  *R10+,R0
       MOV  R0,R2
       BLWP @BUFALC
       MOV  R0,R1
       MOV  *R10+,R0
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
       CI   R10,INTADE
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
TST1   MOV  R11,R12
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
* Run routine
       BLWP @INPUT
* Get address of paragraph now
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
       MOV  @PARINX,R0
       LI   R1,2
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,7+12
       LI   R2,LCRPAX
       BL   @COMPVL
*
       BL   @PSUCCS
*
       B    *R12


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
TST2   MOV  R11,R12
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
* Run routine
       BLWP @INPUT
* Store document status
       MOV  R0,R5
* Get address of paragraph now
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
       MOV  @PARINX,R0
       LI   R1,2
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,108
       LI   R2,LCRPAX
       BL   @COMPVL
* Check document status bits in R5
       COC  @STSTYP,R5
       JEQ  TST2A
       LI   R0,TST2M
       LI   R1,TST2ME-TST2M
       BLWP @PRINTL
       B    *R12
*
TST2A  CZC  @STSENT,R5
       JEQ  TST2B
       LI   R0,TST2N
       LI   R1,TST2NE-TST2N
       BLWP @PRINTL
       B    *R12
*
TST2B  CZC  @STSARW,R5
       JEQ  TST2C
       LI   R0,TST2O
       LI   R1,TST2OE-TST2O
       BLWP @PRINTL
       B    *R12
*
TST2C  BL   @PSUCCS
*
       B    *R12

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
TST3   MOV  R11,R12
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
* Run routine
       BLWP @INPUT
* Get address of paragraph now
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
       MOV  @PARINX,R0
       LI   R1,2
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,104
       LI   R2,LCRPAX
       BL   @COMPVL
*
       BL   @PSUCCS
*
       B    *R12


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
TST4   MOV  R11,R12
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
* Run routine
       BLWP @INPUT
* Get address of paragraph now
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
       MOV  @PARINX,R0
       LI   R1,2
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,121
       LI   R2,LCRPAX
       BL   @COMPVL
*
       BL   @PSUCCS
*
       B    *R12


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
TST5   MOV  R11,R12
* Set test number.
       LI   R3,5
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
* Run routine
       BLWP @INPUT
* Get address of paragraph now
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
       MOV  @PARINX,R0
       LI   R1,2
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,420
       LI   R2,LCRPAX
       BL   @COMPVL
*
       BL   @PSUCCS
*
       B    *R12


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
TST6   MOV  R11,R12
       SETO @INSTMD
* Set test number.
       LI   R3,6
*
       B    @TST5A

* Test 7
* ------
* Insert a character that the system
* doesn't recognize. Output should not
* be affected.
TST7   MOV  R11,R12
* Set test number.
       LI   R3,7
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
* Run routine
       BLWP @INPUT
* Get address of paragraph now
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
       MOV  @PARINX,R0
       LI   R1,2
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,2
       LI   R2,LCRPAX
       BL   @COMPVL
*
       BL   @PSUCCS
*
       B    *R12

* input from the keyboard.
KEYL7  BYTE >F0
KEYL7E

* Test 18
* -------
* Delete a character mid paragraph
TST18  MOV  R11,R12
* Set test number.
       LI   R3,18
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,8
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KYL18
       LI   R1,KYL18E
       CLR  R2
       BL   @CPYKEY
* Run routine
       BLWP @INPUT
* Get address of paragraph now
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
       MOV  @PARINX,R0
       LI   R1,2
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,8
       LI   R2,LCRPAX
       BL   @COMPVL
* Paragraph should be shorter
* Get address of paragraph now
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R0
       MOV  *R0,R0
       MOV  @EXP18,R1
       LI   R2,PARLEN
       BL   @COMPVL
*
       BL   @PSUCCS
*
       B    *R12

* input from the keyboard.
* Delete key.
KYL18  BYTE DELKEY
KYL18E

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
TST19  MOV  R11,R12
* Set test number.
       LI   R3,19
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
* Run routine
       BLWP @INPUT
* Save document status
       MOV  R0,R5
* Get address of paragraph now
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
       MOV  @PARINX,R0
       LI   R1,0
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,7
       LI   R2,LCRPAX
       BL   @COMPVL
* Paragraph should be longer
* Get address of paragraph now
       MOV  @LINLST,R0
       LI   R1,0
       BLWP @ARYADR
       MOV  *R1,R0
       MOV  *R0,R0
       MOV  @EXP19,R1
       LI   R2,PARLEN
       BL   @COMPVL
*
       COC  @STSDCR,R5
       JEQ  TST19A
       LI   R0,TST19M
       LI   R1,TST19N-TST19M
       BLWP @PRINTL
*
TST19A BL   @PSUCCS
*
       B    *R12

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
TST8   MOV  R11,R12
* Set test number.
       LI   R3,8
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
* Run routine
       BLWP @INPUT
* Save document status
       MOV  R0,R5
* Get address of paragraph now
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
       MOV  @PARINX,R0
       LI   R1,2
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,128
       LI   R2,LCRPAX
       BL   @COMPVL
*
       COC  @STSARW,R5
       JEQ  TST8A
       LI   R0,TST8M
       LI   R1,TST8ME-TST8M
       BLWP @PRINTL
*
TST8A  BL   @PSUCCS
*
       B    *R12

* input from the keyboard.
KEYL8  BYTE BCKKEY
KEYL8E
TST8M  TEXT 'Arrow-Key-Pressed bit should be set.'
TST8ME EVEN

* Test 9
* ------
* User pressed the backspace from the
* beginning of the paragraph.
TST9   MOV  R11,R12
* Set test number.
       LI   R3,9
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
* Run routine
       BLWP @INPUT
* Get address of paragraph now
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
       MOV  @PARINX,R0
       LI   R1,1
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,9
       LI   R2,LCRPAX
       BL   @COMPVL
*
       BL   @PSUCCS
*
       B    *R12

* Test 10
* -------
* User pressed the forward space onto
* another line in the middle of the
* paragraph.
TST10  MOV  R11,R12
* Set test number.
       LI   R3,10
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
* Run routine
       BLWP @INPUT
* Save document status
       MOV  R0,R5
* Get address of paragraph now
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
       MOV  @PARINX,R0
       LI   R1,2
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,168
       LI   R2,LCRPAX
       BL   @COMPVL
*
       COC  @STSARW,R5
       JEQ  TST9A
       LI   R0,TST8M
       LI   R1,TST8ME-TST8M
       BLWP @PRINTL
*
TST9A  BL   @PSUCCS
*
       B    *R12

* Pretend that "_" means there was no
* input from the keyboard.
KEYL10 BYTE FWDKEY
KEY10E

* Test 11
* -------
* User pressed the forward space onto
* another paragraph.
TST11  MOV  R11,R12
* Set test number.
       LI   R3,11
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
* Run routine
       BLWP @INPUT
* Get address of paragraph now
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
       MOV  @PARINX,R0
       LI   R1,3
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,0
       LI   R2,LCRPAX
       BL   @COMPVL
*
       BL   @PSUCCS
*
       B    *R12
       
* Test 15
* -------
* User pressed the forward space and
* a letter, but we leave the INPUT
* routine before processing the letter.
TST15  MOV  R11,R12
* Set test number.
       LI   R3,15
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
* Run routine
       BLWP @INPUT
* Get address of paragraph now
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
       MOV  @PARINX,R0
       LI   R1,2
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,168
       LI   R2,LCRPAX
       BL   @COMPVL
*
       BL   @PSUCCS
*
       B    *R12

* Pretend that "_" means there was no
* input from the keyboard.
KEYL15 BYTE FWDKEY
       TEXT 'ab'
KEY15E

* Test 12
* -------
* User presses enter from the beginning
* of a paragraph.
TST12  MOV  R11,R12
* Set test number.
       LI   R3,12
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,0
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL12
       LI   R1,KEY12E
       CLR  R2
       BL   @CPYKEY
* Run routine
       BLWP @INPUT
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
       MOV  @PARINX,R0
       LI   R1,3
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,0
       LI   R2,LCRPAX
       BL   @COMPVL
*
       BL   @PSUCCS
*
       B    *R12


* input from the keyboard.
KEYL12 BYTE ENTER
KEY12E

ERR12  MOV  R1,R0
       LI   R1,ERR12N
       BLWP @MAKETX
*
       LI   R0,ERR12M
       LI   R1,ERR12O-ERR12M
       BLWP @PRINTL
*
       B    *R12
ERR12M TEXT 'Test 000C failed. '
       TEXT 'The old paragraph is not empty: '
ERR12N TEXT '....'
ERR12O
       EVEN

* Test 13
* -------
* User presses enter from the middle
* of a paragraph.
TST13  MOV  R11,R12
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,149
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL12
       LI   R1,KEY12E
       CLR  R2
       BL   @CPYKEY
* Run routine
       BLWP @INPUT
* Get address of earlier paragraph
       MOV  @LINLST,R0
       LI   R1,2
       BLWP @ARYADR
       MOV  *R1,R1
* Set test number.
       LI   R3,>1000+13
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
* Set test number.
       LI   R3,13
* Test later paragraph
       AI   R1,4
       LI   R2,EXP13C
       LI   R0,EXP13D
       BL   @STRCMP
* Test position values.
* CHRPAX should have
* increasd.
       MOV  @PARINX,R0
       LI   R1,3
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,0
       LI   R2,LCRPAX
       BL   @COMPVL
*
       BL   @PSUCCS
*
       B    *R12

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
TST14  MOV  R11,R12
* Set test number.
       LI   R3,14
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,406
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL12
       LI   R1,KEY12E
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
       MOV  *R1,R1
       JNE  ERR14
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
       MOV  @PARINX,R0
       LI   R1,3
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,0
       LI   R2,LCRPAX
       BL   @COMPVL
*
       BL   @PSUCCS
*
       B    *R12

ERR14  MOV  R1,R0
       LI   R1,ERR14N
       BLWP @MAKETX
*
       LI   R0,ERR14M
       LI   R1,ERR14O-ERR14M
       BLWP @PRINTL
*
       B    *R12
ERR14M TEXT 'Test 000E failed. '
       TEXT 'The old paragraph is not empty: '
ERR14N TEXT '....'
ERR14O
       EVEN
       
* Test 16
* -------
* User presses enter and one letter, but
* letter is not initially processed.
TST16  MOV  R11,R12
* Set test number.
       LI   R3,16
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
       MOV  *R1,R1
       JNE  ERR16
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
       MOV  @PARINX,R0
       LI   R1,3
       LI   R2,LPRINX
       BL   @COMPVL
*
       MOV  @CHRPAX,R0
       LI   R1,0
       LI   R2,LCRPAX
       BL   @COMPVL
* The Enter key was at the beginning of
* the keystream. Keystream position
* should have advanced one.
       MOV  @KEYRD,R0
       LI   R1,KEYSTR
       INC  R1
       LI   R2,LKEYRD
       BL   @COMPVL
*
       BL   @PSUCCS
*
       B    *R12

ERR16  MOV  R1,R0
       LI   R1,ERR16N
       BLWP @MAKETX
*
       LI   R0,ERR16M
       LI   R1,ERR16O-ERR16M
       BLWP @PRINTL
*
       B    *R12       
ERR16M TEXT 'Test 0010 failed. '
       TEXT 'The old paragraph is not empty: '
ERR16N TEXT '....'
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
TST17  MOV  R11,R12
* Set test number.
       LI   R3,17
* Set position values
       CLR  @INSTMD
       LI   R0,2
       MOV  R0,@PARINX
       LI   R0,231
       MOV  R0,@CHRPAX
* Copy test keypresses to stream
       LI   R0,KEYL12
       LI   R1,KEY12E
       CLR  R2
       BL   @CPYKEY
* Run routine
       BLWP @INPUT
* Store document status in R2
       MOV  R0,R2
* Check document status bits in R2
       CZC  @STSTYP,R2
       JEQ  TST17A
       LI   R0,TST17M
       LI   R1,TST17N-TST17M
       BLWP @PRINTL
       B    *R12
*
TST17A COC  @STSENT,R2
       JEQ  TST17B
       LI   R0,TST17O
       LI   R1,TST17P-TST17O
       BLWP @PRINTL
       B    *R12
*
TST17B BL   @PSUCCS
*
       B    *R12

TST17M TEXT 'Text-Typed bit should not have been set.'
TST17N
TST17O TEXT 'Enter-Pressed bit should have been set.'
TST17P EVEN


****************************************

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


* Compare contents of R0 and R1.
* Report if they don't match.
*
* R0 - Actual value
* R1 - Expected value
* R2 - Address of six byte string
*      containing variable name
* R3 - test number
COMPVL
       C    R0,R1
       JEQ  COMPRT
*
       LI   R1,COMPM2+13
       BLWP @MAKETX
*
       MOV  R3,R0
       LI   R1,COMPMS+5
       BLWP @MAKETX
*
       LI   R1,COMPM1+9
       MOVB *R2+,*R1+
       MOVB *R2+,*R1+
       MOVB *R2+,*R1+
       MOVB *R2+,*R1+
       MOVB *R2+,*R1+
       MOVB *R2+,*R1+
*
       LI   R0,COMPMS
       LI   R1,COMPM3-COMPMS
       BLWP @PRINTL
*
       B    *R12
*
COMPRT RT
*
COMPMS TEXT 'Test .... failed. '
COMPM1 TEXT 'Value in ...... is wrong. '
COMPM2 TEXT 'Actual value .....'
COMPM3 EVEN


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
       B    *R12
STRMS  TEXT 'Test .... failed. '
       TEXT 'Strings do not match at index '
STRMS2 TEXT '....'
STRMS1 EVEN

PSUCCS MOV  R3,R0
       LI   R1,PSCCSM+5
       BLWP @MAKETX
       LI   R0,PSCCSM
       LI   R1,PSCCSE-PSCCSM
       BLWP @PRINTL
       RT
PSCCSM TEXT 'Test .... succeeded.'
       EVEN
PSCCSE

******* MOCKS **************
* These VDP routines should do nothing
VDPADR
VDPWRT RT

****************************************

SPACE  BSS  >1000
SPCEND

       END