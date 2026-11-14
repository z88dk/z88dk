;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	Deselect the Next SD bus. Idle chip select is $FF.
;	One $FF byte clocks the data line.
;	AF, BC, DE and HL stay as they were.
;

    PUBLIC  sd_deselect_card

sd_deselect_card:
    push    af
    ld      a, $ff
    out     ($e7), a
    out     ($eb), a
    in      a, ($eb)
    pop     af
    ret
