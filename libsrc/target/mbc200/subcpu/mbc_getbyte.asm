;
;		SANYO MBC-200
;
;		Direct I/O to the second Z80 CPU for the video generation
;		Get a byte from the video section
;
;		Stefano Bodrato, 2023
;
;
;	$Id: mbc_getbyte.asm $
;
		SECTION code_clib

		PUBLIC    mbc_getbyte
		PUBLIC    _mbc_getbyte
		
		EXTERN  mbc_rcv_rdy


mbc_getbyte:
_mbc_getbyte:

	ld b,0
	call mbc_rcv_rdy
	ld hl,-1		; error
	ret z
	
	in a,($e8)      ; Master PPI, port A

	ld h,0          ; MSB
	ld l,a          ; LSB
	ret
