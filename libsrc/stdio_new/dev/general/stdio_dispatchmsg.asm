; stdio_dispatchmsg
; 08.2009 aralbrec

PUBLIC stdio_dispatchmsg

; Structure of a typical device driver message dispatcher:
;
; // enter : a = STDIO_MSG_*
; //        bc, de, hl = possibly contain message parameters
; //        MUST NOT ALTER IX, EXX
; //        on stack : ret, file structure
; 
; .device_msginterpretter
;
;    ex (sp),ix                // ix = device driver file structure
;
;    // optional direct jumps for specific messages to speed some things up
;
;    cp STDIO_MSG_GETC
;    jp z, device_getc
;
;    cp STDIO_MSG_PUTC
;    jp z, device_putc
;
;    cp STDIO_MSG_FERR
;    jp z, device_ferr
;
;    // optional return error for messages ignored by device driver
;    // this may be something like socket messages to a disk device
;    // catching them here can mean a shorter message jump table
;
;    cp STDIO_MSG_SOCKET
;    jp nc, dev_error_ensup_mc   // select to set errno appropriately
;
;    // now call this subroutine (stdio_dispatch_msg) to jump to the
;    // correct message function handler
;
;    push hl                   // save possible message parameter
;    ld hl,device_msgfunctbl   // table of message function addresses for this driver
;    jp stdio_dispatchmsg
;
; All device driver message functions must terminate with "pop ix; ret"

.stdio_dispatchmsg

   add a,a                     ; a = STDIO_MSG_* times two
   add a,l
   ld l,a
   jp nc, noinc
   inc h

.noinc                         ; hl = address of message function

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = function address
   
   ex (sp),hl                  ; hl = message parameter
   ret                         ; jump to function address
