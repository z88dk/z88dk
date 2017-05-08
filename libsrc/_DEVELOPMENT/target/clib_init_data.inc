
   ; initialize data section
   
   IF (__crt_model = 1)
   
      ; rom model + data section is not compressed

      EXTERN __CODE_END_tail
      EXTERN __DATA_head, __DATA_END_tail

      ld hl,__CODE_END_tail
      ld de,__DATA_head
      ld bc,__DATA_END_tail - __DATA_head

      EXTERN asm_memcpy
      call   asm_memcpy
   
   ENDIF
   
   IF (__crt_model >= 2)
   
      ; rom model + data section is compressed
      
      EXTERN __CODE_END_tail
		EXTERN __DATA_head, __DATA_END_tail
      
      ld hl,__CODE_END_tail
      ld de,__DATA_head
      ld bc,__DATA_END_tail - __DATA_head

      ld a,b
      or c

      EXTERN   asm_dzx7_standard
      call nz, asm_dzx7_standard

   ENDIF
