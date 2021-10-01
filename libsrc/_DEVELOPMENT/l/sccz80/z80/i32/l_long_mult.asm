;
;       Small C+ Long Library Functions
;
;       Multiply 32 bit numbers
;
;       Entry: dehl=arg1
;       Stack: return address, arg2
;
;       Exit:  dehl=result

; djm note I don't particularly like the use of ix as a pointer to the
; second argument, however it makes it quite a short routine, alternate
; method might be to use bc and bc' to hold arg2 and use a as a loop
; counter - please feel free to experiment!

; aralbrec  advice taken!

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_mult

EXTERN l_mulu_32_32x32

l_long_mult:

   ; dehl = arg1
   ; stack = arg2, ret

   exx
   pop bc
   
   pop hl
   pop de
   
   push bc
   jp l_mulu_32_32x32
