;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;	Modified November 2026 feilipu.
;
;	Pop one __smallc sector frame for the HBIOS port.
;	The caller defines SD_WANT_COUNT as 1 or 0 before the include.
;
;	__smallc pushes the high word, then the low word.
;	The first pop of the sector is the low word.
;	Exit: HL high, DE low, BC buffer. The unit is stored.
;	A count of 0 returns 0 and does not call HBIOS.
;

    EXTERN  sd_hbios_ret
    EXTERN  sd_hbios_return_hl
    EXTERN  sd_hbios_unit
    EXTERN  sd_hbios_count

    pop     hl
    ld      (sd_hbios_ret), hl

IF SD_WANT_COUNT
    pop     hl
    ld      (sd_hbios_count), hl
    ld      a, h
    or      l
    jr      nz, sd_hbios_pop_ok
    pop     hl
    pop     hl
    pop     hl
    pop     hl
    ld      hl, 0
    jp      sd_hbios_return_hl
sd_hbios_pop_ok:
ENDIF

    pop     bc
    pop     de
    pop     hl
    ex      (sp), hl                    ; Z180: HL is the card, the sector high word stays
    ld      a, (hl)
    ld      (sd_hbios_unit), a
    pop     hl
