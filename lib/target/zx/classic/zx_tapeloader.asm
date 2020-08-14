
    EXTERN  __DATA_END_tail
    EXTERN  __BANK_0_END_tail
    EXTERN  __BANK_1_END_tail
    EXTERN  __BANK_2_END_tail
    EXTERN  __BANK_3_END_tail
    EXTERN  __BANK_4_END_tail
    EXTERN  __BANK_5_END_tail
    EXTERN  __BANK_6_END_tail
    EXTERN  __BANK_7_END_tail


     ; Tape loader
;     ld   ix,CRT_ORG_CODE
;     ld   de,__DATA_END_tail - CRT_ORG_CODE
;     xor  a   ;Bank 0
;     call load_block
;     ret  c
     ld   ix,CRT_ORG_BANK_0
     ld   de,__BANK_0_END_tail - CRT_ORG_BANK_0
     ld   c,16 ;Bank 0
     call load_block
     ret  c
     ld   ix,CRT_ORG_BANK_1
     ld   de,__BANK_1_END_tail - CRT_ORG_BANK_1
     ld   c,17 ;Bank 1
     call load_block
     ret  c
     ld   ix,CRT_ORG_BANK_2
     ld   de,__BANK_2_END_tail - CRT_ORG_BANK_2
     ld   c,18 ;Bank 2
     call load_block
     ret  c
     ld   ix,CRT_ORG_BANK_3
     ld   de,__BANK_3_END_tail - CRT_ORG_BANK_3
     ld   c,19 ;Bank 3
     call load_block
     ret  c
     ld   ix,CRT_ORG_BANK_4
     ld   de,__BANK_4_END_tail - CRT_ORG_BANK_4
     ld   c,20 ;Bank 4
     call load_block
     ret  c
     ld   ix,CRT_ORG_BANK_5
     ld   de,__BANK_5_END_tail - CRT_ORG_BANK_5
     ld   c,21 ;Bank 5
     call load_block
     ret  c
     ld   ix,CRT_ORG_BANK_6
     ld   de,__BANK_6_END_tail - CRT_ORG_BANK_6
     ld   c,22 ;Bank 6
     call load_block
     ret  c
     ld   ix,CRT_ORG_BANK_7
     ld   de,__BANK_7_END_tail - CRT_ORG_BANK_7
     ld   c,23 ;Bank 7
     call load_block
     di
     ld   a,16
     ld   (23388),a
     ld   bc,32765
     out  (c),a
     ei
     ret


load_block:
     ld   a,d
     or   e
     ret  z     ;Nothing to load
     ld   a,c
     di
     ld   (23388),a
     ld   bc,32765
     out  (c),a
     ei
     ld   hl,(23613)
     push hl
     ld   hl,load_block1
     push hl
     ld   (23613),sp
     ld   a,255  ;Data block
     scf         ;Load
     call 1366
load_block1:
     pop  hl
     pop  hl
     ld   (23613),hl
     and  a
     ret
