/* decl.c */
extern int dodeclare(enum storage_type storage, TAG_SYMBOL *mtag, int is_struct);
extern TAG_SYMBOL *defstruct(char *sname, enum storage_type storage, int is_struct);
extern int get_ident(void);
extern int dummy_idx(int typ, TAG_SYMBOL *otag);
extern void declglb(int typ, enum storage_type storage, TAG_SYMBOL *mtag, TAG_SYMBOL *otag, int is_struct, char sign, char zfar);
extern void declloc(int typ, TAG_SYMBOL *otag, char sign, char locstatic, char zfar);
extern uint32_t CalcArgValue(char type, char ident, enum symbol_flags flags);
extern char *ExpandArgValue(uint32_t, char *buffer, char tagidx);
extern void ptrerror(int ident);
extern int needsub(void);
extern TAG_SYMBOL *GetVarID(struct varid *var,enum storage_type storage);
extern void BitFieldSwallow(void);
extern char *ExpandType(int type, char **sign, char tagidx);
extern int get_type_size(int type, TAG_SYMBOL *otag);
