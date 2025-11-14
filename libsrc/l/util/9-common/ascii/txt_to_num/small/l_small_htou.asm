
SECTION code_clib
SECTION code_l

PUBLIC l_small_htou

EXTERN l_char2num

l_small_htou:

   ; ascii hex string to unsigned integer
   ; whitespace is not skipped, leading 0x not consumed
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
   
   call l_char2num
   ccf
   ret nc
   cp 16
   ret nc
   
   ld c,a
   
   ld a,h
   and $f0
   jr nz, overflow
   
   ld a,c

   add hl,hl
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
   