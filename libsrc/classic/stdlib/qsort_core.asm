
; Classic qsort shares the newlib sort engine.  Pull it into the classic
; library here (compiled with __CLASSIC, so the cores reach the comparator via
; ix/l_jpix -- see qsort.asm).  Historically classic had its own self-contained
; qsort_sccz80; this replaces it with the shared, tunable newlib core.

    SECTION code_clib

; ix-based closure => Z80-family only (matches qsort.asm / _qsort.asm).
IF !__CPU_INTEL__ && !__CPU_GBZ80__

    PUBLIC  asm_qsort

    defc    __CLIB_OPT_SORT       = 2   ; quicksort
    defc    __CLIB_OPT_SORT_QSORT = 0   ; middle pivot, no insertion tail, no dispersal

    INCLUDE "../../stdlib/z80/sort/__sort_parameters.asm"
    INCLUDE "../../stdlib/z80/sort/asm_quicksort.asm"

    defc    asm_qsort = asm_quicksort

    ; ... and the shared bsearch core (see bsearch.asm / _bsearch.asm)
    INCLUDE "../../stdlib/z80/asm_bsearch.asm"

ENDIF
