       DEF  LTEST
       REF  LOADER,VMBW

* Use this program in order to load all
* of the files needed to test SCRNWRT.
* It will execute the SCRNWRT tests
* automatically.

PABBUF EQU  >1000
PAB    EQU  >F80
STATUS EQU  >837C
PNTR   EQU  >8356
* Byte 0 = Open
* Byte 1 = Status/Display/Fixed
* Byte 4 = max record length 80
* Byte 5 = actual length to write
* Byte 6-7 are not relevant
* Byte 8 = status o file
* Byte 9 = file name length
PDATA1 DATA >0004,PABBUF,>5000,>0000,>000E
FILEN1 TEXT 'DSK2.SCRNTST.O '
       BSS  7
PDATA2 DATA >0004,PABBUF,>5000,>0000,>000F
FILEN2 TEXT 'DSK2.TESTUTIL.obj'
       BSS  7
PDATA3 DATA >0004,PABBUF,>5000,>0000,>000E
FILEN3 TEXT 'DSK2.SCRNWRT.O '
       BSS  7
PDATA4 DATA >0004,PABBUF,>5000,>0000,>000D
FILEN4 TEXT 'DSK2.MEMBUF.O  '
       BSS  7
PDATA5 DATA >0004,PABBUF,>5000,>0000,>000A
FILEN5 TEXT 'DSK2.VAR.O     '
       BSS  7
PDATA6 DATA >0004,PABBUF,>5000,>0000,>000C
FILEN6 TEXT 'DSK2.CONST.O   '
       BSS  7
PDATAE

LDMSG  TEXT 'Loading DSK2.SCRNTST.O,         '
       TEXT 'DSK2.TESTUTIL.O, DSK2.SCRNWRT.O,'
       TEXT 'DSK2.MEMBUF.O                   '

LTEST  LI   R0,0
       LI   R1,LDMSG
       LI   R2,>60
       BLWP @VMBW
* Write PAB to VDP
       LI   R0,PAB
       LI   R1,PDATA1
       LI   R2,>20
LTEST1 BLWP @VMBW
       LI   R6,PAB+9
       MOV  R6,@PNTR
* Load the assembled code
       BLWP @LOADER
* If the Eqaul bit is set, report error
       JEQ  RPTERR
* Update R1 so we can load the next file
       A    R2,R1
       CI   R1,PDATAE
       JL   LTEST1
* Enter the test program
       B    @RUNTST
*
*
ERRMSG TEXT 'LOADER routine error: '
ERRCD  BSS  1
ERRCD1 EVEN
*
RPTERR AI   R0,>3000
       MOVB R0,@ERRCD
       LI   R0,>40
       LI   R1,ERRMSG
       LI   R2,ERRCD1-ERRMSG
       BLWP @VMBW
JMP    JMP  JMP
*
* First loaded program will be found here:
RUNTST
       END