;       Z88 Small C+ Run Time Library 
;
;       Get Long Pointer from Near Memory

                SECTION   code_crt0_sccz80
                PUBLIC    l_getptr


;Fetch long from (hl)

.l_getptr
IF __CPU_8085__
   ex de,hl
   ld hl,(de)
   inc de
   inc de
   ld  a,(de)
   ld  e,a
   ld  d,0
ELSE
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld l,(hl)
   ld h,0
   ex de,hl
ENDIF
   ret
