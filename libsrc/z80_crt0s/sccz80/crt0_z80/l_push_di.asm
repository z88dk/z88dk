
	        SECTION   code_crt0_sccz80
                PUBLIC    l_push_di
		EXTERN	  asm_z80_push_di

		defc l_push_di = asm_z80_push_di
