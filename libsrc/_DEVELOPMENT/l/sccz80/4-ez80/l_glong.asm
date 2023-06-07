;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80
PUBLIC    l_glong
PUBLIC    l_glonghlp


; Pick up long from (*hl)
.l_glonghlp
   defb	$ed, $27	;ld hl,(hl)

;Fetch long dehl from (hl)
.l_glong
   defb $ed, $17	;ld de,(hl)
   inc hl
   inc hl
   defb $ed, $27	;ld hl,(hl)
   ex de,hl
   ret
