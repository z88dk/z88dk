;
;	ZX IF1 & Microdrive functions
;	
;	Write the sector set in "mdvbuffer"
;	The motor must be switched on the right drive
;	and the sector number must be put in CHREC
;	
;	
;	$Id: if1_wrsect.asm,v 1.1 2004-10-08 12:33:24 stefano Exp $
;


		XLIB 	if1_wrsect
		
		XREF	mdvbuffer


if1_wrsect:
		push	ix
		pop	hl
		ld	de,37h		; point to 12 bytes of data block preamble
		add	hl,de
		
		push	hl
		ld	hl,(mdvbuffer)
		add	hl,de
		pop	de
		
		ld	bc,21ch
		ldir
		set	0,(ix+18h)	; set CHFLAG to "write" mode
		call	1
		
		rst	8
		defb	2Ah		; Write a sector to drive

		xor	a
		rst	8
		defb	21h		; Switch microdrive motor off (a=0)

		RST	8
		defb	2Ch		; Reclaim an "M" channel

		ld	hl,0		; write OK
		ret

