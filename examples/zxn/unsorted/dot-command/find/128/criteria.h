#ifndef _CRITERIA_H
#define _CRITERIA_H

#include <adt/p_forward_list_alt.h>

// Data

struct criteria
{
   struct criteria *next;          // link field needed by p_forward_list
   unsigned char (*func)(unsigned char *);  // criteria function
   unsigned char data[1];          // optional additional data
};

extern p_forward_list_alt_t criteria_list;

// Functions

extern void criteria_clear_list(void);
extern void criteria_add_list(unsigned char (*func)(void));
extern void criteria_add_list_long(unsigned char (*func)(int32_t *), const int32_t *num);
extern void criteria_add_list_string(unsigned char (*func)(unsigned char *), const char *s);
extern unsigned char criteria_apply(void);

// Criteria

extern unsigned char criteria_exec(void);
extern unsigned char criteria_name(unsigned char *pattern);
extern unsigned char criteria_size(int32_t *multiplier);
extern unsigned char criteria_type_d(void);
extern unsigned char criteria_type_f(void);

#endif
