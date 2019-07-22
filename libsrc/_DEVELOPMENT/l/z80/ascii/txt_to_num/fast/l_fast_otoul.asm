
SECTION code_clib
SECTION code_l

PUBLIC l_fast_otoul

EXTERN l_fast_otou, error_mc

l_fast_otoul:

   ; ascii octal string to unsigned long
   ; whitespace is not skipped
   ; char consumption stops on overflow
   ;
   ; enter : de = char *buffer
   ;
   ; exit  : bc = & next char to interpret in buffer
   ;         dehl = unsigned result (0 on invalid input, and $ffffffff on overflow)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, bc, de, hl

   call l_fast_otou            ; try to do it in 16 bits
   
   ld c,e
   ld b,d
   
   ld de,0
   ret nc                      ; was 16 bits
   
   ; ahl is result so far
   
   ld e,a
   
   ; 32 bit loop

loop:

   ld a,(bc)
   
   ; inlined isodigit
   
   sub '0'
   ccf
   ret nc
   cp 8
   ret nc
   
   inc bc

IF __CPU_INTEL__
   push bc
   ld c,a
   ld a,l
   add l
   ld l,a
   ld a,h
   adc h
   ld h,a
   ld a,e
   rla
   ld e,a
   ld a,d
   rla
   ld d,a
   ld a,c
   pop bc
ELSE
   add hl,hl
   rl e
   rl d
ENDIF
              jr c, oflow
IF __CPU_INTEL__
   push bc
   ld c,a
   ld a,l
   add l
   ld l,a
   ld a,h
   adc h
   ld h,a
   ld a,e
   rla
   ld e,a
   ld a,d
   rla
   ld d,a
   ld a,c
   pop bc
ELSE
   add hl,hl
   rl e
   rl d
ENDIF
               jr c, oflow
IF __CPU_INTEL__
   push bc
   ld c,a
   ld a,l
   add l
   ld l,a
   ld a,h
   adc h
   ld h,a
   ld a,e
   rla
   ld e,a
   ld a,d
   rla
   ld d,a
   ld a,c
   pop bc
ELSE
   add hl,hl
   rl e
   rl d
ENDIF
               jr c, oflow
   
   ; hl += digit
   
   add a,l
   ld l,a
   
   jr loop

oflow:

   ld de,$ffff
   jp error_mc

