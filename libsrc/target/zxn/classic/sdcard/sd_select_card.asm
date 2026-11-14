;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	Select one Next SD device on port $E7.
;	Bit 0 of card_select clear selects SD0 ($FE).
;	Bit 0 set selects SD1 ($FD).
;	AF is restored. BC, DE and HL stay as they were.
;

    PUBLIC  sd_select_card

    EXTERN  card_select

sd_select_card:
    push    af
    ld      a, (card_select)
    and     1
    jr      z, sd_zxn_sd0
    ld      a, $fd
    jr      sd_zxn_cs
sd_zxn_sd0:
    ld      a, $fe
sd_zxn_cs:
    out     ($e7), a
    pop     af
    ret
