
	SECTION code_clib

	PUBLIC	clg
	PUBLIC	_clg

	EXTERN   generic_console_cls

	EXTERN		putvid_a
	EXTERN		__console_w
	EXTERN		__gemini_mode

	EXTERN		cleargraphics

;
;	$Id: clg.asm $
;

; ******************************************************************
;
;	Clear graphics area, 
;

.clg
._clg

	call generic_console_cls
	ld	l,80
	ld	h,25
	ld	(__console_w),hl
	ld  a,1
	ld	(__gemini_mode),a
	ld  a,27
	call putvid_a
	ld  a,'1'
	call putvid_a

	ld  a,27
	call putvid_a
	ld  a,'D'		; Hide cursor
	call putvid_a
	
	call generic_console_cls
	
	ld  a,27
	call putvid_a
	ld  a,'G'		; Constructi graphics blocks
	jp putvid_a


