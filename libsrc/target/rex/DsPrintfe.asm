;
;	System Call for REX6000
;
;	ported from Rix Myles' SDK
;	Unfortunately, I've found no other way to rewrite the
;	function for the emulator. Daniel
;
;	$Id: DsPrintfe.asm,v 1.4 2017-01-03 00:11:31 aralbrec Exp $

		PUBLIC	DsPrintfe
      PUBLIC   _DsPrintfe


.DsPrintfe	    
._DsPrintfe
        call    saveRegAlloc
	DEFW	$ffb0		
        ld      c,(ix+$08)	
        ld      b,(ix+$09)	;  BC = source
        ld      hl,$0000
        add     hl,sp		
        ex      de,hl		; DE= dest (=stack pointer)
        call    strcpyn		; copy string from BC to DE (ie onto stack)	
	ld      hl,$0066
        push    hl	
	ld      l,(ix+$0e)	  
        ld      h,(ix+$0f)	
        push    hl		; x        
        ld      l,(ix+$0c)	
        ld      h,(ix+$0d)
        push    hl		; y       
        ld      hl,$0028	
        push    hl		; 40        
        ld      hl,$0001
        push    hl		; mode        
        ld      hl,$0000
        add     hl,sp
        ld	de,$000a
	add	hl,de
        push    hl		; pointer to string   	
        call    syscall5_1
        ex      de,hl
        ld      hl,$000e
        add     hl,sp
        ld      sp,hl
        ex      de,hl
        jp      restoreReg
	jp	end
.saveRegAlloc
	pop     hl		; HL = ret addr.
        push    bc
        push    de
        push    ix
        ld      ix,$0000
        add     ix,sp		; ix=sp
        ld      e,(hl)		; get NNNNlo
        inc     hl
        ld      d,(hl)		; get NNNNhi
        inc     hl
        ex      de,hl		; de=return address
        add     hl,sp		; adjust SP according to NNNN
        ld      sp,hl		; Stack point is NNNN bytes further down than before
        ex      de,hl		; hl=return address
        jp      (hl)
.strcpyn
	call    saveReg
        ld      e,c
        ld      d,b
        ld      l,(ix+$02)
        ld      h,(ix+$03)
	push    af
        push    hl
        push    de
        push    bc
        xor     a
        ex      de,hl
.sloop
	cp      (hl)
        ldi     			; (hl) -> (de), til bc==0 or (hl)==0
        jr      nz,sloop
        pop     bc
        pop     de
        pop     hl
        pop     af
        jp      restoreReg
.saveReg
	pop     hl
        push    bc
        push    de
        push    ix
        ld      ix,$0000
        add     ix,sp
        jp      (hl)
.restoreReg
	ld      sp,ix
        pop     ix
        pop     de
        pop     bc
        ret
.syscall5_1
        call 	saveReg
        ld      l,(ix+$12)
        ld      h,(ix+$13)	
	ld	($c000),hl	; System call number
        ld      l,(ix+$10)
        ld      h,(ix+$11)	
	ld	($c002),hl	; Param 1
        ld      l,(ix+$0e)
        ld      h,(ix+$0f)	
	ld	($c004),hl	; Param 2
        ld      l,(ix+$0c)
        ld      h,(ix+$0d)	
	ld	($c006),hl	; Param 3
        ld      l,(ix+$0a)
        ld      h,(ix+$0b)	
	ld	($c008),hl	; Param 4
        ld      l,(ix+$08)
        ld      h,(ix+$09)	
	ld	($c00a),hl	; Param 5
        rst     $10
        ld      hl,$c00e
        ld      b,(hl)
        inc     hl
        ld      h,(hl)
        ld      l,b
        jp      restoreReg
.end
	ret
