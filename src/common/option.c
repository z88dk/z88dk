
#include "option.h"

#include <string.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

static void set_option(option *arg, char *value)
{
    if ( arg->type & OPT_ASSIGN ) {
        if ( arg->type & (OPT_BOOL|OPT_INT) ) {
            *(int *)arg->value = arg->data;
        } else if ( arg->type & OPT_STRING ) {
            *(char *)arg->value = arg->data;
        }
    } else if (arg->type & OPT_OR ) {
        *(int *)arg->value |= arg->data;
    } else if ( arg->type & OPT_FUNCTION ) {
        arg->func(arg,value);
    } else if ( arg->type & OPT_BOOL ) {
        int  val = 1;
        if ( value != NULL ) {
            if ( toupper(*value) == 'N' || toupper(*value) == 'F' || *value == '0') {
                val = 0;
            }
        }
        *(int *)arg->value = val;
    } else if ( arg->type & OPT_BOOL_FALSE) {
        *(int *)arg->value = 0;
    } else if ( arg->type & OPT_INT ) {
        char  *end;
        long val;

        val = strtol(value,&end,0);
        if ( end != value ) {
            *(int *)arg->value = val;
        }
    } else if ( arg->type & OPT_STRING ) {
        *(char **)arg->value = value;
    } 
}


int option_parse(option *args, int argc, char **argv)
{
    int    i;
    int    outargc = 0;

    for ( i = 1; i < argc; i++ ) {
        option *myarg;
        if ( argv[i][0] == '-') {
            char   *argstart = argv[i] + 1;
            int     doubledash = 0;

            /* Swallow the second - option */
            if  ( *argstart == '-' ) {
                argstart++;
                doubledash = OPT_DOUBLE_DASH;
            }
            for ( myarg = args ; myarg->description != NULL; myarg++ ) {

                if ( myarg->type & OPT_HEADER ) {
                    continue;
                }
                if ( !doubledash && strlen(argstart) == 1 && *argstart == myarg->short_name ) {
                    char *val = NULL;
                    if ( (myarg->type & (OPT_BOOL|OPT_BOOL_FALSE|OPT_ASSIGN|OPT_OR)) == 0 ) {
                        if ( myarg->type & OPT_INCLUDE_OPT ) {
                            val = argv[i];
                        } else if ( i+1 < argc ) {
                            i++;
                            val = argv[i];
                        } else {
                            fprintf(stderr, "Insufficient number of arguments supplied\n");
                            break;
                         }
                    }
                    set_option(myarg, val);
                    break;
                } else if ((myarg->type & (OPT_BOOL|OPT_BOOL_FALSE|OPT_ASSIGN|OPT_OR) )) {
                    if ( myarg->long_name && strcmp(argstart, myarg->long_name) == 0 && ( (myarg->type&OPT_DOUBLE_DASH) == doubledash)) {
                        set_option(myarg, NULL);
                        break;
                    }
                } else if (myarg->long_name && strncmp(argstart, myarg->long_name, strlen(myarg->long_name)) == 0 && 
                        ( (myarg->type&OPT_DOUBLE_DASH) == doubledash) ) {
                    char  *val = NULL;
                    if ( argstart[strlen(myarg->long_name)] == '=' || argstart[strlen(myarg->long_name)] == ':' ) {
                        val = myarg->type & OPT_INCLUDE_OPT ? argv[i] : argstart + strlen(myarg->long_name) + 1;
                    } else if ( strlen(argstart) > strlen(myarg->long_name) )  {
                         /* Try and take the value after the option (without the = sign) */
                         val = myarg->type & OPT_INCLUDE_OPT ? argv[i] : argstart + strlen(myarg->long_name);
                    } else {
                        /* Otherwise it's the next argument */
                        if ( myarg->type & OPT_INCLUDE_OPT) {
                            val = argv[i];
                        } else if ( myarg->type & OPT_DEFAULT_VALUE ) {
                            val = (char*) myarg->data;
                        } else if ( i+1 < argc ) {
                            i++;
                            val = argv[i];
                        } else {
                            fprintf(stderr, "Insufficient number of arguments supplied\n");
                            break;
                        }
                    }
                    set_option(myarg, val);
                    break;
                }
            }
            if ( myarg->description == NULL ) {
                if ( myarg->long_name == NULL ) {
                    fprintf(stderr, "Unknown option2 %s\n",argv[i]);
                }
                argv[outargc++] = argv[i];
            }
        } else {
            /* Copy unswallowed options */
            argv[outargc++] = argv[i];
        }
    }
    return outargc;
}



void option_list(option *cur)
{
    printf("\nOptions:\n\n");

    while (cur->description) {
        if ( cur->type & OPT_HEADER ) {
            fprintf(stderr,"\n%s\n",cur->description);
        } else if ( !(cur->type & OPT_DEPRECATED) ) {
            char    shortopt[6];
            char    longopt[26];
            shortopt[0] = longopt[0] = 0;;
            if ( cur->short_name ) {
                snprintf(shortopt, sizeof(shortopt),"-%c", cur->short_name);
            }
            if ( cur->long_name ) {
                snprintf(longopt, sizeof(longopt),"-%s%s", cur->type & OPT_DOUBLE_DASH ? "-" : "", cur->long_name);
            }
            fprintf(stderr,"%5s %-25s %s\n",shortopt,longopt,cur->description);
        }
        cur++;
    }
}
