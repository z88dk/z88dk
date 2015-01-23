; stdio_statesave
; 08.2009 aralbrec

PUBLIC stdio_statesave

; pushes all registers to stack
; companion to stdio_staterestore

; uses : hl

.stdio_statesave

   ex (sp),hl                  ; hl = return address
   push af
   push bc
   push de
   
   ex af,af
   exx
   
   push af
   push bc
   push de
   push hl
   
   push ix
   push iy
   
   ex af,af
   exx
   
   jp (hl)
