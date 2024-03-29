       DEF  KEYDVC,KEYPRS
       DEF  KEYINT
*
       REF  SCAN
       REF  TIMER,PREVKY
       REF  KEYSTR,KEYEND,KEYWRT,KEYRD
       REF  NOKEY
       REF  SCANRT

* Keyboard device to be checked
KEYDVC EQU  >8374
* Key pressed
KEYPRS EQU  >8375
* Key status
KEYSTS EQU  >837C

* The delay before initial repeat
WAIT1  DATA >18
* The delay before additional repeats
WAIT2  DATA >4

* Use an interupt to record key presses
* so that if the computer is working on
* a long process the keys will still be
* recorded.
KEYINT
* Call console Key Scan routine
       MOV  R11,@SCANRT     save GPL R11
       BL   @SCAN           call keyboard scanning routine
       MOV  @SCANRT,R11     restore GPL R11
*
       CB   @KEYPRS,@NOKEY
       JNE  KEYDWN
       MOVB @KEYPRS,@PREVKY
       RT
* A key has been pressed.
KEYDWN CB   @KEYPRS,@PREVKY
       JNE  KEYNEW
       DEC  @TIMER
       JH   KEYRTN
* The Key is being repeated
KEYAGN MOV  @WAIT2,@TIMER
       JMP  KEYCPY
* The Key is new
KEYNEW MOV  @WAIT1,@TIMER
       MOVB @KEYPRS,@PREVKY
* Copy the key to the key buffer
* Auto increment the buffer position
KEYCPY MOV  @KEYWRT,R0
       MOVB @KEYPRS,*R0+
* If the next position is past the
* buffer end, move to the buffer start
       CI   R0,KEYEND
       JL   KEY1
       LI   R0,KEYSTR
* Update KEYWRT with the new buffer
* position, unless this would cause
* KEYWRT to equal KEYRD
KEY1   C    R0,@KEYRD
       JEQ  KEYRTN
       MOV  R0,@KEYWRT
*
KEYRTN RT
       END