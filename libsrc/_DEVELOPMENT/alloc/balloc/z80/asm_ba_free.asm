
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void ba_free(void *m)
;
; Place block m back into its queue for later reallocation.
; If m == NULL, ignore as with free().
;
; ===============================================================

INCLUDE "../../crt_vars.inc"

XLIB asm_ba_free

asm_ba_free:

   ; enter : hl = address of block to free
   ;
   ; exit  : none
   ;
   ; uses  : af, bc, de, hl
   
   ld a,h
   or l
   ret z
   
   dec hl
   ld e,(hl)                   ; e = queue number
   
   inc hl
   ex de,hl                    ; de = block address m
   
   ld h,0
   add hl,hl
   ld bc,(__qtbl)              ; bc = current queue table
   add hl,bc                   ; hl = q
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = first block in q
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; now q->first = m
   
   ex de,hl                    ; hl = block address m
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; m->next = first block in q
   
   ret
