;
; Generic Intel 8275 CRT controller — RC700 device functions.
;
; Declared in <video/i8275.h>.  The RC700 wires the 8275 command/status
; port at $01 and the parameter/data port at $00.
;
; Datasheet: https://bitsavers.org/components/intel/8275/1984_8275.pdf
; RC700 issue: https://github.com/z88dk/z88dk/issues/3011
;

    SECTION code_clib

    PUBLIC  i8275_default_par
    PUBLIC  _i8275_default_par
    PUBLIC  i8275_reset
    PUBLIC  _i8275_reset

    defc    I8275_CMD  = $01            ; command/status port (A0 = 1)
    defc    I8275_DATA = $00            ; parameter/data port (A0 = 0)

; void i8275_default_par(unsigned char *par) __z88dk_fastcall
; hl = par ; fill 4 RC700 default bytes (blinking block cursor).
i8275_default_par:
_i8275_default_par:
    ld      (hl), $4F                   ; par0: 80 chars/row
    inc     hl
    ld      (hl), $98                   ; par1: 25 rows/frame
    inc     hl
    ld      (hl), $7A                   ; par2: underline line 7, 11 lines/char
    inc     hl
    ld      (hl), $4D                   ; par3: blinking block cursor
    ret

; void i8275_reset(unsigned char *par) __z88dk_fastcall
; hl = par ; reprogram the 8275 from par[0..3] and re-enable the display.
i8275_reset:
_i8275_reset:
    xor     a
    out     (I8275_CMD), a              ; Reset command ($00)
    ld      b, 4                        ; 4 parameter bytes
    ld      c, I8275_DATA               ; data port ($00); B on A8-A15 is don't-care
    otir                                ; write par[0..3]
    ld      a, $80                      ; Load Cursor Position
    out     (I8275_CMD), a
    xor     a
    out     (I8275_DATA), a             ; column = 0
    out     (I8275_DATA), a             ; row = 0
    ld      a, $E0                      ; Preset Counters
    out     (I8275_CMD), a
    ld      a, $23                      ; Start Display (burst 8, space 0)
    out     (I8275_CMD), a
    ret
