

		SECTION		code_clib

		PUBLIC		generic_console_xypos

		EXTERN		__laser500_mode

		defc		DISPLAY = 0xf800 - 0x8000

;
; Entry: b = character y
;        c = character x
; Exit:
;      hl = 80 column position
;      bc = extra step to get to 40 columns
; Preserves: af
generic_console_xypos:
	push	af
	ld	a,b		; Modulus 8 
	and	7
	ld	h,a		;*256
	ld	l,0
	srl	b		;y/ 8
	srl	b
	srl	b
	ld	de,80
	inc	b
generic_console_xypos_1:
	add	hl,de
	djnz	generic_console_xypos_1
	and	a		;We went one row too far
	sbc	hl,de
generic_console_xypos_3:
	add	hl,bc			;hl now points to address in display
	ld	de,DISPLAY
	ld	a,(__laser500_mode)
	cp	2
	jr	nz,not_hires
	ld	de,$4000
not_hires:
	add	hl,de
	pop	af
	ret
