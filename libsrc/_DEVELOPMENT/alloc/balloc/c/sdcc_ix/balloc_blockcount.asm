
; size_t balloc_blockcount(unsigned int queue)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC _balloc_blockcount

EXTERN asm_balloc_blockcount

_balloc_blockcount:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_balloc_blockcount
