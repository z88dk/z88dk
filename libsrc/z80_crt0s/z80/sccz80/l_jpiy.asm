; 05.2005 aralbrec

; 'call JPIY' shows up so often that a jp(iy) function
; needs to be part of the z80 library.

                SECTION   code_crt0_sccz80
PUBLIC l_jpiy

.l_jpiy
   jp (iy)
