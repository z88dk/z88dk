
SECTION code_stdlib

PUBLIC __ftoa_asm_exit

EXTERN __ftoa_print, __ftoa_count

__ftoa_asm_exit:

   ;            bc = buffer length
   ;            de = buffer *
   ;
   ;           (IX-5) = flags, bit 7='N', bit 4='#', bit 0=(precision==0), others unaffected
   ;           (IX-4) = tz (number of zeroes to append)
   ;           (IX-3) = fz (number of zeroes to insert after .)
   ;           (IX-2) = iz (number of zeroes to insert before .)
   ;           (IX-1) = ignore
   ;
   ;         if carry set, special form just output buffer with sign
   ;
   ;            stack = char *buf

   ex af,af'
   
   pop hl                      ; hl = char *buf
   
   ld a,h
   or l
   jr z, count_it

print_it:

   call __ftoa_print

restore_it:
   
   ld c,l
   ld b,h
   
   ld hl,32
   add hl,sp
   ld sp,hl
   
   ld l,c
   ld h,b
   
   ret

count_it:

   call __ftoa_count
   jr restore_it
