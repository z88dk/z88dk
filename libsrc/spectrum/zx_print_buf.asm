;
;		Copy a buffer of 8 graphics rows to the zx printer
;
;		Stefano Bodrato, 2018
;
;
;	$Id: zx_print_buf.asm $
;
		SECTION code_clib
		PUBLIC    zx_print_buf
		PUBLIC    _zx_print_buf
		PUBLIC    zx_print_row
		PUBLIC    _zx_print_row
		
		EXTERN  zx_fast
		EXTERN  zx_slow
		EXTERN  call_rom3


.zx_print_buf
._zx_print_buf
		di
		ld	b,8
		jr	eightrows

.zx_print_row
._zx_print_row
		di
		ld	b,1

.eightrows
		push hl
		ld	hl, $0A02
		ld	a,(hl)
		pop hl
		cp	$f3		; DI instruction, should be in that position only for the TS2068
		jr	nz,no_ts2068
		jp $0A29
.no_ts2068
		call call_rom3
		defw $0ED3
		ret
