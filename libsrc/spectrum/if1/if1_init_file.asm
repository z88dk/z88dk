;
;	ZX IF1 & Microdrive functions
;	
;	int if1_init_file (int drive, int name, struct M_CHAN buffer);
;
;	This is the original BASIC structure with no added values/flags.
;
;	
;	Open a file for writing
;	
;	$Id: if1_init_file.asm,v 1.2 2015-01-19 01:33:10 pauloscustodio Exp $
;


		PUBLIC 	if1_init_file

		EXTERN	if1_setname

filename:	defs	10

if1_init_file:
		rst	8
		defb 	31h		; Create Interface 1 system vars if required

		pop	af
		pop	hl	;buffer
		pop	de	;filename
		pop	bc	;driveno
		push	bc
		push	de
		push	hl
		push	af

		push	hl
		
		ld	a,c
		ld	($5cd6),a
		
		push	de
		ld	hl,filename	; filename location
		push	hl
		call	if1_setname
		ld	($5cda),hl	; length
		pop	hl
		ld	($5cdc),hl	; pointer to filename
		pop	de

		;rst	8		; Erase if file exists ?
		;defb	24h
		
		rst	8
		defb	22h		; Open temporary 'M' channel (touch)
		
		; Now IX points to the newly created channel
		push 	ix
		pop	hl

		;ld	a,h
		;or	l
		;and	a
		
		;ld	de,4		; Experimentally corrected
		;add	hl,de		; with this offset
		
		pop	de		; buffer
		ld	bc,253h
		;ld	bc,37h
		ldir			; take a copy of the file buffer header

		xor	a
		rst	8
		defb	21h		; stop microdrive motor

		rst	8
		defb	2Ch		; Reclaim the channel
					; ..I need the initialized buffer only	
		
		; here we could check for free space
		; and eventually give the "microdrive full" error
		ld	hl,0
		
		ret
