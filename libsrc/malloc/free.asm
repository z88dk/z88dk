;
;       Small C+ Library Functions
;
;       Memory Functions
;
;       The routines in this directory are a little kludgey to say the
;       least, but at least they give you a heap from BBC BASIC
;
;       These routines were found on an MSX homepage from the net
;
;       Added to Z88dk archive 1/3/99
;
;	28/4/99 djm, Made check for free(0) and just return if so
;
;       free(char *)

                XLIB    free

                XREF    heaplast
                XREF    heapblocks

.free
        pop     bc
        pop     hl
        push    hl
        push    bc
	ld	a,h
	or	l
	call	nz,basic_free
	ret



.free_new
          ; bc=bp
     ld   (HeapLast),bc
     ld   a,c
     ld   (bc),a
     ld   a,b
     inc  bc
     ld   (bc),a         ; bp->next=bp
     inc  l         ; hl=1
     ld   (HeapBlocks),hl
     pop  de
     pop  bc
     ret


; free tries to add the block to an existing block, and keeps the
;   list in ascending order.

.basic_free          ; IN: HL=pointer to memory previously allocated
     push bc
     push de
     ld   bc,4
     and  a
     sbc  hl,bc
     ld   c,l
     ld   b,h       ;bc=address of block to free (bp)  (true address)
     ld   hl,(HeapBlocks)
     ld   a,h
     or   l
     jp   z,free_new     ; No free blocks -> create list

; Find where to link bp to the list
     ld   hl,(HeapLast)
;Start of loop...
.free_1                  ; check if between p and next
     ld   d,h
     ld   e,l            ;de=p (addy of heaplast)
     ld   a,(hl)
     inc  hl
     ld   h,(hl)         ; hl=p->next
     ld   l,a            ;hl points to next free block
;Now find out if bp is within this range (ie below next and above p)
     push hl
     and  a
     sbc  hl,bc          ;if c, block to free is  next free block
     pop  hl
     jp   c,free_2  ; bp > next

                ;Were below next, but are we above p
     ex   de,hl
     push hl        ;low pointer/hl=addy of first block
     and  a
     sbc  hl,bc     ;if c, block to free>first free block
     pop  hl
     ex   de,hl
     jp   c,free_3  ; p < bp    <= next
                                ; p,next >= bp

;If here, we are not in range/bang on..

.free_2                  ; check if at top or bottom
                                ; bp > next  ||  bp <= p,next
;hl=next block, de=first block
     push hl
     and  a
     sbc  hl,de
     pop  hl
     jp   z,free_21 ;if the same, we only have one block!!!
     jp   nc,free_1 ; next > p - get next bloc

;Get here if we have one block next<p (linked list remember!!)
.free_21
     push hl        ;hl=next
     and  a
     sbc  hl,bc
     pop  hl
     jp   nc,free_3 ; bp <= next   && p >= next
     ex   de,hl
     push hl        ;hl=p
     and  a
     sbc  hl,bc
     pop  hl
     ex   de,hl
     jp   nc,free_1 ; bp <= p     && bp,p >(=?) next

; insert bp into list: p->next=bp, bp->next=next
; bc=bp, de=p, hl=next
;=======================
.free_3                  ; bp <= next < p           bp in front
                    ; p < bp <= next           bp in middle
                    ; next < p < bp            bp at end
     ld   (HeapLast),de  ; last=p
     ld   a,l
     ld   (bc),a         ; bp->next=next
     inc  bc
     ld   a,h
     ld   (bc),a
     dec  bc             ; (bc=bp)
     ex   de,hl
     ld   (hl),c         ; p->next=bp
     inc  hl
     ld   (hl),b
     inc  hl             ; (hl=p+2)
     inc  bc
     inc  bc             ;bc=bp+2

; Try to merge p, bp: if p+p->size=bp then p->next=next,p->size+=bp->size,bp=p
; bc=bp+2, de=next, hl=p+2
     push de        ; save next
     ld   e,(hl)
     inc  hl
     ld   d,(hl)         ; de=p->size
     dec  hl             ; (hl=p+2)
     push hl        ; save p+2
     add  hl,de               ; (hl=p+p->size+2)
     and  a
     sbc  hl,bc               ; (hl=p+p->size+2-bp-2=p+p->size-bp)
     jp   nz,nomerge_1
     ld   a,(bc)
     ld   l,a
     inc  bc
     ld   a,(bc)
     ld   h,a            ; (hl=bp->size)
     add  hl,de               ; (hl=bp->size+p->size)
     ex   de,hl
     pop  hl        ; get p+2
     ld   (hl),e         
     inc  hl
     ld   (hl),d         ; p->size+=bp->size
     dec  hl
     push hl        ; save p+2
     pop  bc        ; bp=p      (bc=p+2)
     dec  hl             ; (hl=p+1)
     pop  de        ; get next
     ld   (hl),d
     dec  hl
     ld   (hl),e         ; p->next=next
     ex   de,hl
                         ; bc=p+2, hl=next
     jp   merge_2        ; Skip raising: it was merged
.nomerge_1
     ld   hl,(HeapBlocks)
     inc  hl        ; Raise free block counter
     ld   (HeapBlocks),hl
     pop  hl
     pop  hl
                         ; bc=bp+2, hl=next

; Try to merge bp, next: if bp+bp->size=next then bp->next=next->next
;                                                 bp->size+=next->size
; bc=bp+2, hl=next
.merge_2
     ld   e,(hl)
     inc  hl
     ld   d,(hl)              ; (de=next->next)
     inc  hl             ; (hl=next+2)
     push de        ; save next->next
     ld   a,(bc)
     ld   e,a
     inc  bc
     ld   a,(bc)
     ld   d,a            ; de=bp->size
     push de        ; save bp->size
     ex   de,hl
     add  hl,bc               ; (hl=bp->size+bp+3)
     scf
     sbc  hl,de               ; (hl=bp->size+bp+3-(next+2)-1)
     jp   nz,nomerge_2
                         ; bc=bp+3, de=next+2
     ex   de,hl
     ld   e,(hl)
     inc  hl
     ld   d,(hl)              ; (de=next->size)
     pop  hl        ; get bp->size
     add  hl,de               ; (hl=bp->size+next->size)
     ld   a,h
     ld   (bc),a
     dec  bc
     ld   a,l
     ld   (bc),a         ; bp->size+=next->size
     dec  bc
     pop  hl
     ld   a,h
     ld   (bc),a
     dec  bc
     ld   a,l
     ld   (bc),a         ; bp->next=next->next
     ld   (HeapLast),bc
     ld   hl,(HeapBlocks)
     dec  hl        ; Lower free block counter
     ld   (HeapBlocks),hl
     pop  de        ;original values entered...
     pop  bc
     ret
.nomerge_2
     pop  hl
     pop  hl
     pop  de
     pop  bc
     ret

