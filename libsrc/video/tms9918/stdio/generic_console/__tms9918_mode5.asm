; This file is not universal - we use 8 bit IO
SECTION code_video_vdp


PUBLIC __tms9918_mode5_printc

EXTERN  generic_console_font32
EXTERN  generic_console_udg32
EXTERN  generic_console_flags

EXTERN  l_tms9918_disable_interrupts
EXTERN  l_tms9918_enable_interrupts

EXTERN  __tms9918_pattern_name
EXTERN  __tms9918_4bpp_attr

EXTERN  __tms9918_attribute
EXTERN  __tms9918_scroll_buffer
EXTERN  FILVRM
EXTERN  LDIRVM
EXTERN  SETWRT

INCLUDE "video/tms9918/vdp.inc"


; p0 p0 p0 p0 p1 p1 p1 p1
__tms9918_mode5_printc:
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
    call    xypos

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
    call    SETWRT

    ld      a,4
    ld      de,(__tms9918_4bpp_attr)    ;e = ink, d = paper

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
    ld      de,128
    add     hl,de
    pop     bc
    djnz    printc_mode5_1
    ret





; convert character x,y to address
; Entry: b = row
;        c = column
;
xypos:
    ld      a,b
    add     a
    add     a       ;*4
    ld      h,a
    ld      a,(__tms9918_pattern_name+1)
    add     h
    ld      h,a     ;Row * 1024 + screen base
    ; Now, how many bytes per character?
    sla     c
    sla     c       ;4 bytes needed for a character
    ld      l,c
    ret