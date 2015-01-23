; int __CALLEE__ filter_callee(int fd, void *filter_driver, void *init)
; 07.2009 aralbrec

PUBLIC filter_callee
PUBLIC ASMDISP_FILTER_CALLEE

EXTERN stdio_fdcommon1, stdio_findfdslot, stdio_malloc, stdio_descendchain, l_jpix, stdio_free
EXTERN stdio_error_ebadf_mc, stdio_error_enfile_mc, stdio_error_enomem_mc, stdio_error_mc

INCLUDE "../stdio.def"

; create a filter fd that filters messages
; and forwards them to an already existing fd

.filter_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl

   ; enter :  l = fd
   ;         bc = void *init
   ;         de = void *filter_driver
   ; exit  : a = hl = filter fd, ix = filter fdstruct*, carry reset
   ;         hl = -1, carry set for error

.asmentry

   ; 1a. get connected fdstruct
   ;
   ;  l = fd
   ; bc = void *init
   ; de = void *filter_driver

   push bc                     ; save void *init

   call stdio_fdcommon1        ; ix = connected fdstruct*
   jp c, stdio_error_ebadf_mc - 1  ; bad fd
   
   ; 1b. we dont filter duped fds
   ;
   ; de = void *filter_driver
   ; ix = connected fdstruct*
   ; stack = void *init

.loop

   bit 7,(ix+3)                ; is this a dup fdstruct?
   jr z, not_dup

   call stdio_descendchain     ; ix = next fdstruct in stdio chain
   jp loop

.not_dup
   
   ; 2. find an available fd slot for filter fd
   ;
   ; de = void *filter_driver
   ; ix = connected fdstruct*
   ; stack = void *init
   
   call stdio_findfdslot
   jp c, stdio_error_enfile_mc - 1  ; no slot available
   
   ; 3. malloc an fdstruct for the filter fd and initialize it
   ; 
   ;  b = STDIO_NUMFD - fd
   ; hl = MSB of fdtbl entry
   ; de = void *filter_driver
   ; ix = connected fdstruct*
   ; stack = void *init
   
   push de
   exx
   pop hl                      ; hl = void *filter_driver
   
   dec hl
   dec hl
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = extra bytes for filter driver
   inc hl
   
   push hl                     ; save void *filter_driver
   
   ld hl,STDIO_SIZEOF_FILTER
   add hl,bc
   ld c,l
   ld b,h                      ; bc = total size of filter fdstruct

   call stdio_malloc           ; hl = filter fdstruct*
   pop de                      ; de = void *filter_driver
   jp nc, stdio_error_enomem_mc - 1  ; insufficent memory
   
   push hl                     ; save filter fdstruct*
   
   ld (hl),205                 ; CALL instruction
   inc hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; write filter driver address
   inc hl
   
   ld a,(ix+3)                 ; connected fdstruct flags
   and $07
   or $40
   ld (hl),a                   ; copy them, setting filter flag
   inc hl
   
   ld (hl),1                   ; reference count
   inc hl
   
   ld (hl),195                 ; JP instruction
   inc hl
   
   ld a,ixl
   ld (hl),a
   inc hl
   ld a,ixh
   ld (hl),a                   ; write connected fdstruct
   
   ; 4. increase reference count of connected fd
   ;
   ;  b' = STDIO_NUMFD - fd
   ; hl' = MSB of fdtbl entry
   ; ix  = connected fdstruct*
   ; stack = void *init, filter fdstruct*
   
   inc (ix+4)
   
   ; 5. send open message to filter driver
   ;
   ;  b' = STDIO_NUMFD - fd
   ; hl' = MSB of fdtbl entry
   ; stack = void *init, filter fdstruct*

   pop ix                      ; ix = filter fdstruct*
   
   pop de                      ; de = void *init
   ld c,(ix+3)                 ; c = mode flags
   ld a,STDIO_MSG_OPEN
   call l_jpix                 ; send open message to filter driver
   jr c, filter_error          ; filter driver returned error
   
   ; 6. enter filter fd in fdtbl
   ;
   ;  b' = STDIO_NUMFD - fd
   ; hl' = MSB of fdtbl entry
   ; ix  = filter fdstruct*

   exx
   
   ld a,ixh
   ld (hl),a
   dec hl
   ld a,ixl
   ld (hl),a
   
   ; 7. exit success
   
   ld a,STDIO_NUMFD
   sub b
   ld l,a
   ld h,0                      ; hl = filter fd
   ret

   ; 8. filter error
   ;
   ; ix = filter fdstruct*
   
.filter_error

   ld e,(ix+6)
   ld d,(ix+7)                 ; de = connected fdstruct
   
   ld hl,4
   add hl,de
   dec (hl)                    ; decrease connected fdstruct reference count
   
   push ix
   pop hl
   
   call stdio_free
   jp stdio_error_mc

defc ASMDISP_FILTER_CALLEE = # asmentry - filter_callee
