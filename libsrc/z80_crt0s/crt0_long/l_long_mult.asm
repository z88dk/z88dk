;
;       Small C+ Long Library Functions
;
;       Multiply 32 bit numbers
;
;       Entry: dehl=arg1
;       Staci: return address, arg2
;
;       Exit:  dehl=result

; djm note I don't particularly like the use of ix as a pointer to the
; second argument, however it makes it quite a short routine, alternate
; method might be to use bc and bc' to hold arg2 and use a as a loop
; counter - please feel free to experiment!

; aralbrec  advice taken!


                SECTION   code_crt0_sccz80
PUBLIC	l_long_mult

; dehl = arg1
; stack = arg2, ret

.l_long_mult

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

   ; dede' = arg1
   ; bcbc' = arg2
   ; hlhl' = res

   ld a,32

.l_long_mult1

   srl b                       ; arg2 >>= 1
   rr c
   exx
   rr b
   rr c
   jr nc, l_long_mult2
   
   add hl,de                   ; res += arg1
   exx
   adc hl,de
   exx

.l_long_mult2

   sla e                       ; arg1 <<= 1
   rl d
   exx
   rl e
   rl d
   
   dec a
   jp nz, l_long_mult1

   push hl
   exx
   pop de
   ret
