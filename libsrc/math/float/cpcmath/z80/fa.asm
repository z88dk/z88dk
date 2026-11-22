; CPC floatpack FA workspace override.
;
; The generic 48-bit glue fa.asm no longer carries the init_floatpack call.
; CPC needs the float-state patch at startup, so this cpc-local copy of the
; original fa module provides the workspace AND hooks the patch via
; code_crt_init.  -lcpc_math precedes the common float libraries in the cpc
; search order, so this fa wins over the generic one for CPC builds, and the
; init runs exactly once.

		SECTION	bss_fp
		PUBLIC	fa

		EXTERN	init_floatpack

fa:		defs	6


		SECTION code_crt_init
		call	init_floatpack
