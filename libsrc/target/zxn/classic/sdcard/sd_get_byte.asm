;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	Clock $FF on SPI data port $EB and return the byte in A.
;	BC, DE and HL stay as they were.
;

    PUBLIC  sd_get_byte

    EXTERN  sd_send_byte

sd_get_byte:
    ld      a, $ff
    jp      sd_send_byte
