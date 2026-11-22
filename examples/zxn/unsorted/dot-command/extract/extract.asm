SECTION code_user

PUBLIC _extract_get_mmu

_extract_get_mmu:

   ; When loading pages, a particular page must be brought
   ; into a specific mmu slot.  However that mmu slot must
   ; not be occupied by the stack.  This subroutine chooses
   ; a suitable mmu slot to do this paging.
   
   ; exit : hl = mmu slot to use
   ;
   ; used : af, hl
   
   ld hl,0xa000

   xor a
   sbc hl,sp
   
   ld l,7
   ld h,a
   
   ret nc
   
   ld l,3
   ret
