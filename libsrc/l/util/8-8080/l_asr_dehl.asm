
SECTION code_clib
SECTION code_l

PUBLIC l_asr_dehl

l_asr_dehl:
   ; arithmetic shift right 32-bit signed long (8080 / 8085 — no CB shifts)
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl >> a   (sign-propagating)
   ;
   ; uses  : af, b, de, hl

   or       a
   ret      z

   cp       32
   jp       c, l_asr_dehl_go
   ld       a,31          ; a>=32 is UB in C; 31 shifts already give full sign fill

l_asr_dehl_go:
   ld       b,a

l_asr_dehl_loop:
   ld       a,d
   rla                    ; CY = bit7 of D (the sign)
   ld       a,d
   rra                    ; D = D >>1 with sign shifted back in, bit0 -> CY
   ld       d,a
   ld       a,e
   rra
   ld       e,a
   ld       a,h
   rra
   ld       h,a
   ld       a,l
   rra
   ld       l,a
   djnz     l_asr_dehl_loop
   ret
