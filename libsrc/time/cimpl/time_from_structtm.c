// Function to call a target dependent routine that partially populates
// a struct tm

#include <time.h>

extern int __LIB__ target_read_structtm(struct tm *) __z88dk_fastcall;

time_t time_from_structtm(time_t *ptr)
{
    static struct tm tm;
    time_t result;

    if ( target_read_structtm(&tm) == 0 ) return 0;

    result = mktime(&tm);

    if ( ptr ) *ptr = result;
    return result;
}
