

#ifndef TEST_H
#define TEST_H


#ifndef MAX_TESTS
#define MAX_TESTS 50
#endif

#define Assert(r,m) Assert_real((r), __FILE__, __LINE__, (m))
#define assertEqual(a,b) Assert_real((a) == (b),  __FILE__, __LINE__, #a  "== "  #b)
#define assertNotEqual(a,b) Assert_real((a) != (b),  __FILE__, __LINE__, #a  "!= "  #b)
extern void         Assert_real(int result, char *file, int line,  char *message);


extern int          suite_run();
extern void         suite_setup(char *suitename);
extern void         suite_add_fixture(void (*setup)(), void (*teardown)());
#define suite_add_test(f) suite_add_test_real("" # f "", f)
extern void         suite_add_test_real(char *testname, void (*test)());


#endif
