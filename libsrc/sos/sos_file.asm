; int sos_file(char *name,type)
; CALLER linkage for function pointers
;
;       $Id: sos_file.asm,v 1.3 2015-01-19 01:33:07 pauloscustodio Exp $
;


PUBLIC sos_file

EXTERN sos_file_callee
EXTERN ASMDISP_SOS_FILE_CALLEE

sos_file:
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp sos_file_callee + ASMDISP_SOS_FILE_CALLEE
