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

    ld      a,25
    call    __agon_putc
    ld      a,$41
    call    __agon_putc
    defb    $dd, $27, 6	; ld hl,(ix+6) (x1)
    call    __agon_putword
    defb    $dd, $27, 4	; ld hl,(ix+4) (y1)
    call    __agon_putword
    ld      a,25
    call    __agon_putc
    ld      a,5
    call    __agon_putc
    defb    $dd, $27, 2	; ld hl,(ix+2) (y2)
    ld      (__gfx_coords),hl
    call    __agon_putword
    defb    $dd, $27, 0	; ld hl,(ix+0) (y2)
    ld      (__gfx_coords+2),hl
    call    __agon_putword
    ret
