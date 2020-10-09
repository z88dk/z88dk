

        MODULE  tms9918_console_vpeek
        SECTION code_clib
        PUBLIC  __tms9918_console_vpeek

        EXTERN  generic_console_font32
        EXTERN  generic_console_udg32
        EXTERN  screendollar
        EXTERN  screendollar_with_count
        EXTERN  __tms9918_screen_mode
        EXTERN  __tms9918_text_xypos

        EXTERN  LDIRMV
	EXTERN	CONSOLE_XOFFSET
	EXTERN	CONSOLE_YOFFSET

        INCLUDE "video/tms9918/vdp.inc"

IF VDP_EXPORT_DIRECT = 1
        PUBLIC  generic_console_vpeek
        defc    generic_console_vpeek = __tms9918_console_vpeek
ENDIF

__tms9918_console_vpeek:
        ld      a,(__tms9918_screen_mode)
        cp      2
        jr      z,vpeek_mode2
; So here we have the text modes
        push    ix
        call    __tms9918_text_xypos
        ; hl = screen address, now read that byte
        ex      de,hl
        push    de      ;Just some space
        ld      hl,0
        add     hl,sp
        ex      de,hl   ;de = space on stack, hl = screen address
        ld      bc,1
        call    LDIRMV
        pop     bc
        pop     ix
        ld      a,c
        and     a
        ret



vpeek_mode2:
        push    ix
        ld      a,c
	add	CONSOLE_XOFFSET
        add     a
        add     a
        add     a
        ld      e,a        
	ld	a,CONSOLE_YOFFSET
	add	b
        ld      d,a
        ld      hl,-8
        add     hl,sp
        ld      sp,hl
        push    hl                ;save buffer
        ; de = VDP address
        ; hl = buffer
        ex      de,hl
        ld      bc,8
        call    LDIRMV
        pop     de                ;buffer
        ld      hl,(generic_console_font32)
        call    screendollar
        jr      nc,gotit
        ld      hl,(generic_console_udg32)
        ld      b,128
        call    screendollar_with_count
        jr      c,gotit
        add     128
gotit:
        ex      af,af
        ld      hl,8
        add     hl,sp
        ld      sp,hl
        ex      af,af
        pop     ix
        ret
