       DEF  LTEST
       REF  LOADER,VMBW,VSBW

* Use this program in order to load all
* of the files needed to test SCRNWRT.
* It will execute the SCRNWRT tests
* automatically.

FILES  DATA FILEN1,FILEN2,FILEN3,FILEN4
       DATA FILEN5,FILEN6,FILEN7,FILEN8
       DATA LSTEND
PDATAE
FILEN1 TEXT 'DSK2.INPTTST.obj'
FILEN2 TEXT 'DSK2.TESTUTIL.obj'
FILEN3 TEXT 'DSK2.INPUT.obj'
FILEN4 TEXT 'DSK2.MEMBUF.obj'
FILEN5 TEXT 'DSK2.VAR.obj'
FILEN6 TEXT 'DSK2.CONST.obj'
FILEN7 TEXT 'DSK2.ARRAY.obj'
FILEN8 TEXT 'DSK2.WRAP.obj'
LSTEND TEXT ' '
       EVEN

       COPY "DSK2.LOADTSTS.asm"