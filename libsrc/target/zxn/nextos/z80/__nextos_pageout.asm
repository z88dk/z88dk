SECTION code_arch

PUBLIC __nextos_page_out

EXTERN __nextos_head

EXTERN __IO_NEXTREG_REG, __REG_MMU0

__nextos_page_out:

   ; restore former 8k page before nextos was brought in
   ;
   ; enter :  a = former 8k page before page in
   ;
   ; exit  :  former 8k page restored in memory
   ;
   ; uses  :  af, bc', l'
   
   exx
   
   ld l,a

   ld a,__nextos_head/256      ; section address start
   rlca
   rlca
   rlca
   and $07                     ; a = mmu page nextos belongs in
   add a,__REG_MMU0
   
   ld bc,__IO_NEXTREG_REG
   out (c),a
   
   inc b
   out (c),l
   
   exx
   ret
