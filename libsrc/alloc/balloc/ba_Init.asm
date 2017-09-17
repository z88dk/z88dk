; Compatibility for the old balloc library

	MODULE	ba_Init

	SECTION	code_alloc_balloc
	PUBLIC	ba_Init
	PUBLIC	_ba_Init

; Clears all memory queues to empty.
;
; enter: HL = number of queues
; uses : F,BC,DE,HL
ba_Init:
_ba_Init:
	add	hl,hl
	ld	c,l
	ld	b,h
	ld	hl,_ba_qtbl
	ld	de,_ba_qtbl + 1
	ld	(hl),0
	dec	bc
	ldir
	ret
	

	SECTION data_alloc_balloc

	PUBLIC	__balloc_array
	EXTERN	_ba_qtbl

__balloc_array:	defw	_ba_qtbl
