
   ; initialize bss section

   IF (__crt_model | __crt_initialize_bss)

         ; bss section is always at least one byte

         EXTERN ASMTAIL_BSS_UNINITIALIZED, ASMHEAD_BSS_END

         ld hl,ASMTAIL_BSS_UNINITIALIZED
         ld bc,ASMHEAD_BSS_END - ASMTAIL_BSS_UNINITIALIZED - 1
   
         ld (hl),0
         
         ld a,b
         or c
         jr z, bss_init_done
         
         ld e,l
         ld d,h
         
         inc de

         ldir

      bss_init_done:

   ENDIF
