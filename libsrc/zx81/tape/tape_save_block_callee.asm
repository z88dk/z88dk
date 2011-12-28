;
;      ZX81 Tape save routine
;
;      NOTE: It does not work for addresses < 1024.
;
;      int __CALLEE__ tape_save_block_callee(void *addr, size_t len, unsigned char type)
;

XLIB tape_save_block_callee
XDEF ASMDISP_TAPE_SAVE_BLOCK_CALLEE

LIB  musamy_save

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

		LD (header+1),a

		; Mark the end of the blocks in the stack
		LD DE,0
		PUSH DE

		PUSH BC			;data len
		PUSH HL			; data location

		ld	bc,1		; pseudo-hdr length -1
		push bc
		ld	hl,header	; pseudo-hdr caption, not the name, just the block type !
		push hl

		jp musamy_save


DEFC ASMDISP_TAPE_SAVE_BLOCK_CALLEE = asmentry - tape_save_block_callee
