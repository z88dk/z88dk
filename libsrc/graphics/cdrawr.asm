; CALLER LINKAGE FOR FUNCTION POINTERS

SECTION code_clib
PUBLIC cdrawr
PUBLIC _cdrawr
EXTERN cdrawr_callee
EXTERN ASMDISP_CDRAWR_CALLEE

.cdrawr
._cdrawr

		pop	af
		pop bc
		pop	de
		pop	hl
		push	hl
		push	de
		push	bc
		push	af


   jp cdrawr_callee + ASMDISP_CDRAWR_CALLEE
