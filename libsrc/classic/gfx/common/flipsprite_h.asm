;
; Sprite flip/rotate Routines
;
; Flips the picture horizontally in a defined sprite
;
;
; $Id: flipsprite_h.asm $
;


    SECTION code_graphics

    EXTERN __graphics_cmphlde
    EXTERN shiftsprite_l

    PUBLIC  flipsprite_h
    PUBLIC  _flipsprite_h
    PUBLIC  ___flipsprite_h


flipsprite_h:
_flipsprite_h:
___flipsprite_h:

;   FASTCALL, no need to mess with the stack

    push    hl

    ld      a,(hl)                      ; Width
    push    af                          ; save width in px
    dec     a

    and     0xF8
    rra
    rra
    rra
    inc     a
    ld      c,a                         ; Width/8
    
    inc     hl
    ld      a,(hl)                      ; B=Height
    ld      b,a

    inc     hl                          ; now points to sprite bitmap data

;    pop     af                          ; Width in px
;    and     7                           ; remainder


;    jr      z,no_shift
;    ld      d,a
;    ld      a,8
;    sub     d
;
;    push    bc
;    ld      d,a
;do_shift:
;    call    shiftsprite_r
;    dec     d
;    jr      nz,do_shift
;    pop     bc
;
;no_shift:

    ; Now HL = top row address of the sprite bitmap,
    ; B = bitmap height,  C = bitmap width (in bytes)

vloop:
    push    bc                          ; B = height (external loop), C=Width in bytes (internal loop)

    ld      a,c
    dec     a                           ; A = Width in bytes -1
    jr      z,vloop_0                   ; jump to the special 1-byte case if appropriate

    add     l                           ; DE = HL+A = bottom byte in the current sprite bitmap row
    ld      e,a
    adc     h
    sub     e
    ld      d,a
    push    de                          ; keep a copy of the rightmost byte address, we'll use it to move on the next row


hloop:
    ld      a,(hl)
    push    af
    ld      a,(de)

    ld      b,8
bit_loop_1:
    rla
IF  !__CPU_INTEL__
    rr      (hl)
ELSE
    ld      c,a
    ld      a,(hl)
    rra
    ld      (hl),a
    ld      a,c
ENDIF
    djnz    bit_loop_1
    ld      (de),a
    pop     af

    ld      b,a
    call    __graphics_cmphlde          ; if right ptr and left ptr are identical let's avod to flip the byte twice
    jr      z,next_row
    ld      a,b

    ld      b,8
    ex      de,hl
bit_loop_2:
    rra
IF  !__CPU_INTEL__
    rl      (hl)
ELSE
    ld      c,a
    ld      a,(hl)
    rla
    ld      (hl),a
    ld      a,c
ENDIF
    djnz    bit_loop_2
    ex      de,hl

    inc     hl
    call    __graphics_cmphlde
    dec     de
    jr      z,next_row
    jr      hloop
next_row:

    pop     hl                           ; get next row address using bottom address of the previous row
    inc     hl

    pop     bc
    djnz    vloop

exit_loop:
    pop     af                           ; Width in px
    pop     hl                           ; keep the pointer to the sprite address
    and     7
    ret     z                            ; no need to "normalize" the picture position

    sub     8                            ; A=8-A
    neg
shift_loop:
    push    af
    call    shiftsprite_l
    pop     af
    dec     a
    jr      nz,shift_loop
    ret


    ; Now HL = top row address of the sprite bitmap
    ; B = bitmap height
vloop_0:
    ld      a,(hl)
    ld      c,9
bit_loop_0:
    rla
IF  !__CPU_INTEL__
    rr      (hl)
ELSE
    ld      d,a
    ld      a,(hl)
    rra
    ld      (hl),a
    ld      a,d
ENDIF
    dec     c
    jr      nz,bit_loop_0
    ld      (hl),a
    inc     hl
    djnz    vloop_0
    jr      exit_loop
