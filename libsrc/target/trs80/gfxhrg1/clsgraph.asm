;
;       HRG1 Hi-Rez graphics routines for TRS-80
;
;       Stefano Bodrato 2021
;

	SECTION	  code_clib
	PUBLIC    clsgraph
	PUBLIC    _clsgraph
	PUBLIC    clg
	PUBLIC    _clg

	INCLUDE	"graphics/grafix.inc"


.clsgraph
._clsgraph
.clg
._clg

	out (1),a   ; enable graphics
	
	ld	hl,16383
	ld	bc,2	; LSB for graphics address

.clsloop	
	inc bc
	out (c),h	; set MSB
	dec bc
	out (c),l	; set LSB
	
	xor a
	;ld	a,h
	;add l
	
	out (5),a	; write 0 (or pattern) to display

	dec hl
	ld	a,h
	or  l
	jr nz,clsloop

	ret
