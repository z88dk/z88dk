#ifndef __TICALC_FCNTL_H__
#define __TICALC_FCNTL_H__

#define ARCHIVE_MAX 0x8000
#define ARCHIVE_MIN 0x4000

#include <fcntl.h>

typedef struct {
    union {
        struct {
            unsigned int offset;
            unsigned char page;
            unsigned char nothing2;
        };
        unsigned long ref;
    };
    unsigned char open;
    unsigned int position;
    unsigned int size;
    mode_t mode;
} TIFILE;

#define MIN_FD 3
#define MAX_FILES 20

extern TIFILE _ti_opened_files[MAX_FILES];
extern unsigned char _ti_files_initialized;

unsigned char _ti_insert_mem(void* dst, unsigned int length);
long _ti_chk_find_sym(char *name) __FASTCALL__ __naked;

#endif
