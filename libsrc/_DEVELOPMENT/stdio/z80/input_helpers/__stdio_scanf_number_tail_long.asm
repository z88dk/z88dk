
XLIB __stdio_scanf_number_tail_long

__stdio_scanf_number_tail_long:

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
