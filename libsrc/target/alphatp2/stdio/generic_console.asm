; Generic console/graphics driver for the VTAC5027 / TMS9927 CRTC
; 

    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_vpeek
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute
    PUBLIC  generic_console_ioctl
    EXTERN  generic_console_flags
    EXTERN  generic_console_plotc
    EXTERN  generic_console_pointxy

    EXTERN  CONSOLE_COLUMNS
    EXTERN  CONSOLE_ROWS

    EXTERN  generic_console_flags

    defc    DISPLAY=0x3000

    INCLUDE "ioctl.def"
    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS=CAP_GENCON_INVERSE


generic_console_ioctl:
    scf
generic_console_set_ink:
generic_console_set_paper:
generic_console_set_attribute:
    ret


generic_console_cls:
    ld      hl, DISPLAY
    ld      de,128
    ld      c, CONSOLE_ROWS
generic_console_cls_1:
    push    hl
    ld      b, CONSOLE_COLUMNS
generic_console_cls_2:
    ld      (hl), 32
	inc     hl
    djnz    generic_console_cls_2:
    pop     hl
    add     hl,de
    dec     c
    jr      nz,generic_console_cls_1

    ld      hl,screen_copy
    ld      de,screen_copy+1
    ld      bc,+((CONSOLE_ROWS+1) * CONSOLE_COLUMNS) - 1
    ld      (hl),32
    ldir

    ret



generic_console_printc:
    ld      a,(generic_console_flags)
    and     128
    or      d
generic_console_printc_no_flags:
    push    bc
    call    xypos
    ld      (hl),a
    pop     bc
    ld      hl, DISPLAY - 128
    ld      de, 128
    inc     b
generic_console_printc_1:
    add     hl, de
    djnz    generic_console_printc_1
    add     hl, bc
    ld      (hl), a

    ret

generic_console_plotc:
    cp      0x20
    jr      c, generic_console_printc_no_flags
    ld      a,0x3f
    sub     d
    or      128
    jr      generic_console_printc_no_flags


;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    call    xypos
    ld      a,(hl)
    and     127
    ret

generic_console_pointxy:
    call    xypos
    ld      a,(hl)
    cp      0x80
    jr      nc, point_high_graphics
    cp      0x20
    ret     c
fail_point:
    xor     a
    ret
point_high_graphics:
    cp      $a0
    jr      nc,fail_point 
    ld      a,0x9f
    sub     (hl)
    and     0x1f
    add     0x20
    ret

; b = row
; c = column
xypos:
    ld      hl,screen_copy - CONSOLE_COLUMNS
    ld      de,CONSOLE_COLUMNS
    inc     b
generic_console_xypos_1:
    add     hl,de
    djnz    generic_console_xypos_1
    add     hl,bc                   ;hl now points to address in display
    ret



; We avoid LDIR to be 8085 compatible
generic_console_scrollup:
    push    de
    push    bc

    ld      hl,screen_copy + CONSOLE_COLUMNS
    ld      de,screen_copy
    ld      bc,+((CONSOLE_ROWS) * CONSOLE_COLUMNS)   ; 1 more row to wipe the bottom row
    ldir
    ex      de,hl
    ld      de,hl
    inc     hl
    ld      bc,CONSOLE_COLUMNS - 1
    ld      (hl),32
    ldir
    

    ld      hl, DISPLAY
	ld      de, screen_copy
    ld      c,CONSOLE_ROWS-1

generic_console_scrollup_1:

    ld      b,CONSOLE_COLUMNS
generic_console_scrollup_2:
    ld      a,(de)
    ld      (hl),a
    inc     hl
    inc     de
    djnz    generic_console_scrollup_2
	
    push    de
    ld      de,128-80
    add     hl,de
    pop     de

    dec     c
    jr      nz,generic_console_scrollup_1

    ld      b, CONSOLE_COLUMNS
generic_console_scrollup_3:
    ld      (hl), 32
    inc     hl
    djnz    generic_console_scrollup_3

    pop     bc
    pop     de
    ret



    SECTION	bss_clib

screen_copy:	
    defs	80 * 26		;Hopefully big enough?



    SECTION code_crt_init

    ; Init CRTC (and reset scroll register)
    ld      hl,(1BF3h)
    ;LD (3FFEh),A   ; Writing to this register makes the screen scroll up
    ld      bc,3FF0h
    ld      e,7   ; the table contains 7 bytes, we will force the last ones
vtac_init:
    ld      a,(hl)
    ld      (bc),a
    inc     hl
    inc     bc
    dec     e
    jp      nz,vtac_init

    ld      c,$0c	;Reset the video driver, reset scroll register
    call    $00b6

    ; Hide cursor
    ld      a,80
    ld      (3FFCh),a
