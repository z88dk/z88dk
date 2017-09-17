; MALLOC function for far memory model
; 29/3/00 GWL
; 30/3/00 Changed size type to long, so >64K mallocs possible

;
; $Id: malloc_far.asm,v 1.6 2017-01-02 20:37:10 aralbrec Exp $
;

        SECTION   code_clib
        PUBLIC malloc_far
        PUBLIC _malloc_far

        EXTERN    malloc_table,pool_table,farpages,farmemspec
        EXTERN    free_loop

include "memory.def"

; far *malloc(long size)

.malloc_far
._malloc_far
	pop	de
        pop     bc
        pop     hl
        push    hl              ; HLBC=required size (bytes)
	push	bc
	push	de
        ld      a,l
        and     $80
        or      h
        jp      nz,badmalloc    ; trying to malloc 8Mb+....
        ld      a,c
        ld      c,b
        ld      b,l             ; BC=pages required, ignoring low byte
        inc     bc
        inc     a
        jr      nz,mall2
        inc     bc              ; BC=total pages required (with 2byte ovhead)

; Stage 1 is to locate a free fragment in the malloc table large enough
; to hold the amount of memory we require

.mall2  ld      hl,malloc_table ; search start
        ld      ix,0            ; and size found
	ld	de,(farpages)	; pages to search
        push    ix              ; save best match so far
	push	hl
.malsearch
	ld	a,d
	or	e
	jr	z,endsearch	; end of malloc_table reached
	dec	de
	ld	a,(hl)
	inc	hl
	inc	hl
	and	a
	jr	nz,malsearch	; back until found a free page
	push	hl		; save start of this fragment+2
        ld      ix,0
.malfragment
        inc     ix
	ld	a,d
	or	e
	jr	z,endfragment	; end of malloc_table reached
	dec	de
	ld	a,(hl)
	inc	hl
	inc	hl
	and	a
	jr	z,malfragment	; back until end of fragment
.endfragment
        push    ix
        ex      (sp),hl
        and     a
        sbc     hl,bc           ; is fragment big enough?
        jr      nc,goodmatch
        pop     hl
        pop     af              ; discard fragment start
	jr	malsearch
.goodmatch
        add     hl,bc
        ex      (sp),hl
	exx
        pop     hl              ; HL'=fragment size
        pop     ix              ; IX=fragment start+2
	dec	ix
	dec	ix		; IX=real fragment start
        pop     de              ; DE'=start of best so far
        pop     bc              ; BC'=size of best so far
        ld      a,b
        or      c
        jr      z,usenew        ; use new fragment if no previous one
        sbc     hl,bc
        jr      nc,useold       ; use old if <=size of new one
        add     hl,bc           ; restore HL=fragment size
.usenew push    hl
        push    ix
        exx
        jr      malsearch
.useold push    bc
        push    de
        exx
        jr      malsearch
.endsearch
	pop	hl		; HL=start of best fragment found
        pop     de              ; DE=size
        ld      a,d
        or      e
        jr      z,badmalloc     ; no suitable fragment found

; Stage 2 is to fill the fragment with memory
; We start with HL=address in malloc_table & BC=pages required

	push	hl		; save parameters
	push	bc
        ld      d,31            ; pretend bank 31 is available
.nextpool
	call	findpool	; IX=pool to allocate from, D=bank
	jr	c,partmalloc
.nextpage
        push    bc              ; save pages to do
	push	hl		; save malloc_table address
.badpage
	xor	a
	ld	bc,256
	call_oz(os_mal)		; get a page
	jr	nc,gotpage
	pop	hl		; restore malloc_table address
        pop     bc
	jr	nextpool
.gotpage
	ld	a,l
	and	a
	jr	nz,badpage	; EEK! OZ returned non-page-aligned mem...
	ld	a,b
	cp	d
	jr	nz,badpage	; EEK! Not from the expected bank...
	ld	a,h
	pop	hl
	ld	(hl),d		; store bank
	inc	hl
	ld	(hl),a		; and high byte
	inc	hl
        pop     bc
        dec     bc
        ld      a,b
        or      c
	jr	nz,nextpage
        pop     bc              ; pages allocated
	pop	hl		; HL=address in malloc_table
        ld      a,($04d1)
        ex	af,af'		; save seg1 binding
        ld      a,(hl)
        inc     hl
        ld      d,(hl)
        dec     hl
        ld      ($04d1),a
        out     ($d1),a         ; bind in start of allocated memory
        ld      e,0             ; DE=address in segment 1
        ld      a,c
        ld      (de),a
        inc     de
        ld      a,b
        ld      (de),a          ; store #pages allocated in first two bytes
        ex	af,af'
        ld      ($04d1),a
        out     ($d1),a         ; rebind seg 1
        ld      de,malloc_table
	and	a
        sbc     hl,de
	srl	h
	rr	l		; HL=pool page number
	ld	e,h
	inc	e		; because E=0 reserved for local memory
	ld	h,l
        ld      l,2             ; EHL=far pointer (skipping #pages)
	ret			; success!


; At this point we need to free up what we've allocated so far and
; then return a NULL pointer

.partmalloc
        pop     bc
        pop     hl
        call    free_loop        ; free pages already allocated

; Here we return a NULL pointer because we're unable to malloc what's
; required

.badmalloc
        ld      e,0
        ld      hl,0
        ret



; Subroutine to find a new pool to allocate from.
; IN:		D=previous bank
; OUT(success):	Fc=0
;		D=new bank
;		IX=pool handle
; OUT(failure):	Fc=1
; 
; Registers changed after return:
; ..BC.EHL/..IY same
; AF..D.../IX.. different

.findpool
        push    bc
	push	hl
	ld	hl,pool_table-32
	ld	c,d
	ld	b,0
	add	hl,bc
.fpool2	inc	hl
	inc	d
	jr	z,openpool	; open new pool if end of bank list
	ld	a,(hl)
	and	a
	jr	z,fpool2	; back if pool not open yet
	add	a,a
	rl	b		; (B was 0 from code above)
	add	a,a
	rl	b
	add	a,a
	rl	b
	add	a,a
	rl	b
	ld	ixh,b
	ld	ixl,a		; IX=pool handle
	and	a		; Fc=0, success!
.nopool
	pop	hl
        pop     bc
	ret
.openpool
	ld	a,(farmemspec)
	ld	bc,0
	call_oz(os_mop)
	jr	c,nopool
	xor	a
	ld	bc,256
	call_oz(os_mal)
	ld	a,b
	push	af		; save A=bank number
	ld	bc,256
	call_oz(os_mfr)
	pop	af
	ld	hl,pool_table-32
	ld	c,a
	ld	b,0
	add	hl,bc
	ld	a,ixl
	ld	b,ixh
	srl	b
	rra
	srl	b
	rra
	srl	b
	rra
	srl	b
	rra
	ld	(hl),a		; save compressed pool handle
	ld	d,c		; D=bank
	pop	hl
        pop     bc
	and	a		; success!
	ret
