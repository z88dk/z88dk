;
;	ZX IF1 & Microdrive functions
;	write a new record for the current buffer
;	
;	if1_write_record (int drive, struct M_CHAN buffer);
;
;	This one is similar to "write sector" but fixes the record header.
;	It is necessary to load a copy of the microdirve MAP and to pass it
;	putting its location into the record structure.;	
;	
;	$Id: if1_write_record.asm,v 1.2 2015-01-19 01:33:10 pauloscustodio Exp $
;


		PUBLIC 	if1_write_record
		
filename:	defm	3

if1_write_record:
		rst	8
		defb 	31h		; Create Interface 1 system vars if required

		ld	ix,2
		add	ix,sp
		ld	a,(ix+2)
		ld	hl,-1
		and	a		; drive no. = 0 ?
		ret	z		; yes, return -1
		dec	a
		cp	8		; drive no. >8 ?
		ret	nc		; yes, return -1
		inc	a
		;push	af

		ld	($5cd6),a
		
		ld	hl,1
		ld	($5cda),hl	; filename length
		ld	hl,filename	; filename location
		ld	(5cdch),hl	; pointer to filename

		ld	l,(ix+0)	; buffer
		ld	h,(ix+1)

		push	hl

		pop	ix

		rst	8
		defb	26h		; Write Record

		;pop	ix
		;rst	8
		;defb	23h   ; (close)

		;rst	8
		;defb	2Ch   ; reclaim buffer

		xor	a
		rst	8
		defb	21h		; Switch microdrive motor off (a=0)

		ret
