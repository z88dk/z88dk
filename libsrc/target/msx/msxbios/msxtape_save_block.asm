; int msxtape_save_block(void *addr, size_t len)
; CALLER linkage for function pointers

PUBLIC msxtape_save_block
PUBLIC _msxtape_save_block
PUBLIC ___msxtape_save_block

EXTERN asm_msxtape_save_block

.msxtape_save_block
._msxtape_save_block
.___msxtape_save_block

;--------------------
;   in   BC=byte size
;        HL=adr.
;--------------------

   pop af
   pop bc
   pop hl
   push hl
   push bc
   push af
   
   jp asm_msxtape_save_block
