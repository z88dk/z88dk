;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Caller linkage for one __smallc sector frame.
;	The caller defines SD_WANT_COUNT as 1 or 0 before the include.
;
;	The arguments stay on the stack. The C caller pops them.
;	Exit matches sd_pop_sector.inc: HL high, DE low, BC buffer.
;	The return address is in sd_c_ret.
;	A count of 0 returns 0 and does not touch the card.
;

    EXTERN  sd_c_ret
    EXTERN  sd_c_return_hl
    EXTERN  card_select
    EXTERN  sd_card_info
    EXTERN  sd_block_count

    pop     hl
    ld      (sd_c_ret), hl

IF SD_WANT_COUNT
    pop     hl
    ld      a, h
    or      l
    jr      nz, sd_keep_count
    push    hl
    ld      hl, 0
    jp      sd_c_return_hl
sd_keep_count:
    ld      (sd_block_count), hl
ENDIF

    pop     bc
    pop     de
    pop     hl
    push    hl
    push    de
    push    bc
    ld      hl, sp+6
    ld      a, (hl+)
    ld      h, (hl)
    ld      l, a
    inc     hl
    ld      a, (hl+)
    ld      (card_select), a
    ld      a, (hl)
    ld      (sd_card_info), a
    pop     bc
    pop     de
    pop     hl
    push    hl
    push    de
    push    bc

IF SD_WANT_COUNT
    ld      hl, (sd_block_count)
    push    hl
    ld      hl, sp+2                    ; 8080: ld hl,sp+n clobbers C
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
