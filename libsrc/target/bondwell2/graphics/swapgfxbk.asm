;
;       Bondwell 2 pseudo graphics routines
;
;       Stefano Bodrato 2021
;
;
;        Video memory paging.
;

		SECTION   smc_clib
		
		PUBLIC    swapgfxbk
		PUBLIC    _swapgfxbk

		PUBLIC    swapgfxbk1
		PUBLIC    _swapgfxbk1



.swapgfxbk
._swapgfxbk

; save current bank
	in      a,(2)     ; PPIC, get current bank
	ld      (swapgfxbk1+1),a

;set VRAM bank
	ld      a,1		; no mask, to keep the NMI disabled
	out     (2),a     ; PPIC, set VRAM bank
	
	ret


.swapgfxbk1
._swapgfxbk1
	ld		a,0		; <---  SELF MODIFYING CODE
	out		(2),a          ; PPIC, restore previous memory bank

	ret



		SECTION code_crt_init

			EXTERN  __BSS_END_tail
			EXTERN  __HIMEM_head
			EXTERN  __HIMEM_END_tail
			ld      hl,__BSS_END_tail
			ld      de,__HIMEM_head
			ld      bc,__HIMEM_END_tail - __HIMEM_head
			ldir
