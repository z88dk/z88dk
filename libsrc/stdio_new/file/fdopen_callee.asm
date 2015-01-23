; FILE __CALLEE__ *fdopen_callee(int fd, char *mode)
; 07.2009 aralbrec

PUBLIC fdopen_callee
PUBLIC ASMDISP_FDOPEN_CALLEE

EXTERN stdio_fdcommon1, stdio_parseperm, stdio_findfileslot, stdio_malloc
EXTERN stdio_error_ebadf_zc, stdio_error_einval_zc, stdio_error_enfile_zc, stdio_error_enomem_zc

INCLUDE "../stdio.def"

.fdopen_callee

   pop hl
   pop de
   ex (sp),hl

   ; attach a high level FILE* interface to a low level fd
   ; does not increase the reference count for the fd
   ;
   ; enter :  l = int fd
   ;         de = char *mode
   ; exit  : hl = FILE *, ix = fdstruct*, carry reset for success
   ;         hl = 0 and carry set for fail

.asmentry

   ; 1. get fdstruct* for underlying fd
   ;
   ;  l = int fd
   ; de = char *mode

   call stdio_fdcommon1        ; ix = fdstruct*
   jp c, stdio_error_ebadf_zc  ; problem with the fd

   ; 2. parse mode flags
   ;
   ; de = char *mode
   ; ix = fdstruct *
   
   call stdio_parseperm        ; a = mode flags
   jp c, stdio_error_einval_zc ; mode string invalid

   ; 3. verify desired mode is a subset of the underlying fd mode
   ;
   ;  a = desired mode flags
   ; ix = fdstruct *
   
   and $07                     ; only intereseted in I/O/A flag bits
   ld c,a
   and (ix+3)                  ; check against fd flags
   cp c
   jp nz, stdio_error_einval_zc  ; file is not open for desired mode
   set 3,c                     ; set FILE bit
   res 0,c                     ; clear A bit
   
   ; 4. find empty slot in file table
   ;
   ;  c = mode flags
   ; ix = fdstruct *

   call stdio_findfileslot     ; hl = MSB of filetbl entry
   jp c, stdio_error_enfile_zc ; file table is full

   ; 5. malloc a FILE struct
   ;
   ;  c = mode flags
   ; hl = MSB of filetbl entry
   ; ix = fdstruct *
   
   exx
   ld bc,STDIO_SIZEOF_FILE
   call stdio_malloc           ; hl = FILE*
   jp nc, stdio_error_enomem_zc  ; malloc failed
   push hl
   exx
   pop de                      ; de = FILE*
   
   ; 6. enter new FILE in file table
   ;
   ;  c = mode flags
   ; hl = MSB of filetbl entry
   ; de = FILE *
   ; ix = fdstruct *
   
   ld (hl),d
   dec hl
   ld (hl),e
   
   ; 7. initialize FILE struct
   ;
   ;  c = mode flags
   ; de = FILE *
   ; ix = fdstruct *
   
   ld l,e
   ld h,d                      ; hl = FILE*
   
   ld (hl),195                 ; JP instruction
   inc hl
   
   ld a,ixl
   ld (hl),a
   inc hl
   ld a,ixh
   ld (hl),a                   ; store fdstruct*
   inc hl

   ld (hl),c                   ; mode flags

   ; 8. return success
   ;
   ; de = FILE*
   ; ix = fdstruct *
   
   ex de,hl
   or a                        ; report no error
   ret

defc ASMDISP_FDOPEN_CALLEE = # asmentry - fdopen_callee
