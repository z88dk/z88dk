
#ifndef OPTION_H
#define OPTION_H

#include <sys/types.h>
#include <inttypes.h>

#define OPT_BOOL         1      // Assign the value to true
#define OPT_BOOL_FALSE   2      // Assign the value to false
#define OPT_INT          4      // Assign the value as an integer
#define OPT_STRING       8      // Assign the value as a string
#define OPT_ASSIGN       16     // Assign the value in data
#define OPT_OR           32     // Combine the value with the existing value
#define OPT_FUNCTION     64     // Call func() with the argument
#define OPT_HEADER       128    // Separator
#define OPT_DEPRECATED   256    // Don't show in help
#define OPT_PRIVATE      256    // Don't show in help
#define OPT_INCLUDE_OPT  512    // Pass the full option to the function
#define OPT_DOUBLE_DASH  1024   // Long option needs a -- 
#define OPT_DEFAULT_VALUE 2048  // Default value held in data


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
