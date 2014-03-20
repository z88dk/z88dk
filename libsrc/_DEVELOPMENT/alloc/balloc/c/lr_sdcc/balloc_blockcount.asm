
; size_t balloc_blockcount(unsigned int queue)

XDEF balloc_blockcount

balloc_blockcount:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_balloc_blockcount.asm"
