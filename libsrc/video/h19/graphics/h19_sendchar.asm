;
;	Heath/Zenith H19 specific code
;	Use the CP/M BIOS to send characters to screen.
;	L = character to be sent
;
;	Stefano Bodrato - 2023
;
;	$Id: h19_sendchar.asm $
;

	SECTION	code_clib
	PUBLIC	h19_sendchar
	PUBLIC	_h19_sendchar
	
;	EXTERN __bdos

.h19_sendchar
._h19_sendchar


;	push af
;	push bc
;	push de
;	push hl
;	ld d,0
;	ld e,l
;	ld	c,2
;	call	__bdos
;	pop hl
;	pop de
;	pop bc
;	pop af
;	ret
;

; ..using the BIOS
	push af
	push bc
	push de
	ld c,l
	ld   de,9	; shift ptr to CONOUT
	ld   hl,(1)	; WBOOT (BIOS)
	add  hl,de
	call __chl
	pop de
	pop bc
	pop af
	ret
	
__chl:
	jp   (hl)

