; Usage: circle(int x, int y, int radius, int skip);

;    HiRez, NO radius correction square pixels assumed
;    Opt by Stefano, 2019: no table on stack, index register is now used for plot sub
;
;


  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        SECTION code_graphics
        PUBLIC  w_draw_circle
        EXTERN  l_graphics_cmp



;Entry:
;      de = x0, hl = y0, bc = radius, a = scale factor
;      b=x0 c=y0, d=radius, e=scale factor
;      ix=plot routine

w_draw_circle:
    ;ld    (w_pix+1),ix

;    ld ix,-11   ;create buffer on stack
;    add ix,sp
;    ld sp,ix
        ld      a, 1
        ld      (scale), a              ;step factor - usually 1

        ld      (x0l), de
        ld      (y0l), hl
        ld      (rlv), bc

    ;call l9900
    ;ld hl,11
    ;add hl,sp
    ;ld sp,hl
    ;ret

;Line 9900
l9900:
        xor     a
        ld      (cxl), a
        ld      (cxh), a
        srl     b
        rr      c
        ld      (dal), bc
;Line 9905
l9905:
        ld      bc, (rlv)
        ld      de, (cxl)
        ld      h, b
        ld      l, c
        call    l_graphics_cmp
        ret     nc
;Line 9910
        ld      a, (dahi)
        bit     7, a
        jr      z, l9915

        ld      bc, (dal)
        ld      hl, (rlv)
        add     hl, bc
        ld      b, h
        ld      c, l
        ld      (dal), bc

        ld      de, (rlv)
        ld      a, (scale)
        ld      c, a
        ld      b, 0
        ld      h, d
        ld      l, e
        or      a                       ; CY = 0
        sbc     hl, bc
        ld      b, h
        ld      c, l
        ld      (rlv), bc
;Line 9915
l9915:
        ld      bc, (dal)
        dec     bc
        ld      h, b
        ld      l, c
        ld      de, (cxl)
        or      a
        sbc     hl, de
        ld      b, h
        ld      c, l
        ld      (dal), bc

l9920:
        ld      bc, (y0l)
        ld      de, (rlv)
    ;srl d
    ;rr e
        ld      h, b
        ld      l, c
        add     hl, de
        push    hl

        ld      bc, (x0l)
        ld      de, (cxl)
        ld      h, b
        ld      l, c
        add     hl, de
        pop     de

        call    do_w_plot               ; (cx,r)

        ld      bc, (y0l)
        ld      de, (rlv)
    ;srl d
    ;rr e
        ld      h, b
        ld      l, c
        add     hl, de
        push    hl

        ld      bc, (x0l)
        ld      de, (cxl)
        ld      h, b
        ld      l, c
        or      a
        sbc     hl, de
        pop     de

        call    do_w_plot               ; (-cx,r)

        ld      bc, (y0l)
        ld      de, (rlv)
    ;srl d
    ;rr e
        ld      h, b
        ld      l, c
        or      a
        sbc     hl, de
        push    hl

        ld      bc, (x0l)
        ld      de, (cxl)
        ld      h, b
        ld      l, c
        add     hl, de
        pop     de

        call    do_w_plot               ; (cx,-r)

        ld      bc, (y0l)
        ld      de, (rlv)
    ;srl d
    ;rr e
        ld      h, b
        ld      l, c
        or      a
        sbc     hl, de
        push    hl

        ld      bc, (x0l)
        ld      de, (cxl)
        ld      h, b
        ld      l, c
        or      a
        sbc     hl, de
        pop     de

        call    do_w_plot               ; (-cx,-r)


        ld      bc, (y0l)
        ld      de, (cxl)
    ;srl d
    ;rr e
        ld      h, b
        ld      l, c
        add     hl, de
        push    hl

        ld      bc, (x0l)
        ld      de, (rlv)
        ld      h, b
        ld      l, c
        add     hl, de
        pop     de

        call    do_w_plot               ; (r,cx)

        ld      bc, (y0l)
        ld      de, (cxl)
    ;srl d
    ;rr e
        ld      h, b
        ld      l, c
        add     hl, de
        push    hl

        ld      bc, (x0l)
        ld      de, (rlv)
        ld      h, b
        ld      l, c
        or      a
        sbc     hl, de
        pop     de

        call    do_w_plot               ; (-r,cx)

        ld      bc, (y0l)
        ld      de, (cxl)
    ;srl d
    ;rr e
        ld      h, b
        ld      l, c
        or      a
        sbc     hl, de
        push    hl

        ld      bc, (x0l)
        ld      de, (rlv)
        ld      h, b
        ld      l, c
        add     hl, de
        pop     de

        call    do_w_plot               ; (r,-cx)

        ld      bc, (y0l)
        ld      de, (cxl)
    ;srl d
    ;rr e
        ld      h, b
        ld      l, c
        or      a
        sbc     hl, de
        push    hl

        ld      bc, (x0l)
        ld      de, (rlv)
        ld      h, b
        ld      l, c
        or      a
        sbc     hl, de
        pop     de

        call    do_w_plot               ; (-r,-cx)

        ld      bc, (cxl)
        ld      a, (scale)
        ld      e, a
        ld      d, 0
        ld      h, b
        ld      l, c
        add     hl, de
        ld      b, h
        ld      c, l
        ld      (cxl), bc
        jp      l9905


;    SECTION smc_clib

do_w_plot:
        jp      (ix)


        SECTION bss_graphics


x0l:    defb    0
x0h:    defb    0

y0l:    defb    0
y0h:    defb    0

rlv:    defb    0
rh:     defb    0

cxl:    defb    0
cxh:    defb    0

dal:    defb    0
dahi:   defb    0

scale:  defb    0

  ENDIF
