
#include <fcntl.h>
#include <stdio.h>


static int aq_seek(int fd, long posn) __smallc __naked
{
#asm
    INCLUDE "fcntl.def"
    ld      a,ESPCMD_SEEK
    call    __esp_send_cmd
    ld      hl,sp+6
    ld      a,(hl)
    call    __esp_send_byte
    ld      hl,sp+2
    ld      bc,4
    call    __esp_send_bytes
    call    __esp_read_byte
    ld      l,a
    ld      h,0
    ret
#endasm
}



long  lseek(int fd,long posn, int whence) __smallc
{
    switch ( (uint8_t)whence ) {
    case SEEK_SET:
        break;
    case SEEK_CUR:
        posn += fdtell(fd);
        break;
    case SEEK_END:
        return -1;          // Not supported
        break;
    }

    if (aq_seek(fd, posn) == 0 ) {
        return fdtell(fd);
    }
    return -1L;
}
