; uint __FASTCALL__  astar_PathLength(struct astar_path *p)
; return the length of the path
; 01.2007 aralbrec

SECTION code_clib
PUBLIC astar_PathLength
PUBLIC _astar_PathLength

; enter : hl = struct astar_path *
; exit  : hl = path length
; uses  : af, bc, de, hl

.astar_PathLength
._astar_PathLength

   ld bc,3
   ld d,b
   ld e,b
   
.loop

   ld a,h
   or l
   jr z, done
   inc de
   
   add hl,bc
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a

   jp loop

.done

   ex de,hl
   ret
