;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
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
    ld      a, 1
    ld      (sd_hbios_count), a
    xor     a
    ld      (sd_hbios_count+1), a
    call    asm_sd_hbios_read
    ret     nz
    scf
    ret

ide_write_sector:
    ld      a, 1
    ld      (sd_hbios_count), a
    xor     a
    ld      (sd_hbios_count+1), a
    call    asm_sd_hbios_write
    ret     nz
    scf
    ret
