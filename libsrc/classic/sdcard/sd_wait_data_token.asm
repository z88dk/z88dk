;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	Read SD card until data token ($FE) arrives,
;	if no answer is given after a timeout period, exit keeping ZF not set
;
;	$Id: sd_wait_data_token.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;

    PUBLIC  sd_wait_data_token

    EXTERN  sd_get_byte
    EXTERN  sd_bytes_per_4ms

sd_wait_data_token:
    ld      b, 25
sd_wdt_out:
    ld      hl, (sd_bytes_per_4ms)
sd_wdt_in:
    call    sd_get_byte
    cp      $fe
    ret     z
    cp      $ff
    jr      nz, sd_wdt_bad
    dec     hl
    ld      a, h
    or      l
    jr      nz, sd_wdt_in
    djnz    sd_wdt_out
sd_wdt_bad:
    ld      a, $ff
    or      a
    ret
