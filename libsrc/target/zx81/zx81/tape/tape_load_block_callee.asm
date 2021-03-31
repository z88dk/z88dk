;
;      Tape load routine
;
;
;      int __CALLEE__ tape_load_block_callee(void *addr, size_t len, unsigned char type)
;
;
;	$Id: tape_load_block_callee.asm,v 1.6 2015-08-11 07:16:36 stefano Exp $
;


PUBLIC tape_load_block_callee
PUBLIC asm_tape_load_block

EXTERN zx_fast
EXTERN zx_slow


; Very simple header, only check the 'type' byte in a Spectrum-ish way.
; For design reasons, we test a whole word..
;-----
.header
	defw 0	; LEN
	defw 0	; LOC

.header2
	defw 0	; file type (2 bytes)
;-----


EXTERN  musamy_load

.tape_load_block_callee

	pop de
	pop bc
	ld a,c
	pop bc
	pop hl
	push de

.asm_tape_load_block
		LD (header+2),hl	; LOC
		LD (header),bc	; LEN
		
		ld	e,a
.ld_retry
		push de
		ld hl,rethere
		push hl

		LD HL,header
		PUSH HL

		LD BC,2	; file type len
		PUSH BC
		LD HL,header2
		PUSH HL

		call zx_fast

		;LD L,40h		; VERIFY MODE
		LD L,0			; LOAD MODE
		jp musamy_load

.rethere
		push hl
		call zx_slow
IF FORlambda
		call $1C28	; BREAK-1 on Lambda
ELSE
		call $f46	; BREAK-1 on ZX81
ENDIF
		pop hl
		pop de
		ret nc	; if BREAK is pressed, return; timeout error code is valid for BREAK too
		ld a,3
		cp l	; timeout ?
		jr z,ld_retry

		xor a
		or l
		ret nz	; other errors

		ld a,(header2)
		cp e
		ret z	; all OK

		ld l,4	; file type error		
		ret
