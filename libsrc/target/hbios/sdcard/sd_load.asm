;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	int sd_load(unsigned char slot, struct SD_INFO *descriptor)
;	Store the unit, set block addressing, and reset the unit.
;	There is no CID on this path.
;

    SECTION code_clib
    SECTION code_arch

    PUBLIC  sd_load
    PUBLIC  _sd_load

    EXTERN  sd_initialize
    EXTERN  sd_hbios_ret
    EXTERN  sd_hbios_return_hl
    EXTERN  sd_hbios_unit

sd_load:
_sd_load:
    pop     hl
    ld      (sd_hbios_ret), hl
    pop     hl
    pop     de
    ld      a, e
    ld      (hl+), a
    push    hl
    ld      l, a
    ld      h, 0
    call    sd_initialize
    pop     hl
    jr      z, sd_hb_load_ok
    ld      hl, -1
    jp      sd_hbios_return_hl

sd_hb_load_ok:
    ld      a, (sd_hbios_unit)
    ld      (hl+), a
    ld      (hl), $12
    ld      hl, 0
    jp      sd_hbios_return_hl
