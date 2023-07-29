SECTION code_clib

PUBLIC __agon_draw
EXTERN __agon_putc
EXTERN __agon_putword
EXTERN __gfx_coords


; ix points to stack frame
; a = colour
__agon_draw:
    ; Set graphics colour
    push    af
    ld      a,18
    call    __agon_putc
    xor     a           ;graphic mode
    call    __agon_putc
    pop     af
    call    __agon_putc

    ; Plot the origin pixel
    ld      a,25
    call    __agon_putc
    ld      a,$41
    call    __agon_putc
    ld      hl,(ix+6)
    call    __agon_putword
    ld      hl,(ix+4)
    call    __agon_putword

    ; Now move the cursor
    ld      a,25
    call    __agon_putc
    ld      a,4
    call    __agon_putc
    ld      hl,(ix+6)
    call    __agon_putword
    ld      hl,(ix+4)
    call    __agon_putword

    ; And now draw the line
    ld      a,25
    call    __agon_putc
    ld      a,5
    call    __agon_putc
    ld      hl,(ix+2)
    ld      (__gfx_coords),hl
    call    __agon_putword
    ld      hl,(ix+0)
    ld      (__gfx_coords+2),hl
    call    __agon_putword
    ret
