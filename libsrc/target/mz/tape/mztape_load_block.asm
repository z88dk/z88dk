; int mztape_load_block(void *addr, size_t len)
; CALLER linkage for function pointers

PUBLIC mztape_load_block
PUBLIC _mztape_load_block

EXTERN asm_mztape_load_block

.mztape_load_block
._mztape_load_block

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
   
   jp asm_mztape_load_block
