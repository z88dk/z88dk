;
; Sprite flip/rotate Routines
;
; Flips the picture vertically in a defined sprite
;
;
; $Id: flipsprite_v.asm $
;


    SECTION code_graphics

    PUBLIC  flipsprite_v
    PUBLIC  _flipsprite_v
    PUBLIC  ___flipsprite_v


flipsprite_v:
_flipsprite_v:
___flipsprite_v:

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
    inc     a
    push    af                          ; Width/8
    
    inc     hl
    ld      a,(hl)                      ; B=Height
    ld      b,a

    pop     af                          ; A=Width/8
    push    af

    inc     hl                          ; now points to sprite bitmap data

    push    bc                          ; Height
    push    hl
    ld      d,0                         ; DE = Width in bytes (row length)
    ld      e,a
    dec     b                           ; last row -1
    jr      z,singlepixel               ; low probability, just one row case, but not impossible
    jr      c,singlepixel               ; overflow protection, rather useless (we don't have protections elsewhere) but it costs only 2 bytes
multiply:
    add     hl,de                       ; multipy rows by bytes in a row
    djnz    multiply
singlepixel:
    ex      de,hl                       ; DE = bottom row address in sprite bitmap data
    pop     hl
    pop     bc                          ; height

    ld      a,b
    rra                                 ; height/2  (vertical loop counter)
    ld      b,a
    pop     af                          ; Width/8
    ld      c,a

    ; Now HL = top row address of the sprite bitmap,
    ; DE = bottom row address of the sprite bitmap
    ; B = bitmap height,  A = bitmap width (in bytes)

vloop:
    push    bc                          ; B=height/2 (external loop), C=Width in bytes (internal loop)

    push    de                          ; bottom row address

    ld      b,c
hloop:
    ld      a,(hl)
    push    af
    ld      a,(de)
    ld      (hl),a
    pop     af
    ld      (de),a
    inc     hl
    inc     de
    djnz    hloop

    pop     de

    ld      a,c                         ; Get width

     ; DE=DE-A (add 256 - A to HL)
     cpl
     scf
     adc    a, e
     ld     e, a
     ld     a, -1 ; And subtract 256 here
     adc    a, d
     ld     d, a
   
    pop     bc
    djnz    vloop

    pop     hl                           ; keep the pointer to the sprite address
    ret

