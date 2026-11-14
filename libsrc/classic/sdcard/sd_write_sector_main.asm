;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	set HL to ptr to buffer location, sd card addres must be requested already.
;
;	$Id: sd_write_sector_main.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;

    PUBLIC  sd_write_sector_main

    EXTERN  sd_send_eight_clocks
    EXTERN  sd_send_byte

sd_write_sector_main:
    ld      b, 0
sd_wslp:
    ld      a, (hl+)                    ; 8080: (hl+) is the cheap synthetic
    call    sd_send_byte
    ld      a, (hl+)
    call    sd_send_byte
    djnz    sd_wslp
    call    sd_send_eight_clocks
    jp      sd_send_eight_clocks
