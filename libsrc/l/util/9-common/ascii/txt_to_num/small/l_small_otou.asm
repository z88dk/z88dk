
SECTION code_clib
SECTION code_l

PUBLIC l_small_otou

l_small_otou:

   ; ascii octal string to unsigned integer
   ; whitespace is not skipped
   ; char consumption stops on overflow
   ;
   ; enter : de = char *buffer
   ;
   ; exit  : de = & next char to interpret in buffer
   ;         hl = unsigned result (0 on invalid input)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, c, de, hl

   ld hl,0

loop:

   ld a,(de)
   
   sub '0'
   ccf
   ret nc
   cp 8
   ret nc
   
   ld c,a
   
   ld a,h
   and $e0
   
   ld a,c
   jr nz, overflow
   
   add hl,hl
   add hl,hl
   add hl,hl
   
   add a,l
   ld l,a
   
   inc de
   jr loop

overflow:

   scf
   ret
