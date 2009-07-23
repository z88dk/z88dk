; CALLER linkage for function pointers

XLIB stricmp
LIB stricmp1

.stricmp

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp stricmp1
