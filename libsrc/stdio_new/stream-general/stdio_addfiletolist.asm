; stdio_addfiletolist
; 06.2008 aralbrec

XLIB stdio_addfiletolist
XREF _filelist

.stdio_addfiletolist

   ; add the FILE structure to the list of open files
   ;
   ; enter : hl = FILE * (offset -4)
   ; exit  : hl = FILE * (offset 0)
   ; uses  : af, de, hl
   
   ld de,(_filelist)           ; de = & first FILE.prev in open list
   ld (_filelist),hl           ; this new FILE is now first in list
   
   ld (hl),_filelist % 256     ; new FILE.prev = list head
   inc hl
   ld (hl),_filelist / 256
   inc hl
   
   ld (hl),e                   ; new FILE.next = first FILE.prev
   inc hl
   ld (hl),d
   dec hl

   ld a,d                      ; if the file list was empty
   or e                        ;   dont be writing stuff into
   jr z, nofirst               ;   non-existent first FILE
      
   ex de,hl                    ; de = new FILE.next, hl = first FILE.prev
   
   ld (hl),e                   ; first FILE.prev = new FILE.next
   inc hl
   ld (hl),d
   
   ex de,hl                    ; hl = new FILE.next

.nofirst

   inc hl
   inc hl
   ret
