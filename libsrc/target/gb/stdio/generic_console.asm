

        SECTION         code_driver

        PUBLIC          generic_console_cls
        PUBLIC          generic_console_vpeek
        PUBLIC          generic_console_pointxy
        PUBLIC          generic_console_scrollup
        PUBLIC          generic_console_printc
        PUBLIC          generic_console_plotc
        PUBLIC          generic_console_set_ink
        PUBLIC          generic_console_set_paper
        PUBLIC          generic_console_set_attribute

        GLOBAL          asm_setchar
        GLOBAL          asm_wrtchr
        GLOBAL          asm_scroll
        GLOBAL          asm_cls
        GLOBAL          asm_clg
        GLOBAL          vpeek_MODE1
	GLOBAL		pointxy_MODE1

        GLOBAL          __fgcolour
        GLOBAL          __bgcolour
        GLOBAL          __mode

        INCLUDE "target/gb/def/gb_globals.def"

        EXTERN          CONSOLE_COLUMNS
        EXTERN          CONSOLE_ROWS
        EXTERN          generic_console_font32
        EXTERN          generic_console_udg32

generic_console_set_attribute:
        ret
generic_console_set_ink:
        and     3
        ld      (__fgcolour),a
        ret
generic_console_set_paper:
        and     3
        ld      (__bgcolour),a
        ret


generic_console_cls:
        ld      a,(__mode)
        dec     a
        jp      z,asm_clg
        jp      asm_cls
        
;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_pointxy:
        ld      a,(__mode)
	dec	a
	jp	z,pointxy_MODE1
	jr	vpeek_console

;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        ld      a,(__mode)
        dec     a
        jp      z,vpeek_MODE1
vpeek_console:
        ld      l,b           ; Y coordinate
        ld      h,0x00
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,hl
        ld      b,0x98
        add     hl,bc
vpeek_1:
        ldh     a,(STAT)
        bit     1,a
        jr      nz,vpeek_1
        ld      a,(hl)
        and     a
        ret



; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_plotc:
generic_console_printc:
    ld      a,(__mode)
    dec     a
    ld      a,d
    jp      nz,asm_setchar          ; Text mode
    push    bc
    ld      c,a
    cp      128
    jr      c,not_udg
    sub     128
    ld      c,a
    ; UDGs are just there with no header
    ld      hl,generic_console_udg32
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a
    jr      do_print
not_udg:
    ld      c,a
    ld      hl,generic_console_font32
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a
    ld      a,(hl+) ;Font type
    inc     hl      ;Skips to the start of encoding table if present
    and     3
    ld      de,128
    cp      FONT_128ENCODING
    jr      z,add_offset
    ld      de,0
    cp      FONT_NOENCODING
    jr      z,add_offset
    ld      d,1
add_offset:
    add     hl,de
do_print:
    ld      a,c
    pop     bc      ;Get coordinates back out
    jp      asm_wrtchr


generic_console_scrollup:
    ld      a,(__mode)
    dec     a
    call    nz,asm_scroll
    ret
