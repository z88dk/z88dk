;
;	open a file on an Amstrad NC100
;

		SECTION code_clib
		PUBLIC open
		PUBLIC _open

.open
._open
	pop af			; return address
	pop bc			; don't care
	pop de			; read or write
	pop hl			; name
	push hl
	push de
	push bc
	push af	

	ld d, 0
	ld a, e			; mode bits
	and 3			; R/W bits
	cp 3
	jr z, open_failed	; Invalid mode
	ld d, 0xB8
	ld e, a
	add a
	add e			; a = modebits x 3
	add 0xA2		; base (A2, A5, A8)
	ld e, a
	call open_callde
open_1:
	jr nc, open_failed
	ex de, hl		; return handle is in DE
	ret
open_failed:
	ld hl, 0xffff
	ret
	
open_callde:
	push de
	ret			; call (de)
