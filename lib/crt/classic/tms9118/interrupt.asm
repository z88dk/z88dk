	EXTERN	VDP_STATUS

tms9118_interrupt:
	push	af
	push	hl
	ld	a, +(VDP_STATUS >> 16)
	and	a
	jr	z,read_port
	ld	a,(-VDP_STATUS)
	jr	done_read
read_port:
	in	a,(VDP_STATUS % 256)
done_read:
	or	a
	jp	p,int_not_VBL
	jp	int_VBL

int_not_VBL:
	pop	hl
	pop	af
	; Needs following with ei/reti or retn as appropriate
