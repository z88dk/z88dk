;
;	Game device library for the TI82/TI83
;	Stefano Bodrato - 21/8/2001
;
;	$Id: joystick.asm,v 1.1 2001-08-21 15:40:17 stefano Exp $
;


        XLIB    joystick

.joystick
	ld	ix,0
	add	ix,sp
	ld	a,(ix+2)
	cp	1
	jr	nz,j_no1

	ld	l,0

	ld	a,255
	out	(1),a
	ld	a,253
	out	(1),a
	in	a,(1)
	and	64	; "clear" key ?
	jr	nz,nofire1
	inc	l
.nofire1

	ld	a,255
	out	(1),a
	ld	a,251
	out	(1),a
	in	a,(1)
	and	64	; "vars" key ?
	jr	nz,nofire2
	set	1,l
.nofire2
	
	ld	a,255
	out	(1),a
	ld	a,254
	out	(1),a
	in	a,(1)
	xor	255
	
	rl	l	; space for the "up" bit
	rra		; down
	rl	l
	rra		; left
	rl	l
	rra		; right
	rl	l
	rra
	jr	nc,noup
	set	3,l
.noup
	jr	j_done
.j_no1
	xor	a
.j_done
	ret
