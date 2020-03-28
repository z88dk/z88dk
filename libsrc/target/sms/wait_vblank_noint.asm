	SECTION code_clib	
	PUBLIC	wait_vblank_noint
	PUBLIC	_wait_vblank_noint
	
	EXTERN	get_vcount
	
;==============================================================
; void wait_vblank_noint()
;==============================================================
; Waits for VBlank, without interrupts
;==============================================================
.wait_vblank_noint
._wait_vblank_noint
.loop
	call	get_vcount	; Gets V counter
	ld	a, l
	cp	192		; Did it reach the last line of display?
	jp	nz, loop	; If not, try again
	ret
