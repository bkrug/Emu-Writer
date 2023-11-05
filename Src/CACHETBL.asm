* Like VAR.asm, the data in this file
* can change and must never be part of
* a cartridge ROM.
* (That being said if we ever move the
* word processor to a cartridge, we'll
* probably skip from VDP caching to 
* cartridge banking.)
*

       DEF  CACHES
       DEF  CCHPRT,CCHLOD,CCHSAV
       DEF  CCHNEW,CCHQIT
       DEF  CCHMGN
       DEF  CCHMHM
       DEF  CCHIPT
*
       REF  PRINT,LOAD,SAVE                        From IO.asm
       REF  MYBNEW,MYBQIT                          "
       REF  EDTMGN                                 From EDTMGN.asm
       REF  MNUHOM                                 From MENU.asm
       REF  INPUT                                  From INPUT.asm

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
CCHPRT DATA 0,PRINT
CCHLOD DATA 0,LOAD
CCHSAV DATA 0,SAVE
CCHNEW DATA 1,MYBNEW
CCHQIT DATA 1,MYBQIT
CCHMGN DATA 2,EDTMGN
CCHIPT DATA 3,INPUT
* Menus
CCHMHM DATA 4,MNUHOM
       DATA -1