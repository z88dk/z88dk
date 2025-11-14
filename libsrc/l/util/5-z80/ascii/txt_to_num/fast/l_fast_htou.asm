
SECTION code_clib
SECTION code_l

PUBLIC l_fast_htou

EXTERN l_char2num

l_fast_htou:

   ; ascii hex string to unsigned integer
   ; whitespace is not skipped, leading 0x not consumed
   ; char consumption stops on overflow
   ;
   ; enter : de = char *buffer
   ;
   ; exit  : de = & next char to interpret in buffer
   ;         hl = unsigned result (0 on invalid input, ahl = partial result on overflow)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, bc, de, hl
   
   ld hl,0
   
loop:

   ld a,(de)
   
   call l_char2num
   jr c, done
   cp 16
   jr nc, done
   
   inc de

   add a,a
   add a,a
   add a,a
   add a,a
   ld c,a
   
   ld a,(de)
   
   call l_char2num
   jr c, done_shift
   cp 16
   jr nc, done_shift
   
   inc de
   
   add a,c
   ld c,a
      
   ld a,h
   ld h,l
   ld l,c
   
   or a
   jr z, loop
   
unsigned_overflow:

   scf
   ret

done_shift:

   ld a,c
   
   add a,a
   adc hl,hl

   adc a,a
   adc hl,hl
   
   adc a,a
   adc hl,hl

   adc a,a
   adc hl,hl
   
   adc a,a
   ret z
   
   ; unsigned overflow
   
   scf
   ret

done:

   xor a
   ret
