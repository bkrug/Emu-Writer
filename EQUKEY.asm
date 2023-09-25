TABKEY EQU  >01
DELKEY EQU  >03
INSKEY EQU  >04
CLRKEY EQU  >07                 * TODO: Isn't this really the erase key?
BCKKEY EQU  >08
FWDKEY EQU  >09
DWNKEY EQU  >0A
UPPKEY EQU  >0B
ENTER  EQU  >0D
ESCKEY EQU  >0F
SPCBAR EQU  >20
CTRLY  EQU  >99
FCTN0  EQU  >BC

LF     EQU  >0A
CR     EQU  >0D

* If key pressed, go to menu
NXTMNU EQU  0
* If key pressed, go to routine
NXTRTN EQU  2
* If key pressed, load routine from cache and branch to it
NXTCCH EQU  4

* When Menu header contains 0 in the
* field address, skip field logic.
NOFLDS EQU  0