;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Wait until the card releases the data line.
;	Busy is $00. This is the R1b tail and the write program time.
;	A free line reads as $FF. Z is set when that byte arrives.
;	A timeout returns with Z clear. Callers treat Z clear as the error.
;	63 passes of 4 ms cover the 250 ms single-block busy limit.
;	HL is the caller's value on both exits. AF and BC change.
;	The byte count in HL is private. The next block pointer stays in HL.
;

    SECTION code_driver

    PUBLIC  sd_wait_not_busy

    EXTERN  sd_get_byte
    EXTERN  sd_bytes_per_4ms

sd_wait_not_busy:
    push    hl
    ld      b, 63
sd_wbs_out:
    ld      hl, (sd_bytes_per_4ms)
sd_wbs_in:
    call    sd_get_byte
    cp      $ff
    jr      z, sd_wbs_ok
    dec     hl
    ld      a, h
    or      l
    jr      nz, sd_wbs_in
    djnz    sd_wbs_out
    ld      a, $ff
    or      a                           ; Z clear. A zero here would look like success.
    pop     hl
    ret

sd_wbs_ok:
    pop     hl                          ; pop does not change Z
    ret
