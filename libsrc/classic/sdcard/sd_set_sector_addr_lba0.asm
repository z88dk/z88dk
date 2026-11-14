;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	set HL to dest address for data
;	set B to number of bytes required
;
;	$Id: sd_set_sector_addr_lba0.asm,v 1.4 2015-01-19 01:33:07 pauloscustodio Exp $
;

    PUBLIC  sd_set_sector_addr_lba0

    EXTERN  sector_lba0
    EXTERN  sd_set_sector_addr_regs

;	8080: ld de,hl. ld bc,(nn) is not an 8080 load.
sd_set_sector_addr_lba0:
    ld      hl, (sector_lba0)
    ld      de, hl
    ld      hl, (sector_lba0+2)
    scf
    jp      sd_set_sector_addr_regs
