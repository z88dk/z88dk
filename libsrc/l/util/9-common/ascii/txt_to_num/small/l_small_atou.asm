
SECTION code_clib
SECTION code_l

PUBLIC l_small_atou

l_small_atou:

   ; ascii to unsigned integer conversion
   ; whitespace is not skipped
   ; char consumption stops on overflow
   ;
   ; enter : de = char *
   ;
   ; exit  : de = & next char to interpret in buffer
   ;         hl = unsigned result (0 on invalid input)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, bc, de, hl

   ld hl,0
   
   dec de
   push hl

loop:

   pop af
   
   inc de
   ld a,(de)
   
   sub '0'
   ccf
   ret nc
   cp 10
   ret nc

   push hl
   
   add hl,hl
   jr c, overflow
   
   ld c,l
   ld b,h
   
   add hl,hl
   jr c, overflow
   
   add hl,hl
   jr c, overflow
   
   add hl,bc
   jr c, overflow
   
   add a,l
   ld l,a
   jr nc, loop
   
   inc h
   jr nz, loop
   
overflow:

   pop hl
   
   scf
   ret
   