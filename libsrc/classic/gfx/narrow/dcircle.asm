IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION code_graphics
    PUBLIC  draw_circle


    DEFVARS 0
    {
        x0              ds.b 1
        y0              ds.b 1
        radius          ds.b 1
        scale           ds.b 1
        cx              ds.b 1
        da              ds.b 1
        func            ds.w 1
    }



;ix points to table on stack (above)

;Entry:
;     b=x0 c=y0, d=radius, e=scale factor
;     ix=plot routine

draw_circle:
    ld      ix, -8                      ;create buffer on stack
    add     ix, sp
    ld      sp, ix
    ld      (ix+x0), b
    ld      (ix+y0), c
    ld      (ix+radius), d
    ld      (ix+scale), e               ;step factor - usually 1
    ld      (ix+func), l
    ld      (ix+func+1), h
    call    l9900
    ld      hl, 8
    add     hl, sp
    ld      sp, hl
    ret

;Line 9900
l9900:
    ld      (ix+cx), 0
    srl     d
    ld      (ix+da), d
;Line 9905
l9905:
    ld      a, (ix+cx)
    cp      (ix+radius)
    ret     nc
;Line 9910
    ld      a, (ix+da)
    and     a
    jp      p, l9915
    add     a, (ix+radius)
    ld      (ix+da), a
    ld      a, (ix+radius)
    sub     (ix+scale)
    ld      (ix+radius), a
;Line 9915
l9915:
    ld      a, (ix+da)
    dec     a
    sub     (ix+cx)
    ld      (ix+da), a

l9920:
    ld      a, (ix+y0)
    add     a, (ix+radius)
    ld      l, a
    ex      af, af'
    ld      a, (ix+x0)
    add     a, (ix+cx)
    ld      h, a
    call    doplot
    ex      af, af'
    ld      l, a
    ld      a, (ix+x0)
    sub     (ix+cx)
    ld      h, a
    call    doplot

    ld      a, (ix+y0)
    sub     (ix+radius)
    ld      l, a
    ex      af, af'
    ld      a, (ix+x0)
    add     a, (ix+cx)
    ld      h, a
    call    doplot
    ex      af, af'
    ld      l, a
    ld      a, (ix+x0)
    sub     (ix+cx)
    ld      h, a
    call    doplot

;Line 9925

    ld      a, (ix+y0)
    add     a, (ix+cx)
    ld      l, a
    ex      af, af'
    ld      a, (ix+x0)
    add     a, (ix+radius)
    ld      h, a
    call    doplot
    ex      af, af'
    ld      l, a
    ld      a, (ix+x0)
    sub     (ix+radius)
    ld      h, a
    call    doplot

    ld      a, (ix+y0)
    sub     (ix+cx)
    ld      l, a
    ex      af, af'
    ld      a, (ix+x0)
    add     a, (ix+radius)
    ld      h, a
    call    doplot
    ex      af, af'
    ld      l, a
    ld      a, (ix+x0)
    sub     (ix+radius)
    ld      h, a
    call    doplot

;Line 9930
    ld      a, (ix+cx)
    add     a, (ix+scale)
    ld      (ix+cx), a
    jp      l9905

;Entry to my plot is the same as for the z88 plot - very convenient!

doplot:
    ret     c
    push    ix
    ld      e, (ix+func)
    ld      d, (ix+func+1)
    push    de
    pop     ix
    ; h, l = coordinates
    call    jpix
    pop     ix
    ret
jpix:
    jp      (ix)

ENDIF
