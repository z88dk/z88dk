;
;      ZX81 Tape save routine
;
;      NOTE: It does not work for addresses < 1024.
;
;      int __CALLEE__ tape_save_block_callee(void *addr, size_t len, unsigned char type)
;
;
;	$Id: tape_save_block_callee.asm,v 1.3 2014-09-28 18:27:01 pauloscustodio Exp $
;


XLIB tape_save_block_callee
XDEF ASMDISP_TAPE_SAVE_BLOCK_CALLEE

LIB  musamy_save

LIB zx_fast
LIB zx_slow


; Very simple header, only check the 'type' byte in a Spectrum-ish way.
; For 'by design' reasons we test a whole word..
;---------
.header
	defw 0
;---------


.tape_save_block_callee

	pop de
	pop bc
	ld a,c
	pop bc
	pop hl
	push de

; enter : ix = addr
;         de = len
;          a = type

.asmentry

		LD (header),a
		
		ld	de,retaddr
		push de

		; Mark the end of the blocks in the stack
		LD DE,0
		PUSH DE

		PUSH BC			;data len
		PUSH HL			; data location

		ld	bc,1		; pseudo-hdr length -1
		push bc
		ld	hl,header	; pseudo-hdr caption, not the name, just the block type !
		push hl
		
		call zx_fast
		jp musamy_save

.retaddr
		push hl
		call zx_slow
		pop hl
		ret


DEFC ASMDISP_TAPE_SAVE_BLOCK_CALLEE = # asmentry - tape_save_block_callee
