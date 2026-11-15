;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Wait until the card releases the data line.
;	Busy is $00. This is the R1b tail and the write program time.
;	A free line reads as $FF. Z is set when that byte arrives.
;	63 passes of 4 ms cover the 250 ms single-block busy limit.
;	Modified November 2026 feilipu.
;

    PUBLIC  sd_wait_not_busy

    EXTERN  sd_get_byte
    EXTERN  sd_bytes_per_4ms

sd_wait_not_busy:
    ld      b, 63
sd_wbs_out:
    ld      hl, (sd_bytes_per_4ms)
sd_wbs_in:
    call    sd_get_byte
    cp      $ff
    ret     z
    dec     hl
    ld      a, h
    or      l
    jr      nz, sd_wbs_in
    djnz    sd_wbs_out
    ld      a, 0
    or      a
    ret
