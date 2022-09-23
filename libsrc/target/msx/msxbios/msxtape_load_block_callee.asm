;
;      Tape load routine
;
;      Stefano, 2022
;
;      int __CALLEE__ msxtape_load_block_callee(void *addr, size_t len)
;

PUBLIC msxtape_load_block_callee
PUBLIC _msxtape_load_block_callee
PUBLIC asm_msxtape_load_block


EXTERN	msxbios

IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
ENDIF



.msxtape_load_block_callee
._msxtape_load_block_callee

   pop af
   pop bc
   pop hl
   push af
   
.asm_msxtape_load_block

;--------------------
;   in   BC=byte size
;        HL=adr.
;--------------------


	push ix		; preserve IX for SDCC

	push hl
	push bc
	xor a		;(short header)
	ld	ix,TAPION
	call	msxbios
	pop bc
	pop hl

ld_loop:
	push hl
	push bc
	ld	ix,TAPIN
	call	msxbios
	pop bc
	pop hl

	ld	(hl),a
	
	jr c,ld_break
	inc hl
	dec bc
	ld a,b
	or c
	jr nz,ld_loop

	call stop_tape

	pop	ix
	ld  hl,0
	ret


ld_break:
	call stop_tape
	pop	ix
	ld hl,-1		;error, break condition occured during write
	ret



stop_tape:
	push hl
	push bc
	ld	ix,TAPIOF
	call	msxbios
	pop bc
	pop hl
	ret
