; FILE __CALLEE__ *freopen_callee(char *filename, char *mode, FILE *stream)
; 07.2009 aralbrec

PUBLIC freopen_callee
PUBLIC ASMDISP_FREOPEN_CALLEE

EXTERN fclose, close, stdio_parseperm, fopen_callee, stdio_findfilestruct, stdio_findfdstruct, stdio_free, fflush
EXTERN stdio_error_einval_zc, stdio_error_zc, stdio_error_ebadf_zc, l_jpix, stdio_descendchain
EXTERN LIBDISP_FCLOSE, LIBDISP_CLOSE, LIBDISP2_CLOSE, LIBDISP_FOPEN_CALLEE, ASMDISP_FFLUSH

INCLUDE "../stdio.def"

.freopen_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl

   ; enter : bc = FILE *stream
   ;         de = char *mode
   ;         hl = char *filename
   ; exit  : hl = FILE * and carry reset for success
   ;         hl = 0 and carry set for fail (stream will be closed and deallocated)
   ;         if filename==NULL original FILE* remains valid in all cases

.asmentry

   ; 1. if filename == 0 we want to change mode only
   ;
   ; bc = FILE*
   ; de = char *mode
   ; hl = char *filename
 
   ld a,h
   or l
   jr z, change_mode

   ; 2. close file and flush high level buffers
   ;
   ; bc = FILE*
   ; de = char *mode
   ; hl = char *filename
   
   push bc                     ; save FILE*
   push hl                     ; save char *filename
   push de                     ; save char *mode
   
   inc bc
   ld a,(bc)
   ld ixl,a
   inc bc
   ld a,(bc)
   ld ixh,a                    ; ix = next file structure in stdio chain
   
   bit 3,(ix+3)                ; is it a FILE struct?
   jr nz, isfile

   ; ix = fdstruct *
   
   call stdio_findfdstruct     ; locate fd table entry corresponding to ix fdstruct
   jr nc, remove_fdtbl         ; if fdstruct was found in fd table
   
   call close + LIBDISP_CLOSE
   jp rejoin

.remove_fdtbl

   call close + LIBDISP2_CLOSE ; remove from fd table too

.rejoin

   ; 3. parse mode string
   ;
   ; stack = FILE*, char *filename, char *mode
   
   pop de                      ; de = char *mode
   call stdio_parseperm        ; a = mode flags
   pop de                      ; de = char *filename
   jr c, e_einval              ; problem with mode string
   
   ; 4. open low level fd
   ;
   ;  a = mode flags
   ; de = char *filename
   ; stack = FILE*
   
   ld c,a
   call open_callee + ASMDISP_OPEN_CALLEE
   jr c, e_error               ; problem with open
   
   ; 5. connect FILE structure with new fd
   ;
   ; ix = fdstruct *
   ; stack = FILE*
   
   pop de                      ; de = FILE*
   jp fopen_callee + LIBDISP_FOPEN_CALLEE

.isfile

   call fclose + LIBDISP_FCLOSE  ; flush high level buffers and close file
   jp rejoin

.e_einval

   call stdio_error_einval_zc  ; set errno

.e_error

   pop ix                      ; ix = FILE*
   
   call stdio_findfilestruct   ; hl = & stdio_filetbl[FILEentry] + 1
   jp c, stdio_error_zc        ; invalid FILE* !!! very bad
   
   ld (hl),0
   dec hl
   ld (hl),0                   ; remove FILE* from open FILE list
   
   push ix
   pop hl                      ; hl = FILE*
      
   call stdio_free
   jp stdio_error_zc

.change_mode

   ; we only want to change the mode flags for the FILE
   
   ; 1. descend stdio chain to first fdstruct
   ;
   ; bc = FILE*
   ; de = char *mode

   push bc                     ; save FILE*
   ld ixl,c
   ld ixh,b                    ; ix = FILE*

.loop0

   call stdio_descendchain     ; ix = next file structure
   bit 3,(ix+3)                ; are we still in the high level FILEs?
   jr nz, loop0

   ; 2. parse mode string
   ;
   ; de = char *mode
   ; ix = first fdstruct* in stdio chain
   ; stack = FILE*
   
   call stdio_parseperm        ; a = b = desired mode flags
   jp c, stdio_error_einval_zc - 1  ; mode string invalid

   ; 3. are desired flags compatible with the underlying fd?
   ;
   ; a = b = desired mode flags
   ; ix = fdstruct*
   ; stack = FILE*
   
   and $07                     ; only interested in IOA bits
   ld b,a
   and (ix+3)                  ; compare with underlying fd
   cp b
   jp nz, stdio_error_ebadf_zc - 1  ; desired mode not compatible with fd

   and $06
   or $08                      ; a = mode to be stored in FILE struct
   
   ; 4. flush stream
   ;
   ;  a = new mode flags
   ; stack = FILE*
   
   pop ix                      ; ix = FILE*
   push af                     ; save mode
   call fflush + ASMDISP_FFLUSH
   pop af
   
   ; 5. change mode
   ;
   ;  a = new mode
   ; ix = FILE*
   
   ld (ix+3),a
   
   ; 6. remove all high level FILE struct in stdio chain
   ;
   ; ix = FILE*

   ld a,STDIO_MSG_FCLS
   call l_jpix                 ; send high level close message
   
   push ix                     ; save FILE*
   ld hl,0
      
.loop1
   
   call stdio_descendchain     ; ix = next file structure
   call stdio_free             ; free previous file structure
   
   bit 3,(ix+3)                ; is it a high level file structure?
   jr z, nomore

   push ix
   pop hl                      ; hl = high level file structure
   
   jp loop1

.nomore

   ; 7. connect FILE* directly to first fdstruct
   ;
   ; ix = fdstruct*
   ; stack = FILE*
   
   pop hl                      ; hl = FILE*
   
   inc hl
   ld a,ixl
   ld (hl),a
   inc hl
   ld a,ixh
   ld (hl),a
   
   dec hl
   dec hl

   or a
   ret

defc ASMDISP_FREOPEN_CALLEE = # asmentry - freopen_callee
