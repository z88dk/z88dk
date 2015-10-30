
   ; initialize data section
   ; data section is always at least one byte
   
   IF (__crt_model = 1)
   
      ; rom model + data section is not compressed

      EXTERN ASMHEAD_CODE_END
      EXTERN ASMHEAD_DATA, ASMHEAD_DATA_END

      ld hl,ASMHEAD_CODE_END
      ld de,ASMHEAD_DATA
      ld bc,ASMHEAD_DATA_END - ASMHEAD_DATA
      
      ldir
   
   ENDIF
   
   IF (__crt_model = 2)
   
      ; rom model + data section is compressed
      
      EXTERN ASMHEAD_CODE_END
      EXTERN ASMHEAD_DATA
      
      ld hl,ASMHEAD_CODE_END
      ld de,ASMHEAD_DATA
      
      EXTERN asm_dzx7_standard
      call asm_dzx7_standard
   
   ENDIF
