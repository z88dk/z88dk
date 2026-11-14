;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Read one sector through RomWBW.
;	C return is 0 or an error code.
;

    SECTION code_clib
    SECTION code_arch

    PUBLIC  sd_read_sector
    PUBLIC  _sd_read_sector
    PUBLIC  sd_read_sector_callee
    PUBLIC  _sd_read_sector_callee
    PUBLIC  asm_sd_hbios_read

    EXTERN  asm_sd_hbios_transfer
    EXTERN  sd_hbios_count
    EXTERN  sd_hbios_return_hl

    defc    HB_DIOREAD = $13
    defc    SD_WANT_COUNT = 0

sd_read_sector:
_sd_read_sector:
    ld      hl, 1
    ld      (sd_hbios_count), hl
    INCLUDE "sd_hbios_keep.inc"
    push    bc
    ld      bc, hl
    pop     hl
    call    asm_sd_hbios_read
    jr      z, sd_hb_rd_keep_ok
    ld      l, a
    ld      h, 0
    jp      sd_hbios_return_hl

sd_hb_rd_keep_ok:
    ld      hl, 0
    jp      sd_hbios_return_hl

sd_read_sector_callee:
_sd_read_sector_callee:
    ld      hl, 1
    ld      (sd_hbios_count), hl
    INCLUDE "sd_hbios_pop.inc"
    push    bc
    ld      bc, hl
    pop     hl
    call    asm_sd_hbios_read
    jr      z, sd_hb_rd_ok
    ld      l, a
    ld      h, 0
    jp      sd_hbios_return_hl

sd_hb_rd_ok:
    ld      hl, 0
    jp      sd_hbios_return_hl

asm_sd_hbios_read:
    ld      a, HB_DIOREAD
    jp      asm_sd_hbios_transfer
