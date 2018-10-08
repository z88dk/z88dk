#ifndef _LS_H
#define _LS_H

#include <stdint.h>
#include <arch/zxn/esxdos.h>

#include "date.h"
#include "sort.h"

#define FLAG_FILE_FILTER_DOT         0
#define FLAG_FILE_FILTER_ALL         1
#define FLAG_FILE_FILTER_ALMOST_ALL  2
#define FLAG_FILE_FILTER_BACKUP      4

#define FLAG_SIZE_TYPE_NONE          0
#define FLAG_SIZE_TYPE_DIVIDER       1
#define FLAG_SIZE_TYPE_HUMAN         2
#define FLAG_SIZE_TYPE_SI            3

#define FLAG_SORT_MOD_NONE           0
#define FLAG_SORT_MOD_GDF            1
#define FLAG_SORT_MOD_REVERSE        2

#define FLAG_NAME_FMT_MOD_NONE       0
#define FLAG_NAME_FMT_MOD_COLOR      1
#define FLAG_NAME_FMT_MOD_QUOTE      2
#define FLAG_NAME_FMT_MOD_LFN        4
#define FLAG_NAME_FMT_MOD_SFN        8
#define FLAG_NAME_FMT_MOD_AUTO       16

#define FLAG_NAME_FMT_CLASSIFY_NONE  0
#define FLAG_NAME_FMT_CLASSIFY_DIR   1
#define FLAG_NAME_FMT_CLASSIFY_EXE   2
#define FLAG_NAME_FMT_CLASSIFY_ALL   3

#define FLAG_DISP_FMT_COLUMN         0
#define FLAG_DISP_FMT_ACROSS         1
#define FLAG_DISP_FMT_COMMAS         2
#define FLAG_DISP_FMT_LONG           3
#define FLAG_DISP_FMT_PER_LINE       4

#define FLAG_DIR_TYPE_ENTER          0
#define FLAG_DIR_TYPE_RECURSIVE      1
#define FLAG_DIR_TYPE_LIST           2

struct flag
{
   // exclude some files from listing
   
   unsigned char file_filter;

   // how to display the file size
   
   unsigned char size_type;
   uint32_t size_divisor;
   
   // how to sort the listing
   
   unsigned char sort_mod;
   cmpfilfunc_t sort_func;     // 0 = no sorting
   
   // how to format date and time
   
   datefmtfunc_t date_func;    // 0 = no date-time
   
   // how to print filenames
   
   unsigned char name_fmt_mod;
   unsigned char name_fmt_classify;
   
   // display listing style
   
   unsigned char disp_size;
   unsigned char disp_width;   // 0 = use screen width
   unsigned char disp_fmt;
   
   // how to handle directories
   
   unsigned char sys;          // include system files in listing
   unsigned char dir_type;
   
   // miscellaneous
   
   unsigned char help;
   unsigned char version;
};

extern struct flag flags;

extern uint8_t current_month;
extern int16_t current_year;

extern struct esx_mode screen_mode;
extern unsigned char canonical_active[ESX_FILENAME_LFN_MAX + 1];

extern unsigned char current_drive[];

extern unsigned char *advance_past_drive(unsigned char *p);
extern unsigned char get_drive(unsigned char *p);

extern unsigned char fin;
extern unsigned char gin;

extern void close_open_files(void);

#endif
