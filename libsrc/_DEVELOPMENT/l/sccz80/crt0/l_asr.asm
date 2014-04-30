
XLIB l_asr

LIB l_asr_hl

l_asr:

   ; hl = de >> hl
   
   ex de,hl
   ld a,e
   
   jp l_asr_hl
