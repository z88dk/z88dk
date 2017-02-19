
   ; initialize bss section

   IF __crt_initialize_bss

         EXTERN asm_memset
         EXTERN __BSS_UNINITIALIZED_tail, __BSS_END_tail

         ld hl,__BSS_UNINITIALIZED_tail
         ld bc,__BSS_END_tail - __BSS_UNINITIALIZED_tail
         
         ld e,0
         call asm_memset

   ENDIF
