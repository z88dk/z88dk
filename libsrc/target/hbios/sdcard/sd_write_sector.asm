;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Write one sector through RomWBW.
;	C return is 0 or an error code.
;	asm_sd_hbios_write stores a count of 1 and keeps BC, DE, and HL.
;	BCDE is the LBA, E low. HL is the buffer.
;	asm_sd_hbios_write_n uses the count already stored.
;

    SECTION code_clib
    SECTION code_arch

    PUBLIC  sd_write_sector
    PUBLIC  _sd_write_sector
    PUBLIC  sd_write_sector_callee
    PUBLIC  _sd_write_sector_callee
    PUBLIC  asm_sd_hbios_write
    PUBLIC  asm_sd_hbios_write_n

    EXTERN  asm_sd_hbios_transfer
    EXTERN  sd_hbios_count
    EXTERN  sd_hbios_return_hl

    defc    HB_DIOWRITE = $14
    defc    SD_WANT_COUNT = 0

sd_write_sector:
_sd_write_sector:
    INCLUDE "sd_hbios_keep.inc"
    push    bc
    ld      bc, hl
    pop     hl
    call    asm_sd_hbios_write
    jr      z, sd_hb_wr_keep_ok
    ld      l, a
    ld      h, 0
    jp      sd_hbios_return_hl

sd_hb_wr_keep_ok:
    ld      hl, 0
    jp      sd_hbios_return_hl

sd_write_sector_callee:
_sd_write_sector_callee:
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
    push    hl
    ld      hl, 1                       ; Z180: one word store. HL is the buffer.
    ld      (sd_hbios_count), hl
    pop     hl

asm_sd_hbios_write_n:
    ld      a, HB_DIOWRITE
    jp      asm_sd_hbios_transfer
