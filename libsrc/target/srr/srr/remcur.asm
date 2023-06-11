;==============================================================
;
; int remcur()
;
;   Removes the cursor from the screen.
;   Returns the cursor address.
;

SECTION code_clib

PUBLIC remcur
PUBLIC _remcur

remcur:
_remcur:
	;PUSH	BC
	call	0e1a2h	; Make IY point to work area (close to RAMPTOP)
	call	0e9e8h	;remove the cursor
	;POP	BC
	ret

