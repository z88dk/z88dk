
		MODULE	fgetc_cons
		SECTION	code_clib
		PUBLIC	fgetc_cons
		PUBLIC	_fgetc_cons


fgetc_cons:
_fgetc_cons:
	call	$70f
	jr	z,fgetc_cons
	cp	13
	jr	z,done
	cp	8
	jr	z,done
	cp	32
	jr	c,fgetc_cons
	cp	127
	jr	nc,fgetc_cons
done:
	ld	l,a
	ld	h,0
	ret

		SECTION code_crt_init

	; Initialise the keyboard ringbuffer
	ld	hl,$9f7a                        ;[0704] 21 7a 9f
	ld      ($a02b),hl                      ;[0707] 22 2b a0
	ld      ($a02d),hl
