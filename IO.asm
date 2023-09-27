       DEF  IOSTRT,IOEND
       DEF  FRSHST,FRSHED
       DEF  SAVE,LOAD,PRINT,MYBNEW
       DEF  MYBQIT
*
       REF  DSRLCL
       REF  INTDOC,INTPAR
       REF  VDPADR,VDPRAD,VDPWRT,VDPSTR
       REF  VDPSPC,VDPINV
       REF  LINLST,MGNLST                         From VAR.asm
       REF  FLDVAL,WINMOD                         "
       REF  ARYADR,BUFGRW                         From ARRAY.asm
       REF  WRAP,INTDOC
       REF  WRAPDC                                From UTIL.asm
       REF  CURMNU

*
       COPY 'CPUADR.asm'
*
       AORG >A000
IOSTRT
       XORG LOADED
*
PAB    EQU  >3C0
PABBUF EQU  PATTBL+>400
*
FIXED  EQU  >00
VARIAB EQU  >10
*
DISPLY EQU  >00
INTERN EQU  >08
*
UPDATE EQU  >00
OUTPUT EQU  >02
INPUT  EQU  >04
APPEND EQU  >06
*
SEQUEN EQU  >00
RELATV EQU  >01
*
FIXSAV EQU  >40                             * Fixed length of save records
MAXPRT EQU  >FE                             * Max Length of print records
*
* PAB data for Saving
SDATA  BYTE 0
       BYTE FIXED+DISPLY+OUTPUT+SEQUEN
       DATA PABBUF
       BYTE FIXSAV                          * Fixed Record Length
       BYTE FIXSAV                          * Length of this record
       DATA 0                               * Record number
       BYTE 0                               * Screen offset
       BYTE 0                               * Name length
SDATA0
*
* PAB data for Loading
LDATA  BYTE 0
       BYTE FIXED+DISPLY+INPUT+SEQUEN
       DATA PABBUF
       BYTE FIXSAV                          * Fixed Record Length
       BYTE FIXSAV                          * Length of this record
       DATA 0                               * Record number
       BYTE 0                               * Screen offset
       BYTE 0                               * Name length
LDATA0
*
* PAB data for Printing
PDATA  BYTE 0
       BYTE VARIAB+DISPLY+OUTPUT+SEQUEN
       DATA PABBUF
       BYTE MAXPRT                          * Max Record Length
       BYTE 0                               * Length of this record
       DATA 0                               * Record number
       BYTE 0                               * Screen offset
       BYTE 0                               * Name length
PDATA0
*
LNGADR DATA PAB+9
*
OPEN   BYTE >00
CLOSE  BYTE >01
READ   BYTE >02
WRITE  BYTE >03
*
CR     BYTE 13
ETX    BYTE 3                               * End of document
*
* This goes at the beginning of each Emu-Writer file
* If the HDR does not match, this is not an Emu-Writer file
* If the first byte of the version is high, the version is incompatible
* If the second byte of the version is high, we can still load the file
FLEHDR TEXT 'DocOfEmuWriter'
FLEVER BYTE 1,1
HDREND
       EVEN

*
* Save
*
SAVE   DECT R10
       MOV  R11,*R10
* Turn off interrupts
       LIMI 0
* Open File
       LI   R2,SDATA
       BL   @OPENFL
       JEQ  SLERR
* Change I/O op-code to write
       LI   R0,PAB
       BL   @VDPADR
       MOVB @WRITE,@VDPWD
* Set VDP write position
       LI   R0,PABBUF
       BL   @VDPADR
* Write file Header
* Let R3 = number of bytes already written to VDP
       LI   R0,FLEHDR
       LI   R1,HDREND-FLEHDR
       MOV  R1,R3
       BL   @VDPWRT
* Let R2 = remaining paragraphs
       MOV  @LINLST,R0
       MOV  *R0,R2
* Let R1 = address of paragraph entry in the paragraph list
       MOV  @LINLST,R0
       CLR  R1
       BLWP @ARYADR
* Let R4 = address within paragraph
* Let R5 = remaining bytes in paragraph
       MOV  *R1,R4
       MOV  *R4,R5
       AI   R4,4
SAVBYT
* If paragraph complete, write CR
       MOV  R5,R5
       JEQ  SAVECR
* Write text to VDP RAM
       MOVB *R4+,@VDPWD
       DEC  R5
       JMP  SAVE3
*
SAVECR
* Prepare for next paragraph
       INCT R1
       DEC  R2
       JEQ  SAVEDN
* Let R4 = address within paragraph
* Let R5 = remaining bytes in paragraph
       MOV  *R1,R4
       MOV  *R4,R5
       AI   R4,4
* Write CR to VDP RAM
       MOVB @CR,@VDPWD
* Enough bytes to write record?
SAVE3  INC  R3
       CI   R3,FIXSAV
* If not, next byte
       JL   SAVBYT
* If yes, write record
       MOV  @LNGADR,@PNTR
       BLWP @DSRLCL
       DATA 8
       JEQ  SLERR
* Re-set VDP write position
       LI   R0,PABBUF
       BL   @VDPADR
*
       CLR  R3
*
       JMP  SAVBYT
* Document complete
SAVEDN
* Write ETX character
       MOVB @ETX,@VDPWD
* Write record
       MOV  @LNGADR,@PNTR
       BLWP @DSRLCL
       DATA 8
       JEQ  SLERR
*
       BL   @CLOSFL
       JEQ  SLERR
* No Error
       CLR  R0
*
SAVERT LIMI 2
*
       MOV  *R10+,R11
       RT
*
SLERR  BL   @DSPERR
       JMP  SAVERT

*
* Load
*
LOAD   DECT R10
       MOV  R11,*R10
* Turn off interrupts
       LIMI 0
* Open File
       LI   R2,LDATA
       BL   @OPENFL
       JEQ  SLERR
* Change I/O op-code to read
       LI   R0,PAB
       BL   @VDPADR
       MOVB @READ,@VDPWD
* Read first record
       MOV  @LNGADR,@PNTR
       BLWP @DSRLCL
       DATA 8
       JEQ  SLERR
* Set VDP read position
       LI   R0,PABBUF
       BL   @VDPRAD
* Does first record contain expected header?
       LI   R1,FLEHDR
LOAD3  MOVB @VDPRD,R0
       CB   R0,*R1+
       JNE  HDRMSS
       CI   R1,FLEVER
       JL   LOAD3
* Is Format-Version too high?
       MOVB @VDPRD,R0
       CB   R0,@FLEVER
       JH   WRGVER
* Read next byte of Format-Version
* If it is too high, file merely has extra data we can't use
       MOVB @VDPRD,R0
* Since this is a valid file, purge the old file
       BL   @INTDOC
* Let R4 = number of record bytes remaining to read
       LI   R4,FIXSAV-HDREND+FLEHDR
* Let R3 = address of first element in paragraph list
       MOV  @LINLST,R3
       C    *R3+,*R3+
*
       JMP  LOADBY
LOADR
* Read record
       MOV  @LNGADR,@PNTR
       BLWP @DSRLCL
       DATA 8
       JEQ  SLERR
* Set VDP read position
       LI   R0,PABBUF
       BL   @VDPRAD
* Let R4 = number of record bytes remaining to read
       LI   R4,FIXSAV
LOADBY
* Is next char a CR?
       MOVB @VDPRD,R5
       CB   R5,@CR
       JEQ  NEWPAR
* Reached end of document?
       CB   R5,@ETX
       JEQ  LOADDN
* No, grow the paragraph's allocated block, if necessary.
* Let R0 be the address of the paragraph.
* Let R1 be the length of the paragraph plus one new character
       MOV  *R3,R0
       MOV  *R0,R1
       AI   R1,5
       BLWP @BUFGRW
       CI   R0,>FFFF
       JEQ  LOADDN
* Store new paragraph address
       MOV  R0,*R3
* Let R6 contain address following the paragraph
       MOV  R0,R6
       C    *R6+,*R6+
       A    *R0,R6
* Append character to paragraph.
       MOVB R5,*R6
* Increase paragraph length by one.
       INC  *R0
       JMP  LOAD1
NEWPAR
* Start new pararaph
* Let R3 = address of element in paragraph list
       MOV  R4,R5
       BL   @INTPAR
       MOV  R1,R3
       MOV  R5,R4
LOAD1
* Decrease remaining char to read
       DEC  R4
* Reached end of record?
       JNE  LOADBY
* Yes, load another record
       JMP  LOADR
* Reached End of Document
LOADDN BL   @CLOSFL
       JEQ  SLERR
* Wrap all paragraphs
       BL   @WRAPDC
* No Error
       CLR  R0
*
LOADRT LIMI 2
*
       MOV  *R10+,R11
       RT
*
* File Header Missing
*
HDRMSS LI   R2,MSGNOT
       JMP  WRGVER+4
*
* Wrong File Format Version
*
WRGVER LI   R2,MSGVER
       BL   @WRTERR
       JMP  LOADRT

*
* Print
*
PRINT  DECT R10
       MOV  R11,*R10
* Turn off interrupts
       LIMI 0
* If not already in Window Mode, wrap all paragraphs
       DECT R10
       MOV  @WINMOD,*R10
       JEQ  PRINT0
       CLR  @WINMOD
       BL   @WRAPDC
PRINT0
* Open File
       LI   R2,PDATA
       BL   @OPENFL
       JEQ  PRTERR
* Change I/O op-code to write
       LI   R0,PAB
       BL   @VDPADR
       MOVB @WRITE,@VDPWD
* Let R2 = current paragraph
       CLR  R2
* Let R1 = address of paragraph's
* entry in the paragraph list
       MOV  @LINLST,R0
PRINT1 MOV  R2,R1
       BLWP @ARYADR
* Let R4 = address of paragraph
* Let R5 = address of wrap list
* Let R6 = address within paragraph
* Let R7 = line in paragraph (0-based)
       MOV  *R1,R4
       MOV  @2(R4),R5
       MOV  R4,R6
       AI   R6,4
       CLR  R7
PRINT2
* Let R8 = length of line
       MOV  *R5,*R5
       JNE  LENP1
* Set Length for paragraph with one line
       MOV  *R4,R8
       JMP  PRINT3
*
LENP1  MOV  R7,R7
       JNE  LENP2
* Set length for first line in paragraph
       MOV  @4(R5),R8
       JMP  PRINT3
*
LENP2  C    R7,*R5
       JHE  LENP3
* Set length for middle lines in paragraph
       MOV  R5,R0
       MOV  R7,R1
       BLWP @ARYADR
*
       CLR  R8
       S    @-2(R1),R8
       A    *R1,R8
       JMP  PRINT3
* Set length for last line in paragraph
LENP3  MOV  R5,R0
       MOV  R7,R1
       DEC  R1
       BLWP @ARYADR
*
       CLR  R8
       S    *R1,R8
       A    *R4,R8
PRINT3
* Let R1 = left margin length
       BL   @GETMGN
* Increase record length by size of left margin
* Truncate the record length if it is greater than 254
       A    R1,R8
       CI   R8,MAXPRT
       JLE  PRNT3B
       LI   R8,MAXPRT
PRNT3B
* Write record (following left margin) to VDP RAM
       LI   R0,PABBUF
       BL   @VDPADR
       BL   @VDPSPC
       MOV  R6,R0
       MOV  R8,R1
       BL   @VDPWRT
* In PAB, specify number of characters to write
       LI   R0,PAB+5
       BL   @VDPADR
       SWPB R8
       MOVB R8,@VDPWD
* Write one record
       MOV  @LNGADR,@PNTR
       BLWP @DSRLCL
       DATA 8
       JEQ  PRTERR
* End of paragraph?
       C    R7,*R5
       JHE  PRINT4
* No, let R6 = address of next line in paragraph
       MOV  R5,R0
       MOV  R7,R1
       BLWP @ARYADR
       MOV  R4,R6
       AI   R6,4
       A    *R1,R6
* Loop to write next line
       INC  R7
       JMP  PRINT2
PRINT4
* Last paragraph of document?
       INC  R2
       MOV  @LINLST,R0
       C    R2,*R0
       JL   PRINT1
* Yes, close file
       BL   @CLOSFL
       JEQ  PRTERR
* No Error (move to R0 later)
       CLR  R3
PRTRT
* If original mode was not window mode,
* wrap all paragraphs in the original mode
       MOV  *R10+,@WINMOD
       JEQ  PRINT5
* Store R1 in case it contains address of error message
       DECT R10
       MOV  R1,*R10
       BL   @WRAPDC
       MOV  *R10+,R1
*       
PRINT5
*
       LIMI 2
* Restore error/non-error to R0
       MOV  R3,R0
*
       MOV  *R10+,R11
       RT
*
* Report Printing error
PRTERR BL   @DSPERR
       MOV  R0,R3
       JMP  PRTRT

*
* Get Left margin
*
* Input:
*   R2 - index of paragraph
* Output:
*   R1 - length of margin
*
GETMGN DECT R10
       MOV  R3,*R10
       DECT R10
       MOV  R4,*R10
       DECT R10
       MOV  R5,*R10
* Let R3 = left margin
* Let R4 = length of MGNLST
* Let R5 = index in MGNLST
       LI   R3,10
       MOV  @MGNLST,R0
       MOV  *R0,R4
       CLR  R5
* No, look at next element
GM1    MOV  R5,R1
       BLWP @ARYADR
* If index out of range, return most recent margin
       JEQ  GM2
* Earlier or same paragraph?
       C    *R1,R2
       JH   GM2
* Yes, save margin
       MOVB @4(R1),R3
       SRL  R3,8
* Look at next MGNLST entry
       INC  R5
       JMP  GM1
* Let R1 = left margin
GM2    MOV  R3,R1
*
       MOV  *R10+,R5
       MOV  *R10+,R4
       MOV  *R10+,R3
       RT

*
* Open file
*
* Input:
*   R2 - Address of PAB Data
* Output:
*   R0, R1, R2 all changed
OPENFL
       DECT R10
       MOV  R11,*R10
* Write PAB data to VDP RAM
       LI   R0,PAB
       BL   @VDPADR
       MOV  R2,R0
       LI   R1,10
       BL   @VDPWRT
* Write device name to VDP RAM
       LI   R2,FLDVAL
       MOV  R2,R0
       BL   @VDPSTR
* Write name length to VDP RAM
       NEG  R2
       A    R0,R2
       SLA  R2,8
*
       MOV  @LNGADR,R0
       BL   @VDPADR
       MOVB R2,@VDPWD
* Store pointer name length
       MOV  @LNGADR,@PNTR
* Remove element from stack early
* so EQ status bit is still set after returning from this method.
       MOV  *R10+,R11
* Open file
       SB   @STATUS,@STATUS
       BLWP @DSRLCL
       DATA 8
*
       RT

*
* Close File
*
CLOSFL
       DECT R10
       MOV  R11,*R10
* Yes, change I/O op-code to close
       LI   R0,PAB
       BL   @VDPADR
       MOVB @CLOSE,@VDPWD
* Remove element from stack early
* so EQ status bit is still set after returning from this method.
       MOV  *R10+,R11
* Close the file
       MOV  @LNGADR,@PNTR
       BLWP @DSRLCL
       DATA 8
*
       RT

MSGNOT TEXT 'Error: File not an EmuWriter document'
       BYTE 0
MSGVER TEXT 'Error: File for higher EmuWriter version'
       BYTE 0
MSG0   TEXT 'Err 0: Bad device name'
       BYTE 0
MSG1   TEXT 'Err 1: Device is write protected'
       BYTE 0
MSG2   TEXT 'Err 2: File type is incorrect'
       BYTE 0
MSG3   TEXT 'Err 3: Illegal operation of peripheral'
       BYTE 0
MSG4   TEXT 'Err 4: Out of space'
       BYTE 0
MSG5   TEXT 'Err 5: Read past end of file'
       BYTE 0
MSG6   TEXT 'Err 6: Device not connected or other Err'
       BYTE 0
MSG7   TEXT 'Err 7: File not found'
       BYTE 0
       EVEN
MSGNUM DATA MSG0,MSG1,MSG2,MSG3
       DATA MSG4,MSG5,MSG6,MSG7
ERRSTS DATA >2000
*
* Write an already determined error
*
WRTERR 
       DECT R10
       MOV  R11,*R10
       JMP  WERR
*
* Report errors on screen
*
DSPERR
       DECT R10
       MOV  R11,*R10
* Read status from VDP RAM
* Let R2 = error number in range 0-7
       LI   R0,PAB+1
       BL   @VDPRAD
       MOVB @VDPRD,R2
       SRL  R2,13
* Let R2 = address of error messsage
       SLA  R2,1
       AI   R2,MSGNUM
       MOV  *R2,R2
* Let R1 = address of error message
* MENULOGIC uses this
WERR   MOV  R2,R1
* Clear error
       SB   @STATUS,@STATUS
* Record Error for MENULOGIC
       SETO R0
* Exit fast.
* Restore stack trace to position when we entered the IO routine.
       MOV  *R10+,R11
       RT

IOEND  AORG

*
* Not really IO routines, but they are on the same menu.
*

FRSHST
       XORG LOADED

YES    TEXT 'Y'
NO     TEXT 'N'
       EVEN

*
* Quit
*
MYBQIT DECT R10
       MOV  R11,*R10
*
       CB   @FLDVAL,@YES
       JNE  CHKNO
       LWPI 0
       BLWP @>0000
*

*
* New Document
*
MYBNEW DECT R10
       MOV  R11,*R10
*
       CB   @FLDVAL,@YES
       JEQ  MYBNY
*
CHKNO  CB   @FLDVAL,@NO
       JEQ  MYBNN
*
       SETO R0
       JMP  MYBNRT
*
MYBNY  BL   @INTDOC
MYBNN  CLR  R0
MYBNRT MOV  *R10+,R11
       RT

FRSHED AORG