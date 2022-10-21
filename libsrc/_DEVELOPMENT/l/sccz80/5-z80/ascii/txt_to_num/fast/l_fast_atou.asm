
SECTION code_clib
SECTION code_l

PUBLIC l_fast_atou

l_fast_atou:

   ; ascii to unsigned integer conversion
   ; whitespace is not skipped
   ; char consumption stops on overflow
   ;
   ; enter : de = char *
   ;
   ; exit  : de = & next char to interpret in buffer
   ;         hl = unsigned result (0 on invalid input)
   ;         carry set on unsigned overflow with ahl = partial result
   ;
   ; uses  : af, bc, de, hl

   ld hl,0

   ld a,(de)
   
   ; inlined isdigit
   
   sub '0'
   ccf
   ret nc
   cp 10
   ret nc

   ld l,a
   inc de

loop:

   ld a,(de)
   
   ; inlined isdigit
   
   sub '0'
   ccf
   ret nc
   cp 10
   ret nc

   inc de

   ; hl *= 10
   
   add hl,hl
   ld c,l
   ld b,h
               jr c, oflow_1
   add hl,hl
               jr c, oflow_2
   add hl,hl
               jr c, oflow_3
   add hl,bc
               jr c, oflow_4

   ; hl += digit
   
   add a,l
   ld l,a
   jr nc, loop
   
   inc h
   jr nz, loop

   ; unsigned overflow has occurred

   ld a,1
   ret

            oflow_1:

               ; tricky -- bc is actually 17-bits here
               ; so must come back and increment the top byte
               
               call oflow_1a
               
               inc a
               ret
            
            oflow_1a:
            
               push de
               ld e,1

               add hl,hl
               rl e

            oflow_2a:

               add hl,hl
               rl e

            oflow_3a:

               add hl,bc
               jr nc, oflow_4a
               inc e

            oflow_4a:

               add a,l
               ld l,a
               jr nc, skip
               
               inc h
               jr nz, skip
               
               inc e
            
            skip:
            
               ld a,e
               pop de
               
               scf
               ret

            oflow_2:
            
               push de
               ld e,1
               jr oflow_2a
            
            oflow_3:
            
               push de
               ld e,1
               jr oflow_3a
               
            oflow_4:
            
               push de
               ld e,1
               jr oflow_4a
