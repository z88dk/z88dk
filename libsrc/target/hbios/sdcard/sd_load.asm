;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	int sd_load(unsigned char slot, struct SD_INFO *descriptor)
;	Store the unit, set block addressing, and reset the unit.
;	There is no CID on this path.
;	The plain name leaves both words for the caller.
;

    SECTION code_clib
    SECTION code_arch

    PUBLIC  sd_load
    PUBLIC  _sd_load

    EXTERN  sd_initialize
    EXTERN  sd_hbios_unit

sd_load:
_sd_load:
    pop     bc
    pop     hl
    pop     de
    push    de
    push    hl
    push    bc
    ld      a, e
    ld      (hl+), a
    push    hl
    ld      l, a
    ld      h, 0
    call    sd_initialize
    pop     hl
    jr      z, sd_hb_load_ok
    ld      hl, -1
    ret

sd_hb_load_ok:
    ld      a, (sd_hbios_unit)
    ld      (hl+), a
    ld      (hl), $12
    ld      hl, 0
    ret
