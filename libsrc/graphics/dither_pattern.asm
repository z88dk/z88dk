;
;	Dither patterns, ordered by increasing intensity (0..11)
;	Functions expects intensity in A and Y coordinate in C
;
;	On exit A will hold the current value for pattern
;
;	Stefano Bodrato, 18/3/2009
;
;	$Id: dither_pattern.asm,v 1.3 2016-04-22 20:17:17 dom Exp $
;

	SECTION  code_clib
	PUBLIC	dither_pattern
	
.dither_pattern
		and	a
		ret	z
		
		cp	11
		jr	c,nomax
		ld	a,255
		ret
.nomax
		sla	a
		sla	a
		ld	l,a
		ld	a,c	; Y
		and	3
		or	l
		ld	l,a
		ld	h,0
		ld	de,_dithpat-4
		add	hl,de
		ld	a,(hl)
		ret

	SECTION		data_clib
_dithpat:
	
	defb	@00000010	; 1
	defb	@00000000
	defb	@00100000
	defb	@00000000

	defb	@00000010	; 2
	defb	@10000000
	defb	@00100000
	defb	@00001000

	defb	@00010100	; 3
	defb	@01000001
	defb	@00010100
	defb	@01000001

	defb	@00010100	; 4
	defb	@01000001
	defb	@10010100
	defb	@01001001

	defb	@01000101	; 5
	defb	@10101000
	defb	@00010101
	defb	@10101010

	defb	@01010101	; 6
	defb	@10101010
	defb	@01010101
	defb	@10101010

	defb	@11001100	; 7
	defb	@00110011
	defb	@11001100
	defb	@00110011

	defb	@11011101	; 8
	defb	@10101010
	defb	@01110111
	defb	@10101010

	defb	@11011101	; 9
	defb	@01110111
	defb	@11011101
	defb	@01110111

	defb	@11111101	; 10
	defb	@01111111
	defb	@11011111
	defb	@11110111

