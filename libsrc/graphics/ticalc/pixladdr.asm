
	XLIB	pixeladdress

	INCLUDE	"grafix.inc"

	XREF	base_graphics


; ******************************************************************
;
; Get absolute	pixel address in map of virtual (x,y) coordinate.
;
; TI Calculator version
;
; addr=base+12*y+int(x/8)
;

.pixeladdress

		push	hl
		ld	a,h
		
		push	af
		
		srl	a
		srl	a
		srl	a
		
		ld	c,a	; c=int(x/8)
		
		;ld	b,l
		ld	h,0
		ld	d,h
		ld	e,l
		add	hl,de
		add	hl,de

; TI 85 and TI86 screens are 16 bytes wide
IF FORti85
		add	hl,de
ENDIF
IF FORti86
		add	hl,de
ENDIF

		add	hl,hl
		add	hl,hl
		
		;ld	hl,(base_graphics)
		ld	de,(base_graphics)
		add	hl,de
		
		ld	b,0
		
		add	hl,bc
		
		ld	d,h
		ld	e,l
		pop	af
		pop	hl
		
		and	@00000111		; a = x mod 8
		xor	@00000111		; a = 7 - a
		
		ret
