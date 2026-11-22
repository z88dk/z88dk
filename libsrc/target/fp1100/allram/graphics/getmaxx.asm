; Skeleton for the all-RAM overlay (doc/target/fp1100/subcpu-plan.md): replaces the ROM-based stock module of the same name.

    MODULE  fp1100_allram_getmaxx
    SECTION code_clib
    PUBLIC  getmaxx
    PUBLIC  _getmaxx

getmaxx:
_getmaxx:
    ld      hl, 319
    ret
