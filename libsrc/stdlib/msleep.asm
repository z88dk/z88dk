


		SECTION		code_clib

		PUBLIC		msleep
		PUBLIC		_msleep

		EXTERN		asm_z80_delay_ms

		; int msleep(unsigned int millis) __z88dk_fastcall

		defc		msleep = asm_z80_delay_ms
		defc		_msleep = asm_z80_delay_ms
