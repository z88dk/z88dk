
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ___sdcc_enter_ix

___sdcc_enter_ix:

IF __SDCC_IX

   ex (sp),ix
	push ix
	
	ld ix,2
	add ix,sp
	
	ret

ELSE

   ex (sp),iy
	push iy
	
	ld iy,2
	add iy,sp
	
	ret

ENDIF
