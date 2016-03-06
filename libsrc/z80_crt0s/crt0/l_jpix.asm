; 05.2005 aralbrec

; 'call JPIX' shows up so often that a jp(ix) function
; needs to be part of the z80 library.

                SECTION   code_crt0_sccz80
PUBLIC l_jpix

.l_jpix
   jp (ix)
