
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
   ;
   ; *10 = *8 + *2 with add hl,hl / rl de. ex (sp),hl is native.
   
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
   rl de
   jr c, overflow_early
   
   push de
   push hl
   
   add hl,hl
   rl de
   jr c, overflow_0
   
   add hl,hl
   rl de
   jr c, overflow_0
   
   ex de,hl
   ex (sp),hl
   add hl,de
   pop de
   ex (sp),hl
   push af                 ; digit; C from LSW add still live
   ld a,l
   adc e
   ld l,a
   ld a,h
   adc d
   ld h,a
   jr c, overflow_digit
   pop af                  ; digit
   ex de,hl
   pop hl
   
   add a,l
   ld l,a
   jr nc, loop
   
   inc h
   jr nz, loop
   
   inc e
   jr nz, loop
   
   inc d
   jr nz, loop
   jr overflow_1

overflow_digit:

   pop af                  ; digit
   pop af                  ; LSW sum

overflow_early:
overflow_1:

   pop hl
   pop de
   
   scf
   ret

overflow_0:

   pop af
   pop af
   
   jr overflow_1
