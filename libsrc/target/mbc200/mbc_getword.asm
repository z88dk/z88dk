;
;		SANYO MBC-200
;
;		Direct I/O to the second Z80 CPU for the video generation
;		Receive a little-endian word from the video section
;
;		Stefano Bodrato, 2023
;
;
;	$Id: mbc_getword.asm $
;
		SECTION code_clib

		PUBLIC    mbc_getword
		PUBLIC    _mbc_getword
		
		EXTERN  mbc_rcv_rdy


mbc_getword:
_mbc_getword:

	ld b,0
	call mbc_rcv_rdy
	ld hl,-1		; error
	ret z
	
	in a,($e8)      ; Master PPI, port A
	ld h,a          ; MSB

	ld b,4
	call mbc_rcv_rdy
	jr nz,no_err
	ld hl,-1		; error
	ret

no_err:
	in a,($e8)      ; Master PPI, port A
	ld l,a          ; LSB
	ret

