
; ===============================================================
; October 2014
; ===============================================================
; 
; int vopen(const char *path, int oflag, void *arg)
;
; Open a file.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_fcntl

PUBLIC asm_vopen, asm0_vopen

EXTERN asm_target_open_p1, asm_target_open_p2
EXTERN __stdio_heap, asm_heap_alloc, asm_heap_free, asm_memset
EXTERN __fcntl_first_available_fd, __fcntl_fdtbl_size
EXTERN error_einval_mc, error_mc, error_enfile_mc

asm_vopen:

   ; enter : de = char *path
   ;         bc = int oflag (LSB is mode byte)
   ;         hl = void *arg (0 if no args)
   ;
   ; exit  : success
   ;
   ;            hl = int fd
   ;            de = FDSTRUCT *
   ;             c = FILE type (bit 5 = 0 if stdio manages unget from eatc)
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all except iy
   
   ; check oflag
   
   ld a,c
   and $03
   jp z, error_einval_mc       ; if at least one of RW not set
   
   res 7,c                     ; set ref_count to one

asm0_vopen:

   ; target part 1: is path valid ?
   
   ; de = char *path
   ; bc = int oflag (bit 7 = 1 for initial ref_count = 2, else 1)
   ; hl = void *arg (0 if no args)
   
   call asm_target_open_p1     ; target can place state in exx set
   jp c, error_mc              ; target reports error
   
   ; allocate an FDSTRUCT
   
   ; hl = data space required by driver (from target)
   ; exx set reserved for target
   
   ld de,11                    ; sizeof(FDSTRUCT header)
   add hl,de                   ; sizeof(FDSTRUCT)
   
   push hl                     ; save sizeof(FDSTRUCT)
   
   ld de,__stdio_heap
   call asm_heap_alloc         ; allocate out of stdio heap
   
   pop bc                      ; bc = sizeof(FDSTRUCT)
   jp c, error_mc              ; if memory unavailable

   ; hl = FDSTRUCT *
   ; bc = sizeof(FDSTRUCT)
   ; exx set reserved for target

   ld e,0
   call asm_memset             ; zero the FDSTRUCT

   ; search for available fd

   ; hl = FDSTRUCT *
   ; exx set reserved for target

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $08

   EXTERN __fcntl_lock_fdtbl, __fcntl_unlock_fdtbl
   
   call __fcntl_lock_fdbtl

   call critical_section

   jp __fcntl_unlock_fdtbl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

critical_section:

   ex de,hl                    ; de = FDSTRUCT *
   call __fcntl_first_available_fd
   
   jp nz, error_enfile_mc      ; if no fd slot is available
   
   ld a,__fcntl_fdtbl_size
   sub b
   
   ; target part 2: create the file
   
   ;  a = fd, carry reset
   ; hl = & fdtbl[fd] + 1b
   ; de = FDSTRUCT *
   ; exx set reserved for target

   push af                     ; save fd
   push de                     ; save FDSTRUCT *
   push hl                     ; save & fdtbl[fd] + 1b
   
   ex de,hl                    ; hl = FDSTRUCT *
   call asm_target_open_p2     ; target creates file, fills FDSTRUCT, return c = FILE type
                               ;   (bit 7 of oflag + 1 indicates initial ref_count)
   pop hl                      ; hl = & fdtbl[fd] + 1b
   pop de                      ; de = FDSTRUCT *
   
   jr c, target_error_p2       ; if target reports error

   pop af                      ;  a = fd

   ; make fd entry
   
   ld (hl),d
   dec hl
   ld (hl),e
   
   ld l,a
   ld h,0                      ; hl = fd
   
   ret

target_error_p2:

   ex de,hl                    ; hl = FDSTRUCT *
   
   ld de,__stdio_heap
   call asm_heap_free
   
   jp error_mc - 1
