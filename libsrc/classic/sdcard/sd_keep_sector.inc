;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Caller linkage for one __smallc sector frame.
;	The caller defines SD_WANT_COUNT as 1 or 0 before the include.
;
;	The arguments stay on the stack. The C caller pops them.
;	Exit matches sd_pop_sector.inc: HL high, DE low, BC buffer.
;	The return address stays on the stack.
;	A count of 0 returns 0 and does not touch the card.
;

    EXTERN  card_select
    EXTERN  sd_card_info
    EXTERN  sd_block_count

IF SD_WANT_COUNT
    ld      hl, 2
    add     hl, sp                      ; 8080: ld hl,sp+n clobbers C
    ld      a, (hl+)
    ld      h, (hl)
    ld      l, a
    ld      a, h
    or      l
    jr      nz, sd_keep_count
    ld      hl, 0
    ret
sd_keep_count:
    ld      (sd_block_count), hl
    ld      hl, 10
    add     hl, sp
ELSE
    ld      hl, 8
    add     hl, sp
ENDIF
    ld      a, (hl+)
    ld      h, (hl)
    ld      l, a                        ; descriptor pointer
    inc     hl
    ld      a, (hl+)
    ld      (card_select), a
    ld      a, (hl)
    ld      (sd_card_info), a

IF SD_WANT_COUNT
    ld      hl, 4
    add     hl, sp
ELSE
    ld      hl, 2
    add     hl, sp
ENDIF
    ld      c, (hl+)
    ld      b, (hl+)
    ld      e, (hl+)
    ld      d, (hl+)
    ld      a, (hl+)
    ld      h, (hl)
    ld      l, a
