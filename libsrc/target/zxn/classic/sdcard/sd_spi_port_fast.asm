;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	The Next SPI clock has no programmable divider.
;	Record 16384 bytes per 4 ms. AF stays as it was.
;

    PUBLIC  sd_spi_port_fast

    EXTERN  sd_bytes_per_4ms

sd_spi_port_fast:
    push    af
    push    hl
    ld      hl, 16384
    ld      (sd_bytes_per_4ms), hl
    pop     hl
    pop     af
    ret
