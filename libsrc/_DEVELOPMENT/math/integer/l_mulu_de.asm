
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_mulu_de

    ; REPLICATION for Z80 of:
    ; Z180 MLT DE and Z80-ZXN MUL DE
    ; compute:  de = d * e

IF __IO_LUT_MODULE_AVAILABLE

l_mulu_de:

    push bc                     ; 11 preserve BC

    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    
    ld b,d                      ; 4  operand Y from D
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D

    pop bc                      ; 10 restore BC
    ret                         ; 10

ELSE

IF __CLIB_OPT_IMATH <= 50

    EXTERN l_small_mulu_de
    defc l_mulu_de = l_small_mulu_de

ENDIF

IF __CLIB_OPT_IMATH > 50

    EXTERN l_fast_mulu_de
    defc l_mulu_de = l_fast_mulu_de

ENDIF

ENDIF
