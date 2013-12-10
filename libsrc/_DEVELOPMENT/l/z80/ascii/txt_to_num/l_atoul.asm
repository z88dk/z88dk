
XLIB l_atoul
LIB l_atou

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

   push de
   push hl                     ; save dehl*2
               jr c, oflow_1
               
   add hl,hl
   rl e
   rl d
               jr c, oflow_2

   add hl,hl
   rl e
   rl d

   ex de,hl
   ex (sp),hl
               jr c, oflow_3
   add hl,de
   pop de
   ex (sp),hl
   adc hl,de
   ex de,hl
   pop hl
               jr c, oflow_4

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
   
   ret


            oflow_1:
            
               add hl,hl
               rl e
               rl d
            
            oflow_2:
            
               add hl,hl
               rl e
               rl d
               ex de,hl
               ex (sp),hl
            
            oflow_3:
            
               add hl,de
               pop de
               ex (sp),hl
               adc hl,de
               ex de,hl
               pop hl
            
            oflow_4:
            
               add a,l
               ld l,a
               ccf
               ret c
               scf
               
               inc h
               ret nz
               
               inc de
               ret
