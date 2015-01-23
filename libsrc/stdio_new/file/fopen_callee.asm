; FILE __CALLEE__ *fopen_callee(char *filename, char *mode)
; 07.2009 aralbrec

PUBLIC fopen_callee
PUBLIC ASMDISP_FOPEN_CALLEE, LIBDISP_FOPEN_CALLEE

EXTERN open_callee, stdio_free
EXTERN stdio_parseperm, stdio_findfileslot, stdio_malloc
EXTERN stdio_error_einval_zc, stdio_error_enfile_zc, stdio_error_enomem_zc
EXTERN ASMDISP_OPEN_CALLEE

INCLUDE "../stdio.def"

.fopen_callee

   pop hl
   pop de
   ex (sp),hl
   
   ; enter : hl = char *filename
   ;         de = char *mode
   ; exit  : hl = FILE * and carry reset for success
   ;         hl = 0 and carry set for fail

.asmentry

   ; 1. parse mode string
   ;
   ; hl = char *filename
   ; de = char *mode

   push hl                     ; save char *filename
   
   call stdio_parseperm        ; a = mode flags
   jp c, stdio_error_einval_zc - 1  ; invalid mode string
   ld c,a

   ; 2. find empty FILE slot
   ;
   ;  c = mode flags
   ; stack = char *filename
   
   call stdio_findfileslot     ; hl = MSB of filetbl entry
   jp c, stdio_error_enfile_zc - 1  ; file table is full

   ; 3. malloc FILE*
   ;
   ;  c = mode flags
   ; hl = MSB of filetbl entry
   ; stack = char *filename

   exx
   
   ld bc,STDIO_SIZEOF_FILE
   call stdio_malloc           ; hl = FILE *
   jp nc, stdio_error_enomem_zc - 1  ; memory not available
   
   ; 4. open low level fd
   ;
   ;  c' = mode flags
   ; hl' = MSB of filetbl entry
   ;  hl = FILE*
   ; stack = char *filename
   
   pop de                      ; de = char *filename
   exx
   push hl                     ; save MSB of filetbl entry
   ld a,c
   exx
   ld c,a                      ; c = mode flags
   push hl                     ; save FILE*
   
   ; de = char *filename
   ;  c = mode flags
   ; stack = MSB of filetbl entry, FILE*
   
   call open_callee + ASMDISP_OPEN_CALLEE  ; ix = fdstruct*
   jr c, fail0
 
   ; 5. enter FILE* in file table
   ;
   ; ix = fdstruct*
   ; stack = MSB of filetbl entry, FILE*
   
   pop de                      ; de = FILE*
   pop hl                      ; hl = MSB of filetbl entry
   
   ld (hl),d
   dec hl
   ld (hl),e
   
   ; 6. fill in FILE structure
   ;
   ; ix = fdstruct*
   ; de = FILE*

.libentry

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

   ld a,(ix+3)                 ; mode flags
   and $06
   or $08                      ; set FILE flag bit
   ld (hl),a                   ; FILE* flags

   ; 7. return FILE*
   ;
   ; de = FILE*
   ; ix = fdstruct*
   ; carry reset
   
   ex de,hl
   ret   

.fail0

   ; stack = MSB of filetbl entry, FILE*
   
   pop hl                      ; hl = FILE*
   call stdio_free

   jp stdio_error_zc - 1
   
defc ASMDISP_FOPEN_CALLEE = # asmentry - fopen_callee
defc LIBDISP_FOPEN_CALLEE = # libentry - fopen_callee
