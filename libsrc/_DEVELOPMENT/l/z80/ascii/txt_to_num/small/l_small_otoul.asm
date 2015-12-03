
SECTION code_clib
SECTION code_l

PUBLIC l_small_otoul

l_small_otoul:

   ; ascii octal string to unsigned long
   ; whitespace is not skipped
   ; char consumption stops on overflow
   ;
   ; enter : de = char *buffer
   ;
   ; exit  : bc = & next char to interpret in buffer
   ;         dehl = unsigned result (0 on invalid input)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, bc, de, hl

   ld c,e
   ld b,d
   
   ld de,0
   ld l,e
   ld h,d
   
loop:

   ld a,(bc)
   
   sub '0'
   ccf
   ret nc
   cp 8
   ret nc
   
   push bc
   
   ld c,a
   
   ld a,d
   and $e0
   
   ld a,c
   jr nz, overflow
   
   ld b,3

shift_loop:

   add hl,hl
   rl e
   rl d
   
   djnz shift_loop
   
   pop bc
   
   add a,l
   ld l,a
   
   inc bc
   jr loop

overflow:

   pop bc
   
   scf
   ret
