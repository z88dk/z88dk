; int tape_load_block(void *addr, size_t len, unsigned char type)
; CALLER linkage for function pointers

PUBLIC tape_load_block
PUBLIC _tape_load_block

EXTERN tape_load_block_callee
EXTERN asm_tape_load_block

.tape_load_block
._tape_load_block

;--------------------
;   in   BC=byte size
;        HL=adr.
;   exit CF=0:ok.
;        CF=1:break
;--------------------

   pop af
   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   push af
   ld a,e		; on the MZ the "type" works differently
   
   jp asm_tape_load_block
