
SECTION code_clib
SECTION code_l

PUBLIC l_asr_dehl

l_asr_dehl:

   ; arithmetic shift right 32-bit signed long
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl >> a   (sign-propagating)
   ;
   ; uses  : af, b, de, hl

   or a
   ret z

   cp 32
   jp c, l_asr_dehl_go
   ld a,31                ; a>=32 is UB in C; 31 shifts give full sign fill

l_asr_dehl_go:
   ld b,a

l_asr_dehl_loop:

   ex de,hl
   sra hl                 ; MSW; C = old bit 0 of E
   ex de,hl

   ld a,h
   rra
   ld h,a
   ld a,l
   rra
   ld l,a

   dec b
   jp nz, l_asr_dehl_loop
   ret
