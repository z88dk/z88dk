

    PUBLIC  cls_MODE1
    PUBLIC  printc_MODE1
    PUBLIC  vpeek_MODE1
    PUBLIC  scrollup_MODE1

    EXTERN  __krt_cls
    EXTERN  __krt_printc
    EXTERN  __krt_vpeek
    EXTERN  __krt_scrollup

    defc    cls_MODE1 = __krt_cls
    defc    printc_MODE1 = __krt_printc
    defc    vpeek_MODE1 = __krt_vpeek
    defc    scrollup_MODE1 = __krt_scrollup

    EXTERN  __z9001_attr

    PUBLIC  __krt_hook_cls_colour
    PUBLIC  __krt_hook_set_colour
    PUBLIC  __krt_hook_scrollup_colour

    EXTERN  KRT_ADDRESS
    EXTERN  KRT_ROWS
    EXTERN  KRT_COLUMNS

; Set colour
; Entry: hl = screen address
__krt_hook_set_colour:
    dec     h
    dec     h
    dec     h
    dec     h
    ld      a,(__z9001_attr)
    ld      (hl),a
    ret

__krt_hook_cls_colour:
    ld      hl,KRT_ADDRESS - 1024
    ld      de,KRT_ADDRESS - 1024 + 1
    ld      bc,+(KRT_COLUMNS * KRT_ROWS) - 1
    ld      a,(__z9001_attr)
    ld      (hl),a
    ldir
    ret

__krt_hook_scrollup_colour:
    ld      hl,KRT_ADDRESS - 1024 + KRT_COLUMNS
    ld      de,KRT_ADDRESS - 1024
    ld      bc,+(KRT_COLUMNS * (KRT_ROWS-1)) - 1
    ldir
    ex      de,hl
    ld      d,h
    ld      e,l
    inc     de
    ld      a,(__z9001_attr)
    ld      (hl),a
    ld      bc,KRT_COLUMNS - 1
    ldir
    ret
