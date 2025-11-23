#ifndef _CATALOG_H
#define _CATALOG_H

#include <arch/zxn/esxdos.h>

#define CATALOG_MODE_SRC  0
#define CATALOG_MODE_DIR  1

extern unsigned char catalog_control;
extern unsigned char catalog_morethanone;

extern void catalog_add_dir_record(unsigned char *name);
extern void catalog_add_file_records(unsigned char *name);
extern void catalog_add_file_records_from_dir(unsigned char *name);

extern struct esx_lfn lfn;
extern struct esx_cat catalog;

#endif
