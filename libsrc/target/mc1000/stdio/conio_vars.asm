

	SECTION data_clib
	PUBLIC	__mc1000_modeval
	PUBLIC	__mc1000_mode
	PUBLIC	__ink_colour
	PUBLIC	__MODE2_attr

__mc1000_mode:	   defb	   0x00		   ; 0 = text, 1 = hires, 2 = colour
__mc1000_modeval:  defb    0x00            ; lores mode 0x9e               ;hires mode

__ink_colour:	   defb	   7
__MODE2_attr:     defb    @11000000,@00000000
