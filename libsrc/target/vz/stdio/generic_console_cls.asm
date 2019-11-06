
    SECTION code_clib

    PUBLIC  generic_console_cls

    EXTERN  __vz200_mode
    EXTERN  base_graphics



generic_console_cls:
    ld      a,(__vz200_mode)
    ld      bc,512
    and     a
    ld      a,' '
    jr      z,cls_1
    ld      bc,2048
    xor     a
cls_1:
    ld      hl, (base_graphics)
    ld      d,h
    ld      e,l
    inc     de
    ld      (hl),a
    ldir
    ret