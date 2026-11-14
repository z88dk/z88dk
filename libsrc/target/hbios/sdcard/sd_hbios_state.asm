;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	RomWBW HBIOS disk state for one unit.
;	The C return address stays in sd_hbios_ret.
;

    SECTION code_clib
    SECTION code_arch

    PUBLIC  sd_hbios_return_hl

    EXTERN  sd_hbios_ret

sd_hbios_return_hl:
    push    hl
    ld      hl, (sd_hbios_ret)
    ld      de, hl
    pop     hl
    push    de
    ret


    SECTION bss_clib

    PUBLIC  sd_hbios_unit
    PUBLIC  sd_hbios_bank
    PUBLIC  sd_hbios_count
    PUBLIC  sd_hbios_ret
    PUBLIC  sd_hbios_fn

sd_hbios_count:
    defs    2

sd_hbios_ret:
    defs    2

sd_hbios_unit:
    defs    1

sd_hbios_bank:
    defs    1

sd_hbios_fn:
    defs    1
