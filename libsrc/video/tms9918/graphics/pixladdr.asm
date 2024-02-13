
        MODULE  __tms9918_pixeladdress
	SECTION	code_video_vdp
	PUBLIC	__tms9918_pixeladdress
	PUBLIC	__tms9918_pix_return

	EXTERN	__tms9918_attribute
	EXTERN	l_tms9918_disable_interrupts
	EXTERN	l_tms9918_enable_interrupts

	INCLUDE	"graphics/grafix.inc"
	INCLUDE	"video/tms9918/vdp.inc"

;
;	$Id: pixladdr.asm $
;


.__tms9918_pixeladdress
    ld      c,h		; X
    ld      b,l		; Y

    ld      a,h		; X
    and     @11111000
    ld      l,a

    ld      a,b		; Y
    rra
    rra
    rra
    and     @00011111

    ld      h,a		; + ((Y & @11111000) << 5)

    ld      a,b		; Y
    and     7
    ld      e,a
    ld      d,0
    add     hl,de		; + Y&7

;-------
    call    l_tms9918_disable_interrupts
IF VDP_CMD < 256
    ld      a,l
    VDPOUT(VDP_CMD)
    ld      a,h		;4
    and     @00111111	;7
    VDPOUT(VDP_CMD)
    push    bc		;delay
    pop     bc
    VDPIN(VDP_DATAIN)
ELSE
    push    bc
    ld      bc,VDP_CMD
    out     (c), l          ; LSB of video memory ptr
    ld      a,h		; MSB of video mem ptr
    and     @00111111	; masked with "read command" bits
    out     (c), a
    ld      bc,VDP_DATAIN
    push    bc		;delay
    pop     bc
    in      a,(c)
    pop     bc
ENDIF
    ex      de,hl		;de = VDP address
    ld      hl,__tms9918_pixelbyte
    ld      (hl),a
    call    l_tms9918_enable_interrupts
;-------

    ld      a,c
    and     @00000111
    xor     @00000111
    ret


.__tms9918_pix_return
    ld       (hl),a	; hl points to "__tms9918_pixelbyte"
    call    l_tms9918_disable_interrupts
IF VDP_CMD < 256
    ld      a,e
    VDPOUT(VDP_CMD)
    ld      a,d
    and     @00111111
    or      @01000000
    VDPOUT(VDP_CMD)
    ld      a,(__tms9918_pixelbyte)
    push    bc		;delay
    pop     bc
    VDPOUT(VDP_DATA)
    push    bc		;delay
    pop     bc
    ; And support colour as well
    ld      a,e
    VDPOUT(VDP_CMD)
    ld      a,d
    add     $20		;Move to bitmap to colour
    and     @00111111
    or      @01000000
    VDPOUT(VDP_CMD)
    ld      a,(__tms9918_attribute)
    push    bc
    pop     bc
    VDPOUT(VDP_DATA)
ELSE
    ld      bc,VDP_CMD
    out     (c),e
    ld      a,d		; MSB of video mem ptr
    and     @00111111	; masked with "write command" bits
    or      @01000000
    out     (c),a
    ld      a,(__tms9918_pixelbyte) ; Can it be optimized ? what about VDP timing ?
    ld      bc,VDP_DATA
    push    bc
    pop     bc
    out     (c),a
    ld      bc,VDP_CMD
    push    bc		;delay
    pop     bc
    out     (c),e
    ld      a,d		; MSB of video mem ptr
    add     $20
    and     @00111111	; masked with "write command" bits
    or      @01000000
    out     (c),a
    ld      a,(__tms9918_attribute)
    ld      bc,VDP_DATA
    out     (c),a
ENDIF
    call    l_tms9918_enable_interrupts
    pop      bc
    ret

    SECTION bss_video_vdp
    PUBLIC  __tms9918_pixelbyte

.__tms9918_pixelbyte
    defb    0
