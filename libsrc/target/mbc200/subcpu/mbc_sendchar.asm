;
;		SANYO MBC-200
;
;		Direct I/O to the second Z80 CPU for the video generation
;		Send a byte to the video section
;
;		Stefano Bodrato, 2023
;
;
;	$Id: mbc_sendchar.asm $
;
		SECTION code_clib

		PUBLIC    mbc_sendchar
		PUBLIC    _mbc_sendchar
		

mbc_sendchar:
_mbc_sendchar:

wait_obf:
	in a,($ea)         ; Master PPI, port C
	and $80            ; test OBF signal
	jr z,wait_obf
	
	in a,($e9)         ; Master PPI, port B
	and $fe            ; PB0 -> mapped to PA5 of the slave PPI
	; or 1
	out($e9),a
	
	ld a,l             ; FASTCALL:  HL holds the byte to be sent
	out ($e8),a        ; Master PPI, port A
	
	ret
