;
; Sprite flip/rotate Routines
;
; Invert the picture in the sprite data
;
;
; $Id: invsprite.asm $
;


    SECTION code_graphics

    PUBLIC  invsprite
    PUBLIC  _invsprite
    PUBLIC  ___invsprite



invsprite:
_invsprite:
___invsprite:

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
    ld      c,a
    
    inc     hl
    ld      a,(hl)                      ; B=Height
    ld      b,a

    inc     hl                          ; now points to sprite bitmap data

vloop:
    push    bc                          ; B=height/2 (external loop), C=Width in bytes (internal loop)

    ld      b,c
hloop:
    ld      a,(hl)
    cpl
    ld      (hl),a
    inc     hl
    djnz    hloop
   
    pop     bc
    djnz    vloop

    pop     hl                           ; keep the pointer to the sprite address
    ret

