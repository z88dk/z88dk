#-----------------------------------------------------------------------------
# Test common utils
# Copyright (C) Paulo Custodio, 2011-2022
# License: http://www.perlfoundation.org/artistic_license_2_0
#-----------------------------------------------------------------------------

include ../Make.common

CC			?= gcc
CFLAGS		+= -Wall -std=gnu11 -MMD \
-I../../ext/uthash/src \
-I../../ext/regex \
-I../../ext/optparse 

SRCS 		:= \
$(wildcard *.c) \
$(wildcard t/*.c) \
$(wildcard ../../ext/regex/reg*.c) \
$(wildcard ../../ext/Unity/src/*.c)

OBJS		:= $(SRCS:.c=.o) \
				$(UNIXem_OBJS)

# -DUNITY_EXCLUDE_SETJMP_H for compilation in Linux
CFLAGS		+= -DUNITY_EXCLUDE_SETJMP_H -I. -I../../ext/Unity/src \
				$(UNIXem_CFLAGS)

DEPENDS		:= $(SRCS:.c=.d)

all: t/test$(EXESUFFIX)

t/test$(EXESUFFIX): $(OBJS)
	$(CC) $(CFLAGS) -o t/test$(EXESUFFIX) $(OBJS) $(LDFLAGS)

t/test.o: t/test.c t/test1.hh t/test2.hh

t/test1.hh: $(wildcard t/*.c) Makefile
	@grep -h -i '^void run_[a-z0-9_]*(void)' t/*.c | sed -e 's/void run_\([a-z0-9_]*\).*/if (strcmp(argv[1],"\1") == 0) { extern void run_\1(void); run_\1(); exit(0); } else/' > t/test1.hh
	@echo Built t/test1.hh

t/test2.hh: $(wildcard t/*.c) Makefile
	@grep -h -i '^void t_[a-z0-9_]*(void)' t/*.c | sed -e 's/void \(t_[a-z0-9_]*\).*/extern void \1(void); RUN_TEST(\1);/' > t/test2.hh
	@echo Built t/test2.hh

test: t/test$(EXESUFFIX)
	t/test$(EXESUFFIX)
	t/run_tests.sh

clean:
	$(RM) t/test$(EXESUFFIX) $(OBJS) $(DEPENDS)

-include $(DEPENDS)
