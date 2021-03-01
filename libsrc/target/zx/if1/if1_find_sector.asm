;
;	ZX IF1 & Microdrive functions
;	
;	int if1_find_sector (int drive);
;
;	Find a free sector in the specified drive
;
;	Create an empty file, then delete it just to discover
;	which sector can be written !!!.
;
;	
;	$Id: if1_find_sector.asm $
;

		SECTION   code_clib
		PUBLIC 	if1_find_sector
		PUBLIC 	_if1_find_sector


if1_find_sector:
_if1_find_sector:

		push hl
		
		rst	8
		defb 	31h		; Create Interface 1 system vars if required

		pop	bc	;driveno

		ld      a,c
		ld      hl,-1
		and     a               ; drive no. = 0 ?
		ret     z               ; yes, return -1
		cp      9               ; drive no. >8 ?
		ret     nc              ; yes, return -1
		ld	($5cd6),a

		push	ix	;save callers

		
		ld	hl,4
		ld	($5cda),hl	; filename length
		ld	hl,filename	; filename location
		ld	(5cdch),hl	; pointer to filename

		;rst	8		; Erase if file exists ?
		;defb	24h
		
		rst	8
		defb	22h		; Open temporary 'M' channel (touch)
		; Now IX points to the newly created channel

		ld	a,(ix+29h)	; pick the sector number...
		ld	l,a
		ld	h,0
		push	hl		; ..and save it onto the stack

		rst	8
		defb	2Ch		; Reclaim an "M" channel
		
		pop	hl
		pop	ix		;restore callers
		
		ret

                SECTION   rodata_clib
filename:	defm	"0-!g"
