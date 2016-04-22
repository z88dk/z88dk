
	SECTION	code_clib
	PUBLIC	pixeladdress
	
	EXTERN	zx_rowtab

	INCLUDE	"graphics/grafix.inc"

;
;	$Id: pixladdr2.asm,v 1.5 2016-04-22 20:17:17 dom Exp $
;
;
; ******************************************************************
;
; IT IS SLOWER THAN THE DEFAULT ONE !  124 vs 104 Cycles !!
;
; ******************************************************************
;
; Table based version - Stefano 19/2/2002
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
;  ..bc..../ixiy same
;  af..dehl/.... different
;


.pixeladdress

		; de = l*2
		xor	a		; 4
		rl	l		; 8
		rla			; 4
		ld	e,l		; 4
		ld	d,a		; 4
		
		ld	a,h		; 4
		
		ld	hl,zx_rowtab	; 10
		
		add	hl,de		; 15
		
		ld	b,a		; 4
		rra			; 4
		srl	a		; 8
		srl	a		; 8
		add	(hl)		; 7
		ld	e,a		; 4
		inc	hl		; 6
		ld	a,0		; 7
		adc	(hl)		; 7
		ld	d,a		; 4
		ld	a,b		; 4

	        AND     @00000111	; 4
	        XOR	@00000111	; 4
	        
	        RET

