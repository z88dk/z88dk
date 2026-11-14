;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	Mini-FAT names for one SPI slot.
;	L = 0 selects the slot. Carry is set when the transfer is ready.
;

    PUBLIC  asm_disk_initialize
    PUBLIC  ide_read_sector
    PUBLIC  ide_write_sector

    EXTERN  sd_initialize
    EXTERN  asm_sd_read_sector
    EXTERN  asm_sd_write_sector

asm_disk_initialize:
    ld      a, l
    or      a
    jr      z, sd_mf_init
    ret

sd_mf_init:
    ld      h, 0
    call    sd_initialize
    ret     nz
    scf
    ret

ide_read_sector:
    push    hl
    ld      hl, bc
    pop     bc
    call    asm_sd_read_sector
    ret     nz
    scf
    ret

ide_write_sector:
    push    hl
    ld      hl, bc
    pop     bc
    call    asm_sd_write_sector
    ret     nz
    scf
    ret
