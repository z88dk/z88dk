
SECTION code_clib
SECTION code_stdlib

PUBLIC __dtoa_asm_exit

EXTERN __dtoa_print, __dtoa_count

__dtoa_asm_exit:

   ;            bc = buffer length
   ;            de = buffer *
   ;
   ;        (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ;        (IX-5) = iz (number of zeroes to insert before .)
   ;        (IX-4) = fz (number of zeroes to insert after .)
   ;        (IX-3) = tz (number of zeroes to append)
   ;        (IX-2) = ignore
   ;        (IX-1) = '0' marks start of buffer
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

   call __dtoa_print

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

   call __dtoa_count
   jr restore_it
