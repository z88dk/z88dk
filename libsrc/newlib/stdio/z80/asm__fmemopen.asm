
; ===============================================================
; Jan 2014
; ===============================================================
; 
; FILE *_fmemopen_(void **bufp, size_t *sizep, const char *mode)
;
; Associate a memory buffer with a stream.
;
; More general than the proposed standard functions which only
; allow read/write-able fixed buffers (fmemopen) and write-only
; expanding buffers (open_memstream).  This function allows
; all combinations, treating a buffer exactly like a file.
; The mode flag "x" is re-purposed to indicate the buffer is
; allowed to expand via realloc.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm__fmemopen
PUBLIC asm0__fmemopen

EXTERN error_einval_zc, error_zc, __stdio_file_add_list, __stdio_heap
EXTERN __stdio_parse_mode, asm_heap_alloc, __stdio_file_constructor, l_setmem_hl
EXTERN __stdio_memstream_driver, asm_realloc, __stdio_file_destructor, asm_free

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

EXTERN __stdio_lock_file_list, __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm__fmemopen:

   ; enter : hl = char **bufp
   ;         bc = size_t *sizep
   ;         de = char *mode
   ;          a = mode mask (0TXC BAWR, set bit disallows)
   ;
   ; exit  : success
   ;
   ;            hl = FILE *
   ;            ix = FILE *
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, ix

   push hl                     ; save bufp
   push bc                     ; save sizep
   push af                     ; save mode mask
   
   ld a,h
   or l
   jp z, error_einval_zc - 3   ; if bufp == 0
   
   ld a,b
   or c
   jp z, error_einval_zc - 3   ; if sizep == 0
   
   call __stdio_parse_mode
   jp c, error_einval_zc - 3   ; if mode string is invalid
   
   pop af
   and c
   
   jp nz, error_einval_zc - 2  ; if mode byte is disallowed
   
   push bc                     ; save mode byte
   
   ; allocate FILE structs from stdio's heap
   
   ld hl,31                    ; sizeof(memstream FILE *)
   ld de,(__stdio_heap)
   call asm_heap_alloc
   
   jp c, error_zc - 3          ; if malloc failed

   inc hl
   inc hl                      ; hl = FILE *
   
asm0__fmemopen:

   ; hl = FILE * (29 bytes uninitialized)
   ; stack = bufp, sizep, mode byte

   ld e,l
   ld d,h                      ; de = FILE *
   
   push de
   pop ix                      ; ix = FILE *
   
   call __stdio_file_constructor
   
   ld hl,13
   add hl,de                   ; hl = & FILE.memstream_flags
   
   xor a
   call l_setmem_hl - 30
   
   ; FILE structure set to default
   
   ; de = FILE *
   ; ix = FILE *
   ; stack = bufp, sizep, mode byte
   
   ex de,hl                    ; hl = FILE *
   
   inc hl
   ld (hl),__stdio_memstream_driver % 256
   inc hl
   ld (hl),__stdio_memstream_driver / 256
   
   pop de                      ; e = mode byte = 0TXC BAWR
   ld (ix+28),e                ; save original mode byte
   
   ld a,e
   rrca
   rrca
   and $c0
   add a,$27
   ld (ix+3),a                 ; set r/w bits, memstream type
   
   ld a,e
   rla
   and $02
   ld (ix+4),a                 ; if r mode, indicate last op was read

   ; FILE portion is initialized, memstream portion remains
   
   ld a,e
   and $24
   ld d,a

   ; ix = FILE *
   ;  e = mode byte = 0TXC BAWR
   ;  d = memstream mode = F0X0 0A00
   ; stack = bufp, sizep

   ; must allocate a buffer ?
   
   pop hl                      ; hl = size_t *sizep
   
   ld (ix+16),l
   ld (ix+17),h                ; store in FILE structure
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = size
   
   pop hl                      ; hl = char **bufp
   
   ld (ix+14),l
   ld (ix+15),h                ; store in FILE structure
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = void *buf
   
   ld a,b
   or c
   jr z, must_allocate_size_0
   
   ld a,h
   or l
   jr z, must_allocate_buf_0
   
rejoin_0:

   ; ix = FILE *
   ;  e = mode byte = 0TXC BAWR
   ;  d = memstream mode = F0X0 0A00
   ; hl = void *buf
   ; bc = size_t size

   ld (ix+13),d                ; store final memstream mode
   ld a,e                      ; a = mode byte = 0TXC BAWR
   
   push hl                     ; save buf
   
   push ix
   pop de
   
   ld hl,18
   add hl,de                   ; hl = & vector.array
   
   pop de                      ; de = void *buf
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; vector.array = buf
   inc hl

   push bc

   ;  a = mode byte = 0TXC BAWR
   ; hl = & vector.size
   ; bc = capacity
   ; de = void *buf
   ; stack = capacity

   and $50
   jr z, mode_TC_00
   
   cp $50
   jr z, mode_TC_11
   
mode_TC_01:

   push hl                     ; save & vector.size

   ld l,e
   ld h,d                      ; hl = void *buf
      
   ld a,b
   or c
   jr z, skip_cpir

   xor a
   cpir                        ; look for '\0'

   scf

skip_cpir:

   sbc hl,de                   ; hl = index of '\0' or end of buf

   ex de,hl                    ; de = position_index @ '\0'
   
   ld c,e
   ld b,d                      ; bc = append_index @ '\0'
   
   pop hl
   jr rejoin_1

mode_TC_11:

   ld bc,0                     ; bc = append_index = 0

mode_TC_00:

   ld de,0                     ; de = position_index = 0

rejoin_1:

   ; bc = append_index
   ; de = position_index
   ; hl = & vector.size
   ; stack = capacity
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; vector.size = append_index
   inc hl
   
   pop bc                      ; bc = capacity
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; vector.capacity = capacity
   inc hl
   
   bit 5,(ix+13)               ; vector allowed to grow ?
   jr z, vector_no_grow

   ld bc,$ffff                 ; max_size = all of memory

vector_no_grow:

   ld (hl),c
   inc hl
   ld (hl),b                   ; vector.max_size = capacity
   inc hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; fptr = position_index

   ; add FILE to open list

   push ix
   pop de                      ; de = FILE *

   call __stdio_file_add_list
   
   ; return FILE*
   
   push ix
   pop hl                      ; hl = FILE *
   
   or a                        ; carry reset for success
   ret

must_allocate_size_0:

   ; ix = FILE *
   ;  e = mode byte = 0TXC BAWR
   ;  d = memstream mode = F0X0 0A00
   ; hl = void *buf
   ; bc = size_t size = 0

   bit 5,d
   call z, error_einval_zc
   jr z, allocate_fail         ; if not allowed to grow buffer
   
   inc bc                      ; make room for '\0'
   ld hl,0                     ; void *buf = 0

must_allocate_buf_0:

   push bc
   push de
   
   call asm_realloc
   
   pop de
   pop bc
   
   jr c, allocate_fail
   
   bit 5,d
   jr nz, _skip
   
   set 7,d                     ; if not allowed to expand, must free buffer on close

_skip:

   dec bc                      ; make capacity smaller to hide terminating '\0'
   
   add hl,bc                   ; hl = & end of buffer
   ld (hl),0                   ; zero terminate
   
   sbc hl,bc
   jp rejoin_0

allocate_fail:

   ; ix = FILE *

   call __stdio_file_destructor
      
   push ix
   pop hl
   
   dec hl
   dec hl                      ; hl = & FILE.link
   
   call asm_free               ; free(FILE *)
   jp error_zc
