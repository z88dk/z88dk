#ifndef _OPTIONS_H
#define _OPTIONS_H

#define OPT_TYPE_EXACT    0
#define OPT_TYPE_LEADING  1

#define OPT_ACTION_OK     0


typedef unsigned int (*optfunc)(unsigned char *, int, char **);

struct opt
{
   unsigned char *name;
   unsigned char type;
	optfunc action;
};

extern unsigned int option_exec_b(void);
extern unsigned int option_exec_f(void);
extern unsigned int option_exec_i(void);
extern unsigned int option_exec_n(void);
extern unsigned int option_exec_strip_slashes(void);
extern unsigned int option_exec_S(unsigned char *idx, int argc, char **argv);
extern unsigned int option_exec_suffix(unsigned char *idx, int argc, char **argv);
extern unsigned int option_exec_t(unsigned char *idx, int argc, char **argv);
extern unsigned int option_exec_target_directory(unsigned char *idx, int argc, char **argv);
extern unsigned int option_exec_T(void);
extern unsigned int option_exec_u(void);
extern unsigned int option_exec_v(void);
extern unsigned int option_exec_help(void);
extern unsigned int option_exec_version(void);
extern unsigned int option_exec_system(void);

#endif
