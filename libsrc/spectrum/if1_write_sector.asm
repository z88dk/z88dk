;
;	ZX IF1 & Microdrive functions
;	
;	if1_write_sector (int drive, int sector, struct M_CHAN buffer);
;	
;	
;	$Id: if1_write_sector.asm,v 1.1 2004-10-08 12:33:24 stefano Exp $
;


		XLIB 	if1_write_sector
		
		LIB 	if1_wrsect
		LIB 	if1_rommap

		XREF	mdvbuffer
		
		XREF	MAKE_M
		XREF	MOTOR


if1_write_sector:

		call	if1_rommap

		ld	ix,2
		add	ix,sp
		ld	a,(ix+4)
		ld	hl,-1
		and	a		; drive no. = 0 ?
		ret	z		; yes, return -1
		dec	a
		cp	8		; drive no. >8 ?
		ret	nc		; yes, return -1
		inc	a
		push	af

		ld	a,(ix+2)	; sector number
		push	af

		ld	l,(ix+0)	; buffer
		ld	h,(ix+1)
		ld	(mdvbuffer),hl

		;ld	a,'M'
		;ld	(5CD9h),A	; l_str1 (device type = "M")

		call	MAKE_M

		pop	af		; sector number
		ld	(ix+0Dh),a	; CHREC

		pop	af
		ld	(ix+19h),A	; CHDRIV
		call	MOTOR
		
		call	if1_wrsect

		ld	hl,0
		ret
