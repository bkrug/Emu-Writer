* First address of text buffer
MEMBEG EQU  >2000
* Address following text buffer
MEMEND EQU  >F7D8

* Addresses >FFD8 through >FFFF are used for XOP 1 on the TI-99/4A. 
* --- E/A manual 24.2.1.1 (page 400)

LOADED EQU  MEMEND         Address to load executable code from cache
VDPWA  EQU  >8C02          VDP RAM write address
VDPRD  EQU  >8800          VDP RAM read data
VDPWD  EQU  >8C00          VDP RAM write data
VDPSTA EQU  >8802          VDP RAM status
PNTR   EQU  >8356          PAB length pointer address
STATUS EQU  >837C
INTSTP EQU  >83C2          First four bits enable/disable interrupt steps
USRISR EQU  >83C4          Address defining address of user-defined service routine
REG1CP EQU  >83D4          Address holding a copy of VDP Register 1

*
* VDP addresses
*
SCRTBL EQU  >0             Screen Image Table
PATTBL EQU  >800           Pattern table
VDPCCH EQU  >1000          address for storing executable code
PABBUF EQU  PATTBL+>400    location to store the contents of a file record for read/write
PAB    EQU  SCRTBL+>3C0    Peripheral Access Block

PATLOW EQU  PATTBL
PATHGH EQU  PATTBL+>400

CURSOR_PATTERN_ADR    EQU  >7F*8+1+PATTBL
