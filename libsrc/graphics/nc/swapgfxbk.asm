;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 15/10/98
;
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;       Amstrad NC version by Stefano - 2017
;
;
;	$Id: swapgfxbk.asm $
;

		SECTION	code_clib
                PUBLIC    swapgfxbk
                PUBLIC    _swapgfxbk

		PUBLIC	swapgfxbk1
      PUBLIC   _swapgfxbk1



.swapgfxbk
._swapgfxbk
IF FORzcn
	RET
ELSE
		LD A,($B001)
		LD (pgsave),A
		LD A,67
		LD ($B001),A
		OUT ($11), A		; $10=0($b000), $11=$4000($b001), $12=$8000 ($b002), $13=$c000 ($b003)
		RET
ENDIF
		

.swapgfxbk1
._swapgfxbk1
IF FORzcn
	RET
ELSE
		LD A,(pgsave)
		LD ($B001) ,A
		OUT ($11) ,A
		RET

        SECTION bss_clib
.pgsave
	defb 0

ENDIF

