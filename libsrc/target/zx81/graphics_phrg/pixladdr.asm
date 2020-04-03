;--------------------------------------------------------------
; ZX81 Pseudo - HRG library
; by Stefano Bodrato, Mar. 2020
;--------------------------------------------------------------
;
;	Find pixel position in memory and convert pseudo graphics byte
;
;
;	$Id: pixladdr.asm $
;

	MODULE    __pseudohrg_pixeladdress
	SECTION   code_graphics
	
	PUBLIC	pixeladdress
	PUBLIC	__pixeladdress_hl
	PUBLIC	pix_return
	PUBLIC	pix_return_pixelbyte

	EXTERN	base_graphics

;	INCLUDE	"graphics/grafix.inc"


	PUBLIC _gfxhr_pixtab

._gfxhr_pixtab
; LSb on the left
;			defb 11, 36, 162, 150, 55, 8, 143, 18, 12, 15, 40, 183, 22, 41, 164, 25

; LSb on the right
			defb 11,12,55,22,162,49,143,164,36,15,8,41,150,183,18,25



.pixeladdress
	ld	a,h		; X
	ld	c,a
	
	ld	e,l		; Y
	ld	d,0
	
	ld 	hl,(base_graphics)
	ld	b,33
.rloop
	add	hl,de
	djnz rloop

	ld	a,c		; X
	srl a		; /2
	srl a		; /4
	ld	e,a
	add	hl,de

.__pixeladdress_hl
	ld	(__dfile_addr),hl		; D-FILE address
	ld	a,(hl)
	
	;ex	de,hl
	
	ld	hl,_gfxhr_pixtab
	ld	b,16
.tabloop
	cp (hl)
	jr	z,cfound
	inc hl
	djnz	tabloop
	xor a
	jr	zbyte
.cfound
	ld	a,16
	sub b
.zbyte
	
	ld	hl,__pixelbyte
	ld	d,h
	ld	e,l
	ld	(hl),a

	ld	a,c
	and	@00000011
	xor	@00000011
	ret


.pix_return_pixelbyte
	ld	a,(__pixelbyte)

.pix_return

	and @00001111

;	ld	(hl),a	; hl points to "pixelbyte"
;ld	a,2
	ld	hl,_gfxhr_pixtab
	ld	d,0
	ld	e,a
	add hl,de
	ld	a,(hl)
	ld	hl,(__dfile_addr)
	;ex	de,hl
	ld	(hl),a
	ret
	


	SECTION bss_clib
	PUBLIC	__pixelbyte
	PUBLIC	__dfile_addr

.__pixelbyte
	 defb	0

.__dfile_addr
	 defw	0

