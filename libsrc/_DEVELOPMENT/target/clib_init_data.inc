
   ; initialize data section
   ; data section is always at least one byte
   
   IF (__crt_model = 1)
   
      ; rom model + data section is not compressed

      EXTERN __CODE_END_head
      EXTERN __DATA_head, __DATA_END_tail

      ld hl,__CODE_END_head
      ld de,__DATA_head
      ld bc,__DATA_END_tail - __DATA_head
      
      ldir
   
   ENDIF
   
   IF (__crt_model >= 2)
   
      ; rom model + data section is compressed
      
      EXTERN __CODE_END_head, __DATA_head
      
      ld hl,__CODE_END_head
      ld de,__DATA_head
      
      EXTERN asm_dzx7_standard
      call asm_dzx7_standard
   
   ENDIF
