;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Pop one __smallc sector frame.
;	The caller defines SD_WANT_COUNT as 1 or 0 before the include.
;
;	__smallc pushes the high word, then the low word.
;	That order is the same on sccz80 and on zsdcc.
;	The first pop of the sector is the low word.
;	The address helper wants the high word in HL.
;
;	Exit: HL high, DE low, BC buffer.
;	The return address stays on the stack.
;	A count of 0 returns 0 and does not touch the card.
;

    EXTERN  card_select
    EXTERN  sd_card_info
    EXTERN  sd_block_count

IF SD_WANT_COUNT
    pop     hl                          ; return address
    pop     de
    ld      a, d
    or      e
    jr      nz, sd_pop_count_ok
    pop     de                          ; buffer, sector, descriptor
    pop     de
    pop     de
    pop     de
    push    hl
    ld      hl, 0
    ret
sd_pop_count_ok:
    ld      (sd_block_count), de
ELSE
    pop     hl                          ; return address
ENDIF

    pop     bc                          ; buffer
    pop     de                          ; sector low
    push    hl
    push    bc
    push    de
                                        ; low, buffer, return, high, descriptor
    ld      hl, 6
    add     hl, sp
    ld      e, (hl+)
    ld      d, (hl+)                    ; sector high
    ld      a, (hl+)
    ld      h, (hl)
    ld      l, a                        ; descriptor pointer
    inc     hl
    ld      a, (hl+)
    ld      (card_select), a
    ld      a, (hl)
    ld      (sd_card_info), a
    push    de
                                        ; high, low, buffer, return, high, descriptor
    pop     hl
    pop     de
    pop     bc
                                        ; return, high, descriptor
; BC, DE and HL are live. Copy the return over the descriptor and drop
; the two words above it. vm1: inc sp, not pop af.
    push    hl
    ld      hl, 2
    add     hl, sp
    ld      a, (hl)
    ld      hl, 6
    add     hl, sp
    ld      (hl), a
    ld      hl, 3
    add     hl, sp
    ld      a, (hl)
    ld      hl, 7
    add     hl, sp
    ld      (hl), a
    pop     hl
    inc     sp
    inc     sp
    inc     sp
    inc     sp
