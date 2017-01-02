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
;
;       Stefano - Sept 2011
;
;
;	$Id: swapgfxbk.asm,v 1.6 2017-01-02 22:57:58 aralbrec Exp $
;

;    INCLUDE "flos.def"
    INCLUDE "osca.def"

		SECTION code_clib
		PUBLIC    swapgfxbk
      PUBLIC    _swapgfxbk
		PUBLIC	swapgfxbk1
      PUBLIC   _swapgfxbk1


.swapgfxbk
._swapgfxbk
		;call kjt_wait_vrt		; wait for last line of display
		;call kjt_page_in_video	; page video RAM in at $2000-$3fff
		
		di
		ld	 (asave),a
		in a,(sys_mem_select)	
		or $40
		out (sys_mem_select),a	; page in video RAM
		ld a,(asave)
		ret

.swapgfxbk1
._swapgfxbk1
		ld	 (asave),a
		in a,(sys_mem_select)	; page in video RAM
		and $bf
		out (sys_mem_select),a
		;call kjt_page_out_video	; page video RAM out of $2000-$3fff

        ld		a,@10000011                     ; Enable keyboard and mouse interrupts only
        out		(sys_irq_enable),a
		ld a,(asave)
        ei

		ret

		SECTION bss_clib
.asave
		defb 0
