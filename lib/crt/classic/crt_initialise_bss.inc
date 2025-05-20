
IF CRT_INITIALIZE_BSS = 1
    EXTERN  __BSS_head
    EXTERN  __BSS_END_tail
    xor     a
    ld      hl,__BSS_head
    ld      bc,__BSS_END_tail - __BSS_head - 1
  IF !__CPU_INTEL__ && !__CPU_GBZ80__
    ld      de,__BSS_head + 1
    ld      (hl),a
    ldir
  ELSE
    inc     b
    inc     c
init_8080:
    ld      (hl+),a
    dec     c
    jr      NZ,init_8080
    dec     b
    jr      NZ,init_8080
  ENDIF
ENDIF