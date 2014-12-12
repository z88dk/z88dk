
   ; initialize data section
   
   IF __crt_model = 1
   
      ; rom model + data segment is not compressed

      EXTERN ASMTAIL_CODE, ASMHEAD_DATA, ASMSIZE_DATA

      ld hl,ASMTAIL_CODE
      ld de,ASMHEAD_DATA
      ld bc,ASMSIZE_DATA
      
      EXTERN asm_memcpy
      call asm_memcpy
   
   ENDIF
   
   IF __crt_model = 2
   
      ; rom model + data segment is compressed
      
      EXTERN ASMTAIL_CODE, ASMHEAD_DATA
      
      ld hl,ASMTAIL_CODE
      ld de,ASMHEAD_DATA
      
      EXTERN asm_dzx7_standard
      call asm_dzx7_standard
   
   ENDIF
