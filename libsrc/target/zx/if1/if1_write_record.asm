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
;	$Id: if1_write_record.asm,v 1.4 2017-01-03 01:40:06 aralbrec Exp $
;

		SECTION code_clib
		PUBLIC 	if1_write_record
      PUBLIC   _if1_write_record

if1_write_record:
_if1_write_record:
		rst	8
		defb 	31h		; Create Interface 1 system vars if required

		push	ix		;save callers
		ld	ix,4
		add	ix,sp
		ld	a,(ix+2)
		ld	hl,-1
		and	a		; drive no. = 0 ?
		jr	z,if1_write_record_exit		; yes, return -1
		dec	a
		cp	8		; drive no. >8 ?
		jr	nc,if1_write_record_exit		; yes, return -1
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
if1_write_record_exit:
		pop	ix		; restore callers
		ret

		SECTION rodata_clib	
filename:	defm	3
