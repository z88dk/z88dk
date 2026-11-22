SECTION code_arch

PUBLIC __nextos_page_in

EXTERN __nextos_head
EXTERN __nextos_page

EXTERN __IO_NEXTREG_REG, __REG_MMU0

__nextos_page_in:

   ; bring 8k page holding nextos functions into memory
   ;
   ; exit :  a = former 8k page before page in
   ;         nextos page in memory
   ;
   ; uses :  af, bc', l'
   
   exx
   
   ld a,__nextos_head/256      ; section address start
   rlca
   rlca
   rlca
   and $07                     ; a = mmu page nextos belongs in
   add a,__REG_MMU0
   
   ld bc,__IO_NEXTREG_REG
   out (c),a
   
   inc b
   in l,(c)                    ; l = current 8k page in memory
   
   ld a,(__nextos_page)
   out (c),a                   ; bring nextos in
   
   ld a,l
   
   exx
   ret
