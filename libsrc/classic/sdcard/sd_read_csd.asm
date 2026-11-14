;
;	SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	Read card information details
;
;	$Id: sd_read_csd.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;

    PUBLIC  sd_read_csd

    EXTERN  sector_buffer_loc
    EXTERN  sd_get_cid_csd
    EXTERN  asm_sd_csd_sectors

    INCLUDE "sdcard.def"

; Returns BC:DE = Total capacity of card (in sectors)
;	8080: asm_sd_csd_sectors returns DEHL. ld bc,de and ld de,hl keep this exit.

sd_read_csd:
    ld      hl, (sector_buffer_loc)
    ld      a, CMD9                     ; send "read CSD" command: 49 00 00 00 00 01 to read card info
    call    sd_get_cid_csd
    ret     nz
    call    asm_sd_csd_sectors
    ld      bc, de
    ld      de, hl
    xor     a
    ret
