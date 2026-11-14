;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	The Next core supplies card power.
;	Deselect the bus and record 16384 bytes per 4 ms.
;	AF, BC, DE and HL stay as they were.
;

    PUBLIC  sd_power_on

    EXTERN  sd_deselect_card
    EXTERN  sd_bytes_per_4ms

sd_power_on:
    call    sd_deselect_card
    push    hl
    ld      hl, 16384
    ld      (sd_bytes_per_4ms), hl
    pop     hl
    ret
