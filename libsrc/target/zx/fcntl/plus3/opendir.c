

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <dirent.h>



#define DIR_CACHE_SIZE 4

// This is never exposed out of the library
struct DIR {
    char     wildcard[17];
    uint8_t  buf_posn;
    uint8_t  buf_available;
    uint8_t  count;
    uint8_t  buffer[DIR_CACHE_SIZE+1][13];
};

static int getmore(DIR *dir);
static int readblock(void *ptr) __z88dk_fastcall __naked;

const char wildcard[] = "*.*\xff";


extern DIR mydir;


DIR * opendir (const char *dirname)
{
   DIR *dir = &mydir;

   strcpy(dir->wildcard, dirname);
   strcat(dir->wildcard, wildcard);
   memset(dir->buffer, 0, sizeof(dir->buffer));
   dir->count = 0;
   dir->buf_available = DIR_CACHE_SIZE; // Fake a number
   getmore(dir);
   return dir;
}

struct dirent *readdir(DIR *dir)
{
   static struct dirent dirent;

again:
   if ( dir->buf_posn <= dir->buf_available ) {
       // Populate the dirent
       uint8_t *entry = (uint8_t *)dir->buffer[dir->buf_posn++];
       uint8_t *ptr = (uint8_t *)&dirent.d_name[0];
       int i;
     
       for ( i = 0; i < 11; i++ ) {
           uint8_t c = entry[i];
           if ( c  == ' ' )
               continue;
           if ( i == 8 ) *ptr++ = '.';
           *ptr++ = c & 127;
       }
       *ptr = 0;
       dirent.d_ino = dir->count++;
       return &dirent;
   } 
   if ( getmore(dir) == 0 ) return NULL;
   goto again;
}

int closedir(DIR *dir)
{
    return 0;
}

static int getmore(DIR *dir)
{
    // Copy the last directory entry into the first position
    if ( dir->buf_available != DIR_CACHE_SIZE ) return 0;
    memcpy(&dir->buffer[0], &dir->buffer[DIR_CACHE_SIZE - 1], 13);
    dir->buf_posn = 1;
    dir->buf_available = readblock(dir);
    return dir->buf_available;
}

static int readblock(void *ptr) __z88dk_fastcall __naked
{
#asm
	INCLUDE	"target/zx/def/p3dos.def"
        EXTERN  dodos
getmore:
	; hl = DIR
        push    ix      ;save callers
	ld	d,h	;de = filename
	ld	e,l
	ld	bc,20
	add	hl,bc	;Points to buffer
        ex      de,hl
	ld	b,DIR_CACHE_SIZE + 1	; number of entries in the buffer
	ld	c,1		; include system files
	ld	iy, DOS_CATALOG
	call	dodos
        pop     ix
        ld      hl,0
        ret     nc      ;Dos error
        ld      l,b
        dec     l
        ret
SECTION bss_driver
_mydir:	defs	85
#endasm
}
