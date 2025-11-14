;
; Sprite flip/rotate Routines
;
; Flips the picture horizontally in a defined sprite
;
;
; $Id: shiftsprite_r.asm $
;


    SECTION code_graphics

    PUBLIC  shiftsprite_r
    PUBLIC  _shiftsprite_r
    PUBLIC  ___shiftsprite_r

; NOTE: the D register must be preserved !

shiftsprite_r:
_shiftsprite_r:
___shiftsprite_r:

    push    hl


    ld      a,(hl)                      ; Width
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


    ; Now HL = top row address of the sprite bitmap,
    ; B = bitmap height,  C = bitmap width (in bytes)

vloop:
    push    bc                          ; B = height (external loop), C=Width in bytes (internal loop)

    and     a                           ; reset CY
hloop:
    ld      a,(hl)
    rra
    ld      (hl),a
    inc     hl
    dec     c
    jr      nz,hloop
   
    pop     bc
    djnz    vloop

    pop     hl                           ; keep the pointer to the sprite address
    ret

