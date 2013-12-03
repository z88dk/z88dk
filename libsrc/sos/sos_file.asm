; int sos_file(char *name,type)
; CALLER linkage for function pointers
;
;       $Id: sos_file.asm,v 1.1 2013-12-03 13:42:32 stefano Exp $
;


XLIB sos_file

LIB sos_file_callee
XREF ASMDISP_SOS_FILE_CALLEE

sos_file:
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp sos_file_callee + ASMDISP_SOS_FILE_CALLEE
