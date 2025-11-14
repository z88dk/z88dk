SECTION code_user

PUBLIC _sp1_TestCollision

EXTERN error_znc

; int sp1_TestCollision(struct sp1_ss *s1, struct sp1_ss *s2, unsigned int tolerance)
; callee linkage

_sp1_TestCollision:

IFDEF __SDCC

   ; must preserve ix and iy
   
   pop af
   pop bc
   pop de
   pop hl
   push af
   
   push ix
   push iy
   
   push bc
   pop iy
   
   push de
   pop ix
   
   call _sp1_TestCollision_0

   pop iy
   pop ix
   ret

_sp1_TestCollision_0:

ENDIF

IFDEF __SCCZ80

   pop af
   pop hl
   pop ix
   pop iy
   push af

ENDIF

   ; ix = struct sp1_ss * (sprite #2)
   ; iy = struct sp1_ss * (sprite #1)
   ;  l = tolerance
   
   ; see if x-interval intersects
   
   ; sprite # 1
   
   ld a,(iy+1)                 ; column coordinate (in chars)
   add a,a                     ; multiply by 8
   add a,a
   add a,a
   add a,(iy+5)                ; add horizontal rotation
   ld b,a                      ; b = pixel x-coord of top left corner
   
   ld a,(iy+2)                 ; width (in chars)
   dec a                       ; do not count blank column on right of sprite
   add a,a                     ; multiply by 8
   add a,a
   add a,a
   sub (iy+17)                 ; subtract x-threshold
   inc a
   sub l                       ; build in the tolerance
   ld c,a                      ; c = width of sprite in pixels

   ; sprite #2

   ld a,(ix+1)                 ; column coordinate (in chars)
   add a,a                     ; multiply by 8
   add a,a
   add a,a
   add a,(ix+5)                ; add horizontal rotation
   ld d,a                      ; d = pixel x-coord of top left corner
   
   ld a,(ix+2)                 ; width (in chars)
   dec a                       ; do not count blank column on right of sprite
   add a,a                     ; multiply by 8
   add a,a
   add a,a
   sub (ix+17)                 ; subtract x-threshold
   inc a
   sub l                       ; build in the tolerance
   ld e,a                      ; e = width of sprite in pixels

   call RIsIvalInIval8         ; do these two intervals intersect?
   jp nc, error_znc            ; if not, no collision is detected
   
   ; see if y-interval intersects
   
   ; sprite #1
   
   ld a,(iy+4)
   and $07
   ld h,a                      ; h = vertical rotation 0-7
   ld a,(iy+0)                 ; row coordinate (in chars)
   add a,a                     ; multiply by 8
   add a,a
   add a,a
   add a,h                     ; add vertical rotation
   ld b,a                      ; b = pixel y-coord of top left corner
   
   ld a,(iy+3)                 ; height (in chars)
   dec a                       ; do not count blank row at bottom of sprite
   add a,a                     ; multiply by 8
   add a,a
   add a,a
   sub (iy+18)                 ; subtract y-threshold
   inc a
   sub l                       ; build in tolerance
   ld c,a                      ; c = height of sprite in pixels
   
   ; sprite #2

   ld a,(ix+4)
   and $07
   ld h,a                      ; h = vertical rotation 0-7
   ld a,(ix+0)                 ; row coordinate (in chars)
   add a,a                     ; multiply by 8
   add a,a
   add a,a
   add a,h                     ; add vertical rotation
   ld d,a                      ; d = pixel y-coord of top left corner
   
   ld a,(ix+3)                 ; height (in chars)
   dec a                       ; do not count blank row at bottom of sprite
   add a,a                     ; multiply by 8
   add a,a
   add a,a
   sub (ix+18)                 ; subtract y-threshold
   inc a
   sub l                       ; build in tolerance
   ld e,a                      ; e = height of sprite in pixels

   call RIsIvalInIval8         ; do these two intervals intersect?
   jp nc, error_znc            ; if not, no collision
   
   ld hl,1
   ret



RIsIvalInIval8:

; Determine if two 8-bit intervals intersect.  Intervals
; can wrap across 0-255 boundary.  Amazingly this test
; reduces to detecting whether either of the start points
; of each interval lie in the other interval.
;
; enter  :  b = interval 1 start coordinate
;           c = interval 1 width
;           d = interval 2 start coordinate
;           e = interval 2 width
; exit   : carry flag set = intersection detected
; uses   : af

   ld a,b
   sub d
   cp e
   ret c

   ld a,d
   sub b
   cp c
   ret
