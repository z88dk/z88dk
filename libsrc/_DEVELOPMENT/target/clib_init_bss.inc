
   ; initialize bss section

   IF (__crt_model | __crt_initialize_bss)

      EXTERN ASMHEAD_BSS, ASMHEAD_BSS_END

      ld hl,ASMHEAD_BSS
      ld bc,ASMHEAD_BSS_END - ASMHEAD_BSS
   
      ld e,0
   
      EXTERN asm_memset
      call asm_memset

   ENDIF
