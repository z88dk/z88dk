;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;	Modified November 2026 feilipu.
;
;	Mini-FAT names for one RomWBW disk unit.
;	L = 0 selects the unit. Carry is set when the transfer is ready.
;	The unit comes from sd_initialize. HL is already 512 bytes higher.
;

    SECTION code_clib
    SECTION code_arch

    PUBLIC  asm_disk_initialize
    PUBLIC  ide_read_sector
    PUBLIC  ide_write_sector

    EXTERN  sd_initialize
    EXTERN  asm_sd_hbios_read
    EXTERN  asm_sd_hbios_write
    EXTERN  sd_hbios_count

asm_disk_initialize:
    ld      a, l
    or      a
    jr      z, sd_hb_mf_init
    ret

sd_hb_mf_init:
    ld      h, 0
    call    sd_initialize
    ret     nz
    scf
    ret

ide_read_sector:
    ld      hl, 1                       ; Z180: one word store
    ld      (sd_hbios_count), hl
    call    asm_sd_hbios_read
    ret     nz
    scf
    ret

ide_write_sector:
    ld      hl, 1                       ; Z180: one word store
    ld      (sd_hbios_count), hl
    call    asm_sd_hbios_write
    ret     nz
    scf
    ret
