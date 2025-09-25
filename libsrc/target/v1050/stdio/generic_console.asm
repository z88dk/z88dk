
; V1050 <> ADM3A terminal code grabber and converter
; Stefano, May 2023


    SECTION code_clib
    INCLUDE "ioctl.def"

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_vpeek
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute
    PUBLIC  generic_console_ioctl

    EXTERN  asm_load_charset

    EXTERN  CONSOLE_COLUMNS
    EXTERN  CONSOLE_ROWS

    ;EXTERN  __console_x
    ;EXTERN  __console_y
    EXTERN  set_cursor
    ;EXTERN generic_console_flags

    EXTERN  v1050_sendchar

    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS=CAP_GENCON_UDGS|CAP_GENCON_CUSTOM_FONT|CAP_GENCON_INVERSE|CAP_GENCON_BOLD|CAP_GENCON_UNDERLINE

generic_console_cls:
    ld      hl,screen_copy
    ld      de,screen_copy+1
    ld      bc,+(CONSOLE_ROWS * CONSOLE_COLUMNS) - 1
    ld      (hl),32
    ldir
    ld      l, 0x0C
    call    v1050_sendchar
    ld      hl, 0
    jp      set_cursor

generic_console_set_attribute:
		; Set text attribute (underline, inverse, bold)

		;rla		; deal with underline bit
    rra
    jr      nc, noinv

    ld      l, 0x9B                     ; CSI = "ESC["
    call    v1050_sendchar
    ld      l, '7'
    call    v1050_sendchar
    ld      l, 'm'
    call    v1050_sendchar
    ret
noinv:
    ld      l, 0x9B                     ; CSI = "ESC["
    call    v1050_sendchar
    ld      l, '0'
    call    v1050_sendchar
    ld      l, 'm'
    call    v1050_sendchar
    ret


; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
    push    af
    push    bc
    call    xypos
    ld      (hl),a
    pop     bc

		; force cursor position
    ld      l, 27
    call    v1050_sendchar
    ld      l, '='
    call    v1050_sendchar
    ld      a, b    ; y
    add     32
    ld      l, a
    call    v1050_sendchar
    ld      a, c    ; x
    add     32
    ld      l, a
    call    v1050_sendchar

		; send actual character
    pop     af

    cp      128
    jr      c, noudg

    add     32

;		push af
;		ld l,27
;		call v1050_sendchar
;		ld l,'('
;		call v1050_sendchar
;		ld l,'1'	; Select alternate font
;		call v1050_sendchar
;		pop af

noudg:

;		push af
;		ld l,27
;		call v1050_sendchar
;		ld l,'('
;		call v1050_sendchar
;		ld l,'0'	; Select standard font
;		call v1050_sendchar
;		pop af

    ld      l, a
    jp      v1050_sendchar

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    call    xypos
    ld      a,(hl)
    and     a
    ret

xypos:
    ld      hl,screen_copy - CONSOLE_COLUMNS
    ld      de,CONSOLE_COLUMNS
    inc     b
generic_console_printc_1:
    add     hl,de
    djnz    generic_console_printc_1
generic_console_printc_3:
    add     hl,bc                   ;hl now points to address in display
    ret


; a = ioctl
; de = arg
generic_console_ioctl:

    ex      de, hl
    ld      c, (hl)                     ;bc = where we point to
    inc     hl
    ld      b, (hl)

    cp      IOCTL_GENCON_SET_FONT32
    jr      nz, check_set_udg

        ;ld      (generic_console_font32),bc
    ld      l, c
    ld      h, b
    ld      b, 96
    ld      c, 0
    call    asm_load_charset
success:
    and     a
    ret

check_set_udg:
    cp      IOCTL_GENCON_SET_UDGS
    jr      nz, failure

    ld      l, 27
    call    v1050_sendchar
    ld      l, ')'
    call    v1050_sendchar
    ld      l, '1'                      ; Select G1 for the extended font
    call    v1050_sendchar

        ;ld      (generic_console_udg32),bc
    ld      l, c
    ld      h, b
; 96 redefinable characters in G1 mode
    ld      b, 96
    ld      c, 96
    call    asm_load_charset

; 64 redefinable characters in G2 mode
; we keep them for low resolution graphics (clg6/loadudg6 will load the pseudo-graphics font)
;    ld      b, 64
;    ld      c, 192
;    call    asm_load_charset

    jr      success

failure:
    scf
    ret



generic_console_scrollup:
    push    de
    push    bc
    ld      hl,screen_copy + CONSOLE_COLUMNS
    ld      de,screen_copy
    ld      bc,+((CONSOLE_ROWS-1) * CONSOLE_COLUMNS)
    ldir
    ex      de,hl
    ld      b,CONSOLE_COLUMNS
cls_1:
    ld      (hl),32
    inc     hl
    djnz    cls_1
    ; place cursor at the bottom row..
    ld      l, 27
    call    v1050_sendchar
    ld      l, '='
    call    v1050_sendchar
    ld      l, 32+24
    call    v1050_sendchar
    ld      l, 32
    call    v1050_sendchar
    ; and send LF
    ld      l, 10
    call    v1050_sendchar
    pop     bc
    pop     de
    ret


generic_console_set_ink:
generic_console_set_paper:
    ret


    SECTION bss_clib

screen_copy:
    defs  80 * 25    ;Hopefully big enough?

    SECTION code_crt_init

    EXTERN  CRT_FONT
    EXTERN  asm_load_charset
    EXTERN  base_graphics

    ld      hl, screen_copy
    ld      (base_graphics),hl
    ld      hl, CRT_FONT
    ld      a, h
    or      l
    jr      z, no_custom_font
    ld      b, 96
    ld      c, 0
    call    asm_load_charset
no_custom_font:
