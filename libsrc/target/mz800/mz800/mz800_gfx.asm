;
;	Sharp MZ-800 specific routines
;
;	void mz800_gfx_init(void);
;	void mz800_gfx_ink(uint8_t ink, uint8_t paper) __smallc;
;
;	The graphics screen: 320x200 in four pens (planes I and II, 40 bytes a line, a byte's leftmost pixel is its bit 0), palette black, bright red, bright green, white
;	(mz800_set_palette changes it).  The video RAM is at $8000-$9FFF, with the character generator at $1000-$1FFF, only while a library routine draws (IN ($E0) in, IN ($E1) out),
;	so a program's code and the data these routines read must not be there then: the drawing code is linked first (section code_driver) and programs start at $2000.
;	Plot, unplot, xorplot, clg and the console share the ink and paper pens (default 3 and 0): textcolor and textbackground set them, and so does mz800_gfx_ink.
;

    SECTION code_driver
    PUBLIC  mz800_gfx_init
    PUBLIC  _mz800_gfx_init
    PUBLIC  mz800_gfx_ink
    PUBLIC  _mz800_gfx_ink
    PUBLIC  __mz800_gfx_clear
    EXTERN  __mz800_con_ink
    EXTERN  __mz800_con_paper

mz800_gfx_init:
_mz800_gfx_init:
    out     ($e0), a                    ; RAM at $0000-$0FFF
    out     ($e1), a                    ; RAM at $E000-$FFFF
    xor     a
    out     ($ce), a                    ; 320x200, four pens, planes I and II
    ld      hl, palette
    ld      b, 4
pal_loop:
    ld      a, (hl)
    out     ($f0), a
    inc     hl
    djnz    pal_loop
    in      a, ($e1)                    ; (the video RAM out)
    ret

palette:
    defb    $00, $1a, $2c, $3f          ; (pen << 4) | colour: black, bright red, bright green, white

; void mz800_gfx_ink(uint8_t ink, uint8_t paper) __smallc
mz800_gfx_ink:
_mz800_gfx_ink:
    ld      hl, 2
    add     hl, sp
    ld      a, (hl)                     ; paper
    and     3
    ld      (__mz800_con_paper), a
    inc     hl
    inc     hl
    ld      a, (hl)                     ; ink
    and     3
    ld      (__mz800_con_ink), a
    ret

; Clear the screen to the pen in a: one replace write sets all of a byte's pixels in both planes, the planes of the pen getting 1s and the other 0.
; Uses af, bc, de, hl.
__mz800_gfx_clear:
    and     3
    or      $80
    ld      e, a                        ; the write format
    call    l_push_di                   ; (kept: pop restores)
    in      a, ($e0)
    ld      a, e
    out     ($cc), a
    ld      hl, $8000
    ld      bc, 8000
    ld      a, $ff
clear_loop:
    ld      (hl), a
    inc     hl
    dec     bc
    ld      d, a
    ld      a, b
    or      c
    ld      a, d
    jr      nz, clear_loop
    in      a, ($e1)
    call    l_pop_ei
    ret

    EXTERN  l_push_di
    EXTERN  l_pop_ei

