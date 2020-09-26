       DEF  LTEST
       REF  LOADER,VMBW,VSBW

* Use this program in order to load all
* of the files needed to test SCRNWRT.
* It will execute the SCRNWRT tests
* automatically.

FILES  DATA FILEN1,FILEN2,FILEN3,FILEN4
       DATA FILEN5
	   DATA LSTEND
PDATAE
FILEN1 TEXT 'DSK2.TESTFRAM.obj'
FILEN2 TEXT 'DSK2.DISPTST.obj'
FILEN3 TEXT 'DSK2.DISP.obj'
FILEN4 TEXT 'DSK2.VAR.obj'
FILEN5 TEXT 'DSK2.CONST.obj'
LSTEND TEXT ' '
       EVEN
	   
       COPY "DSK2.LOADTSTS.asm"