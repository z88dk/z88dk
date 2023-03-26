; This file is not universal - we use 8 bit IO
SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC __v9938_mode5_printc
PUBLIC __v9938_mode5_scroll

EXTERN  generic_console_font32
EXTERN  generic_console_udg32
EXTERN  generic_console_flags

EXTERN  l_tms9918_disable_interrupts
EXTERN  l_tms9918_enable_interrupts

EXTERN  __tms9918_pattern_name
EXTERN  __tms9918_attribute

EXTERN  __tms9918_attribute
EXTERN  __tms9918_scroll_buffer

EXTERN  __v9938_wait_vdp

EXTERN  __v9938_YMMM
EXTERN  FILVRM
EXTERN  LDIRVM
EXTERN  SETWRT
EXTERN  __v9938_mode5_xypos



; p0 p0 p0 p0 p1 p1 p1 p1
__v9938_mode5_printc:
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
    call    __v9938_mode5_xypos

    ld      b,8
printc_mode5_1:
    push    bc
    ld      a,b
    exx
    bit     3,b
    jr      z,printc_mode5_no_underline
    cp      1
    jr      nz,printc_mode5_no_underline
    ld      a,255
    jr      printc_mode5_not_bold
printc_mode5_no_underline:
    ld      a,(hl)
    bit     4,b
    jr      z,printc_mode5_not_bold
    rrca
    or      (hl)
printc_mode5_not_bold:
    xor     c
    inc     hl
    exx

    ex      af,af

    call    l_tms9918_disable_interrupts
    call    SETWRT

    ld      a,(__tms9918_attribute)
    ld      d,a
    and     $f0
    ld      e,a
    ld      a,d
    and     $0f
    ld      d,a

    ld      a,4

printc_mode5_2:
    ex      af,af
    ; We have two pixels per byte, so lets unroll a bit

    rlca            ;Do we need ink or paper?
    ld      c,d     ;paper
    jr      nc,printc_mode5_is_paper
    ld      c,e    ;ink
printc_mode5_is_paper:
    rlca            ;Get the next pixel
    ld      b,a     ;Save the rest of char line
    ld      a,d
    jr      nc,printc_mode5_is_paper2
    ld      a,e    ;ink
printc_mode5_is_paper2:
    rrca
    rrca
    rrca
    rrca
    and     0x0f
    or      c

IF VDP_DATA < 0
    ld      (-VDP_DATA),a
ELIF VDP_DATA < 256
    out     (VDP_DATA),a
ELSE
    ;; TODO
ENDIF

    ld      a,b
    ex      af,af
    dec     a
    jp      nz,printc_mode5_2
    call    l_tms9918_enable_interrupts
    ld      de,128
    add     hl,de
    pop     bc
    djnz    printc_mode5_1
    ret




__v9938_mode5_scroll:
    ld      bc,0        ;To coordinate 0,0
    ld      l,8
    ld      e,192
    ld      d,2
    call    __v9938_YMMM
    ; Blank out the bottom line of the screen
    ld      hl,(__tms9918_pattern_name)
    ld      de,23*1024
    add     hl,de
    ld      a,(__tms9918_attribute)
    and     $0f
    ld      e,a
    rrca
    rrca
    rrca
    rrca
    or      e
    ld      bc,1024
    jp      FILVRM
    


ENDIF
