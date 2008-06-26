; uint __CALLEE__ getline_callee(char **lineptr, uint *n, FILE *stream)
; 06.2008 aralbrec

XLIB getline_callee

LIB getdelim_callee
XREF ASMDISP_GETDELIM_CALLEE

.getline_callee

   pop hl
   pop ix
   pop de
   ex (sp),hl
   
   ld c,13
   jp getdelim_callee + ASMDISP_GETDELIM_CALLEE
