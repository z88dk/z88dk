;
;	ZX IF1 & Microdrive functions
;	
;	int if1_write_sector (int drive, int sector, struct M_CHAN buffer);
;	
;	Writes the specified sector to the specified drive.
;
;	
;	$Id: if1_write_sector.asm,v 1.3 2006-05-23 21:47:26 stefano Exp $
;


		XLIB 	if1_write_sector
		
		;;LIB 	if1_wrsect
		LIB 	if1_rommap

		;;XREF	mdvbuffer
		
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
		ld	(mdvbuffer+1),hl  ; Self modifying code  :oP

		call	MAKE_M

		pop	af		; sector number
		ld	(ix+0Dh),a	; CHREC

		pop	af
		ld	(ix+19h),A	; CHDRIV
		
		call	MOTOR
		
		push	ix
		pop	hl
		ld	de,37h		; point to 12 bytes of data block preamble
		add	hl,de
		
		push	hl
mdvbuffer:	ld	hl,0
		add	hl,de
		pop	de
		
		ld	bc,21ch
		ldir

		set	0,(ix+18h)	; set CHFLAG to "write" mode
		call	1

		RST	8
		defb	22h		; Open a temp "M" channel

		rst	8
		defb	2Ah		; Write a sector to drive

		xor	a
		rst	8
		defb	21h		; Switch microdrive motor off (a=0)

		RST	8
		defb	2Ch		; Reclaim an "M" channel

		ld	hl,0

		ret
