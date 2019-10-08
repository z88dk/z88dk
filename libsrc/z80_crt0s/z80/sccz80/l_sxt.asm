;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                SECTION   code_crt0_sccz80
                PUBLIC    l_sxt

.l_sxt    ld l,a
          rlca
          sbc   a,a
          ld h,a
          ret


