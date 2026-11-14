;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
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
    ld      (sd_block_count), hl
    ld      a, h
    or      l
    jr      nz, sd_pop_count_ok
    pop     hl
    pop     hl
    pop     hl
    pop     hl
    ld      hl, 0
    jp      sd_c_return_hl
sd_pop_count_ok:
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

; BC, DE and HL are live. Two inc sp drop the card pointer.
    inc     sp
    inc     sp
