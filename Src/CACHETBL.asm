* Like VAR.asm, the data in this file
* can change and must never be part of
* a cartridge ROM.
* (That being said if we ever move the
* word processor to a cartridge, we'll
* probably skip from VDP caching to 
* cartridge banking.)
*

       DEF  CACHES
       DEF  CCHMHM
*
       REF  PRINT,LOAD,SAVE                        From IO.asm
       REF  MYBNEW,MYBQIT                          "
       REF  MNUHOM                                 From MENU.asm

*
* Cache Table
*
* Word 1: Address in VDP RAM to load from
* Word 2: Address in loaded code in CPU to branch to
*
* At compile-time, Word #1 is incorrect,
* but STORCH is supposed to fix it for us at startup.
* For now each routine in the same cache needs to have
* the same (meaningless) number.
*
CACHES
* Menus
CCHMHM DATA 4,MNUHOM
       DATA -1