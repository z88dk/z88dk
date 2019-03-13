

	MODULE	tms9918_generic_console
        SECTION code_clib

        EXTERN	__tms9918_cls
        PUBLIC  __tms9918_scrollup
        PUBLIC  __tms9918_printc
        PUBLIC  __tms9918_set_ink
        PUBLIC  __tms9918_set_paper
        PUBLIC  __tms9918_set_inverse
        EXTERN  __tms9918_attribute
        EXTERN  __tms9918_text_xypos

        EXTERN  generic_console_font32
        EXTERN  generic_console_udg32

        EXTERN  __console_w
        EXTERN  ansi_SCROLLUP
        EXTERN  ansi_cls
        EXTERN  conio_map_colour
        EXTERN  generic_console_flags
        EXTERN  __tms9918_screen_mode
        EXTERN  __tms9918_scroll_buffer
        EXTERN  FILVRM
        EXTERN  LDIRVM
        EXTERN  LDIRMV

        INCLUDE "video/tms9918/vdp.inc"


;
; The SPC-1000 has both a MC6847 and optionally a TMS9228A
;
; To support both we want the MC6847 to be the primary, and
; the VDP as the slave, so don't export the tms symbols as
; generic_console_*
;
; The Tatung Einstein has a TMS9928A as a main display and
; an 80 column 6845 as a secondary display.
;
IF VDP_EXPORT_DIRECT = 1
        PUBLIC  generic_console_cls
        PUBLIC  generic_console_scrollup
        PUBLIC  generic_console_printc
        PUBLIC  generic_console_set_ink
        PUBLIC  generic_console_set_paper
        PUBLIC  generic_console_set_inverse

        defc        generic_console_cls = __tms9918_cls
        defc        generic_console_scrollup = __tms9918_scrollup
        defc        generic_console_printc = __tms9918_printc
        defc        generic_console_set_ink = __tms9918_set_ink
        defc        generic_console_set_paper = __tms9918_set_paper
        defc        generic_console_set_inverse = __tms9918_set_inverse
ENDIF


__tms9918_set_inverse:
        ret

__tms9918_set_ink:
        call    conio_map_colour
        rla
        rla
        rla
        rla
        and     @11110000
        ld      b,0x0f
set_attr:
        ld      c,a
        ld      hl,__tms9918_attribute
        ld      a,(hl)
        and     b
        or      c
        ld      (hl),a
        ret

__tms9918_set_paper:
        call    conio_map_colour
        and     15
        ld      b,0xf0
        jr      set_attr
        


__tms9918_scrollup:
        push    de
        push    bc
        ld      a,(__tms9918_screen_mode)
        ld      b,3
        ld      hl,32
        and     a
        jr      z,scroll_text
        ld      b,4
        ld      hl,40
        cp      1
        jr      z,scroll_text
        call    ansi_SCROLLUP
scroll_rejoin:
        pop     bc
        pop     de
        ret


; Entry: bc = width
scroll_text:
        push    ix
        push    hl      ;Save width for later
        ld      de,0    ;destination
scroll_text_1:
        push    bc
        push    hl      ;Source
        push    de      ;Destination

        ld      de,__tms9918_scroll_buffer
        ld      bc,256
        call    LDIRMV
        pop     de
        push    de
        ld      hl,__tms9918_scroll_buffer
        ld      bc,256
        call    LDIRVM
        pop     de      ;Destination
        pop     hl
        inc     d
        inc     h
        pop     bc
        djnz    scroll_text_1
        ; And blank characters out
        ld      b,23
        ld      c,0
        call    __tms9918_text_xypos
        pop     bc
        ld      a,' '
        call    FILVRM
        pop     ix
        jr      scroll_rejoin




; c = x
; b = y
; a = d = character to print
; e = raw
__tms9918_printc:
        push    ix
        ld      a,(__tms9918_screen_mode)
        cp      2
        jr      z,tms9918_printc_1
        push    de                ;Save character
        call    __tms9918_text_xypos
        pop     de
        ld      a,d
        ld      bc,1
        call    FILVRM
        pop     ix
        ret
tms9918_printc_1:
        ld      a,d
        ld      de,(generic_console_font32)
        dec     d
        bit     7,a
        jr      z,tms9918_printc_rejoin
        ld      de,(generic_console_udg32)
        res     7,a
tms9918_printc_rejoin:
        ld      l,a
        ld      h,0
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,de
        ld      a,c
        add     a
        add     a
        add     a
        ld      e,a
        ld      d,b
        push    de
        ld      bc,8
        call    LDIRVM
        pop     hl
        ld      de,8192
        add     hl,de        
        push    hl
        ld      a,(__tms9918_attribute)
        ld      hl,generic_console_flags
        bit     7,(hl)
        jr      z,not_inverse
        rlca
        rlca
        rlca
        rlca
not_inverse:
        pop     hl
        ld      bc,8
        call    FILVRM
        pop     ix
        ret


