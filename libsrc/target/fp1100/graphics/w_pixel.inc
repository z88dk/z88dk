
    EXTERN  w_pixeladdress

    EXTERN  getmaxy
    EXTERN  getmaxx
    EXTERN  l_cmp
    EXTERN  __gfx_coords
    EXTERN  __fp1100_plot_buffer

    EXTERN  __fp1100_attr

    INCLUDE "target/fp1100/def/fp1100.def"

; Generic code to handle the pixel commands
; Define NEEDxxx before including

    push    hl		;save x
    call    getmaxy		;hl = maxy
    inc     hl
    call    l_cmp
    pop     hl
    ret     nc

    ex      de,hl		;de = x, hl = y
    push    hl		;save y
    call    getmaxx
    inc     hl
    call    l_cmp
    pop     hl
    ret     nc
    ex      de,hl
    ld      (__gfx_coords),hl	;x
    ld      (__gfx_coords+2),de	;y
    push    bc
    call    w_pixeladdress
IF NEEDplot
    ld      a,(__fp1100_attr)
    and     7
    or      GMODE_PIX_OR
    ld      b,a
    ld      a,SUB_GATTR
    call    TRNC2
    ld      b,9
    ld      hl,__fp1100_plot_buffer
    ld      a,SUB_PLOT
    call    TRNCx
ENDIF
IF NEEDunplot
    ld      a,(__fp1100_attr)
    rrca
    rrca
    rrca
    rrca
    and     7
    or      GMODE_PIX_OFF
    ld      b,a
    ld      a,SUB_GATTR
    call    TRNC2
    ld      b,9
    ld      a,SUB_PLOT
    ld      hl,__fp1100_plot_buffer
    call    TRNCx
ENDIF
IF NEEDxor
    ld      a,(__fp1100_attr)
    and     7
    or      GMODE_PIX_XOR
    ld      b,a
    ld      a,SUB_GATTR
    call    TRNC2
    ld      b,9
    ld      a,SUB_PLOT
    ld      hl,__fp1100_plot_buffer

    call    TRNCx
ENDIF
IF NEEDpoint
    ld      b,4
    ld      hl,__fp1100_plot_buffer
    ld      a,SUB_POINT
    call    TRNCx
    call    READB
    and     a
ENDIF
    pop     bc		;Restore callers
    ret
