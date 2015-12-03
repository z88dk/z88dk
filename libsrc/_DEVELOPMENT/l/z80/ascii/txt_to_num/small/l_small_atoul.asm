
SECTION code_clib
SECTION code_l

PUBLIC l_small_atoul

l_small_atoul:

   ; ascii buffer to unsigned long conversion
   ; whitespace is not skipped
   ; char consumption stops on overflow
   ;
   ; enter : de = char *
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
   
   dec bc
   push de
   push hl

loop:

   pop af
   pop af
   
   inc bc
   ld a,(bc)
   
   sub '0'
   ccf
   ret nc
   cp 10
   ret nc
   
   push de
   push hl
   
   add hl,hl
   rl e
   rl d
   jr c, overflow_0
   
   push de
   push hl
   
   add hl,hl
   rl e
   rl d
   jr c, overflow_0
   
   add hl,hl
   rl e
   rl d
   jr c, overflow_0
   
   ex de,hl
   ex (sp),hl
   add hl,de
   pop de
   ex (sp),hl
   adc hl,de
   ex de,hl
   pop hl
   jr c, overflow_1
   
   add a,l
   ld l,a
   jr nc, loop
   
   inc h
   jr nz, loop
   
   inc e
   jr nz, loop
   
   inc d
   jr nz, loop

overflow_1:

   pop hl
   pop de
   
   scf
   ret

overflow_0:

   pop af
   pop af
   
   jr overflow_1
