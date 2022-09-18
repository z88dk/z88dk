; int tape_save_block(void *addr, size_t len, unsigned char type)
; CALLER linkage for function pointers

PUBLIC tape_save_block
PUBLIC _tape_save_block

EXTERN asm_tape_save_block

.tape_save_block
._tape_save_block

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
   
   jp asm_tape_save_block
