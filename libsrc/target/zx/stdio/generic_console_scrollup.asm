; Scroll Spectrum/TS2068 up
;
; Relies on ROM routines to perform the scroll
;
; Toggle on __ts2068_hrgmode to determine whether to scroll
; the second display
;

	MODULE	generic_console_scrollup

	SECTION	code_clib
	PUBLIC	generic_console_scrollup
	EXTERN	call_rom3
	EXTERN	__ts2068_hrgmode

	EXTERN	__zx_console_attr
        EXTERN  zx_rowtab

		
generic_console_scrollup:
        push    de
	push	bc
		
IF NOROMCALLS
	; Code to be used when the original ROM is missing or not available
        push    ix
        ld      ix,zx_rowtab
        ld      a,8
.outer_loop
        push    af
        push    ix
        ld      a,23
.inner_loop
        ld      e,(ix+16)
        ld      d,(ix+17)
        ex      de,hl
        ld      e,(ix+0)
        ld      d,(ix+1)
        ld      bc,32
        ldir
		
        ld      bc,16
        add     ix,bc
        dec     a
        jr      nz,inner_loop
        pop     ix
        pop     af
        inc     ix
        inc     ix
        dec     a
        jr      nz,outer_loop
; clear
        ld      ix,zx_rowtab + (192 - 8) * 2
        ld      a,8
.clear_loop
        push    ix
        ld      e,(ix+0)
        ld      d,(ix+1)
        ld      h,d
        ld      l,e
        ld      (hl),0
        inc     de
        ld      bc,31
        ldir
        pop     ix
        inc     ix
        inc     ix
        dec     a
        jr      nz,clear_loop
		
	ld      hl,$4000+6880
	ld      de,$4000+6881
	ld      bc,31
	ld      a,(__zx_console_attr)
	ld      (hl),a
	ldir
		
        pop     ix
	pop	bc
	pop	de
        ret
ELSE
  IF FORts2068
        ld      a,(__ts2068_hrgmode)
	cp	6	;Hires
	jr	z,hrgscroll
	cp	2	;High colour
	jr	z,hrgscroll
	cp	1	;Screen 1
	jr	z,hrgscroll
  ENDIF
        ld      a,($dff)
        cp      $17
        jr      nz,ts2068_rom
		
        call    call_rom3
        defw    3582    ;scrollup
		
	pop	bc
	pop	de
        ret
		
.ts2068_rom
        call    call_rom3
        defw    $939    ; TS2068 scrollup
	pop	bc
	pop	de
        ret
		
ENDIF

		

IF FORts2068
.hrgscroll
        push    ix
        ld      ix,zx_rowtab
        ld      a,8
.outer_loop
        push    af
        push    ix
	ld	a,(__ts2068_hrgmode)
        ld      b,23
.inner_loop
	push	bc
        ld      e,(ix+16)
        ld      d,(ix+17)
        ex      de,hl
        ld      e,(ix+0)
        ld      d,(ix+1)
	cp	1
	jr	z,just_screen_1
	push	de
	push	hl
        ld      bc,32
        ldir
	pop	hl
	pop	de
just_screen_1:
        set     5,d
        set     5,h
        ld      bc,32
        ldir
        ld      bc,16
        add     ix,bc
	pop	bc
	djnz	inner_loop

        pop     ix
        pop     af
        inc     ix
        inc     ix
        dec     a
        jr      nz,outer_loop
; clear
        ld      ix,zx_rowtab + (192 - 8) * 2
	ld	a,(__ts2068_hrgmode)
        ld      b,8
.clear_loop
	push	bc
        push    ix
        ld      e,(ix+0)
        ld      d,(ix+1)
        ld      h,d
        ld      l,e
        inc     de
	push	de
	push	hl
	cp	1
	jr	z,clear_screen1_only
        ld      (hl),0
        ld      bc,31
        ldir
; second display
clear_screen1_only:
	pop	hl
	pop	de
        set     5,d
        set     5,h
	cp	4
	ex	af,af
	ld	a,(__zx_console_attr)
	ld	c,a
	ex	af,af
	jr	z,clear_hires2
	ld	c,0
clear_hires2:
        ld      (hl),c
        ld      bc,31
	ldir
        pop     ix
        inc     ix
        inc     ix
	pop	bc
	djnz	clear_loop
        pop     ix
	pop	bc
	pop	de
        ret
ENDIF
