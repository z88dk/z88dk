;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	ZX Spectrum Next SPI data port $EB.
;	Send the byte in A and discard the byte that comes back.
;	BC, DE and HL stay as they were.
;

    PUBLIC  sd_send_byte

sd_send_byte:
    out     ($eb), a
    in      a, ($eb)
    ret
