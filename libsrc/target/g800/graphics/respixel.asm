
    SECTION code_graphics

    PUBLIC  respixel

    EXTERN  sety
    EXTERN  setx
    EXTERN  getpat

    EXTERN  __gfx_coords

; in: hl=(x,y)
respixel:
    push    af
    push    bc
    push    hl

    ld      (__gfx_coords), hl
    call    sety
    call    getpat
    ld      a, d
    cpl
    ld      d, a
    call    setx
	
    in      a, (c)                   ;dummy read
    in      a, (c)                   ;read data
    and     d
    call    setx                     ; to prevent automatic increment of lcd driver
    exx
    out     (c), a                   ;write data
	
    pop     hl
    pop     bc
    pop     af
    ret
