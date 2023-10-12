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
* If key pressed, go to form
NXTFRM EQU  2
* If key pressed, go to routine
NXTRTN EQU  4
* If key pressed, load routine from cache and branch to it
NXTCCH EQU  6

* When Menu header contains 0 in the
* field address, skip field logic.
NOFLDS EQU  0

DFLTPG EQU  80        Default Page Width
SCRNWD EQU  40

*
* Array lengths
MGNLNG EQU  8
MGNPWR EQU  3

*
* Indexes in margin entry
INDENT EQU  3
LEFT   EQU  4
PWIDTH EQU  5         Paragraph width