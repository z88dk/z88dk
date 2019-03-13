;
; Shared variables between the VT100 and VT52 engines


		MODULE		conio_vars
		SECTION		data_graphics

		PUBLIC		__excali64_attr

.__excali64_attr       defb $70	; White on Black


        SECTION code_crt_init
        EXTERN  __BSS_END_tail
        EXTERN  __HIMEM_head
        EXTERN  __HIMEM_END_tail
        ld      hl,__BSS_END_tail
        ld      de,__HIMEM_head
        ld      bc,__HIMEM_END_tail - __HIMEM_head
        ldir
