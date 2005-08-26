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
; char *malloc(int bytes);
;
;
; $Id: malloc.asm,v 1.3 2005-08-26 23:50:42 aralbrec Exp $
;

                XLIB    malloc
                
                XREF    heapblocks
                XREF    heaplast


.OutMem
     pop  iy
     pop  ix
     pop  de
     pop  bc
     ld   hl,0
     or a
     ret



; IN: HL=size OUT: HL=pointer to mem
;                    =0 if out of memory, carry flag also set if successful
;           uses AF,(BC,DE),HL,(IX,IY)

.malloc
     push bc
     push de
     push ix
     push iy
     ld   de,4      ; Add headersize
     add  hl,de
     jp   c,OutMem
     ex   de,hl          ; Requested size in DE
     ld   bc,(HeapBlocks)     ; Number of free blocks list in BC
     ld   ix,(HeapLast)  ; IX walks through linked list
     ld   a,b
     or   c
     jp   z,OutMem  ; No free blocks
.mal_1
     push ix        ; 
     pop  iy        ; IY=prev
     ld   l,(ix+0)  ;address of next block
     ld   h,(ix+1)
     push hl
     pop  ix        ; ix=ix->next (ix=addy of next block)
     ld   l,(ix+2)
     ld   h,(ix+3)  ; HL=size of block
     or   a
     sbc  hl,de
     jp   nc,mal_2  ; Request fits
     dec  bc        ; try next block
     ld   a,b
     or   c
     jp   nz,mal_1  ; not yet through list
                ;run out of memory!!!
                    ; Here more memory should be allocated
                    ; But it isnt for now
     jp   OutMem

;Here we try to fit memory..
.mal_2
                    ; BC=p, DE=ReqSize, HL=BlockSize-ReqSize
     jp   z,mal_3        ; Exactfit
                    ; HL=size remaining of block
     ld   (ix+2),l
     ld   (ix+3),h  ; Store it. The link is still correct
     ld   (HeapLast),ix
     ex   de,hl
     add  ix,de          ; ix=IX+NewBlkSize
     ld   (ix+2),l
     ld   (ix+3),h  ; save size of new block
     jp   mal_4     ;get out of here..

;Exact fit...  ;iy holds previous block..
.mal_3    
     ld   a,(ix+0)  ; IY->next=IX->next
     ld   (iy+0),a
     ld   a,(ix+1)
     ld   (iy+1),a
     ld   hl,(HeapBlocks)
     dec  hl        ; One free block less on the list
     ld   (HeapBlocks),hl
     ld   (HeapLast),iy
.mal_4
     push ix
     pop  hl
     ld   bc,4
     add  hl,bc          ; HL=pointer to datablock


     pop  iy
     pop  ix
     pop  de
     pop  bc
     scf
     ret
