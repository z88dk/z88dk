
	SECTION	code_clib
	PUBLIC	pixeladdress

	PUBLIC	pix_return

	EXTERN	l_tms9918_disable_interrupts
	EXTERN	l_tms9918_enable_interrupts

	INCLUDE	"graphics/grafix.inc"
	INCLUDE	"video/tms9918/vdp.inc"

;
;	$Id: pixladdr.asm $
;

; ******************************************************************
;
; Get absolute	pixel address in map of virtual (x,y) coordinate.
;
; in:  hl	= (x,y) coordinate of pixel (h,l)
;
; out: de	= address	of pixel byte
;	   a	= bit number of byte where pixel is to be placed
;	  fz	= 1 if bit number is 0 of pixel position
;
; registers changed	after return:
;  ......../ixiy same
;  afbcdehl/.... different
;
	;;EXTERN	base_graphics

.pixeladdress
	
	ld	c,h		; X
	ld	b,l		; Y
	
	ld	a,h		; X
	and	@11111000
	ld	l,a

	ld	a,b		; Y
	rra
	rra
	rra
	and	@00011111

	ld	h,a		; + ((Y & @11111000) << 5)

	ld	a,b		; Y
	and	7
	ld	e,a
	ld	d,0
	add	hl,de		; + Y&7
	
;-------
	call	l_tms9918_disable_interrupts
IF VDP_CMD < 0
	ld	a,l
	ld	(-VDP_CMD),a
	ld	a,h		;4
	and	@00111111	;7
	ld	(-VDP_CMD),a
	ld	a,(-VDP_DATAIN)
	ld	e,a
ELSE
	ld	a,l		; LSB of video memory ptr
	out	(VDP_CMD), a
	ld	a,h		; MSB of video mem ptr
	and	@00111111	; masked with "read command" bits
	out	(VDP_CMD), a
	in	a, (VDP_DATAIN)
	ld	e,a
ENDIF
	call	l_tms9918_enable_interrupts
	ld	a,e
	ex	de,hl		;de = VDP address
	ld	hl,pixelbyte
	ld	(hl),a
;-------

        ld	a,c
        and     @00000111
        xor	@00000111
	
	ret


.pix_return
         ld       (hl),a	; hl points to "pixelbyte"
	call	l_tms9918_disable_interrupts
IF VDP_CMD < 0
	ld	a,e
	ld	(-VDP_CMD),a
	ld	a,d
	and	@00111111
	or	@01000000
	ld	(-VDP_CMD),a
	ld	a,(pixelbyte)
	ld	(-VDP_DATA),a
ELSE
         ld       a,e		; LSB of video memory ptr
         out      (VDP_CMD),a
         ld       a,d		; MSB of video mem ptr
         and      @00111111	; masked with "write command" bits
         or       @01000000
         out      (VDP_CMD), a
         ld       a,(pixelbyte) ; Can it be optimized ? what about VDP timing ?
         out      (VDP_DATA), a
ENDIF
	call	l_tms9918_enable_interrupts
         pop      bc
         ret

	SECTION bss_clib
	PUBLIC	pixelbyte

.pixelbyte
	 defb	0
