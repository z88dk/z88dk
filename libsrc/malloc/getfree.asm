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
;       int getfree()

                XLIB    getfree
                XREF    heapblocks
                XREF    heaplast



;   getfree     OUT: HL=Total free heap,
;                    DE=Biggest block of heap
;                    BC=Number of blocks free
; Goes through the whole list, counting and adding everything
;           uses AF,BC,DE,HL
.getfree
     push ix
     ld   hl,0
     ld   de,0
     ld   bc,(HeapBlocks)     ; Number of free blocks list in BC
     ld   ix,(HeapLast)  ; IX walks through linked list
     ld   a,b
     or   c
     jp   z,getfree_3         ; No free blocks
.getfree_1
     push bc
     ld   c,(ix+0)
     ld   b,(ix+1)
     push bc
     pop  ix        ; ix=ix->next
     ld   c,(ix+2)
     ld   b,(ix+3)  ; BC=size of block
     add  hl,bc          ; add block to total
     ex   de,hl
     push hl
     or   a
     sbc  hl,bc
     pop  hl
     jp   nc,getfree_2   ; Not bigger
     ld   h,b
     ld   l,c       ; save size of bigger block
.getfree_2     
     ex   de,hl
     pop  bc
     dec  bc        ; try next block
     ld   a,b
     or   c
     jp   nz,getfree_1   ; not yet through list
     ld   bc,(HeapBlocks)
.getfree_3
     pop  ix
     ret