* Key codes
TABKEY EQU  >01
DELKEY EQU  >03
INSKEY EQU  >04
FCTN8  EQU  >06
CLRKEY EQU  >07                 * TODO: Isn't this really the erase key?
BCKKEY EQU  >08
FWDKEY EQU  >09
DWNKEY EQU  >0A
UPPKEY EQU  >0B
ENTER  EQU  >0D
ESCKEY EQU  >0F
SPCBAR EQU  >20
CTRLY  EQU  >99
CTRL8  EQU  >9E
FCTN0  EQU  >BC

VRTCHR EQU  >01
WINCHR EQU  >02
LF     EQU  >0A
CR     EQU  >0D
INV    EQU  >80

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

DFLTHT EQU  66        Default Page Height
DFLTPG EQU  80        Default Page Width
DFLTMG EQU  10        Default Left Margin
*
SCRNWD EQU  40        Width of screen in characters
TXTHGT EQU  22        Height of portion of screen, not including header
HDRHGT EQU  2         Number of rows in the screen header

*
* Array lengths
MGNLNG EQU  8
MGNPWR EQU  3

MAXIDT EQU  20        Max indent in vertical mode

*
* Indexes in margin entry
INDENT EQU  3
LEFT   EQU  4
RIGHT  EQU  5
TOP    EQU  6
BOTTOM EQU  7

*
* Locations in FLDVAL for different margin fields
FPHGHT EQU 3
FLEFT  EQU 6
FRIGHT EQU 9
FINDNT EQU 12
FHANG  EQU 15
FTOP   EQU 16
FBOT   EQU 19