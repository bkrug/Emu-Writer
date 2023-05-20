DELKEY EQU  >03
INSKEY EQU  >04
CLRKEY EQU  >07                 * Isn't this really the erase key?
BCKKEY EQU  >08
FWDKEY EQU  >09
UPPKEY EQU  >0B
DWNKEY EQU  >0A
ENTER  EQU  >0D
ESCKEY EQU  >0F
FCTN0  EQU  >BC

* If key pressed, go to menu
NXTMNU EQU  0
* If key pressed, go to routine
NXTRTN EQU  2

* When Menu header contains 0 in the
* field address, skip field logic.
NOFLDS EQU  0