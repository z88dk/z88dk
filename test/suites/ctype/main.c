

#include "ctype_test.h"

int main(int argc, char *argv[])
{
    int  res = 0;

#ifdef HAVE_ISXDIGIT
    res += test_isxdigit();
#endif
#ifdef HAVE_ISUPPER  
    res += test_isupper();
#endif
#ifdef HAVE_ISSPACE
    res += test_isspace();
#endif
#ifdef HAVE_ISPUNCT
    res += test_ispunct();
#endif
#ifdef HAVE_ISPRINT
    res += test_isprint();
#endif
#ifdef HAVE_ISLOWER
    res += test_islower();
#endif
#ifdef HAVE_ISGRAPH
    res += test_isgraph();
#endif
#ifdef HAVE_ISDIGIT
    res += test_isdigit();
#endif
#ifdef HAVE_ISCNTRL
    res += test_iscntrl();
#endif
#ifdef HAVE_ISASCII
    res += test_isascii();
#endif
#ifdef HAVE_ISALPHA
    res += test_isalpha();
#endif
#ifdef HAVE_ISALNUM
    res += test_isalnum();
#endif
#ifdef HAVE_ISBDIGIT
    res += test_isbdigit();
#endif
#ifdef HAVE_ISODIGIT
    res += test_isodigit();
#endif

    return res;
}
