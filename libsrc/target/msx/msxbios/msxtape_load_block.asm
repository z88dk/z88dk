; int msxtape_load_block(void *addr, size_t len)
; CALLER linkage for function pointers

PUBLIC msxtape_load_block
PUBLIC _msxtape_load_block
PUBLIC ___msxtape_load_block

EXTERN asm_msxtape_load_block

.msxtape_load_block
._msxtape_load_block
.___msxtape_load_block

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
   
   jp asm_msxtape_load_block
