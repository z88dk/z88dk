
   ; initialize data section
   
   IF __crt_model = 1
   
      ; rom model + data segment is not compressed

      EXTERN ASMHEAD_CODE_END, ASMHEAD_DATA, ASMHEAD_DATA_END

      ld hl,ASMHEAD_CODE_END
      ld de,ASMHEAD_DATA
      ld bc,ASMHEAD_DATA_END - ASMHEAD_DATA
      
      EXTERN asm_memcpy
      call asm_memcpy
   
   ENDIF
   
   IF __crt_model = 2
   
      ; rom model + data segment is compressed
      ; there is always at least one byte in the data section
      
      EXTERN ASMHEAD_CODE_END, ASMHEAD_DATA
      
      ld hl,ASMHEAD_CODE_END
      ld de,ASMHEAD_DATA
      
      EXTERN asm_dzx7_standard
      call asm_dzx7_standard
   
   ENDIF
