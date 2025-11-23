#ifndef _OPTION_H
#define _OPTION_H

#define OPT_TYPE_EXACT    0
#define OPT_TYPE_LEADING  1

typedef unsigned int (*optfunc_t)(void);

struct opt
{
   unsigned char *name;
   unsigned char type;
   optfunc_t action;
};

#define OPT_ACTION_OK     0

extern unsigned char option_unsigned_number(unsigned char *p, unsigned int *res);

extern unsigned int option_exec_cd(void);
extern unsigned int option_exec_cwd(void);
extern unsigned int option_exec_question(void);
extern unsigned int option_exec_path(void);

#endif
