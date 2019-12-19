
    SECTION code_clib
    PUBLIC  generic_console_xypos

    EXTERN  __x1_mode

    defc    DISPLAY = $3000
    
; We need to multiply by either 40 or 80 depending on the mode
generic_console_xypos:
    ex      af,af
    ld      l,b
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl   ;x8
    ld      e,l
    ld      d,h
    add     hl,hl
    add     hl,hl   ;x32
    add     hl,de   ;x40
    ld      a,(__x1_mode)
    and     a
    jr      z,mode0_xypos
    add     hl,hl   ;x80
mode0_xypos:
    ld      b,+(DISPLAY / 256)
    add     hl,bc   ;add on column + display base
    ex      af,af
    ret