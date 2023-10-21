

#define ANSI_STDIO
#define STDIO_ASM
#include <stdio.h>

#ifdef __8080__
int fread(void *ptr, size_t size, size_t nmemb, FILE *fp) {
    if ( (fp->flags & (_IOUSE|_IOREAD|_IOSYSTEM)) == (_IOUSE|_IOREAD)) {
        unsigned int len = size * nmemb;

        if ( len == 0 ) return len;
#ifdef STDIO_BINARY
        unsigned int r;

        while ( len ) {
            unsigned char c = fgetc(fp);
            if ( c == EOF ) break;
            *(unsigned char *)ptr++ = c;
            r++;
        }
        return r / size;
#else
        unsigned int c = fgetc(fp);

        if ( c != EOF ) {
            *(unsigned char *)ptr = c;
            --len;
            len = read(fp->desc.fd, ptr+1, len);
            return (len+1) / size;
        }
#endif

    }
    return -1;
}

#else

static int wrapper() __naked
{
#asm
; int fread(void *ptr, size_t size, size_t nmemb, FILE *fp) __naked
    GLOBAL _fread
fread:
_fread:
IF __CPU_GBZ80__
    ld      hl,-1
    ld      d,h
    ld      e,l
    ret
ELSE
    push    ix          ;save callers
IF __CPU_RABBIT__
    ld      hl,(sp + 8) ; size
    ld      c,l
    ld      b,h
    ld      hl,(sp + 6) ; nmemb
    mul                 ; bc = nmemb * size
    ld      a,c
    or      b
    jp      z,fread_exit
    ld      ix,(sp + 4) ;fp
    ld      hl,(sp + 10) ;ptr
ELSE
    ld      ix,0
    add    ix,sp
    ld      hl,(ix+6)   ;nmemb
    ld      de,(ix+8)   ;size
    call    l_mult      ;hl = nmemb * size
    ld      a,h
    or      l
    jp      z,fread_exit
    ld      c,l
    ld      b,h
    ld      hl,(ix+10)  ;ptr
    ld      de,(ix+4)   ;fp
    push    de    
    pop     ix          ;ix = fp
ENDIF
    ld      de,0        ;bytes read
    ; Check that we have a non-system reader thats in use
    ld      a,(ix + fp_flags)
    bit     4,a         ; _IOSYSTEM
    jr      nz,read_byte_done
    and     _IOUSE | _IOREAD
    cp       _IOUSE | _IOREAD
    jr      nz,read_byte_done
#ifdef __STDIO_BINARY
    bit    6,(ix + fp_flags)    ; _IOTEXT
    jp    z,fread_block
    ; Text mode, read byte byte
    ; ix = fp
    ; hl = ptr
    ; bc = count
    ; de = bytes read
read_byte_loop:
    push    hl
    push    de
    push    bc
    push    ix
    call    fgetc       ;NB: preserves ix
    pop     bc          ;so dont need ot explicitly pop it
    pop     bc          ;bc= remaining
    pop     de          ;de= count
    ld      a,l
    inc     h
    pop     hl
    jr      z,read_byte_done
    ; It wasnt EOF, carry on
    ld      (hl),a
    inc     de
    inc     hl
    dec     bc
    ld      a,b
    or      c
    jr      nz,read_byte_loop
#else
    jr      fread_block
#endif
read_byte_done:
    ; de = bytes read
    ; divide and return
IF __CPU_RABBIT__ | __CPU_KC160__
    ld      hl,(sp + 8) ;size
ELSE
    ld      ix,0
    add    ix,sp
    ld      hl,(ix+8)   ;size
ENDIF
    call    l_div_u     ;hl = de/hl = bytes_read/size
fread_exit:
    pop     ix          ;restore callers
    ret

fread_block:
    ; Read from a file using blocks    
    ; Pick up any ungot character
    push    hl
    push    de
    push    bc
    push    ix
    call    fgetc       ;preserves ix
    pop     bc
    pop     bc
    pop     de
    ld      a,l
    inc     h
    pop     hl
    jr      z,read_byte_done
    ld      (hl),a      ;save byte
    inc     hl
    inc     de
    dec     bc

    ; Now call fread1 directly
    ex      de,hl       ; de = buf
                        ; bc = bytes to read
                        ; ix = fp
    call    fread1      ; hl = bytes read
    inc     hl
    ex      de,hl
    jr      read_byte_done

fread1:
    bit     5,(ix+fp_flags)    ; _IOEXTRA
    jr      z,fread_direct
    ; Calling via the extra hook
    ld      hl,(ix+fp_extra)
    ld      a,__STDIO_MSG_READ
    jp      l_jphl
fread_direct:
    ld      hl,(ix+fp_desc)
    push    hl
    push    de
    push    bc
    call    read
    pop     bc
    pop     bc
    pop     bc
    ret
ENDIF
#endasm
}
#endif
