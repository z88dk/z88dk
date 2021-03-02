;
;       ZX IF1 & Microdrive functions
;
;       Check if the specified microdrive map is 'full'
;
;       int if1_mdv_full (int drive);
;       
;		HL=CY=1 if full, otherwise HL=CY=0
;

;
;       $Id: if1_mdv_full.asm $
;

		SECTION   code_clib
		PUBLIC    if1_mdv_full
		PUBLIC    _if1_mdv_full

                

if1_mdv_full:
_if1_mdv_full:

; __FASTCALL__
		EX		DE,HL
		LD		HL,0	; '
		
        LD      B,$20
NXT_B_MAP:
		LD      A,(DE)
        CP      $FF
		SCF
		CCF
        RET     NZ

        INC     DE
        DJNZ    NXT_B_MAP
 
		SCF
        DEC		HL	; -1
        RET
