; stdio_rmfilefromlist
; 06.2008 aralbrec

XLIB stdio_rmfilefromlist
XREF _filelist

.stdio_rmfilefromlist

   ; remove the FILE structure from the list of open files
   ;
   ; enter : hl = FILE * (offset 0)
   ; exit  : hl = FILE * (offset -4)
   ; uses  : af, bc, de, hl
   
   dec hl
   ld b,(hl)
   dec hl
   ld c,(hl)                   ; bc = & next FILE.prev
   dec hl
   
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = & previous FILE.next
   
   ex de,hl                    ; hl = & previous FILE.next, de = FILE * (offset -4)
   
   ld (hl),c                   ; previous FILE.next = & next FILE.prev
   inc hl
   ld (hl),b
   dec hl
   
   ld a,b                      ; if there is no next FILE
   or c                        ;   dont be writing stuff into it
   jr z, nonext

   ld a,l                      ; next FILE.prev = & previous FILE.next
   ld (bc),a
   inc bc
   ld a,h
   ld (bc),a

.nonext

   ex de,hl
   ret
