
#ifndef OPTION_H
#define OPTION_H

#include <sys/types.h>

#define OPT_BOOL         1
#define OPT_BOOL_FALSE   2
#define OPT_INT          4
#define OPT_STRING       8
#define OPT_ASSIGN       16
#define OPT_OR           32
#define OPT_FUNCTION     64
#define OPT_HEADER       128
#define OPT_DEPRECATED   256
#define OPT_PRIVATE      256
#define OPT_INCLUDE_OPT  512
#define OPT_DOUBLE_DASH  1024


typedef struct option_s option;

struct option_s {
    const char     short_name;
    const char    *long_name;
    int            type;
    const char    *description;
    void          *value;
    void         (*func)(option *arg, char *val);
    intptr_t       data;
};


int option_parse(option *args, int argc, char **argv);
void option_list(option *cur);


#endif
