; strlwr function for use with far pointers
; 1/4/00 GWL


		LIB farseg1,incfar
                XLIB strlwr_far


;far *strlwr(far *s)
; converts s to lowercase

.strlwr_far
	pop	hl
	pop	bc
	pop	de		; EBC=far pointer
	push	de
	push	bc
	push	hl
	ld	a,($04d1)
	ex	af,af'		; save seg 1 binding
	call	farseg1		; bind to segment 1, with address in HL
.strlwr1
        ld      a,(hl)
        and     a
	jr	z,strlwrend
	cp	'A'
	jr	c,strlwr2
	cp	'Z'+1
	jr	nc,strlwr2
	or	32
	ld	(hl),a
.strlwr2
        call    incfar
        jr      strlwr1
.strlwrend
	ex	af,af'
	ld	($04d1),a
	out	($d1),a		; rebind segment 1
	pop	hl
	pop	bc
	pop	de		; get EBC=pointer again
	push	de
	push	bc
	jp	(hl)		; save 1 byte returning!
