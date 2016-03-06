;
;       Small C+ Long Library Functions
;
;       Divide 2 32 bit numbers
;
;       Hopefully this routine does work!
;
;       I think the use of ix is unavoidable in this case..unless you know
;       otherwise!
;
;       This is for unsigned quantities..separate routine for signed..
;
;       Replaced use of ix with bcbc'

                SECTION   code_crt0_sccz80
PUBLIC    l_long_div_u
PUBLIC    L_LONG_DIVIDE0, L_LONG_DIVENTRY

; 32 bit division
; enter:
;    dehl = arg2
;   stack = arg1, ret
; exit:
;    dehl = arg1/arg2
;   de'hl'= arg1%arg2

.l_long_div_u

   ld a,d
   or e
   or h
   or l
   jr z, divide0
   
   pop af
   push hl
   exx
   pop de
   pop bc
   ld hl,0
   exx
   pop bc
   ld hl,0
   push af

.entry

   ld a,32
   or a

   ; bcbc' = arg1
   ; hlhl' = res
   ; dede' = arg2

.l_long_div1

   exx                         ; arg1 <<= 1
   rl c
   rl b
   exx
   rl c
   rl b
   
   exx                         ; res <<= 1
   adc hl,hl
   exx
   adc hl,hl
   
   exx                         ; res -= arg2
   sbc hl,de
   exx
   sbc hl,de
   jr nc, l_long_div2

   exx                         ; res += arg2
   add hl,de
   exx
   adc hl,de

.l_long_div2

   ccf
   dec a
   jp nz, l_long_div1

   exx                         ; arg1 <<= 1
   rl c
   rl b
   exx
   rl c
   rl b

   ; looking to return:
   ;  dehl  = quotient = arg1
   ; de'hl' = remainder = res
   
   push hl
   exx
   pop de
   push bc
   exx
   pop hl
   ld e,c
   ld d,b
   ret

.divide0

   exx
   pop bc
   pop hl
   pop de
   push bc
   exx
   ret

DEFC L_LONG_DIVIDE0 = # divide0 - l_long_div_u
DEFC L_LONG_DIVENTRY = # entry - l_long_div_u
