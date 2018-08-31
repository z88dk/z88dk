; int compare_dostm(struct dos_tm *a, struct dos_tm *b)

SECTION code_time

PUBLIC asm_compare_dostm

EXTERN error_mc, error_onc

asm_compare_dostm:

   ; enter : hl = struct dos_tm *a
   ;         bc = struct dos_tm *b
   ;
   ; exit  : if a < b : hl = -1, carry set
   ;         if a = b : hl =  0, carry reset, z set
   ;         if a > b : hl =  1, carry reset, nz set
   ;
   ; uses  : af, bc, de, hl
   
   inc hl
   inc hl
   inc hl
   
   inc bc
   inc bc
   inc bc
   
   ld d,(hl)
   dec hl
   ld a,(hl)                   ; da = a->date
   
   sub $20                     ; make month zero based
   ld e,a
   sbc a,a
   add a,d
   ld d,a                      ; de = adjusted a->date
   
   push hl                     ; save &a->date
   
   ld l,c
   ld h,b
   
   ld b,(hl)
   dec hl
   ld a,(hl)                   ; ba = b->date
   
   sub $20                     ; make month zero based
   ld c,a
   sbc a,a
   add a,b
   ld b,a                      ; bc = adjusted b->date
   
   ex de,hl                    ; de = &b->date
   
   xor a
   sbc hl,bc
   
   jp c, error_mc - 1          ; return with hl = -1
   jp nz, error_onc - 1        ; return with hl = 1
   
   ex de,hl                    ; hl = &b->date
   
   dec hl
   ld b,(hl)
   dec hl
   ld c,(hl)                   ; bc = b->time
   
   pop hl                      ; hl = &a->date
   
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a                      ; hl = a->time
   
   sbc hl,bc
   
   jp c, error_mc              ; return with hl = -1
   jp nz, error_onc            ; return with hl = 1
   
   ret                         ; return with hl = 0
