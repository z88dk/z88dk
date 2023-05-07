;
;		SANYO MBC-200
;
;		Direct I/O to the second Z80 CPU for the video generation
;
;		Stefano Bodrato, 2023
;
;
;	$Id: mbc_rcv_rdy.asm $
;
		SECTION code_clib
		PUBLIC    mbc_rcv_rdy
		PUBLIC    _mbc_rcv_rdy
		EXTERN	__mbc_rcv

mbc_rcv_rdy:
_mbc_rcv_rdy:

wait_ibf:
	in a,($ea)        ; Master PPI, port C
	bit 5,a           ; test IBF signal 
	ret nz
	djnz wait_ibf
	xor a
	ret

