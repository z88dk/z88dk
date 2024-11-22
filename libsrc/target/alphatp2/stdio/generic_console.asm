

    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute
    PUBLIC  generic_console_ioctl


    EXTERN  CONSOLE_COLUMNS
    EXTERN  CONSOLE_ROWS

    EXTERN  generic_console_flags

    defc    DISPLAY=0x3000

    INCLUDE "ioctl.def"
    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS=CAP_GENCON_INVERSE

generic_console_ioctl:
    scf
generic_console_set_paper:
generic_console_set_attribute:
generic_console_set_ink:
    ret


generic_console_scrollup:
    push    bc
    push    de
    ld      de, DISPLAY
    ld      hl, DISPLAY+128
    ld      c, CONSOLE_ROWS
sloop1:
    ld      b, CONSOLE_COLUMNS
sloop2:
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    djnz    sloop2
    ld      de, 128 - CONSOLE_COLUMNS
    add     hl, de
    ld      d, h
    ld      e, l
    ld      a,e
    sub     128
    ld      e,a
    ld      a,d
    sbc     0
    ld      d,a
    dec     c
    jr      nz, sloop1
    ld      b, CONSOLE_COLUMNS
    ld      a,32
sloop4:
    ld      (de), a
    inc     de
    dec     b
    jr      nz, sloop4
    pop     de
    pop     bc
    ret

generic_console_cls:
    ret
    ld      hl, DISPLAY
    ld      c, CONSOLE_ROWS
loop1:
    ld      b, CONSOLE_COLUMNS
loop2:
    ld      (hl), 32
    inc     hl
    djnz    loop2
    ld      de, 128 - CONSOLE_COLUMNS
    add     hl, de
    dec     c
    jr      nz, loop1
    ret

generic_console_printc:
    call    xypos
    ld      a, (generic_console_flags)
    and     128
    or      d
    ld      (hl), a
    ret

generic_console_vpeek:
   ;; TODO, appears to be write only?
    call    xypos
    ld      a,(hl)
    and     a
    ret


; Entry: b = row
;	 c = column
; Exit:	hl = address
xypos:
   ;128 byles per row
    ld      l,b
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    ld      b,+(DISPLAY/256)
    add     hl,bc
    ret


    SECTION code_crt_init

    ld      c,$0c	;Reset the video driver, reset scroll register
    call    $00b6
