



#include "string_tests.h"



void strlcat_fits()
{
    char   buf[20];

    strcpy(buf, "First");

    Assert(strlcat(buf, "Last", sizeof(buf)) == 9, "Should be == 9");
    Assert(strcmp(buf, "FirstLast") == 0, "Incorrect contents");
}

void strlcat_short()
{
    char   buf[8];
    int   ret;

    strcpy(buf, "First");

    Assert(strlcat(buf, "Last", sizeof(buf)) == 9, "Should be == 9");
    Assert(strcmp(buf, "FirstLa") == 0, "Incorrect contents");
}


void strlcat_empty_string()
{
    char   buf[20];

    buf[0] = 0;

    Assert(strlcat(buf, "Last", sizeof(buf)) == 4, "Should be == 4");
    Assert(strcmp(buf, "Last") == 0, "Incorrect contents");
}


/* n == 1 has room only for the NUL already in an empty dst. */
void strlcat_size_one_empty()
{
    char   buf[8];

    buf[0] = 0;
    buf[1] = 'Z';

    Assert(strlcat(buf, "hi", 1) == 2, "Should be == 2");
    Assert(buf[0] == 0, "Empty string was appended");
    Assert(buf[1] == 'Z', "Wrote past the empty string");
}


/* n == 1 and a longer dst: nothing is appended, length is strlen + strlen. */
void strlcat_size_one_full()
{
    char   buf[8];

    buf[0] = 'a';
    buf[1] = 'b';
    buf[2] = 0;
    buf[3] = 'Z';

    Assert(strlcat(buf, "hi", 1) == 4, "Should be == 4");
    Assert(strcmp(buf, "ab") == 0, "Appended into a full buffer");
    Assert(buf[3] == 'Z', "Wrote past the terminator");
}


int test_strlcat()
{

    suite_setup("Strlcat Tests");

    suite_add_test(strlcat_fits);
    suite_add_test(strlcat_short);
    suite_add_test(strlcat_empty_string);
    suite_add_test(strlcat_size_one_empty);
    suite_add_test(strlcat_size_one_full);

    return suite_run();
}

