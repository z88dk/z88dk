include(`z88dk.m4')

; ----------------------------------------------------------------
; Z88DK LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; Draw tile at specified position (in 1712T)
;
; Params:
;     A = tile index (0-255)
;     D = pixel line (0-200, even values only)
;     E = char column (0-30)
;
; WARNING: Computer will crash if an interrupt occurs during execution!
; ----------------------------------------------------------------

SECTION smc_clib
SECTION smc_nirvanap

IF ((__NIRVANAP_OPTIONS & 0x3) = 0x3)

; ----------------------------------------------------------------

; WIDE SPRITES ENABLED

PUBLIC asm_NIRVANAP_drawTW

asm_NIRVANAP_drawTW:

; preserve stack pointer
        ld      (exit_draw+1), sp       ; delay 20T in 4 bytes
        ld      bc, $2e00               ; delay 10T
delay_sprite:
        djnz    delay_sprite            ; delay 593T
        jp      asm_NIRVANAP_drawT      ; execute NIRVANA_drawT with delay 10T

; ----------------------------------------------------------------
		  
ENDIF

PUBLIC asm_NIRVANAP_drawT

EXTERN __NIRVANAP_TILE_IMAGES
EXTERN __NIRVANAP_bitmaps, __NIRVANAP_deltas, __NIRVANAP_attribs

asm_NIRVANAP_drawT:

; preserve stack pointer
        ld      (exit_draw+1), sp

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
        ld      d, h
        ld      e, l
        add     hl, hl
        add     hl, de
        add     hl, hl
        add     hl, hl
        add     hl, hl
        add     hl, hl
        ld      de, __NIRVANAP_TILE_IMAGES
        add     hl, de

; draw bitmap lines
z88dk_for(`LOOP', `1', `8', 
`
        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ld      a, (hl)
        ld      (de), a
        inc     hl
        dec     e
        inc     d
        ldi
        ldi
')

; calculate routine attribute address
        ex      de, hl

        ld      h, __NIRVANAP_deltas/256
        ld      l, b
        inc     l
        ld      c, (hl)
        inc     l
        ld      a, (hl)
        ex      af, af'

        ld      hl, __NIRVANAP_attribs - __NIRVANAP_bitmaps - 16
        ld      b, h
        add     hl, sp
        ld      sp, hl

; set 1st column of routine attributes
z88dk_for(`LOOP', `1', `8', 
`
        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de
')

        ex      af, af'
        ld      c, a
        ld      hl, -16
        add     hl, sp
        ld      sp, hl

; set 2nd column of routine attributes
z88dk_for(`LOOP', `1', `7', 
`
        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de
')
        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a

exit_draw:
; restore stack pointer
        ld      sp, 0
        ret
