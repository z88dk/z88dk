
SECTION code_stdlib

PUBLIC __ftoa_preamble

EXTERN l_setmem_hl, __ftoa_sgnabs

__ftoa_preamble:

   ; enter :  c = flags (bit 4=#, bits 7 and 0 will be modified)
   ;         de = precision (clipped at 255)
   ;         hl = buffer *
   ;         exx set contains float

   ld a,c
   and $7e                     ; zero bits 7,0 of flags
   ld c,a

   ld a,d
   or a
   jr z, check_prec
   ld e,$ff                    ; max precision is 255

check_prec:

   or e
   jr nz, init_buffer
   inc c                       ; indicate precision == 0

init_buffer:

   ;   C = flags
   ;   E = precision
   ;  HL = buffer *
   ; EXX = float x

   ld (hl),c
   inc hl

   xor a
   call l_setmem_hl - 6
   
   ld (hl),'0'
   inc hl
   
   push hl
   pop ix

   ; determine sign of x

   call __ftoa_sgnabs          ; supplied by math library
   
   rra                         ; sign bit to carry flag
   ret nc   

   set 7,(ix-5)                ; indicate float is negative

   ; EXX    = float x
   ;  E     = precision
   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; (IX-5) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = '0' marks start of buffer
   
   ret
