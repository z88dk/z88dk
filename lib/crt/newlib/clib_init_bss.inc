
   ; initialize bss section

   IF __crt_initialize_bss

         EXTERN asm_memset
         EXTERN __BSS_head, __BSS_UNINITIALIZED_head

         ld hl,__BSS_head
         ld bc,__BSS_UNINITIALIZED_head - __BSS_head
         
         ld e,0
         call asm_memset

   ENDIF
