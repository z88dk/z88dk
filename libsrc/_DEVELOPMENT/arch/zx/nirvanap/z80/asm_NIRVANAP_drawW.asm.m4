include(`z88dk.m4')
include(`clib_target_cfg.asm')

IF (__NIRVANAP_OPTIONS & 0x1)

; WIDE DRAW ENABLED

; ----------------------------------------------------------------
; Z88DK LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; Draw wide tile (24x16 pixels) at specified position (in 2345T)
;
; Params:
;     A = wide tile index (0-255)
;     D = pixel line (0-200, even values only)
;     E = char column (0-29)
;
; IMPORTANT: This routine is disabled by default, recompile this file
;            declaring 'ENABLE_WIDE_DRAW' before calling it!!!
;
; WARNING: Computer will crash if an interrupt occurs during execution!
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_nirvanap

PUBLIC asm_NIRVANAP_drawW

EXTERN __NIRVANAP_bitmaps, __NIRVANAP_WIDE_IMAGES
EXTERN __NIRVANAP_attribs, __NIRVANAP_deltas

asm_NIRVANAP_drawW:

; preserve stack pointer
        ld      (exit_wide+1), sp

; calculate screen bitmap lookup address
        ld      h, __NIRVANAP_bitmaps/256
        ld      l, d
        ld      sp, hl

; preserve values
        ld      b, e
        ld      c, h

; calculate tile image address
        ld      h, 0
        ld      l, a
        ld      e, h
        add     hl, hl
        add     hl, hl
        add     hl, hl
        rra
        rr      e
        rra
        rr      e
        ld      d, a
        add     hl, de
        ld      de, __NIRVANAP_WIDE_IMAGES
        add     hl, de

; draw bitmap lines
z88dk_for(`LOOP', `1', `8', 
`
        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi
        ld      a, (hl)
        ld      (de), a
        inc     hl
        dec     e
        dec     e
        inc     d
        ldi
        ldi
        ldi
')

; calculate routine attribute addresses
        ex      de, hl
        ld      hl, __NIRVANAP_attribs - __NIRVANAP_bitmaps - 16
        add     hl, sp
        ld      sp, hl

; set routine attribute offsets
        ld      h, __NIRVANAP_deltas/256
        ld      l, b
        inc     l
        ld      a, (hl)
        ld      (wide_1st+2), a
        inc     l
        ld      a, (hl)
        ld      (wide_2nd+2), a
        inc     l
        ld      a, (hl)
        ld      (wide_3rd+2), a

; set routine attributes
        ld      b, 8
loop_wide:
        pop     ix
        ld      a, (de)
        inc     de
wide_1st:
        ld      (ix+0), a
        ld      a, (de)
        inc     de
wide_2nd:
        ld      (ix+0), a
        ld      a, (de)
        inc     de
wide_3rd:
        ld      (ix+0), a
        djnz    loop_wide

exit_wide:
; restore stack pointer
        ld      sp, 0
        ret


ENDIF
