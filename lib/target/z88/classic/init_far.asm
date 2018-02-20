; Startup code for far memory model
; 31/3/00 GWL
; 21/5/00 Modified for more flexible CF-compatible structure arrangement
;

init_far:

IF DEFINED_far_mmset
	ld	a,MM_S1+MM_FIX
ELSE
	ld	a,MM_S1
ENDIF
	ld	(farmemspec),a		; initialise farmemspec
	ld	hl,1+(farheapsz/256)
	ld	(farpages),hl		; initialise farpages
        add     hl,hl
        ld      b,h
        ld      c,l
	ld	hl,actual_malloc_table
        ld      (malloc_table),hl	; initialise malloc_table
	ld	d,h
	ld	e,l
	inc	de	
        ld      (hl),0
        dec     bc
        ldir                            ; clear malloc_table
        ld      hl,pool_table
        ld      de,pool_table+1
        ld      bc,223
        ld      (hl),0
        ldir                            ; clear pool_table
	ret
