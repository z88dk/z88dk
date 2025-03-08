    section code_clib

    public  sety
    public  setx
    public  getpat

sety:
; set y position
; in:  l = y position
    push    af

    ld      a, 0x40                     ; set startline to 0
    call    out40

    ld      a, l
    rra
    rra
    rra                               ; a=y/8
    and     0x0f
    or      0xb0
    call    out40
    exx
    ld      bc,41h                      ; output data port, it must be survive through getpat and setx
    exx
    ld      bc,41h                      ; input data port, it must be survive through getpat and setx
    pop     af

    ret

; make pattern
; in: l = y position
; out d = pattern
getpat:
    ld      a, l
    and     0x07                        ;a=y%8
    inc     a
    ld      d, 0x1
loop_shift:
    dec     a
    ret     z
    sla     d
    jp      loop_shift

; set x position
setx:
    push    af

      ; lower 4bit of x(h)
    ld      a, h
    and     0x0F
    call    out40

      ; higher 4bit of x(h)
    ld      a, h
    rra
    rra
    rra
    rra
    and     0x0f
    or      0x10
    call    out40

    pop     af
    ret

; write to lcd driver
out40:
    push    af
loop40:
    in      a, (0x40)
    and     0x80
    jp      nz, loop40
    pop     af
    out     (0x40), a
    ret
