
   ; initialize bss section

   IF crt_model

      ; zero bss section if not ram model

      EXTERN ASMHEAD_BSS, ASMSIZE_BSS

      ld hl,ASMHEAD_BSS
      ld bc,ASMSIZE_BSS
   
      ld e,0
   
      EXTERN asm_memset
      call asm_memset

   ENDIF
