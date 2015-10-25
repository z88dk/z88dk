
   ; initialize data section
   
   EXTERN ASMHEAD_CODE_END, ASMHEAD_DATA, ASMHEAD_DATA_END
   
   IF (__crt_model = 1) && ((ASMHEAD_DATA_END - ASMHEAD_DATA) > 0)
   
      ; rom model + data segment is not compressed

      ld hl,ASMHEAD_CODE_END
      ld de,ASMHEAD_DATA
      ld bc,ASMHEAD_DATA_END - ASMHEAD_DATA
      
      ldir
   
   ENDIF
   
   IF (__crt_model = 2) && ((ASMHEAD_DATA_END - ASMHEAD_DATA) > 0)
   
      ; rom model + data segment is compressed
      
      ld hl,ASMHEAD_CODE_END
      ld de,ASMHEAD_DATA
      
      EXTERN asm_dzx7_standard
      call asm_dzx7_standard
   
   ENDIF
