/* Every module writes __fp_mode, whatever it declares (check_fpkinds.sh compiles it
 * with each -D), so that each float is read in the format of its own module */
#include <stdlib.h>                     /* declares atof() and strtod() */
#ifdef GLOBAL
float k_f;
#endif
#ifdef FILE_STATIC
static float k_f;
int *k_use(void) { return (int *)&k_f; }
#endif
#ifdef ARRAY
float k_arr[2];
#endif
#ifdef POINTER
float *k_ptr;
#endif
#ifdef MEMBER
struct k_in { int i; float f; };
struct k_out { int i; struct k_in in; } k_st;
#endif
#ifdef LOCAL
int k_fn(void) { float t; t = 0; return sizeof(t); }
#endif
#ifdef LOCAL_STATIC
int k_fn(void) { static float t; return sizeof(t); }
#endif
#ifdef PARAM
int k_fn(float a) { return sizeof(a); }
#endif
#ifdef RETURN
float k_fn(void) { return 0; }
#endif
#ifdef EXTERN
extern float k_ext;
int *k_use(void) { return (int *)&k_ext; }
#endif
#ifdef PROTOTYPE
float k_proto(float a);
#endif
#ifdef SELF_POINTER
struct k_node { struct k_node *next; int v; } k_list;
#endif
#ifdef NESTED_PTR
struct k_pay { float v; };
struct k_node { struct k_node *next; struct k_pay *p; } k_head;
#endif
#ifdef PTR_ARRAY
struct k_pay { float v; };
struct k_box { struct k_pay *items[4]; } k_box;
#endif
int k_int;
