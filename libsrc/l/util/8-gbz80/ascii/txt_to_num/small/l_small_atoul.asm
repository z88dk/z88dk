
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
   ; *10 = *8 + *2. Digit stays in A through the shifts. *2 LSW
   ; stays in BC. No dummy stack frame and no ex (sp),hl.
   
   ld bc,de
   
   ld de,0
   ld hl,de

loop:

   ld a,(bc)
   
   sub '0'
   ccf
   ret nc
   cp 10
   ret nc
   
   push de                 ; last good MSW
   push hl                 ; last good LSW
   push bc                 ; string
   
   add hl,hl
   rl e
   rl d
   jr c, overflow_2        ; *2 overflow: value >= 2^31
   
   push de                 ; *2 MSW
   ld bc,hl                ; *2 LSW
   
   add hl,hl
   rl e
   rl d
   jr c, overflow_3
   
   add hl,hl
   rl e
   rl d
   jr c, overflow_3
   
   add hl,bc               ; *8 LSW + *2 LSW
   pop bc                  ; *2 MSW
   push af                 ; digit; C from LSW add still live
   ld a,e
   adc c
   ld e,a
   ld a,d
   adc b
   ld d,a
   jr c, overflow_digit
   
   pop af                  ; digit
   pop bc                  ; string
   
   add a,l
   ld l,a
   jr nc, consumed
   
   inc h
   jr nz, consumed
   
   inc e
   jr nz, consumed
   
   inc d
   jr nz, consumed
   jr overflow_1

consumed:

   pop af                  ; drop last-good LSW
   pop af                  ; drop last-good MSW
   inc bc
   jr loop

overflow_digit:
overflow_3:

   pop af                  ; digit or *2 MSW

overflow_2:

   pop bc                  ; string
overflow_1:

   pop hl
   pop de
   
   scf
   ret
