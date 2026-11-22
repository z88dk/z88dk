
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_number_tail_long

__stdio_scanf_number_tail_long:

   ; enter :   bc = long *p
   ;         dehl = long
   ;
   ;         carry flag state set by strtol / strtoul
   ;
   ;            carry reset, number is valid
   ;
   ;            carry set, number valid only if dehl != 0
   
   jr nc, number_valid
   
   ld a,d
   or e
   or h
   or l
   
   jr z, number_invalid

number_valid:   

   ; enter :   bc = long *p
   ;         dehl = long

   ; WRITE LONG TO LONG *P
   
   ld a,b
   or c
   ret z                       ; if assignment is suppressed
   
   exx
   inc hl                      ; items assigned++
   exx
   
   push de                     ; save MSW of long
   ex de,hl                    ; de = LSW of long
   ld l,c
   ld h,b                      ; hl = long *p
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   pop de                      ; de = MSW of long
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; *p = long
   
   ret

number_invalid:

   scf
   ret
