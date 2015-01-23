; stdio_staterestore
; 08.2009 aralbrec

PUBLIC stdio_staterestore

; pops all registers from stack
; companion to stdio_statesave

.stdio_staterestore

   pop hl                      ; hl = return address

   exx
   ex af,af
   
   pop iy
   pop ix
   
   pop hl
   pop de
   pop bc
   pop af
   
   exx
   ex af,af
   
   pop de
   pop bc
   pop af
   ex (sp),hl
   
   ret
