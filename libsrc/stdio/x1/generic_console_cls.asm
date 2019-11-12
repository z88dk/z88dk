
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
    ;; TODO Set palette
    call    gclr
    ret


gclr:   DI
        LD      BC,1A03H        ;Write to all planes
        LD      A,11
        OUT     (C),A
        DEC     A
        OUT     (C),A
        LD      BC,4000H
GCLSLP: XOR     A
        DEC     BC
        OUT     (C),A
        LD      A,B
        OR      C
        JR      NZ,GCLSLP
        DEC     BC
        IN      A,(C)
        EI
        RET
