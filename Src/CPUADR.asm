LOADED EQU  >3800          Address to load executable code from cache
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
