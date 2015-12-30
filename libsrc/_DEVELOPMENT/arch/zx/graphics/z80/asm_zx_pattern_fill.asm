
; ===============================================================
; 2002 aralbrec
; ===============================================================
;
; int zx_pattern_fill(uint x, uint y, void *pattern, uint depth)
;
; Pattern flood fill an area on screen, allowing use of up to
; depth * 3 + 30 bytes of stack space.
;
; Return zero if the flood fill could not complete.
;
; ===============================================================
;
; This subroutine performs a byte-at-a-time breadth-first patterned
; flood fill.  It works by allocating a circular queue on the stack,
; with the size of the queue determined by an input parameter.
;
; The queue is divided into three contiguous blocks: the pattern
; block, the investigate block and the new block.
;
; The queue contains 3-byte structures (described below) with a
; special structure delimiting each block.  The physical end of the
; queue is marked with a special byte.  The contents of the queue
; grow down in memory.
;
; The pattern block holds pixels that have been blackened on screen
; and are only waiting to have the pattern applied to them before
; they are removed from the queue.
;
; The investigate block holds pixels that have been blackened on
; screen and are waiting to be investigated before they become part
; of the pattern block.  'Investigating' a pixel means trying to
; expand the fill in all four directions.  Any successful expansion
; causes the new pixel to be added to the new block.
;
; The new block holds pixels that have been blackened on screen and
; are waiting to become part of the investigate block.  The new block
; expands as the investigate block is investigated.
;
; The pattern fill algorithm follows these steps:
;
; 1. Examine the investigate block.  Add new pixels to the new block
;    if an expansion is possible.
; 2. Pattern the pattern block.  All pixels waiting to be patterned
;    are patterned on screen.
; 3. The investigate block becomes the pattern block.
;    The new block becomes the investigate block.
; 4. Repeat until the investigate block is empty.
;
; The algorithm may bail out prematurely if the queue fills up.
; Bailing out causes any pending pixels in the queue to be patterned
; before the subroutine exits.  If PFILL would continue to run by
; refusing to enter new pixels when the queue is full, there would be
; no guarantee that the subroutine would ever return.
;
; Plainly, the idea behind the patterned flood fill is simple.  The
; start pixel grows out in a diamond shape as neighbour pixels above,
; to the left, to the right and below are investigated.  A fill
; boundary two pixels thick is maintained in that diamond shape.
; The outermost boundary is the frontier, and is where the flood fill
; is growing from (ie the investigate block).  The inner boundary is
; the pattern block, waiting to be patterned.  A solid inner boundary
; is necessary to prevent the flood-fill frontier pixels from growing
; back toward the starting pixel through holes in the pattern.  Once
; the frontier pixels are investigated, the innermost boundary is
; patterned.  The newly investigated pixels become the outermost
; boundary (the investigate block) and the old investigate block
; becomes the new pattern block, forming the new inner solid boundary.
;
; Each entry in the queue is a 3-byte struct that grows down in memory:
;       screen address      (2-bytes, MSB first)
;       fill byte           (1-byte)
; A screen address with MSB < 0x40 is used to indicate the end of a block.
; A screen address with MSB >= 0x80 is used to mark the physical end of the Q.
;
; The fill pattern is a typical 8x8 pixel character, stored in 8 bytes.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_pattern_fill

EXTERN error_einval_mc, error_enomem_mc, error_znc, asm_zx_pxy2saddr, asm_zx_px2bitmask
EXTERN asm_zx_saddrup, asm_zx_saddrpdown, asm_zx_saddrpup, asm_zx_saddrcleft, asm_zx_saddrcright

asm_zx_pattern_fill:

   ; enter :  l = x coordinate
   ;          h = y coordinate
   ;         de = void *pattern
   ;         bc = uint depth
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno = ENOMEM or EINVAL
   ;
   ; uses  : af, bc, de, hl, ix

   ld a,h
   cp 192
   jp nc, error_einval_mc      ; if y coordinate out of range
   
   push de                     ; save (pattern pointer) variable
   dec bc                      ; we will start with one struct in the queue
   push bc                     ; save max stack depth variable

   call asm_zx_pxy2saddr       ; hl = screen address
   
   ex de,hl
   call asm_zx_px2bitmask      ; l = bitmask
   ld b,l
   
   ; de = screen address
   ;  b = bitmask

   ex de,hl                    ; hl = screen address
   call fill_byte              ; b = fill byte
   jp nc, error_znc - 2        ; if nothing to fill

viable:

   ex de,hl                    ; de = screen address, b = fill byte
   
   ld hl,-7
   add hl,sp
   
   push hl                     ; create pattern block pointer = top of queue
   push hl
   pop ix                      ; ix = top of queue
   
   dec hl
   dec hl
   dec hl
   push hl                     ; create investigate block pointer
   
   ld hl,-12
   add hl,sp
   push hl                     ; create new block pointer

   xor a
   push af
   dec sp                      ; mark end of pattern block
   
   push de                     ; screen address and fill byte are
   push bc                     ;   first struct in investigate block
   inc sp
   
   push af
   dec sp                      ; mark end of investigate block

   ld c,(ix+7)
   ld b,(ix+8)                 ; bc = max stack depth - 1
   inc bc

   ld l,c
   ld h,b
   add hl,bc                   ; space required = 3*BC (max depth) + 10
   add hl,bc                   ; but have already taken 9 bytes
   ld c,l
   ld b,h                      ; bc = # uninitialized bytes in queue
   
   ld hl,0
   sbc hl,bc                   ; negate hl, additions above will not set carry
   add hl,sp
   
   ld (hl),0                   ; zero last byte in queue
   ld sp,hl                    ; move stack below queue
   
   ld a,$80
   push af                     ; mark end of queue with $80 byte
   inc sp
   
   ld e,l
   ld d,h
   inc de
   dec bc
   ldir                        ; zero the uninitialized bytes in queue

; ix = top of queue, bottom of queue marked with 0x80 byte

; Variables indexed by ix, LSB first:
;
;   ix + 11/12    return address
;   ix + 09/10    fill pattern pointer
;   ix + 07/08    max stack depth
;   ix + 05/06    pattern block pointer
;   ix + 03/04    investigate block pointer
;   ix + 01/02    new block pointer

; A picture of memory at this point:
;
;+-----------------------+   higher addresses
;|                       |         |
;|-   return address    -|        \|/
;|                       |         V
;+-----------------------+   lower addresses
;|        fill           |
;|-  pattern pointer    -|
;|                       |
;+-----------------------+
;|                       |
;|-  max stack depth    -|
;|                       |
;+-----------------------+
;|                       |
;|-   pattern block     -|
;|                       |
;+-----------------------+
;|                       |
;|- investigate block   -|
;|                       |
;+-----------------------+
;|                       |
;|-     new block       -|
;|                       |
;+-----------------------+
;|  end of block marker  |  <- ix = pattern block = top of queue
;|          ?            |
;|          ?            |
;+-----------------------+
;|  screen address MSB   |  <- investigate block
;|  screen address LSB   |
;|      fill byte        |
;+-----------------------+
;|  end of block marker  |
;|          ?            |
;|          ?            |
;+-----------------------+
;|          0            |  <- new block
;|          0            |
;|          0            |
;+-----------------------+
;|                       |
;|        ......         |  size is a multiple of 3 bytes
;|     rest of queue     |
;|      all zeroed       |
;|        ......         |
;|                       |
;+-----------------------+
;|         0x80           |  <- sp, special byte marks end of queue
;+-----------------------+

pf_loop:

   ld l,(ix+3)
   ld h,(ix+4)                 ; hl = investigate block
   
   ld e,(ix+1)
   ld d,(ix+2)                 ; de = new block
   
   call investigate
   
   ld (ix+1),e
   ld (ix+2),d                 ; save new block
   
   ld (ix+3),l
   ld (ix+4),h                 ; save investigate block

   ld l,(ix+5)
   ld h,(ix+6)                 ; hl = pattern block
   
   ld c,(ix+7)
   ld b,(ix+8)                 ; bc = max stack depth (available space)
   
   call apply_pattern
   
   ld (ix+7),c
   ld (ix+8),b                 ; save stack depth
   
   ld (ix+5),l
   ld (ix+6),h                 ; save pattern block

   ld a,(hl)                   ; done if the investigate block was empty
   cp $40
   jr nc, pf_loop

pf_end:

   ld de,11                    ; return address is at ix+11
   add ix,de
   ld sp,ix
   
   jp error_znc                ; indicate success

; INVESTIGATE BLOCK
; IN/OUT: hl = investigate block, de = new block

investigate:

   ld a,(hl)		
   cp $80                      ; bit 15 of screen addr set if time to wrap		
   jr c, i_no_wrap
   
   push ix
   pop hl                      ; hl = ix = top of queue
   
   ld a,(hl)

i_no_wrap:

   cp $40                      ; screen address < $4000 marks end of block
   jr c, investigate_end       ; are we done yet?
   
   ld b,a
   dec hl
   ld c,(hl)                   ; bc = screen address
   dec hl
   
   ld a,(hl)                   ; a = fill byte
   dec hl
   
   push hl                     ; save spot in investigate block
   
   ld l,c
   ld h,b                      ; hl = screen address
   ld b,a                      ; b = fill byte

go_up:

   push hl                     ; save screen address
   
   call asm_zx_saddrpup        ; move screen address up one pixel
   jr c, up_dead_end           ; if went off screen
   
   push bc                     ; save fill byte
   
   call fill_byte
   call c, add_new             ; if up is not dead end, add this to new_block
   
   pop bc                      ; restore fill byte

up_dead_end:

   pop hl                      ; restore screen address

go_down:

   push hl                     ; save screen address
   
   call asm_zx_saddrpdown      ; move screen address down one pixel
   jr c, down_dead_end         ; if moved off screen
   
   push bc                     ; save fill byte
   
   call fill_byte
   call c, add_new             ; if down is not a dead end, add this to new_block
   
   pop bc                      ; restore fill byte
   
down_dead_end:

   pop hl                      ; restore screen address

go_left:

   bit 7,b                     ; can only move left if leftmost bit of fill byte is set
   jr z, go_right

   ld a,l
   and $1f
   jr z, go_right              ; if at leftmost edge of screen
   
   push hl                     ; save screen address
   
   call asm_zx_saddrcleft      ; move screen address left one char
   
   push bc                     ; save fill byte
   
   ld b,$01                    ; set rightmost pixel in incoming fill byte
   call fill_byte
   call c, add_new             ; if left is not a dead end, add this to new_block
   
   pop bc                      ; restore fill byte
   pop hl                      ; restore screen address

go_right:

   bit 0,b                     ; can only move right if rightmost bit of fill byte is set
   jr z, investigate_next
   
   ld a,l
   inc a
   and $1f
   jr z, investigate_next      ; if at rightmost edge of screen
   
   call asm_zx_saddrcright     ; move screen address right one char
   
   ld b,$80                    ; set leftmost pixel in incoming fill byte
   call fill_byte
   call c, add_new             ; if right is not dead end, add this to new_block

investigate_next:

   pop hl                      ; hl = spot in investigate block
   jr investigate

investigate_end:

   dec hl
   dec hl
   dec hl                      ; investigate_block now points at new_block

   ld a,(de)                   ; check if new_block is at end of queue
   cp $80
   jr c, no_wrap_new
   
   push ix
   pop de                      ; de = ix = top of queue

no_wrap_new:

   xor a
   ld (de),a                   ; store end marker for new block
   
   dec de
   dec de
   dec de
   
   ret

; FILL BYTE
; enter : b = incoming byte, hl = screen address
; exit  : b = fill byte, screen blackened with fill byte, carry set if viable
   
fill_byte:

   ld a,b
   xor (hl)                    ; zero out incoming pixels that run into display pixels
   and b
   ret z

bf_loop:

   ld b,a
   rra                         ; expand incoming pixels
   ld c,a                      ; to the right and left within byte
   
   ld a,b
   add a,a
   or c
   or b
   ld c,a
   
   xor (hl)                    ; zero out pixels that run into
   and c                       ; set pixels on display
   
   cp b
   jr nz, bf_loop              ; keep going until incoming byte does not change
   
   or (hl)
   ld (hl),a                   ; blacken byte on screen

   scf                         ; indicate that this was a viable step
   ret

; ADD NEW
; add incoming fill byte and screen address to new_block
; enter : b = incoming byte, hl = screen address, de = new_block

add_new:

   push hl                     ; save screen address
   
   ld l,(ix+7)
   ld h,(ix+8)                 ; hl = max stack depth
   
   ld a,h
   or l
   jr z, bail                  ; no space in queue so bail!
   
   dec hl                      ; available queue space decreases by one struct
   
   ld (ix+7),l
   ld (ix+8),h
   
   pop hl                      ; hl = screen address

   ld a,(de)                   ; check if new_block is at end of queue
   cp $80
   jr c, an_no_wrap
   
   push ix
   pop de                      ; de = ix = top of queue

an_no_wrap:

   ex de,hl
   
   ; make struct
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; store screen address
   dec hl
   
   ld (hl),b                   ; store fill byte
   dec hl
   
   ex de,hl
   ret

; BAIL
; If the queue filled up, we need to bail.
; Bailing means patterning any set pixels which may still be on the display.
; If we didnt bail there would be no guarantee the fill would ever return.

bail:

   pop hl                      ; hl = screen address, b = fill byte
   
   ld a,b
   xor (hl)
   ld (hl),a                   ; remove this fill byte from screen

   xor a
   ld (de),a                   ; mark end of new block

   ld l,(ix+5)
   ld h,(ix+6)                 ; hl = pattern block
   
   call apply_pattern          ; pattern block
   call apply_pattern          ; investigate block
   call apply_pattern          ; new block

   ld de,11                    ; return address is at ix+11
   add ix,de
   ld sp,ix
   
   jp error_enomem_mc          ; indicate we had to bail

; APPLY PATTERN
; hl = pattern block, bc = max stack depth (available space)

apply_pattern:

   ld a,(hl)
   cp $80                      ; bit 15 of screen addr set if time to wrap
   jr c, ap_no_wrap
   
   push ix
   pop hl                      ; hl = ix = top of queue
   
   ld a,(hl)

ap_no_wrap:

   cp $40                      ; screen address < $4000 marks end of block
   jr c, apply_end             ; are we done yet?

   and $07                     ; use scan line 0..7 to index pattern
   add a,(ix+9)
   ld e,a
   ld a,0
   adc a,(ix+10)
   ld d,a                      ; de points into fill pattern
   ld a,(de)                   ; a = pattern 

   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = screen address
   dec hl

   and (hl)                    ; and pattern with fill byte
   
   sub (hl)                    ; or in complement of fill byte
   dec a
   
   ex de,hl
   
   and (hl)                    ; apply pattern to screen
   ld (hl),a
   
   ex de,hl
   
   dec hl
   inc bc                      ; increase available queue space
   
   jr apply_pattern

apply_end:

   dec hl
   dec hl
   dec hl                      ; pattern block now points at investigate block
   
   ret
