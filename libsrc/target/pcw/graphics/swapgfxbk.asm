;
;       Amstrad PCW graphics routines
;
;       Stefano Bodrato 2021
;
;
;        Video memory paging.
;

	SECTION   code_graphics
		
	PUBLIC    swapgfxbk
	PUBLIC    _swapgfxbk

	PUBLIC    swapgfxbk1
	PUBLIC    _swapgfxbk1



.swapgfxbk
._swapgfxbk
	di
	ld   a,81h
	out  (0F1h),a  ; 04000h = Bank 1 R/W - Screen/BIOS
	ld   a,82h
	out  (0F2h),a  ; 08000h = Bank 2 R/W - Screen
	ret


.swapgfxbk1
._swapgfxbk1
	ld   a,85h
	out  (0F1h),a  ; 04000h = Bank 5 R/W - TPA
	ld   a,86h
	out  (0F2h),a  ; 08000h = Bank 6 R/W - TPA
	ei
	ret



	SECTION code_crt_init

	EXTERN  __BSS_END_tail
	EXTERN  __HIMEM_head
	EXTERN  __HIMEM_END_tail
	ld      hl,__BSS_END_tail
	ld      de,__HIMEM_head
	ld      bc,__HIMEM_END_tail - __HIMEM_head
	ldir
