*
* CPU RAM addresses
*
PNTR   EQU  >8356          PAB length pointer address
STATUS EQU  >837C
INTSTP EQU  >83C2          First four bits enable/disable interrupt steps
USRISR EQU  >83C4          Address defining address of user-defined service routine
REG1CP EQU  >83D4          Address holding a copy of VDP Register 1
VDPRD  EQU  >8800          VDP RAM read data
VDPSTA EQU  >8802          VDP RAM status
VDPWD  EQU  >8C00          VDP RAM write data
VDPWA  EQU  >8C02          VDP RAM write address
*
GRMRD  EQU  >9800
GRMWA  EQU  >9C02

MEMBEG EQU  >2000         First address of text buffer
MEMEND EQU  >F7D8         Address following text buffer
LOADED EQU  MEMEND        Address to load executable code from cache
* Addresses >FFD8 through >FFFF are used for XOP 1 on the TI-99/4A. 
* --- E/A manual 24.2.1.1 (page 400)

*
* GROM addresses
*
GROM_CHAR_PAT   EQU  >06B4

*
* VDP addresses
*
PATTBL EQU  >0             Pattern table
SCRTBL EQU  >800           Screen Image Table
VDPCCH EQU  >C00           address for storing executable code
PABBUF EQU  PATTBL+>400    location to store the contents of a file record for read/write
PAB    EQU  SCRTBL+>3C0    Peripheral Access Block

PATLOW                EQU  PATTBL
PATHGH                EQU  PATTBL+>400
CURSOR_PATTERN_ADR    EQU  >7F*8+1+PATTBL

*
* VDP Register Values
*
REG_SCRTBL   EQU  SCRTBL/>400
REG_PATTBL   EQU  PATTBL/>800