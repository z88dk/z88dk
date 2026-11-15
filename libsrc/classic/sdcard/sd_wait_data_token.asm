;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	Read until the data token ($FE) arrives.
;	$FF or $00 is delay and stays inside the timeout. $00 is the line held low.
;	$01-$0F is a data error token. Any other byte fails at once.
;	No token after the timeout returns with Z clear.
;	HL and BC are the caller's values on both exits. AF changes.
;	The byte count in HL is private. It is not the buffer.
;
;	$Id: sd_wait_data_token.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;

    PUBLIC  sd_wait_data_token

    EXTERN  sd_get_byte
    EXTERN  sd_bytes_per_4ms

    INCLUDE "sdcard.def"

sd_wait_data_token:
    push    hl                          ; the caller keeps this pointer
    push    bc
    ld      b, 25                       ; 100 ms. CMD17 and CMD18 both use this token.
sd_wdt_out:
    ld      hl, (sd_bytes_per_4ms)
sd_wdt_in:
    call    sd_get_byte
    cp      TOKEN_DATA
    jr      z, sd_wdt_ok
    cp      $ff
    jr      z, sd_wdt_next
    or      a                           ; $00: still busy. Not an error token.
    jr      z, sd_wdt_next
    jr      sd_wdt_bad
sd_wdt_next:
    dec     hl
    ld      a, h
    or      l
    jr      nz, sd_wdt_in
    djnz    sd_wdt_out                  ; 8080: djnz is the cheap synthetic
sd_wdt_bad:
    ld      a, $ff
    or      a                           ; Z clear. pop does not change flags.
    pop     bc
    pop     hl
    ret

sd_wdt_ok:
    pop     bc
    pop     hl
    ret
