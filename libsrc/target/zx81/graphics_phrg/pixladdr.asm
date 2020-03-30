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
	PUBLIC	pix_return_2

	EXTERN	base_graphics

;	INCLUDE	"graphics/grafix.inc"


	PUBLIC _gfxhr_pixtab

._gfxhr_pixtab
; LSb on the left
;			defb 11, 36, 162, 150, 55, 8, 143, 18, 12, 15, 40, 183, 22, 41, 164, 25

; LSb on the right
			defb 11,12,55,22,162,49,143,164,36,15,8,41,150,183,18,25



.pixeladdress
	push	af			; keep C flag

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

	pop		af			; check C flag
	push	af
	ld		e,0				; needed if 'singlebyte'
	jr		c,singlebyte
	
	push hl
	call map_pixtab
	rla
	rla
	rla
	rla
	and @11110000
	ld	e,a

	pop	hl
	inc hl

.singlebyte
	call map_pixtab
	or	e
	
	ld	hl,__pixelbyte
	ld	(hl),a

	pop af			; check C flag
	jr	c,singlebyte_exit
	ld	a,c
	and	@00000111
	xor	@00000111
	ret
	
.singlebyte_exit
	ld	a,c
	and	@00000011
	xor	@00000011
	ret



.pix_return_2
;	ld	(hl),a	; hl points to "pixelbyte"
;ld	a,2
	push af
	rra
	rra
	rra
	rra
	call pix_return
	ld	hl,__dfile_addr
	inc (hl)
	pop af


.pix_return
	and @00001111
	ld	hl,_gfxhr_pixtab
	ld	d,0
	ld	e,a
	add hl,de
	ld	a,(hl)
	ld	hl,(__dfile_addr)
	;ex	de,hl
	ld	(hl),a
	ret
	


.map_pixtab
	ld	a,(hl)	
	ld	hl,_gfxhr_pixtab
	ld	b,15
.tabloop
	cp (hl)
	jr	z,cfound
	inc hl
	djnz	tabloop
	xor a
	jr	zbyte
.cfound
	ld	a,15
	sub b
.zbyte
	ret


	SECTION bss_clib
	PUBLIC	__pixelbyte
	PUBLIC	__dfile_addr

.__pixelbyte
	 defb	0

.__dfile_addr
	 defw	0

