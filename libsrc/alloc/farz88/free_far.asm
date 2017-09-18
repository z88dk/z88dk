; FREE function for far memory model
; 31/3/00 GWL
;
; $Id: free_far.asm,v 1.6 2017-01-02 20:37:10 aralbrec Exp $
;

        SECTION code_clib
        PUBLIC    free_far
        PUBLIC    _free_far

        PUBLIC    free_loop
        EXTERN    malloc_table,pool_table

include "memory.def"


; void free(far *p);

.free_far
._free_far
        pop     hl
        pop     bc
        pop     de              ; EBC=far pointer
        push    de
        push    bc
        push    hl
        ld      a,c
        cp      2
        ret     nz              ; low byte=2 always
        dec     e               ; because 0=local pointer
        ld      c,b
        ld      b,e             ; BC=page number
        ld      hl,malloc_table
        add     hl,bc
        add     hl,bc           ; HL=address in malloc_table
        ld      a,($04d1)
        ex	af,af'          ; save seg 1 binding
        ld      a,(hl)
        inc     hl
        ld      d,(hl)
        dec     hl
        ld      ($04d1),a
        out     ($d1),a
        ld      e,0
        ld      a,(de)
        ld      c,a
        inc     de
        ld      a,(de)
        ld      b,a             ; BC=#pages to deallocate
        ex	af,af'
        ld      ($04d1),a
        out     ($d1),a         ; rebind segment 1
.free_loop
        ld      a,(hl)
        and     a
        jr      z,notallocated
        ld      e,a
        ld      d,0             ; DE=bank
        ld      (hl),d
        inc     hl
        ld      ix,pool_table-32
        add     ix,de
        ld      a,(ix+0)        ; A=compressed pool handle
        add     a,a
        rl      d               ; D was 0 previously
        add     a,a
        rl      d
        add     a,a
        rl      d
        add     a,a
        rl      d
        ld      ixh,d
        ld      ixl,a           ; IX=pool handle
        ld      a,e             ; A=bank
        ld      d,(hl)
        ld      e,0             ; DE=address
        ld      (hl),e
        inc     hl
        push    bc
        ld      bc,256
        ex      de,hl
        call_oz(os_mfr)
        ex      de,hl
        pop     bc
.notallocated
	dec	bc
        ld      a,b
        or      c
        jr      nz,free_loop
        ret


