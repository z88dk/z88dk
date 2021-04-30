;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; Sept 2003 - Stefano: Fixed bug for sprites wider than 8.
; Apr 2017  - Stefano: Fixed bug for sprite pos coordinates wider than 255.
;

; GSX Graphics for CP/M
; Uses plot() altering its behavior with GSX_WRTMODE


;
;
; $Id: w_putsprite3.asm $
;

IF !__CPU_INTEL__
	SECTION code_graphics
	PUBLIC    putsprite
   PUBLIC    _putsprite

	EXTERN	plot

; GSX structure used to alter the 'write mode'
	EXTERN	gios_ctl
	EXTERN	gios_pb
	EXTERN	gios_intin


; __gfx_coords: h,l (vert-horz)
; sprite: (ix)

.putsprite
._putsprite
		
        ld      hl,2   
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ;sprite address
		
		push	ix		; preserve IX
		
        push	de
        pop	ix

        inc     hl
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      c,(hl)
        inc     hl
        ld      b,(hl)  ; x and y __gfx_coords
		ld		(oldx),bc

        inc     hl
        ld      a,(hl)  ; and/or/xor mode

;--------------------------------------

	cp	182	; or(hl) opcode
	jr	z,door

	cp	166	; and(hl) opcode
	jr	nz,doxor
	ld	a,4		;W_ERASE
	call	setdrwmode
	jr	door

.doxor
	; 174 - xor
	ld	a,3		;W_COMPLEMENT
	call	setdrwmode

;--------------------------------------
.door
	ld	a,(ix+0)	; Width
	ld	b,(ix+1)	; Height
.oloopo
	push	bc		;Save # of rows
	push	af

	ld		hl,(oldx)	;;

	;ld	b,a		;Load width
	ld	b,0		; Better, start from zero !!

	ld	c,(ix+2)	;Load one line of image

.iloopo
	sla	c		;Test leftmost pixel
	jr	nc,noploto	;See if a plot is needed

	push bc
	push hl
	push de

;	push hl
;	push de

	call	plot
	
	pop	de
	pop	hl
	pop	bc


.noploto

	inc	b	; witdh counter
	inc hl ;;
	
	pop	af
	push	af
	
	cp	b		; end of row ?
	
	jr	nz,noblko
	
	inc	ix
	ld	c,(ix+2)	;Load next byte of image
	
	jr noblocko
	
.noblko
	
	ld	a,b	; next byte in row ?
	;dec	a
	and	a
	jr	z,iloopo
	and	7
	
	jr	nz,iloopo
	
.blocko
	inc	ix
	ld	c,(ix+2)	;Load next byte of image
	jr	iloopo

.noblocko

	;pop hl
	;inc	l
	inc de
	
	pop	af
	pop	bc		;Restore data
	djnz	oloopo

	;ret
	ld	a,1		;W_REPLACE

	pop	ix		; restore IX before exiting

;----------------------------------------------

setdrwmode:
	push hl
	push de
	push bc
	push ix
	
	ld	hl,gios_ctl
	ld	(hl),32		; GSX_WRTMODE
	inc hl
	ld	(hl),0

	ld	hl,gios_ctl+6	; parameter count (n_intin)
	ld	(hl),1
	inc hl
	ld	(hl),0
	
	ld	hl,gios_intin
	ld	(hl),a	; W_REPLACE, W_COMPLEMENT or W_ERASE
	inc hl
	ld	(hl),0

	ld	de,gios_pb
	ld	c,115   ; GSX
	call	5

	pop ix
	pop bc
	pop de
	pop hl
	ret

;---------------------------------------------

	SECTION  bss_graphics
.oldx
         defw   0

ENDIF
