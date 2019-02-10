;
;	PX-8 routines
;	by Stefano Bodrato, 2019
;
;	'cmdsequence' is a byte list containing the number of parameters (bytes), the function code and its parameters.
;	The ESC leading character is added by the function transparently.
;
;	$Id: esc_sequence.asm $
;
;	int esc_sequence(char *cmdsequence);
;


	SECTION	code_clib
	
	PUBLIC	esc_sequence
	PUBLIC	esc_sequence
	
	EXTERN	subcpu_call
	
esc_sequence:
_esc_sequence:

.asmentry
	ld	a,27
	push hl
	call conout
	pop hl
	
	ld	a,(hl)
	ld	b,a
	inc b
.outloop
	inc hl
	ld	a,(hl)
	push hl
	push bc
	call	conout
	pop bc
	pop hl
	djnz outloop
	ret

	

.conout
		ld	c,a
		ld	hl,(1)	; WBOOT (BIOS)
		ld  a,9		; CONOUT offset
		add l
		ld  l,a
		jp (hl)
