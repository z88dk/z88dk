;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Write one sector through RomWBW.
;	C return is 0 or an error code.
;

    SECTION code_clib
    SECTION code_arch

    PUBLIC  sd_write_sector
    PUBLIC  _sd_write_sector
    PUBLIC  sd_write_sector_callee
    PUBLIC  _sd_write_sector_callee
    PUBLIC  asm_sd_hbios_write

    EXTERN  asm_sd_hbios_transfer
    EXTERN  sd_hbios_count
    EXTERN  sd_hbios_return_hl

    defc    HB_DIOWRITE = $14

sd_write_sector:
_sd_write_sector:
    jp      sd_write_sector_callee

sd_write_sector_callee:
_sd_write_sector_callee:
    ld      hl, 1
    ld      (sd_hbios_count), hl
    defc    SD_WANT_COUNT = 0
    INCLUDE "sd_hbios_pop.inc"
    push    bc
    ld      bc, hl
    pop     hl
    call    asm_sd_hbios_write
    jr      z, sd_hb_wr_ok
    ld      l, a
    ld      h, 0
    jp      sd_hbios_return_hl

sd_hb_wr_ok:
    ld      hl, 0
    jp      sd_hbios_return_hl

asm_sd_hbios_write:
    ld      a, HB_DIOWRITE
    jp      asm_sd_hbios_transfer
