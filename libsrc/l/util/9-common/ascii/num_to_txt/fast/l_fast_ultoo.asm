
SECTION code_clib
SECTION code_l

PUBLIC l_fast_ultoo

EXTERN l_fast_utoo, l_setmem_de
EXTERN l1_fast_utoo_lz, l1_fast_utoo_nlz
EXTERN l2_fast_utoo_lz, l2_fast_utoo_nlz
EXTERN l3_fast_utoo_lz, l3_fast_utoo_nlz

l_fast_ultoo:

   ; write unsigned octal long to ascii buffer
   ;
   ; enter : dehl = unsigned long
   ;           bc = char *buffer
   ;         carry set to write leading zeroes
   ;
   ; exit  : de   = char *buffer (one byte past last char written)
   ;         carry set if in write loop
   ;
   ; uses  : af, bc, de, hl

   inc d
   dec d
   jr nz, _32_bit
   
   inc e
   dec e
   jr nz, _24_bit
   
_16_bit:
   
   ld e,c
   ld d,b                      ; de = char *buffer
   
   jp nc, l_fast_utoo

   ld a,'0'
   call l_setmem_de - 10       ; write five leading zeroes
   
   jp l_fast_utoo

_24_bit:

   push hl                     ; save LSW
   ld h,e
   
   ld e,c
   ld d,b                      ; de = char *buffer

   ld c,h
   ld b,2
   
   jr c, leading_zeroes_24
   
   xor a
   call l1_fast_utoo_nlz

rejoin_24:

   pop hl
   ld b,6
   
   jr c, rejoin_24_lz

   ld a,c
   and $03

   dec de
   jp l3_fast_utoo_nlz

rejoin_24_lz:

   ld a,c
   and $03
   
   jp l3_fast_utoo_lz

leading_zeroes_24:

   ld a,'0'
   call l_setmem_de - 6

   xor a
   call l1_fast_utoo_lz
   
   jr rejoin_24

_32_bit:

   push hl                     ; save LSW
   ex de,hl
   
   ld e,c
   ld d,b                      ; de = char *buffer
   
   ld c,l
   ld b,5

   ld a,0
   call c, l2_fast_utoo_lz
   call nc, l2_fast_utoo_nlz

   jr rejoin_24
