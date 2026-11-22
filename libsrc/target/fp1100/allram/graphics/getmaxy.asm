; Skeleton for the all-RAM overlay (doc/target/fp1100/subcpu-plan.md): replaces the ROM-based stock module of the same name.

    MODULE  fp1100_allram_getmaxy
    SECTION code_clib
    PUBLIC  getmaxy
    PUBLIC  _getmaxy

getmaxy:
_getmaxy:
    ld      hl, 199
    ret
