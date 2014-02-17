
XLIB l_atoul
LIB l_atou, error_mc

l_atoul:

   ; ascii buffer to unsigned long conversion
   ; whitespace is not skipped
   ; char consumption stops on overflow
   ;
   ; enter : de = char *
   ;
   ; exit  : bc = & next char to interpret in buffer
   ;         dehl = unsigned result (0 on invalid input, and $ffffffff on overflow)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, bc, de, hl
   
   call l_atou                 ; try to do it in 16 bits
   
   ld c,e
   ld b,d
   
   ld de,0
   ret nc                      ; was 16-bit
   
   ld e,a                      ; e = overflow from 16 bit result
   
   ; 32 bit loop
   
loop:

   ld a,(bc)

   ; inlined isdigit
   
   sub '0'
   ccf
   ret nc
   cp 10
   ret nc
   
   inc bc
   
   ; dehl *= 10

   add hl,hl
   rl e
   rl d
               jr c, oflow_0
   push de
   push hl                     ; save dehl*2

   add hl,hl
   rl e
   rl d
               jr c, oflow_1

   add hl,hl
   rl e
   rl d
               jr c, oflow_1

   ex de,hl
   ex (sp),hl
   add hl,de
   pop de
   ex (sp),hl
   adc hl,de
   ex de,hl
   pop hl
               jr c, oflow_0

   ; dehl += digit
   
   add a,l
   ld l,a
   jp nc, loop
   
   inc h
   jp nz, loop
   
   inc e
   jp nz, loop
   
   inc d
   jp nz, loop
   
   ; unsigned overflow has occurred
   
   dec de
   dec h
   ld l,h
   
   ret

oflow_1:

   pop de
   pop de                      ; junk two items on stack

oflow_0:

   ld de,$ffff
   jp error_mc
