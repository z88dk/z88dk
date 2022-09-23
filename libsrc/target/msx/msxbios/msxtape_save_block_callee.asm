;
;      Tape save routine
;
;      Stefano, 2022
;
;      int __CALLEE__ msxtape_save_block_callee(void *addr, size_t len)
;

PUBLIC msxtape_save_header_callee
PUBLIC _msxtape_save_header_callee
PUBLIC msxtape_save_block_callee
PUBLIC _msxtape_save_block_callee
PUBLIC asm_msxtape_save_block
PUBLIC asm_msxtape_save_header


EXTERN	msxbios

IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
ENDIF


.msxtape_save_header_callee
._msxtape_save_header_callee

   pop af
   pop bc
   pop hl
   push af
   ld a,-1
   jr asm_msxtape_save_header


.msxtape_save_block_callee
._msxtape_save_block_callee

   pop af
   pop bc
   pop hl
   push af

.asm_msxtape_save_block

;--------------------
;   in   BC=byte size
;        HL=adr.

;   A: 00H=Short header, NZ=Long header. 
;--------------------

	xor a		;(short header)

.asm_msxtape_save_header
	push ix		; preserve IX for SDCC

	push hl
	push bc
	ld	ix,TAPOON
	call	msxbios
	pop bc
	pop hl

sv_loop:
	ld	a,(hl)

	push hl
	push bc
	ld	ix,TAPOUT
	call	msxbios
	pop bc
	pop hl
	
	jr c,sv_break
	inc hl
	dec bc
	ld a,b
	or c
	jr nz,sv_loop
	
	call stop_tape

	pop	ix
	ld  hl,0
	ret
	

sv_break:
	call stop_tape
	pop	ix
	ld hl,-1		;error, break condition occured during write
	ret



stop_tape:
	push hl
	push bc
	ld	ix,TAPOOF
	call	msxbios
	pop bc
	pop hl
	ret
