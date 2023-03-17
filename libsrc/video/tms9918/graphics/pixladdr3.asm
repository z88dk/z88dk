
    MODULE  __tms9918_pixeladdress3
    SECTION	code_clib
    PUBLIC  __tms9918_pixeladdress3
    PUBLIC  __tms9918_pix_return3

    EXTERN  l_tms9918_disable_interrupts
    EXTERN  l_tms9918_enable_interrupts

    INCLUDE "graphics/grafix.inc"
    INCLUDE "video/tms9918/vdp.inc"

;
;	$Id: pixladdr.asm $
;

; Exits c = x, b = y, de = vdp address

; Each "row" of characters represents 4 rows of screen
.__tms9918_pixeladdress3
    ld      c,h     ; X
    ld      b,l     ; Y

    ; Find the character
    ld      a,l
    srl     a               ;Divide pixel row by 2
    add     a
    add     a
    add     a
    and     @11100000       ;a= character at start of row
    srl     h               ;h = xpos / 2
    add     h               ;a = character that we need to modify
    ld      l,a
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl           ;hl = address in name table of character

    ; Now find out which byte in the character
    ld      a,b		;y
    and     7
    add     l
    ld      l,a
    ld      a,h
    adc     0
    ld      h,a

;-------
    call    l_tms9918_disable_interrupts
IF VDP_CMD < 0
    ld      a,l
    ld      (-VDP_CMD),a
    ld      a,h		;4
    and     @00111111	;7
    ld      (-VDP_CMD),a
    push    bc
    pop     bc
    ld      a,(-VDP_DATAIN)
ELSE
    push    bc
    ld      bc,VDP_CMD
    out     (c), l          ; LSB of video memory ptr
    ld      a,h		; MSB of video mem ptr
    and     @00111111	; masked with "read command" bits
    out     (c), a
    ld      bc,VDP_DATAIN
    push    bc
    pop     bc
    in      a,(c)
    pop     bc
ENDIF
    ex      de,hl           ;de = VDP address
    ld      hl,__tms9918_pixelbyte3
    ld      (hl),a
    call    l_tms9918_enable_interrupts
    ret

    
;de = VDP address
.__tms9918_pix_return3
    ld       (hl),a	; hl points to "__tms9918_pixelbyte3"
    call    l_tms9918_disable_interrupts
IF VDP_CMD < 0
    ld      a,e
    ld      (-VDP_CMD),a
    ld      a,d
    and     @00111111
    or      @01000000
    ld      (-VDP_CMD),a
    ld      a,(__tms9918_pixelbyte3)
    push    bc
    pop     bc
    ld      (-VDP_DATA),a
ELSE
    ld      bc,VDP_CMD
    out     (c),e
    ld      a,d		; MSB of video mem ptr
    and     @00111111	; masked with "write command" bits
    or      @01000000
    out     (c),a
    ld      a,(__tms9918_pixelbyte3) ; Can it be optimized ? what about VDP timing ?
    ld      bc,VDP_DATA
    push    bc
    pop     bc
    out     (c),a
ENDIF
    call    l_tms9918_enable_interrupts
    pop      bc
    ret

    SECTION bss_clib
    PUBLIC  __tms9918_pixelbyte3

.__tms9918_pixelbyte3
    defb    0
