; int sos_file(char *name,type)
; CALLER linkage for function pointers
;
;       $Id: sos_file.asm,v 1.4 2016-06-19 20:58:00 dom Exp $
;

        SECTION   code_clib
PUBLIC sos_file
PUBLIC _sos_file

EXTERN sos_file_callee
EXTERN ASMDISP_SOS_FILE_CALLEE

sos_file:
_sos_file:
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp sos_file_callee + ASMDISP_SOS_FILE_CALLEE
