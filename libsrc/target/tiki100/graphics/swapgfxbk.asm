;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 15/10/98
;
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;	CAVEAT
;	CAVEAT	Always call swapgfxbk1 IMMEDIATELY after you are
;	CAVEAT	done with accessing video RAM using swapgfxbk.
;	CAVEAT
;
;	$Id: swapgfxbk.asm,v 1.2 2017-01-02 22:57:59 aralbrec Exp $
;

	SECTION		code_graphics
	PUBLIC		swapgfxbk
	PUBLIC		_swapgfxbk

	PUBLIC		swapgfxbk1
	PUBLIC		_swapgfxbk1


.swapgfxbk
._swapgfxbk
	di
	ex	af,af
	ld	a,($FFC8)		; Copy of system register
	or	$08			; select graphics RAM bank
	out	($1C),a			; System register (page-in gfx RAM)
	ex	af,af
	ret

.swapgfxbk1
._swapgfxbk1
	ex	af,af
	ld	a,($FFC8)		; Copy of system register
	out	($1C),a			; System register (page-out gfx RAM)
	ex	af,af
	ei
	ret

	SECTION		code_crt_init

	EXTERN		__BSS_END_tail
	EXTERN		__HIMEM_head
	EXTERN		__HIMEM_END_tail

	ld	hl,__BSS_END_tail
	ld	de,__HIMEM_head
	ld	bc,__HIMEM_END_tail - __HIMEM_head
	ldir

; TODO: Copy graphics to high memory
