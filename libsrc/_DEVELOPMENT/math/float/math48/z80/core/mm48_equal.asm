
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_equal

mm48_equal:

;     Set AC' equal to AC
;     -------------------
;
;     NAME:      EQUAL
;     FUNCTION:  AC'=AC. AC' is set equal to the number in AC.
;     OFFSET:    36H
;     STACK:     6 bytes.

   push bc
   push de
   push hl
   
   exx
   
   pop hl
   pop de
   pop bc
   
   ret
