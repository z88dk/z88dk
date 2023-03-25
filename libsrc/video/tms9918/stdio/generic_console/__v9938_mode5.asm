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
EXTERN  __tms9918_4bpp_attr

EXTERN  __tms9918_attribute
EXTERN  __tms9918_scroll_buffer

EXTERN  __v9938_wait_vdp


EXTERN  FILVRM
EXTERN  LDIRVM
EXTERN  SETWRT



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


__v9938_mode5_scroll:
    ld      bc,0        ;To coordinate 0,0
    ld      l,8
    ld      e,192
    ld      d,2
    call    ymmm
    ; Blank out the bottom line of the screen
    ld      hl,(__tms9918_pattern_name)
    ld      de,23*1024
    add     hl,de
    ld      a,(__tms9918_4bpp_attr+1)
    ld      e,a
    rrca
    rrca
    rrca
    rrca
    or      e
    ld      a,$85
    ld      bc,1024
    jp      FILVRM
    
;****************************************************************
;  List 4.9   YMMM sample
;               to use, set L, E, B, C, D(bit 2) and go
;               VRAM (B,l)-(*,e) ⟶ VRAM (B,C)
;               DIX must be set in D(bit 2)
;****************************************************************
;
ymmm:   
    call    l_tms9918_disable_interrupts
    push    bc
    call    __v9938_wait_vdp
    ld      a,34
    VDPOUT(VDP_CMD)
    ld      a,17+$80
    VDPOUT(VDP_CMD)     ;Set R#17 = 34 (so writes go there?)

    ld      bc,VDP_PORT3        ;sx
    out     (c),l
    xor     a
    out     (c),a

    ld      a,l                     ;make NY and DIY
    sub     e
    ld      e,00001000B
    jp      nc,YMMM1
    ld      e,00000000B
    neg
YMMM1:  
    ld      l,a                     ;L := NY , D := DIY

    ld      a,d
    or      e

    pop     de                      ;restore DX,dY
    push    af                      ;save DIX,dIY
    xor     a
    out     (c),d                   ;DX
    out     (c),a
    out     (c),e                   ;DY
    out     (c),a
    out     (c),a                   ;dummy
    out     (c),a                   ;dummy
    out     (c),l                   ;NY
    out     (c),a
    out     (c),a                   ;dummy
    pop     af
    out     (c),a                   ;DIX and DIY
    ld      a,11100000B             ;YMMM command
    out     (c),a
    call    __v9938_wait_vdp
    call    l_tms9918_enable_interrupts
    ret

ENDIF
