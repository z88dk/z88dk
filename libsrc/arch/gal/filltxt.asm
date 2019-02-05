;
;       Galaksija libraries
;
;----------------------------------------------------------------
;
;	$Id: filltxt.asm $
;
;----------------------------------------------------------------
;
; Fill text memory with specified character code
;
;----------------------------------------------------------------

	SECTION code_clib
	PUBLIC   filltxt
	PUBLIC   _filltxt

filltxt:
_filltxt:
	; __FASTCALL__ mode
	ld	e,l
	ld	hl,$2800        ; DFILE ADDR
	ld	bc,32*16
fillp:
	LD (HL),e            ; POKE DFILE
	inc hl
	dec bc
	ld	a,b
	or c
	jr nz,fillp
	ret
