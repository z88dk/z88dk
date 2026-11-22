SECTION code_clib

PUBLIC in_Wait

; -----------------------------------------------------------------------------
; void in_Wait(uint msec) __z88dk_fastcall
;
; Pauses execution for a specified number of milliseconds.
; Target: Philips P2000T (Z80 @ 2.500 MHz)
; Accuracy: ~0.04% error (2501 cycles vs 2500 target)
;
; Input:
;   HL = Number of milliseconds to wait.
; -----------------------------------------------------------------------------
in_Wait:
    ld   a, h
    or   l
    ret  z
_w_outer:
    ld   bc, 95                 ; CALIBRATION: 95 loops * 26 cycles + overhead ~= 2500
_w_inner:
    dec  bc                     ; 6 T
    ld   a, b                   ; 4 T
    or   c                      ; 4 T
    jr   nz, _w_inner           ; 12 T (Taken), 7 T (Not Taken)

    dec  hl                     ; 6 T
    ld   a, h                   ; 4 T
    or   l                      ; 4 T
    jr   nz, _w_outer           ; 12 T
    ret