;
;       Small C+ Long Library Functions
;
;       Multiply 32 bit numbers
;
;       Entry: dehl=arg1
;       Stack: return address, arg2
;
;       Exit:  dehl=result


       SECTION   code_crt0_sccz80
       PUBLIC    l_long_mult
       EXTERN    l_mulu_32_32x32

.l_long_mult
   ; dehl = arg1
   ; stack = arg2, ret

   exx
   pop bc

   pop hl
   pop de

   push bc
   jp l_mulu_32_32x32
