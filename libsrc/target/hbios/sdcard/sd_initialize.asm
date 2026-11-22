;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Reset one RomWBW disk unit.
;	HL is the unit on entry. HL is 0 on success and -1 on error.
;

    SECTION code_clib
    SECTION code_arch

    PUBLIC  sd_initialize
    PUBLIC  _sd_initialize

    EXTERN  asm_hbios
    EXTERN  sd_hbios_unit

    defc    HB_DIORESET = $11

sd_initialize:
_sd_initialize:
    ld      a, l
    ld      (sd_hbios_unit), a
    ld      c, a
    ld      b, HB_DIORESET
    ld      de, 0
    ld      hl, 0
    call    asm_hbios
    or      a
    jr      z, sd_hb_init_ok
    ld      hl, -1
    or      a
    ret

sd_hb_init_ok:
    xor     a
    ld      hl, 0
    ret
