
		MODULE	getk
		SECTION	code_clib
		PUBLIC	getk
		PUBLIC	_getk


getk:
_getk:
	call	$70f
	ld	hl,0
	ret	z
	cp	13
	jr	z,done
	cp	8
	jr	z,done
	cp	32
	ret	c
	cp	127
	ret	nc
done:
	ld	l,a
	ld	h,0
	ret

		SECTION code_crt_init

	; Initialise the keyboard ringbuffer
	ld	hl,$9f7a                        ;[0704] 21 7a 9f
	ld      ($a02b),hl                      ;[0707] 22 2b a0
	ld      ($a02d),hl
