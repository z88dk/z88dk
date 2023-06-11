SECTION code_clib

PUBLIC __agon_circle
EXTERN __agon_putc
EXTERN __agon_putword
EXTERN __gfx_coords


; ix points to stack frame
; a = colour
; (int x, int y, int radius, int skip) __smallc
__agon_circle:
    ; Set graphics colour
    push    af
    ld      a,18
    call    __agon_putc
    xor     a           ;graphic mode
    call    __agon_putc
    pop     af
    call    __agon_putc

    ; Move to position
    ld      a,25
    call    __agon_putc
    ld      a,4
    call    __agon_putc
    defb    $dd, $27, 6	; ld hl,(ix+6) (x1)
    call    __agon_putword
    defb    $dd, $27, 4	; ld hl,(ix+4) (y1)
    call    __agon_putword

    ld      a,25
    call    __agon_putc
    ld      a,0x90
    call    __agon_putc
    defb    $dd, $27, 2	; ld hl,(ix+2) (radius)
    call    __agon_putword
    ld      hl,0
    call    __agon_putword
    ret
