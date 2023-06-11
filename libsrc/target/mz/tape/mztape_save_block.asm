; int mztape_save_block(void *addr, size_t len)
; CALLER linkage for function pointers

PUBLIC mztape_save_block
PUBLIC _mztape_save_block

EXTERN asm_mztape_save_block

.mztape_save_block
._mztape_save_block

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
   
   jp asm_mztape_save_block
