;
; Sprite flip/rotate Routines
;
; Flips the picture horizontally in a defined sprite
;
;
; $Id: shiftsprite_l.asm $
;


    SECTION code_graphics

    PUBLIC  shiftsprite_l
    PUBLIC  _shiftsprite_l
    PUBLIC  ___shiftsprite_l


shiftsprite_l:
_shiftsprite_l:
___shiftsprite_l:

;   FASTCALL, no need to mess with the stack
;    ld      hl, 2
;    add     hl, sp
;    ld      e, (hl)
;    inc     hl
;    ld      d, (hl)                     ;sprite address
;    ex      de,hl

    push    hl


    ld      a,(hl)                      ; Width
    dec     a

    and     0xF8
    rra
    rra
    rra

	ld      d,0
	ld      e,a

    inc     a
    ld      c,a                         ; Width/8
    
    inc     hl
    ld      a,(hl)                      ; B=Height
    ld      b,a

    inc     hl                          ; now points to sprite bitmap data


    ; Now HL = top row address of the sprite bitmap,
    ; B = bitmap height,  C = bitmap width (in bytes)

vloop:
    push    bc                          ; B = height (external loop), C=Width in bytes (internal loop)

;	ld      a,c
;	dec     a                           ; A = Width in bytes -1
;	add     l                           ; HL = HL+A = bottom byte in the current sprite bitmap row
;	ld      l,a
;    adc     h
;	sub     l
;	ld      h,a
    add     hl,de
    push    hl                          ; keep a copy of the rightmost byte address, we'll use it to move on the next row	

	and     a                           ; reset CY
hloop:
    ld      a,(hl)
	rla
	ld      (hl),a
	dec     hl
	dec     c
    jr      nz,hloop

    pop     hl                          ; move to next row address
	inc     hl

    pop     bc
    djnz    vloop

    pop     hl                           ; keep the pointer to the sprite address
    ret

