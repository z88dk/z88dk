SECTION code_clib

PUBLIC __agon_drawto
EXTERN __agon_putc
EXTERN __agon_putword
EXTERN __gfx_coords


; ix points to stack frame
; a = colour
__agon_drawto:
    ; Set graphics colour
    push    af
    ld      a,18
    call    __agon_putc
    xor     a           ;graphic mode
    call    __agon_putc
    pop     af
    call    __agon_putc

    ; Plot pixel at start
    ld      a,25
    call    __agon_putc
    ld      a,$41
    call    __agon_putc
    ld      hl,(__gfx_coords)
    call    __agon_putword
    ld      hl,(__gfx_coords+2)
    call    __agon_putword

    ; We also have to move the graphics cursor
    ld      a,25
    call    __agon_putc
    ld      a,4
    call    __agon_putc
    ld      hl,(__gfx_coords)
    call    __agon_putword
    ld      hl,(__gfx_coords+2)
    call    __agon_putword

    ; And now we can draw a line
    ld      a,25
    call    __agon_putc
    ld      a,5
    call    __agon_putc
    ld      hl,(ix+2)	;x2
    ld      (__gfx_coords),hl
    call    __agon_putword
    ld      hl,(ix+0)	;y2
    ld      (__gfx_coords+2),hl
    call    __agon_putword
    ret
