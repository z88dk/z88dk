
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_number_tail_int

__stdio_scanf_number_tail_int:

   ; enter : de = int *p
   ;         hl = integer
   ;
   ;         carry flag state set by strtoi / strtou
   ;
   ;             carry reset, number is valid
   ;
   ;             carry set, number valid only if hl != 0 

   jr nc, number_valid
   
   ld a,h
   or l
   
   jr z, number_invalid

number_valid:

   ; enter : de = int *p
   ;         hl = integer

   ; WRITE INTEGER TO INT *P
   
   ld a,d
   or e
   ret z                       ; if assignment is suppressed
   
   exx
   inc hl                      ; items assigned++
   exx
   
   ex de,hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; *p = integer

   ret

number_invalid:

   scf
   ret
