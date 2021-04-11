;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2007       **
; ******************************************************
;
;       void __LIB__ __CALLEE__ cpc_UnExo(int src, int dst);
;
;       $Id: cpc_UnExo_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_UnExo_callee
        PUBLIC    _cpc_UnExo_callee
        PUBLIC    asm_cpc_UnExo
		
        EXTERN cpc_DisableFirmware
        EXTERN cpc_EnableFirmware
		


.cpc_UnExo_callee
._cpc_UnExo_callee

;Exomizer 2 Z80 decoder
; by Metalbrain
;
; compression algorithm by Magnus Lind

;input  	hl=compressed data start
;		de=uncompressed destination start
;
;		you may change exo_mapbasebits to point to any free buffer
pop af
pop de
pop hl
push af

di
call deexo
ei
ret

.asm_cpc_UnExo
.deexo
		ld	ixh,128

		ld	b,52
		ld	iy,exo_mapbasebits
		push	de
.exo_initbits
	ld	a,b
		sub	4
		and	15
		jr	nz,exo_node1

		ld	de,1		;DE=b2
.exo_node1
	ld	c,16
.exo_get4bits
	call	exo_getbit
		rl	c
		jr	nc,exo_get4bits
		ld	(iy+0),c	;bits(i)=b1

		push	hl
		inc	c
		ld	hl,0
		scf
.exo_setbit
	adc	hl,hl
		dec	c
		jr	nz,exo_setbit
		ld	(iy+52),e
		ld	(iy+104),d	;base(i)=b2
		add	hl,de
		ex	de,hl
		inc	iy

		pop	hl
		djnz	exo_initbits
		inc	c
		
.exo_literalseq
	pop	de
.exo_literalcopy
ldir			;copy literal(s)
.exo_mainloop
	ld	c,1
		call	exo_getbit	;literal?
		jr	c,exo_literalcopy
		ld	c,255
.exo_getindex
	inc	c
		call	exo_getbit
		jr	nc,exo_getindex
		ld	a,c		;C=index
		cp	16
		ret	z
		jr	c,exo_continue
		push	de
		ld	d,16
		call	exo_getbits
		jr	exo_literalseq
.exo_continue
	push	de
		call	exo_getpair
		push	bc
		pop	af
		ex	af,af'		;lenght in AF'
		ld	de,512+48	;1?
		dec	bc
		ld	a,b
		or	c
		jr	z,exo_goforit
		ld	de,1024+32
		dec	bc		;2?
		ld	a,b
		or	c
		jr	z,exo_goforit
		ld	e,16
.exo_goforit
	call	exo_getbits
		ld	a,e
		add	a,c
		ld	c,a
		call	exo_getpair	;bc=offset
		pop	de		;de=destination
		push	hl		
		ld	h,d
		ld	l,e
		sbc	hl,bc		;hl=origin
		ex	af,af'
		push	af
		pop	bc		;bc=lenght
		ldir
		pop	hl		;Keep HL, DE is updated
		jr	exo_mainloop	;Next!

.exo_getpair
	ld	iy,exo_mapbasebits
		ld	b,0
		add	iy,bc
		ld	d,(iy+0)
		call	exo_getbits
		ld	a,c
		add	a,(iy+52)
		ld	c,a
		ld	a,b
		adc	a,(iy+104)
		ld	b,a
		ret

.exo_getbits
	ld	bc,0		;get D bits in BC
.exo_gettingbits
dec	d
		ret	m
		call	exo_getbit
		rl	c
		rl	b
		jr	exo_gettingbits

.exo_getbit
	ld	a,ixh		;get one bit
		add	a,a
		ld	ixh,a
		ret	nz
		ld	a,(hl)
		inc	hl
		rla
		ld	ixh,a
		ret

.exo_mapbasebits
defs	156	;tables for bits, baseL, baseH


