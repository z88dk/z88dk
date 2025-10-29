
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_mulu_de

    ; REPLICATION for Z80 of:
    ; Z180 MLT DE and Z80-ZXN MUL DE
    ; compute:  de = d * e

IF __CLIB_OPT_IMATH <= 50

    EXTERN l_small_mulu_de
    defc l_mulu_de = l_small_mulu_de

ENDIF

IF __CLIB_OPT_IMATH > 50

    EXTERN l_fast_mulu_de
    defc l_mulu_de = l_fast_mulu_de

ENDIF
