
   ; initialize bss section

   IF __crt_model | __crt_initialize_bss

      EXTERN ASMHEAD_BSS, ASMSIZE_BSS

      ld hl,ASMHEAD_BSS
      ld bc,ASMSIZE_BSS
   
      ld e,0
   
      EXTERN asm_memset
      call asm_memset

   ENDIF
