

#define ANSI_STDIO
#define STDIO_ASM
#include <stdio.h>



#ifdef __8080__
int fwrite(void *ptr, size_t size, size_t nmemb, FILE *fp) {
    if ( (fp->flags & (_IOUSE|_IOWRITE|_IOSYSTEM)) == (_IOUSE|_IOWRITE)) {
    unsigned int len = size * nmemb;

    if ( len == 0 ) return 0;

    len = write(fp->desc.fd, ptr, len);
    return (len+1) / size;
    }
    return -1;
}

#else

static int wrapper() __naked
{
#asm
; int fwrite(void *ptr, size_t size, size_t nmemb, FILE *fp) __naked
    GLOBAL _fwrite
fwrite:
_fwrite:
IF __CPU_INTEL__ | __CPU_GBZ80__
    ld      hl,-1
    ret
ELSE
    push    ix    ;save callers
  IF __CPU_RABBIT__
    ld      hl,(sp + 8)     ; size
    ld      c,l
    ld      b,h
    ld      hl,(sp + 6)     ; nmemb
    mul                     ; bc = nmemb * size
    ld      a,c
    or      b
    jp      z,fwrite_exit
    ld      ix,(sp + 4)     ;fp
    ld      hl,(sp + 10)    ;ptr
    ex      de,hl
  ELSE
    ld      ix,0
    add     ix,sp
    ld      hl,(ix+6)       ;nmemb
    ld      de,(ix+8)       ;size
    call    l_mult          ;hl = nmemb * size
    ld      a,h
    or      l
    jp      z,fwrite_exit
    ld      c,l
    ld      b,h
    ld      de,(ix+10)      ;ptr
    ld      hl,(ix+4)       ;fp
    push    hl    
    pop     ix              ;ix = fp
  ENDIF
    ld      hl,0    ;bytes written
    ; Check that we have a non-system reader thats in use
    ld      a,(ix + fp_flags)
    bit     4,a             ; _IOSYSTEM
    jr      nz,fwrite_done
    and     _IOUSE | _IOWRITE
    cp      _IOUSE | _IOWRITE
    jr      nz,fwrite_done
    ; ix = fp
    ; bc = bytes to write
    ; hl = buffer
    call    _fwrite1        ; hl = bytes written
fwrite_done:
    ; hl = bytes read
    ; divide and return
    ex      de,hl
  IF __CPU_RABBIT__ | __CPU_KC160__
    ld      hl,(sp + 8)     ;size
  ELSE
    ld      ix,0
    add     ix,sp
    ld      hl,(ix+8)       ;size
  ENDIF
    call    l_div_u         ;hl = de/hl = bytes_written/size
fwrite_exit:
    pop     ix              ;restore callers
    ret


; (buf, size, fp)
_fwrite1:
    ; ix = fp
    ; bc = size
    ; de = buf
    bit     5,(ix+fp_flags)    ;_IOEXTRA
    jr      z,fwrite_direct
    ; Calling via the extra hook
    ld      hl,(ix+fp_extra)
    ld      a,__STDIO_MSG_WRITE
    jp      l_jphl
fwrite_direct:
    ld      hl,(ix+fp_desc)
    push    hl
    push    de
    push    bc
    call    write
    pop     bc
    pop     bc
    pop     bc
    ret
ENDIF
#endasm
}
#endif
