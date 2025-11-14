#ifndef _DATE_H
#define _DATE_H

#include <time.h>

extern struct tm date_tm;

typedef unsigned char *(*datefmtfunc_t)(struct dos_tm *dt);

extern unsigned char *date_fmt_long_iso(struct dos_tm *dt);
extern unsigned char *date_fmt_iso(struct dos_tm *dt);
extern unsigned char *date_fmt_locale(struct dos_tm *dt);

#endif
