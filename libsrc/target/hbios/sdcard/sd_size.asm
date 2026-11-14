;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	unsigned long sd_size(struct SD_INFO *descriptor)
;	Return the byte count for a card of at most 2 GB.
;	A larger card returns 0.
;

    SECTION code_clib
    SECTION code_arch

    PUBLIC  sd_size
    PUBLIC  _sd_size

    EXTERN  sd_sectors

sd_size:
_sd_size:
    call    sd_sectors
    ld      a, d
    or      a
    jr      nz, sd_hb_sz0
    ld      a, e
    cp      $40
    jr      c, sd_hb_sz_fit
    jr      nz, sd_hb_sz0
    ld      a, h
    or      l
    jr      nz, sd_hb_sz0
sd_hb_sz_fit:
    ld      b, 9
sd_hb_sz_sh:
    add     hl, hl
    ld      a, e
    rla
    ld      e, a
    ld      a, d
    rla
    ld      d, a
    jr      c, sd_hb_sz0
    djnz    sd_hb_sz_sh
    ret

sd_hb_sz0:
    ld      de, 0
    ld      hl, 0
    ret
