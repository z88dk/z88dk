
SECTION code_clib
SECTION code_l

PUBLIC l_fast_otou

l_fast_otou:

   ; ascii octal string to unsigned integer
   ; whitespace is not skipped
   ; char consumption stops on overflow
   ;
   ; enter : de = char *buffer
   ;
   ; exit  : de = & next char to interpret in buffer
   ;         hl = unsigned result (0 on invalid input, ahl on overflow)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, c, de, hl

   ld hl,0

loop:

   ld a,(de)
   
   ; inlined isodigit
   
   sub '0'
   ccf
   ret nc
   cp 8
   ret nc
   
   inc de
   
   add hl,hl
               jr c, oflow_1
   add hl,hl
               jr c, oflow_2
   add hl,hl
               jr c, oflow_3
   
   ; hl += digit
   
   add a,l
   ld l,a
   
   jr loop

            oflow_1:
            
               ld c,1
               
               add hl,hl
               rl c
            
            oflow_2a:
            
               add hl,hl
               rl c
            
            oflow_3a:
            
               add a,l
               ld l,a
               
               ld a,c
               scf
               ret
            
            oflow_2:
            
               ld c,1
               jr oflow_2a
            
            oflow_3:

               ld c,1
               jr oflow_3a
