		
		SECTION code_clib
		PUBLIC _setdta
		PUBLIC __setdta

.__setdta
._setdta	ex de, hl
		jp 0xB8C6
