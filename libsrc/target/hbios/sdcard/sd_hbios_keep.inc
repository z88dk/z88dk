;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Caller linkage for one __smallc sector frame.
;	The caller defines SD_WANT_COUNT as 1 or 0 before the include.
;
;	The arguments stay on the stack. The C caller pops them.
;	Exit matches sd_hbios_pop.inc: HL high, DE low, BC buffer.
;	The return address is in sd_hbios_ret.
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
    ld      a, h
    or      l
    jr      nz, sd_hb_keep_count
    push    hl
    ld      hl, 0
    jp      sd_hbios_return_hl
sd_hb_keep_count:
    ld      (sd_hbios_count), hl
ENDIF

    pop     bc
    pop     de
    pop     hl
    ex      (sp), hl                    ; Z180: HL is the card, the sector high word stays
    ld      a, (hl)
    ld      (sd_hbios_unit), a
    ex      (sp), hl
    push    hl
    push    de
    push    bc

IF SD_WANT_COUNT
    ld      hl, (sd_hbios_count)
    push    hl
    ld      hl, sp+2
    ld      c, (hl)
    inc     hl
    ld      b, (hl)
    inc     hl
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    inc     hl
    ld      a, (hl)
    inc     hl
    ld      h, (hl)
    ld      l, a
ENDIF
