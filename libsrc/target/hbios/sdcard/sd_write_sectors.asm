;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Write count sectors through RomWBW.
;	A count of 0 returns 0 and does not call HBIOS.
;

    SECTION code_clib
    SECTION code_arch

    PUBLIC  sd_write_sectors
    PUBLIC  _sd_write_sectors
    PUBLIC  sd_write_sectors_callee
    PUBLIC  _sd_write_sectors_callee

    EXTERN  asm_sd_hbios_write
    EXTERN  sd_hbios_return_hl

    defc    SD_WANT_COUNT = 1

sd_write_sectors:
_sd_write_sectors:
    INCLUDE "sd_hbios_keep.inc"
    push    bc
    ld      bc, hl
    pop     hl
    call    asm_sd_hbios_write
    jr      z, sd_hb_mwr_keep_ok
    ld      l, a
    ld      h, 0
    jp      sd_hbios_return_hl

sd_hb_mwr_keep_ok:
    ld      hl, 0
    jp      sd_hbios_return_hl

sd_write_sectors_callee:
_sd_write_sectors_callee:
    INCLUDE "sd_hbios_pop.inc"
    push    bc
    ld      bc, hl
    pop     hl
    call    asm_sd_hbios_write
    jr      z, sd_hb_mwr_ok
    ld      l, a
    ld      h, 0
    jp      sd_hbios_return_hl

sd_hb_mwr_ok:
    ld      hl, 0
    jp      sd_hbios_return_hl
