       DEF  CACHES
       DEF  CCHPRT,CCHLOD,CCHSAV
       DEF  CCHNEW,CCHQIT
       DEF  CCHMGN
       DEF  CCHMHM,CCHMFL,CCHMTT,CCHMHK
       DEF  CCHFSV,CCHFLD,CCHFPR,CCHFNW
       DEF  CCHFQT,CCHFMG
*
       REF  PRINT,LOAD,SAVE                        From IO.asm
       REF  MYBNEW,MYBQIT                          "
       REF  EDTMGN                                 From EDTMGN.asm
       REF  FRMSAV,FRMLOD,FRMPRT,FRMNEW,FRMQIT     From FORM.asm
       REF  FRMMGN                                 "
       REF  MNUHOM,MNUFL,MNUTTL,MNUHK              From MENU.asm
       REF  MNUSTR,MNUEND                          "

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
* Menus
CCHMHM DATA 3,MNUHOM
CCHMFL DATA 3,MNUFL
CCHMTT DATA 3,MNUTTL
CCHMHK DATA 3,MNUHK
* Forms
CCHFSV DATA 4,FRMSAV
CCHFLD DATA 4,FRMLOD
CCHFPR DATA 4,FRMPRT
CCHFNW DATA 4,FRMNEW
CCHFQT DATA 4,FRMQIT
CCHFMG DATA 4,FRMMGN
       DATA -1