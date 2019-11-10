
    SECTION code_clib

    PUBLIC  generic_console_cls

    EXTERN  __console_w
    EXTERN  __x1_attr
    defc    DISPLAY = $3000



generic_console_cls:
    ld      bc,DISPLAY
    ld      hl,(__console_w)	;l = w, h = height
cls_1:
    ld      a,' '
    out     (c),a
    res     4,b
    ld      a,(__x1_attr)
    out     (c),a
    set     4,b
    inc     bc
    dec     l
    jr      nz,cls_1
    dec     h
    jr      nz,cls_1
    ret
