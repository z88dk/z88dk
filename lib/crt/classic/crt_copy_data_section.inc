; For ROM compilations copy the data section up into RAM

IF ( __crt_model = 1 )
    ; Just copy the DATA section
    EXTERN  __ROMABLE_END_tail
    EXTERN  __DATA_head
    EXTERN  __DATA_END_tail
    ld      hl,__ROMABLE_END_tail
    ld      de,__DATA_head
    ld      bc,__DATA_END_tail - __DATA_head
  IF __CPU_INTEL__
    EXTERN  asm_memcpy
    call    asm_memcpy
  ELSE
    ldir
  ENDIF
ELIF ( __crt_model >= 2 )
    EXTERN  __ROMABLE_END_tail
    EXTERN  __DATA_head
    ld      hl,__ROMABLE_END_tail
    ld      de,__DATA_head
  IF ( __crt_model = 2)
    EXTERN  asm_dzx7_standard
    call    asm_dzx7_standard
  ELIF ( __crt_model = 3)
    EXTERN  asm_dzx0_standard
    call    asm_dzx0_standard
  ENDIF
ENDIF