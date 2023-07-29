SECTION code_clib

PUBLIC __agon_drawr
EXTERN __agon_putc
EXTERN __agon_putword
EXTERN __gfx_coords


; ix points to stack frame
; a = colour
__agon_drawr:
    ; Set graphics colour
    push    af
    ld      a,18
    call    __agon_putc
    xor     a           ;graphic mode
    call    __agon_putc
    pop     af
    call    __agon_putc

    ;Plot pixel
    ld      a,25
    call    __agon_putc
    ld      a,$41
    call    __agon_putc
    ld      hl,(__gfx_coords)
    call    __agon_putword
    ld      hl,(__gfx_coords+2)
    call    __agon_putword

    ; Move to 
    ld      a,25
    call    __agon_putc
    ld      a,4
    call    __agon_putc
    ld      hl,(__gfx_coords)
    call    __agon_putword
    ld      hl,(__gfx_coords+2)
    call    __agon_putword

    ld      a,25
    call    __agon_putc
    ld      a,5
    call    __agon_putc
    ld      de,(ix+2)	;x2
    ld      hl,(__gfx_coords)
    add     hl,de
    ld      (__gfx_coords),hl
    call    __agon_putword
    ld      de,(ix+0)	;y2
    ld      hl,(__gfx_coords+2)
    add     hl,de
    ld      (__gfx_coords+2),hl
    call    __agon_putword
    ret
