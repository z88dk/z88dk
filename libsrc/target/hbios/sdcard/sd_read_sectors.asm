;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Read count sectors through RomWBW.
;	A count of 0 returns 0 and does not call HBIOS.
;

    SECTION code_clib
    SECTION code_arch

    PUBLIC  sd_read_sectors
    PUBLIC  _sd_read_sectors
    PUBLIC  sd_read_sectors_callee
    PUBLIC  _sd_read_sectors_callee

    EXTERN  asm_sd_hbios_read
    EXTERN  sd_hbios_return_hl

sd_read_sectors:
_sd_read_sectors:
    jp      sd_read_sectors_callee

sd_read_sectors_callee:
_sd_read_sectors_callee:
    defc    SD_WANT_COUNT = 1
    INCLUDE "sd_hbios_pop.inc"
    push    bc
    ld      bc, hl
    pop     hl
    call    asm_sd_hbios_read
    jr      z, sd_hb_mrd_ok
    ld      l, a
    ld      h, 0
    jp      sd_hbios_return_hl

sd_hb_mrd_ok:
    ld      hl, 0
    jp      sd_hbios_return_hl
