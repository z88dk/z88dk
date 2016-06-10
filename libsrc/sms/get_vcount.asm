	SECTION code_clib	
	PUBLIC	get_vcount
	PUBLIC	_get_vcount
	
;==============================================================
; int get_vcount()
;==============================================================
; V Counter reader
; Waits for 2 consecutive identical values (to avoid garbage)
; Returns in a *and* b
;==============================================================
.get_vcount
._get_vcount
	in	a, ($7e)	; get VCount
.loop	
	ld	l,a		; store it
	in	a, ($7e)	; and again
	cp	l		; Is it the same?
	jp 	nz, loop	; If not, repeat
	ld	h, 0
	ret   
