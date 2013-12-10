
XLIB l_ultoo

LIB l_utoo, l_setmem_de
LIB l1_utoo_lz, l1_utoo_nlz
LIB l2_utoo_lz, l2_utoo_nlz
LIB l3_utoo_lz, l3_utoo_nlz

   scf

l_ultoo:

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

   push hl
   ex de,hl                    ; deal with MSW first
   
   ld e,c
   ld d,b                      ; de = char *buffer
   
   inc h
   dec h
   jr nz, bits_32
   
   inc l
   dec l
   jr nz, bits_24
   
   ; 16 bits
   
   pop hl
      
   jp nc, l_utoo
   
   ld a,'0'
   call l_setmem_de - 10       ; write five leading zeroes
   
   jp l_utoo
   
bits_24:
   
   ld a,'0'
   call c, l_setmem_de - 6     ; write three leading zeroes
   
   ld b,2
   ld a,h
   ld h,l
   ld l,a
   call c, l1_utoo_lz
   call nc, l1_utoo_nlz

join_32:

   ld a,h
   pop hl
   ld b,6
   
   jr c, do_leading
   
   rlca
   rlca
   jp l3_utoo_nlz

do_leading:

   rlca
   rlca
   jp l3_utoo_lz
   
bits_32:
   
   ld a,0
   ld b,5
   call c, l2_utoo_lz
   call nc, l2_utoo_nlz

   jp join_32
