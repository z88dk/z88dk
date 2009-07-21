

#ifndef TEST_H
#define TEST_H

#define MAX_TESTS 300

#define Assert(r,m) Assert_real((r), __FILE__, __LINE__, (m))
extern void         Assert_real(int result, char *file, int line,  char *message);


extern int          suite_run();
extern void         suite_setup(char *suitename);
#define suite_add_test(f) suite_add_test_real("" # f "", f)
extern void         suite_add_test_real(char *testname, void (*test)());


#endif
