;
;   Graphics library for the Epson PX8
;   Stefano - Mar 2017
;
;
	SECTION	code_clib
	PUBLIC	pixeladdress

;
;	$Id: clg.asm,  Stefano, 2017 $
;

        PUBLIC    clg
        PUBLIC    _clg
        PUBLIC    px8_conout

.clg
._clg
	
		ld	c,27		; ESCape
		call px8_conout
		ld	c,0xd0		; set mode
		call px8_conout
		ld	c,3			; graphics mode
		call px8_conout

		ld	c,27		; ESCape
		call px8_conout
		ld	c,'2'		; cursor off
		jp px8_conout

.px8_conout
		ld	hl,(1)	; WBOOT (BIOS)
		ld  a,9		; CONOUT offset
		add l
		ld  l,a
		jp (hl)
