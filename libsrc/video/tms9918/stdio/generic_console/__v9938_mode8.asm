; This file is not universal - we use 8 bit IO
SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC __v9938_mode8_printc
PUBLIC __v9938_mode8_scroll

EXTERN  generic_console_font32
EXTERN  generic_console_udg32
EXTERN  generic_console_flags

EXTERN  l_tms9918_disable_interrupts
EXTERN  l_tms9918_enable_interrupts

EXTERN  __tms9918_pattern_name
EXTERN  __tms9918_attribute

EXTERN  __tms9918_8bpp_attr
EXTERN  __tms9918_scroll_buffer

EXTERN  __v9938_wait_vdp

EXTERN  __v9938_YMMM
EXTERN  FILVRM
EXTERN  LDIRVM
EXTERN  SETWRT
EXTERN  __v9938_mode8_xypos



__v9938_mode8_printc:
    ld      a,d         ;save character
    exx
    ld      bc,(generic_console_font32)
    dec     b
    bit     7,a
    jr      z,handle_characters
    ld      bc,(generic_console_udg32)
    res     7,a
handle_characters:
    ld      l,a
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,bc
    ld      a,(generic_console_flags)
    ld      b,a
    rlca
    sbc     a,a             ; ; c = 0/ c = 255
    ld      c,a
    exx    
    ; bc = b = y, c = x, coordinates to print at
    ; hl' = font
    ; c' = inverse flag
    ; b' = flags
    call    __v9938_mode8_xypos




    ld      b,8     ;8 rows
printc_mode8_1:
    push    bc
    ld      a,b
    exx
    bit     3,b
    jr      z,printc_mode8_no_underline
    cp      1
    jr      nz,printc_mode8_no_underline
    ld      a,255
    jr      printc_mode8_not_bold
printc_mode8_no_underline:
    ld      a,(hl)
    bit     4,b
    jr      z,printc_mode8_not_bold
    rrca
    or      (hl)
printc_mode8_not_bold:
    xor     c
    inc     hl
    exx

    ex      af,af
    call    l_tms9918_disable_interrupts
    call    SETWRT
    ld      de,(__tms9918_8bpp_attr)    ;e = ink, d = paper
    ld      a,8
printc_mode8_2:
    ex      af,af
    rlca    ;Do we need ink or paper?
    ld      c,a     ;Save character
    ld      a,d
    jr      nc,printc_mode8_is_paper
    ld      a,e     ;ink
printc_mode8_is_paper:
IF VDP_DATA < 0
    ld      (-VDP_DATA),a
ELIF VDP_DATA < 256
    out     (VDP_DATA),a
ELSE
    ;; TODO
ENDIF
    ld      a,c
    ex      af,af
    dec     a
    jp      nz,printc_mode8_2
    call    l_tms9918_enable_interrupts
    ld      de,256
    add     hl,de
    pop     bc
    djnz    printc_mode8_1
    ret




__v9938_mode8_scroll:
    ld      bc,0        ;To coordinate 0,0
    ld      l,8
    ld      e,192
    ld      d,2
    call    __v9938_YMMM
    ; Blank out the bottom line of the screen
    ld      hl,(__tms9918_pattern_name)
    ld      de,23*2048
    add     hl,de
    ld      a,(__tms9918_8bpp_attr+1)
    ld      bc,2048
    jp      FILVRM
    


ENDIF
