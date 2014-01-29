
; ===============================================================
; Jan 2014
; ===============================================================
; 
; FILE *_fmemopen(void **bufp, size_t *sizep, const char *mode)
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

XLIB asm__fmemopen
XDEF asm0__fmemopen

LIB asm_malloc, l_setmem_hl, asm_realloc, asm_free
LIB __stdio_parse_permission, __stdio_file_init, __stdio_file_close
LIB __stdio_memstream_driver, error_einval_zc, error_zc

asm__fmemopen:

   ; enter : hl = char **bufp
   ;         bc = size_t *sizep
   ;         de = char *mode
   ;          a = mode mask (IOBX11AC, set bit disallows)
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
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, ix

   push hl                     ; save bufp
   push bc                     ; save sizep
   push af                     ; save mode mask
   
   call __stdio_parse_permission
   jp c, error_einval_zc - 3   ; if mode string is invalid
   
   pop af
   and c
   jp nz, error_einval_zc - 2  ; if mode byte is disallowed
   
   push bc                     ; save mode byte
   
   ld hl,26                    ; sizeof(memstream FILE *)
   call asm_malloc
   jp c, error_zc - 3          ; if malloc failed

asm0__fmemopen:

   ; hl = FILE * (26 bytes uninitialized)
   ; stack = bufp, sizep, mode byte

   ld e,l
   ld d,h                      ; de = FILE *
   
   ld ixl,e
   ld ixh,d                    ; ix = FILE *
   
   call __stdio_file_init
   
   ld hl,13
   add hl,de                   ; hl = & FILE.memstream_flags
   
   xor a
   call l_setmem_hl - 26
   
   ; FILE structure set to default
   
   ; de = FILE *
   ; ix = FILE *
   ; stack = bufp, sizep, mode byte
   
   ex de,hl                    ; hl = FILE *
   
   inc hl
   ld (hl),__stdio_memstream_driver % 256
   inc hl
   ld (hl),__stdio_memstream_driver / 256
   
   pop de                      ; e = mode byte = IOBX00AC
   
   ld a,e
   and $c0
   inc a
   ld (ix+3),a                 ; set r/w bits, memstream type
   
   rlca
   rlca
   and $02
   ld (ix+4),a                 ; if r mode, indicate last op was read

   ; FILE portion is initialized, memstream portion remains
   
   ld a,e
   and $12
   ld d,a

   ; ix = FILE *
   ;  e = mode byte = IOBX 00AC
   ;  d = memstream mode = F00G 00A0
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
   ;  e = mode byte = IOBX 00AC
   ;  d = memstream mode = F00G 00A0
   ; hl = void *buf
   ; bc = size_t size

   ld (ix+13),d                ; store final memstream mode
   ld a,e                      ; a = mode byte = IOBX00AC
   
   push hl                     ; save buf
   
   ld e,ixl
   ld d,ixh
   
   ld hl,18
   add hl,de                   ; hl = & FILE.buffer
   
   pop de                      ; de = void *buf
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; store buffer
   inc hl
   
   dec bc                      ; bc = size - 1 = end_index
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; store end_index
   inc hl

   ;  a = mode byte = IOBX 00AC   
   ; hl = & FILE.position
   ; bc = end_index
   ; de = void *buf

   and $03
   jr z, mode_AC_00
   
   rra
   jr c, mode_AC_X1
   
   ; mode_AC_10

   push hl                     ; save & FILE.position

   ld l,e
   ld h,d                      ; hl = void *buf
      
   inc bc                      ; bc = size of buffer

   xor a
   cpir                        ; look for '\0'

   scf
   sbc hl,de                   ; hl = index of '\0' or end of buf

   ex de,hl                    ; de = position_index @ '\0'
   
   ld c,e
   ld b,d                      ; bc = append_index @ '\0'
   
   pop hl
   jr rejoin_1

mode_AC_X1:

   ld bc,0                     ; bc = append_index = 0

mode_AC_00:

   ld de,0                     ; de = position_index = 0

rejoin_1:

   ; bc = append_index
   ; de = position_index
   ; hl = & FILE.position
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; store position_index
   inc hl
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; store append_index
   
   push ix
   pop hl                      ; hl = FILE *
   
   or a                        ; carry reset for success
   ret

must_allocate_size_0:

   ; ix = FILE *
   ;  e = mode byte = IOBX 00AC
   ;  d = memstream mode = F00G 00A0
   ; hl = void *buf
   ; bc = size_t size = 0

   bit 4,d
   call z, error_einval_zc
   jr z, allocate_fail         ; if not allowed to grow buffer
   
   inc bc                      ; allocate minimum buffer size
   ld hl,0                     ; void *buf = 0

must_allocate_buf_0:

   push bc
   push de
   
   ex de,hl                    ; de = void *buf
   call asm_realloc
   
   pop de
   pop bc
   
   bit 4,d
   jr nz, _skip
   set 7,d                     ; if not allowed to expand, must free buffer on close

_skip:

   jr nc, rejoin_0             ; if allocation was successful

allocate_fail:

   ; ix = FILE *

   push ix
   
   call __stdio_file_close
   
   pop hl
   call asm_free               ; free(FILE *)
   
   jp error_zc
