
	SECTION	data_clib

	PUBLIC	__vector06c_ink
	PUBLIC	__vector06c_paper
	PUBLIC	__vector06c_scroll
	PUBLIC	__vector06c_mode

__vector06c_ink:	defb	15
__vector06c_paper:	defb	0
__vector06c_scroll:	defb	1
__vector06c_mode:	defb	0	;bit 4 set for 512x256 mode
