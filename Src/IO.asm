       DEF  IOSTRT,IOEND
       DEF  FRSHST,FRSHED
       DEF  SAVE,LOAD,PRINT,MYBNEW
       DEF  MYBQIT
*
       REF  DSRLCL                                From DSRLNK.asm
       REF  INTDOC,INTPAR                         From MAIN.asm
       REF  VDPADR,VDPRAD,VDPWRT,VDPSTR           From VDP.asm
       REF  VDPSPC,VDPINV                         "
       REF  PARLST,MGNLST                         From VAR.asm
       REF  FLDVAL,WINMOD                         "
       REF  VER2,PGELIN,PREVBM                    "
       REF  PGHGHT,PGWDTH                         "
       REF  CURMNU                                "
       REF  ARYADR,BUFGRW,BUFALC                  From ARRAY.asm
       REF  WRAP,WRAPDC                           From WRAP.asm
       REF  GETMGN                                From UTIL.asm

*
       COPY 'CPUADR.asm'
       COPY 'EQUKEY.asm'
*
       AORG >A000
IOSTRT
       XORG LOADED
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
CARRET BYTE CR
ETX    BYTE 3                               * End of document
*
* This goes at the beginning of each Emu-Writer file
* If the HDR does not match, this is not an Emu-Writer file
* If the first byte of the version is high, the version is incompatible
* If the second byte of the version is high, we can still load the file
FLEHDR TEXT 'DocOfEmuWriter'
FLEVER BYTE 1,2
HDREND
* Format version that introduced margins
VERMGN BYTE 2
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
       MOV  @PARLST,R0
       MOV  *R0,R2
* Let R1 = address of paragraph entry in the paragraph list
       MOV  @PARLST,R0
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
       JEQ  DOCDN
* Let R4 = address within paragraph
* Let R5 = remaining bytes in paragraph
       MOV  *R1,R4
       MOV  *R4,R5
       AI   R4,4
* Write CR to VDP RAM
       MOVB @CARRET,@VDPWD
* Enough bytes to write record?
SAVE3  BL   @SAVCHK
       JEQ  SLERR
       JMP  SAVBYT
* Document complete
DOCDN
* Write ETX character
       MOVB @ETX,@VDPWD
       BL   @SAVCHK
       JEQ  SLERR
* Write Page Width & Page Height to file
       MOVB @PGWDTH,@VDPWD
       BL   @SAVCHK
       JEQ  SLERR
       MOV  @PGHGHT,@VDPWD
       BL   @SAVCHK
       JEQ  SLERR
* Save Margins
* Let R2 = end of Margin Array
* R3 continues to = number of bytes sent to VDP so far
* Let R4 = address in Margin Array
SAVMGN MOV  @MGNLST,R4
       MOV  *R4,R2
       SLA  R2,MGNPWR
       C    *R2+,*R2+
       A    R4,R2
* Save each byte from Margin list sequentially
       MOVB *R4+,@VDPWD
SAVM1  BL   @SAVCHK
       JEQ  SLERR
       MOVB *R4+,@VDPWD
       C    R4,R2
       JL   SAVM1
* Write final record
       BL   @SAVWRT
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

* If byte count has reached 64,
* write Save file record to disk.
*
* Input:
*   R3 = number of bytes already in VDP
* Changed: R0
* Output:
*   R3 = either incremented or 0
SAVCHK DECT R10
       MOV  R11,*R10
* One more byte was written
       INC  R3
* Have we written a full record?
       CI   R3,FIXSAV
       JL   CHKRT
* Yes, write record
       BL   @SAVWRT
       JEQ  CHKERR
* Re-set VDP write position
       LI   R0,PABBUF
       BL   @VDPADR
* Clear byte counter
       CLR  R3
*
CHKRT  MOV  *R10+,R11
       RT
* Return with EQ bit set
CHKERR MOV  *R10+,R11
       S    R0,R0
       RT

* Write one record
SAVWRT MOV  @LNGADR,@PNTR
       BLWP @DSRLCL
       DATA 8
       RT

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
       JEQ  LODERR
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
       MOVB @VDPRD,@VER2
* Since this is a valid file, purge the old file
       BL   @INTDOC
* Let R4 = number of record bytes remaining to read (from this record)
       LI   R4,FIXSAV-HDREND+FLEHDR
* Let R3 = address of first element in paragraph list
       MOV  @PARLST,R3
       C    *R3+,*R3+
* Read one byte from record
LOADBY
       MOVB @VDPRD,R5
* If we ran out of bytes, load another record
       BL   @LODCHK
       JEQ  LODERR
* Is next char a CR?
       CB   R5,@CARRET
       JEQ  NEWPAR
* Reached end of document?
       CB   R5,@ETX
       JEQ  LODMGN
* No, grow the paragraph's allocated block, if necessary.
* Let R0 be the address of the paragraph.
* Let R1 be the length of the paragraph plus one new character
       MOV  *R3,R0
       MOV  *R0,R1
       AI   R1,5
       BLWP @BUFGRW
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
       JMP  LOADBY
NEWPAR
* Start new pararaph
* Let R3 = address of element in paragraph list
       MOV  R4,R5
       BL   @INTPAR
       MOV  R1,R3
       MOV  R5,R4
*
       JMP  LOADBY
* Read margin if VER2 is high Enough
LODMGN CB   @VER2,@VERMGN
       JL   LOADDN
* Read page size and margins
       BL   @REDMGN
       JEQ  LODERR
* Reached End of Document
LOADDN BL   @CLOSFL
       JEQ  LODERR
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

LODERR BL   @DSPERR
       B    @SAVERT

* If byte count has reached 0,
* read Save file record from disk.
*
* Input:
*   R4 = number of bytes to read from VDP
* Changed: R0
* Output:
*   R4 = either decremented or 64
LODCHK DECT R10
       MOV  R11,*R10
* Decrease remaining char to read
       DEC  R4
* Reached end of record?
       JNE  LODC1
* Read record from file
       MOV  @LNGADR,@PNTR
       BLWP @DSRLCL
       DATA 8
       JEQ  LODCER
* Set VDP read position
       LI   R0,PABBUF
       BL   @VDPRAD
* Let R4 = number of record bytes remaining to read
       LI   R4,FIXSAV
*
LODC1  MOV  *R10+,R11 
       RT
* Return with EQ bit set
LODCER MOV  *R10+,R11
       S    R0,R0
       RT

*
* Read Margin from file
REDMGN DECT R10
       MOV  R11,*R10
* Read page width / height bytes
       MOVB @VDPRD,@PGWDTH
       BL   @LODCHK
       JEQ  MGNERR
*
       MOVB @VDPRD,@PGHGHT
       BL   @LODCHK
       JEQ  MGNERR
* Let R5 = number of elements in array
       MOVB @VDPRD,R5
       BL   @LODCHK
       JEQ  MGNERR
       SWPB R5
*
       MOVB @VDPRD,R5
       BL   @LODCHK
       JEQ  MGNERR
       SWPB R5
* Let R7 = number of bytes to read for margins
       MOV  R5,R7
       SLA  R7,MGNPWR
       C    *R7+,*R7+
* Reserve space in buffer
       MOV  R7,R0
       BLWP @BUFALC
       JEQ  MGNDN
       MOV  R0,@MGNLST
* Let R6 = location in Margin List
* Let R7 = end of allocated space
       MOV  R0,R6
       A    R0,R7
* Save element count
       MOV  R5,*R6+
* Read rest of margin data
       MOVB @VDPRD,*R6+
LODM1  BL   @LODCHK
       JEQ  MGNERR
       MOVB @VDPRD,*R6+
       C    R6,R7
       JL   LODM1
*
MGNDN  MOV  *R10+,R11
       RT
* Return with EQ stats bit checked
MGNERR S    R0,R0
       MOV  *R10+,R11
       RT      

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
       JEQ  PRINT1
       CLR  @WINMOD
       BL   @WRAPDC
PRINT1
* Open File
       LI   R2,PDATA
       BL   @OPENFL
       JEQ  PRTERR
* Change I/O op-code to write
       LI   R0,PAB
       BL   @VDPADR
       MOVB @WRITE,@VDPWD
* Set the number of remaining lines on
* current page.
       CLR  @PGELIN
* Let R2 = index of current paragraph
       CLR  R2
* Let R1 = address of paragraph's
* entry in the paragraph list
       MOV  @PARLST,R0
PRINT2 MOV  R2,R1
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
PRINT3
* If we are between pages, print top/bottom
* margins.
* Let PGELIN = number of printable lines
* in a page.
       BL   @PRTEMP
       JEQ  PRTERR       
* Let R8 = line length
       BL   @LLEN
* Write left white-space to VDP RAM
       BL   @PRTMG
* Write record (following left margin) to VDP RAM
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
* Decrease PGELIN as we are closer to page end.
       DEC  @PGELIN
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
* Increase R7 to next line.
       INC  R7
* Loop to write next line
       JMP  PRINT3
PRINT4
* Last paragraph of document?
       INC  R2
       MOV  @PARLST,R0
       C    R2,*R0
       JL   PRINT2
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
* If we are between pages, print several
* empty lines for the top/bottom margin.
* Let PGELIN = number of printable lines
* in a page.
*
* Input:
*   R2 = paragraph index
*   R5 = address of wrap list
*   R6 = address within paragraph
*   R7 = line in paragraph (0-based)
*
PRTEMP DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R3,*R10
       DECT R10
       MOV  R4,*R10
* Let R4 (high byte) = number of empty lines to print
       CLR  R4
* Is this the end of the page?
       MOV  @PGELIN,R0
       JEQ  TBMGN
* No, is there exactly one line left on page?
       CI   R0,1
       JNE  PERT
* Yes, are there either exactly two lines 
* left in this paragrah, or is this the 
* beginning of a multi-line paragraph?
       MOV  *R5,R0
       INC  R0
       S    R7,R0
       CI   R0,2
       JEQ  WIDOW
*
       MOV  R7,R7
       JNE  PERT
       MOV  *R5,R0
       JEQ  PERT
* Yes, we're going to print the margins early to avoid
* an orphan or widow. Print an extra margin line, too.
WIDOW  AI   R4,1*>100
* Go through process to print empty margin lines.
* R4 (high byte) should currently contain either 0 or 1.
TBMGN
* Yes, let R3 = address of margin entry
       MOV  R2,R0
       BL   @GETMGN
       MOV  R0,R3
       JNE  PE1
* There is no margin entry for this paragraph.
* Use defaults.
       LI   R3,DMGENT-TOP
PE1
* Add size of current page's top margin to R4
       AB   @TOP(R3),R4
* Is this the beginning of the document?
       MOV  R2,R2
       JEQ  PE2
* No, Add size of previous page's bottom margin to R4
       AB   @PREVBM,R4
* Store this page's bottom margin size
* for use the next time we print margins.
PE2    MOVB @BOTTOM(R3),@PREVBM
* Let R4 = number of empty lines to print
       SRL  R4,8
       JEQ  PERT
* In PAB, specify record length of zero.
       LI   R0,PAB+5
       BL   @VDPADR
       LI   R0,1
       MOVB R0,@VDPWD
* Write same number of records specified by R4
PE3    MOV  @LNGADR,@PNTR
       BLWP @DSRLCL
       DATA 8
       JEQ  PEERR
*
       DEC  R4
       JNE  PE3
* Let @PGELIN = number of printable lines on a page
       MOVB @PGHGHT,R0
       SB   @TOP(R3),R0
       SB   @BOTTOM(R3),R0
       SRL  R0,8
       MOV  R0,@PGELIN
*
* Return, without reporting error.
PERT   MOV  *R10+,R4
       MOV  *R10+,R3
       MOV  *R10+,R11
       RT
*
* Return, reporting error through EQ bit.
PEERR  MOV  *R10+,R4
       MOV  *R10+,R3
       MOV  *R10+,R11
       S    R0,R0
       RT
*
DMGENT DATA >0606

*
* Get line length
*
* Input:
*   R4, R5, R7
* Output:
*   R8
*
LLEN
* Is the wrap list empty, and thus is this
* a one line paragraph?
       MOV  *R5,*R5
       JNE  LLEN1
* Yes, set line length to match paragraph
* length
       MOV  *R4,R8
       RT
*
LLEN1  MOV  R7,R7
       JNE  LLEN2
* Set length for first line in paragraph
       MOV  @4(R5),R8
       RT
*
LLEN2  C    R7,*R5
       JHE  LLEN3
* Set length for middle lines in paragraph
       MOV  R5,R0
       MOV  R7,R1
       BLWP @ARYADR
*
       CLR  R8
       S    @-2(R1),R8
       A    *R1,R8
       RT
* Set length for last line in paragraph
LLEN3  MOV  R5,R0
       MOV  R7,R1
       DEC  R1
       BLWP @ARYADR
*
       CLR  R8
       S    *R1,R8
       A    *R4,R8
*
       RT

*
* Write enough spaces to the buffer
* for left margin and indent
*
* Input:
*      R2 = current paragraph
*      R7 = current line in paragraph
*      R8 = size of record
* Output:
*      R8 = increased according to left margin
*
PRTMG  DECT R10
       MOV  R11,*R10
* Let R1 = address of MGNLST entry
       MOV  R2,R0
       BL   @GETMGN
       MOV  R0,R1
* Let R1 = either left margin length
*          or left margin + first line indent
       JEQ  PRTMG2
       MOVB @LEFT(R1),R0
       MOVB @INDENT(R1),R1
       SRL  R0,8
       SRA  R1,8
       MOV  R7,R7
       JEQ  PRTMG0
       NEG  R1
PRTMG0 MOV  R1,R1
       JLT  PRTMG1
       A    R1,R0
PRTMG1 MOV  R0,R1
       JMP  PRTMG3
PRTMG2 LI   R1,DFLTMG
PRTMG3
* Increase record length by size of left margin
* Truncate the record length if it is greater than 254
       A    R1,R8
       CI   R8,MAXPRT
       JLE  PRTMG4
       LI   R8,MAXPRT
PRTMG4
* Write spaces to VDP RAM,
* according to number in R1
       LI   R0,PABBUF
       BL   @VDPADR
       BL   @VDPSPC
*
       MOV  *R10+,R11
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
MSGYN  TEXT 'Press only "Y" or "N"'
       BYTE 0
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
       LI   R1,MSGYN
       JMP  MYBNRT
*
MYBNY  BL   @INTDOC
MYBNN  CLR  R0
MYBNRT MOV  *R10+,R11
       RT

FRSHED AORG