

    MODULE  tms9918_console_vpeek
    SECTION code_video_vdp
    PUBLIC  __tms9918_console_vpeek
    PUBLIC  __tms9918_vpeek_continue

    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  screendollar
    EXTERN  screendollar_with_count
    EXTERN  __tms9918_screen_mode
    EXTERN  __tms9918_text_xypos
    EXTERN  __v9938_mode5_vpeek
    EXTERN  __v9938_mode6_vpeek
    EXTERN  __v9938_mode8_vpeek

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
IF V9938
        cp      80
        jr      z,text_vpeek
        cp      5
        jp      z,__v9938_mode5_vpeek
        cp      6
        jp      z,__v9938_mode6_vpeek
        cp      8
        jp      z,__v9938_mode8_vpeek
ENDIF
        cp      2
        jr      z,vpeek_mode2
        ccf
        ret     c           ;Not a text mode
text_vpeek:
        ; So here we have the text modes
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
        ld      a,c
        and     a
        ret



vpeek_mode2:
    ld      a,c
    add     CONSOLE_XOFFSET
    add     a
    add     a
    add     a
    ld      e,a        
    ld      a,CONSOLE_YOFFSET
    add     b
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
__tms9918_vpeek_continue:
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
    ret
