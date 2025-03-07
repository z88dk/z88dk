
    SECTION code_graphics

    PUBLIC  xorpixel

    EXTERN  sety
    EXTERN  setx
    EXTERN  getpat

    EXTERN  __gfx_coords

; in: hl=(x,y)
xorpixel:
    push    af
    push    bc
    push    hl

    ld      (__gfx_coords), hl
    call    sety
    call    getpat
    call    setx

    in      a, (c)                   ; dummy read
    in      a, (c)                   ; read data
    xor     d
    call    setx                     ; to prevent automatic increment of lcd driver
    out     (c), a                   ; write data

    pop     hl
    pop     bc
    pop     af
    ret
