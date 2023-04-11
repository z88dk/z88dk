
; This file is not universal - we use 8 bit IO
SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC __v9938_mode6_printc
PUBLIC __v9938_mode6_scroll

EXTERN  generic_console_font32
EXTERN  generic_console_udg32
EXTERN  generic_console_flags

EXTERN  l_tms9918_disable_interrupts
EXTERN  l_tms9918_enable_interrupts

EXTERN  __tms9918_pattern_name
EXTERN  __tms9918_2bpp_attr

EXTERN  __tms9918_attribute
EXTERN  __tms9918_scroll_buffer

EXTERN  __v9938_wait_vdp
EXTERN  __v9938_mode6_xypos

EXTERN  __v9938_YMMM
EXTERN  FILVRM
EXTERN  LDIRVM
EXTERN  SETWRT

__v9938_mode6_printc:
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
;Mode 3: 4 pixels per byte
;p0 p0 p1 p1 p2 p2 p3 p3
; Entry:  b = y
;         c = x
;       hl' = font entry to print
;        c' = inverse mask
;        b' = flags
    call    __v9938_mode6_xypos
    ld      b,8
printc_mode6_1:
    push    bc
    ld      a,b
    exx
    bit     3,b
    jr      z,printc_mode6_no_underline
    cp      1
    jr      nz,printc_mode6_no_underline
    ld      a,255
    jr      printc_mode6_not_bold
printc_mode6_no_underline:
    ld      a,(hl)
    bit     4,b
    ld      a,(hl)
    jr      z,printc_mode6_not_bold
    rrca
    or      (hl)
printc_mode6_not_bold:
    xor     c
    inc     hl
    exx

    ex      af,af
    call    l_tms9918_disable_interrupts
    call    SETWRT
    ex      af,af

    ld      b,2
printc_mode6_2:
    ld      de,(__tms9918_2bpp_attr)    ;e = ink, b = paper
    push    bc
    push    hl
    ld      l,a
    ld      b,4    ;4 iterations
    ld      c,0    ;final byte
printc_mode6_3:
    rl      l
    ld      a,d
    jr      nc,is_paper
    ld      a,e
is_paper:
    or      c
    ld      c,a
    srl     d
    srl     d
    srl     e
    srl     e
    djnz    printc_mode6_3
    ld      a,l    ;Save the character for a moment
    pop     hl

    ex      af,af
    ld      a,c
IF VDP_DATA < 0
    ld      (-VDP_DATA),a
ELIF VDP_DATA < 256
    out     (VDP_DATA),a
ELSE
    ;; TODO
ENDIF
    ex      af,af

    pop     bc
    djnz    printc_mode6_2
    call    l_tms9918_enable_interrupts
    ld      de,128
    add     hl,de
    pop     bc
    djnz    printc_mode6_1
    ret



__v9938_mode6_scroll:
    ld      bc,0        ;To coordinate 0,0
    ld      l,8
    ld      e,192
    ld      d,2
    call    __v9938_YMMM
    ; Blank out the bottom line of the screen
    ld      hl,(__tms9918_pattern_name)
    ld      de,23*1024
    add     hl,de
    ld      a,(__tms9918_2bpp_attr+1)
    and     @11000000
    ld      e,a
    rlc     e
    rlc     e
    or      e
    rlc     e
    rlc     e
    or      e
    rlc     e
    rlc     e
    or      e
    ld      bc,1024
    jp      FILVRM


ENDIF