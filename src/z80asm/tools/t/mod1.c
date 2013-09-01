#include "mod1.h"
#include <stdio.h>
#include <glib.h>

void init_1(void)
{
	printf("init_1()\n");
}

void fini_1(void)
{
	printf("fini_1()\n");
}

void struct_Module1_init(struct Module1 *self)
{
	self->name = g_strdup("module 1 calling");
	printf("Module1 init %s\n", self->name);
}

void struct_Module1_fini(struct Module1 *self)
{
	printf("Module1 fini %s\n", self->name);
	g_free(self->name);
}


