;
;	Xircom REX 6000 Library
;
;
;	DsTextButton((unsigned int x, unsigned int y,
;                      unsigned int cx, unsigned int cy,
;                      unsigned char eventid, char *str)
;
;
; This gets transformed into:
;
; SYSCALL6P(0x7a, x, y, cx, cy, eventid, (long) str)

	XLIB	DsTextButton
	LIB	SYSCALL6

.DsTextButton
	ld	ix,2
	add	ix,sp		;ix points to frame (str)
	ld	hl,$7a		;DS_DIALOG_TEXT_BUTTON
	ld	($c000),hl
	ld	l,(ix+10)	;x
	ld	h,(ix+11)
	ld	($c002),hl
	ld	l,(ix+8)	;y
	ld	h,(ix+9)
	ld	($c004),hl
	ld	l,(ix+6)	;cx
	ld	h,(ix+7)
	ld	($c006),hl
	ld	l,(ix+4)	;cy
	ld	h,(ix+5)
	ld	($c008),hl
	ld	l,(ix+2)	;eventid
	ld	h,(ix+3)	
	ld	($c00a),hl
	ld	l,(ix+0)	;str
	ld	h,(ix+1)
	ld	($c00c),hl
	in	a,(1)		;get current bank
	ld	l,a
	ld	h,0
	ld	($c00e),hl
	rst	16		;call the ROM routine
	ld	hl,($c00e)	;pick up the result
	ret
