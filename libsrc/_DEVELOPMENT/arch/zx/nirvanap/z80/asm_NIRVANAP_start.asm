; ----------------------------------------------------------------
; Z88DK LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_nirvanap

PUBLIC asm_NIRVANAP_start

EXTERN __NIRVANAP_delay_128k

asm_NIRVANAP_init:

        ld      a, ($004c)
        and     2
        ld      (__NIRVANAP_delay_128k-1), a
		  
		  ret
