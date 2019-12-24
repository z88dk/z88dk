;

        SECTION code_clib
	PUBLIC	psg_init
	PUBLIC	_psg_init
	
psg_init:
_psg_init:
	ld	e,@01010101
	xor	a 	; R0: Channel A frequency low bits
	call	outpsg

	ld	e,a
	ld	b,0
	ld	d,12
psg_iniloop:
	inc	b
	ld	e,0
	call	outpsg
skip:
	dec	d
	jr	nz,psg_iniloop

	ld	e,$7f		;Register 7, enable aux ports
	ld	b,7
	call	outpsg
	ld	e,@00001011	; R11: Envelope
	ld	b,11
outpsg:
	ld	a,b
	out	($00),a
	ld	a,e
	out	($01),a
	ret

