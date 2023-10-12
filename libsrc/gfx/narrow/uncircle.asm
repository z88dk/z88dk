;
;     Z88 Graphics Functions - Small C+ stubs
; Usage: uncircle(int x, int y, int radius, int skip);


  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION code_graphics

        PUBLIC  uncircle
        PUBLIC  _uncircle
        PUBLIC  ___uncircle
        EXTERN  asm_uncircle


uncircle:
_uncircle:
___uncircle:
        push    ix
        ld      ix, 2
        add     ix, sp
        ld      e, (ix+2)               ;skip
        ld      d, (ix+4)               ;radius
        ld      c, (ix+6)               ;y
        ld      b, (ix+8)               ;x
        jp      asm_uncircle
  ENDIF
