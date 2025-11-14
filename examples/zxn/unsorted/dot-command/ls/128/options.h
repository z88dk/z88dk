#ifndef _OPTIONS_H
#define _OPTIONS_H

#define OPT_TYPE_EXACT    0
#define OPT_TYPE_LEADING  1

typedef unsigned int (*optfunc_t)(unsigned char *, int, char **);

struct opt
{
   unsigned char *name;
   unsigned char type;
   optfunc_t action;
};

#define OPT_ACTION_OK     0

extern unsigned int option_exec_a(void);
extern unsigned int option_exec_A(void);
extern unsigned int option_exec_B(void);
extern unsigned int option_exec_block_size(unsigned char *idx, int argc, char **argv);
extern unsigned int option_exec_h(void);
extern unsigned int option_exec_si(void);
extern unsigned int option_exec_s(void);
extern unsigned int option_exec_t(void);
extern unsigned int option_exec_gdf(void);
extern unsigned int option_exec_r(void);
extern unsigned int option_exec_S(void);
extern unsigned int option_exec_U(void);
extern unsigned int option_exec_t(void);
extern unsigned int option_exec_X(void);
extern unsigned int option_exec_time_long_iso(void);
extern unsigned int option_exec_time_iso(void);
extern unsigned int option_exec_time_locale(void);
extern unsigned int option_exec_color_never(void);
extern unsigned int option_exec_color_always(void);
extern unsigned int option_exec_F(void);
extern unsigned int option_exec_file_type(void);
extern unsigned int option_exec_indicator_style_none(void);
extern unsigned int option_exec_p(void);
extern unsigned int option_exec_Q(void);
extern unsigned int option_exec_C(void);
extern unsigned int option_exec_x(void);
extern unsigned int option_exec_m(void);
extern unsigned int option_exec_l(void);
extern unsigned int option_exec_one(void);
extern unsigned int option_exec_w(unsigned char *idx, int argc, char **argv);
extern unsigned int option_exec_width(unsigned char *idx, int argc, char **argv);
extern unsigned int option_exec_d(void);
extern unsigned int option_exec_R(void);
extern unsigned int option_exec_system(void);
extern unsigned int option_exec_help(void);
extern unsigned int option_exec_version(void);
extern unsigned int option_exec_lfn_on(void);
extern unsigned int option_exec_lfn_off(void);
extern unsigned int option_exec_lfn_both(void);

#endif
