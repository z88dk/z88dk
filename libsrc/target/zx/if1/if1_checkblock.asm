;
;	ZX IF1 & Microdrive functions
;
;	Stefano Bodrato - Oct. 2004
;
;
;	if1_checkblock:
;	 - check the loaded block for integrity
;	 - other various checks
;	
;	$Id: if1_checkblock.asm,v 1.3 2016-07-01 22:08:20 dom Exp $
;

		SECTION code_clib
		PUBLIC 	if1_checkblock
		
		EXTERN	if1_checksum
		
		EXTERN	mdvbuffer
		PUBLIC	if1_sect_read
		PUBLIC	if1_verifymode



if1_checkblock:
		push	ix
		pop	hl
		ld	de,43h		; RECFLAG
		add	hl,de
		ld	bc,14
		call	if1_checksum

		ld	hl,status	; D70E
		ld	(hl),1
;
		jr	nz,chksector
		inc	(hl)

		ld	a,(ix+43h)	; RECFLG
		or	(ix+46h)	; 2nd byte of RECLEN
		and	2
		jr	z,chk1
		bit	1,(ix+43h)	; RECFLG
		jr	z,chksector
		ld	a,(ix+47h)	; RECNAM: file name
		or	a
		jr	nz,chksector
chk1:
		ld	a,4
		jr	chk2
chksector:
		push	ix
		pop	hl
		ld	de,52h		; CHDATA
		add	hl,de
		ld	bc,512		; 512 bytes of data
		call	if1_checksum	; verify checksum
		ld	a,(status)
		jr	nz,chk2
		inc	a
		inc	a
chk2:
		ld	hl,if1_sect_read		; flag for "sector read"
		cp	(hl)
		ret	c
		ret	z
		ld	(hl),a
		ld	b,a
		
		ld	a,(if1_verifymode)
		bit	2,a
		ld	a,b
		ret	nz

; Copy microdrive channel to work buffer
		push	ix
		pop	hl
		ld	de,(mdvbuffer)
		ld	bc,595
		ldir
		ret


		SECTION bss_clib
status:		defb	0
if1_sect_read:	defb	0
if1_verifymode:	defb	0
