;
;      Tape load routine
;
;
;      int __CALLEE__ tape_load_block_callee(void *addr, size_t len, unsigned char type)
;


XLIB tape_load_block_callee
XDEF ASMDISP_TAPE_LOAD_BLOCK_CALLEE

; Very simple header, only check the 'type' byte in a Spectrum-ish way.
; For design reasons, we test a whole word..
;-----
.header
	defw 0	; LEN
	defw 0	; LOC

.header2
	defw 0	; file type (2 bytes)
;-----


LIB  musamy_load

.tape_load_block_callee

	pop de
	pop bc
	ld a,c
	pop bc
	pop hl
	push de

.asmentry
		LD (header+2),hl	; LOC
		LD (header),bc	; LEN
		
		ld	e,a
		push de
		ld hl,rethere
		push hl

		LD HL,header
		PUSH HL

		LD BC,2	; file type len
		PUSH BC
		LD HL,header2
		PUSH HL

		;LD L,40h		; VERIFY MODE
		LD L,0			; LOAD MODE
		jp musamy_load

.rethere
		pop de
		xor a
		or l
		ret nz	; other errors
		ld a,(header2)
		cp e
		ret z	; all OK
		ld l,4	; file type error		
		ret


DEFC ASMDISP_TAPE_LOAD_BLOCK_CALLEE = asmentry - tape_load_block_callee
