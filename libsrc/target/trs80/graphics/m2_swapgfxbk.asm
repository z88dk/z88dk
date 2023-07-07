;
;       Z88 Graphics Functions - Small C+ stubs
;       Written around the Interlogic Standard Library
;
;       Page the graphics bank in/out - used by all gfx functions
;       Version for the TRS80 Model II CP/M
;
;       It tries to determine the CP/M type in use
;       to switch the memory bank properly
;       Stefano - 6/2023
;
;
;	$Id: m2_swapgfxbk.asm $
;


		SECTION	code_clib

		PUBLIC    swapgfxbk
		PUBLIC    _swapgfxbk

		PUBLIC	swapgfxbk1
		PUBLIC   _swapgfxbk1


.swapgfxbk
._swapgfxbk

	di
	push	hl
	push	de
	push	bc
	ld	a,(64)  ; If we have a 'JP' at position $40, it should be the P&T "special functions" entry
	ld  b,21	; "enable access to screen "
	sub	$c3     ; 'JP' ?
	jr  nz,vram_map
	call 64	; VRAM switching, the Pickles & Trout CP/M way
	pop	bc
	pop	de
	pop	hl
	ret

; Unknown CP/M type, use the I/O port and cross fingers
.vram_map
	push af
	ld	a,$81		; enable video memory access
 	out	($FF),a
	pop af
	pop	bc
	pop	de
	pop	hl
	ret


.swapgfxbk1
._swapgfxbk1

	push	hl
	push	de
	push	bc
	ld	a,(64)
	ld  b,22	; "disable access to screen "
	sub	$c3
	jr  nz,vram_unmap
	call 64	; VRAM switching, the Pickles & Trout CP/M way
	pop	bc
	pop	de
	pop	hl
	ei
	ret

; Unknown CP/M type, use the I/O port and cross fingers
.vram_unmap
	push af
 	ld	a,$01		; disable video memory access
 	out	($FF),a
	pop af
	pop	bc
	pop	de
	pop	hl
	ei
	ret


;--------------------------------------------------
	SECTION		code_crt_init
	EXTERN		base_graphics
	EXTERN		asm_set_cursor_state

	ld	hl,$f800
	ld	(base_graphics),hl

	ld	l,0x20		;disable cursor
	call	asm_set_cursor_state

