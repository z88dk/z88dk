#ifndef _OPTIONS_H
#define _OPTIONS_H

// Data

#define OPT_TYPE_EXACT    0
#define OPT_TYPE_LEADING  1

typedef unsigned int (*optfunc_t)(unsigned char *, unsigned int, char **);

struct opt
{
   unsigned char *name;
   unsigned char type;
   optfunc_t action;
};

#define OPT_ACTION_OK     0

// Option sort

extern int sort_cmp_option(struct opt *a, struct opt *b);
extern int sort_opt_search(unsigned char *name, struct opt *a);

// Options

extern unsigned int option_exec_name(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_name_eq(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_mindepth(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_mindepth_eq(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_maxdepth(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_maxdepth_eq(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_type(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_type_d(void);
extern unsigned int option_exec_type_f(void);
extern unsigned int option_exec_size(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_size_eq(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_mtime(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_mtime_eq(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_mmin(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_mmin_eq(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_exec(void);
extern unsigned int option_exec_prune(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_prune_eq(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_lfn_on(void);
extern unsigned int option_exec_lfn_off(void);
extern unsigned int option_exec_lfn_both(void);
extern unsigned int option_exec_cd(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_cd_eq(unsigned char *i, unsigned int argc, char **argv);
extern unsigned int option_exec_help(void);
extern unsigned int option_exec_version(void);

#endif
