
   ; initialize bss section

   EXTERN ASMTAIL_BSS_UNINITIALIZED, ASMHEAD_BSS_END

   IF (__crt_model | __crt_initialize_bss) && ((ASMHEAD_BSS_END - ASMTAIL_BSS_UNINITIALIZED) > 0)

      IF ((ASMHEAD_BSS_END - ASMTAIL_BSS_UNINITIALIZED) = 1)

         xor a
         ld (ASMTAIL_BSS_UNINITIALIZED),a
      
      ELSE

         ld hl,ASMTAIL_BSS_UNINITIALIZED
         ld bc,ASMHEAD_BSS_END - ASMTAIL_BSS_UNINITIALIZED
   
         ld (hl),0
         
         ld e,l
         ld d,h
         
         inc de

         ldir

   ENDIF
