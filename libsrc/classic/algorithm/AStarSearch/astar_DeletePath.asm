; void __FASTCALL__ astar_DeletePath(struct astar_path *p)
; delete the path by freeing any memory associated with it
; 01.2007 aralbrec

SECTION code_clib
PUBLIC astar_DeletePath
PUBLIC _astar_DeletePath
EXTERN _u_free

; enter: hl = struct astar_path *
; uses : af, bc, de, hl

.astar_DeletePath
._astar_DeletePath

   ld a,h
   or l
   ret z
   
   ld e,l
   ld d,h
   
   inc hl
   inc hl
   ld a,(hl)                 ; is ref count == 0?
   or a
   ret nz                    ; if not, no more freeing

.loop

   ; de = & struct astar_path
   ; hl = & struct astar_path.ref_count

   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                    ; hl = & next struct astar_path
   
   push hl
   ex de,hl
   push hl
   call _u_free
   pop hl
   pop hl
   
   ld a,h
   or l
   ret z                     ; no more paths!
   
   ld e,l
   ld d,h
   
   inc hl
   inc hl
   dec (hl)                  ; ref count--
   jp z, loop                ; if zero, delete it
   
   ret
