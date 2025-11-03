*
* Key codes
*
FCTN1  EQU  >03
FCTN2  EQU  >04
FCTN3  EQU  >07
FCTN4  EQU  >02
FCTN5  EQU  >0E
FCTN6  EQU  >0C
FCTN7  EQU  >01
FCTN8  EQU  >06
FCTN9  EQU  >0F
FCTN0  EQU  >BC
FCTNL  EQU  >C2
FCTNSM EQU  >BD        * FCTN+Semicolon
FCTNS  EQU  >08
FCTND  EQU  >09
FCTNX  EQU  >0A
FCTNE  EQU  >0B

CTRLL  EQU  >8C
CTRLY  EQU  >99
CTRLZ  EQU  >9A
CTRLSM EQU  >9C        * CTRL+Semicolon
CTRL8  EQU  >9E

SPCBAR EQU  >20

*
* Control codes
*
VRTCHR EQU  >01
WINCHR EQU  >02
LF     EQU  >0A
CR     EQU  >0D
INV    EQU  >80

*
* Alias keys
*
DELKEY EQU  FCTN1
INSKEY EQU  FCTN2
ERSKEY EQU  FCTN3
TABKEY EQU  FCTN7
ESCKEY EQU  FCTN9
BCKKEY EQU  FCTNS
FWDKEY EQU  FCTND
DWNKEY EQU  FCTNX
UPPKEY EQU  FCTNE
UNDKEY EQU  CTRLZ
RDOKEY EQU  CTRLY
ENTER  EQU  CR

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
EMPPAR EQU  4         The number of bytes used by an empty paragrah

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

* Document status codes
STATYP EQU  >1              * Text Typed
STAENT EQU  >2              * Enter Pressed
STADCR EQU  >4              * Deleted Carriage Return
STAPAR EQU  >8              * Paragraph Line Count Changed
STAWIN EQU  >10             * Window Moved
STADSH EQU  >20             * Redisplay dashboard line (margins, fonts)
STAARW EQU  >40             * Arrow Key Pressed
ERAMEM EQU  >8000           * Insufficient Memory Error

* Paragraph Locations
PARAGRAPH_WRAPLIST_OFFSET   EQU  >0002
PARAGRAPH_TEXT_OFFSET       EQU  >0004

* Undo Types
UNDO_INS    EQU  >0002      * Insert text
UNDO_OVR    EQU  >0004      * Overwrite text
UNDO_DEL    EQU  >0006      * Delete right-of-cursor

*
UNDO_ANY_PARA  EQU  >0002      * Location in undo-action of paragraph index
UNDO_ANY_CHAR  EQU  >0004      * Location in undo-action of character index
UNDO_ANY_LEN   EQU  >0006      * Location in undo-action of string-length
UNDO_PAYLOAD   EQU  >0008      * Location in undo-action of deleted text

*
MAX_UNDO_LIST_LENGTH   EQU  16
MAX_UNDO_PAYLOAD       EQU  255