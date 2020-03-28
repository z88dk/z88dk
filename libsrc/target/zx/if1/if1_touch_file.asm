;
;	ZX IF1 & Microdrive functions
;	
;	int if1_touch_file (int drive, int name);
;	
;	Works like the 'touch' command.
;	Returns with the sector number associated to the file.
;
;	... no timestamp, just opens a file creating it if necessary and closes it immediately.
;	A temp buffer in the BASIC area is created and destroyed, so don't locate your code too low.
;	
;	$Id: if1_touch_file.asm,v 1.3 2016-07-01 22:08:20 dom Exp $
;

		SECTION code_clib
		PUBLIC 	if1_touch_file
		PUBLIC 	_if1_touch_file

		EXTERN	if1_setname

if1_touch_file:
_if1_touch_file:
		rst	8
		defb 	31h		; Create Interface 1 system vars if required

		pop	hl
		pop	de	;filename
		pop	bc	;driveno
		push	bc
		push	de
		push	hl
		push	ix	;save callers

		ld	a,c
		ld	($5cd6),a
			
		push	de
		ld	hl,filename	; filename location
		push	hl
		call	if1_setname
		ld	($5cda),hl	; length
		pop	hl
		ld	(5cdch),hl	; pointer to filename
		pop	de

		rst	8
		defb	22h		; Open temporary 'M' channel (touch)

		; Now IX points to the newly created channel

		ld	h,0
		ld	l,(ix+$29)	; save the sector number
		push	hl
		rst	8
		defb	23h		; Close channel and write current sector.
		pop	hl
		pop	ix		;restore callers
		ret

		SECTION bss_clib
filename:	defs	10
