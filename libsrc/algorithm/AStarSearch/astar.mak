
ASTAR_CFILES = $(notdir $(wildcard algorithm/AStarSearch/*.c))
ASTAR_AFILES = $(notdir $(wildcard algorithm/AStarSearch/*.asm))


ASTAR_OBJECTS = $(ASTAR_CFILES:.c=.o) $(ASTAR_AFILES:.asm=.o)

ASTAR_OBJS = $(addprefix algorithm/AStarSearch/obj/z80/, $(ASTAR_OBJECTS)) $(addprefix algorithm/AStarSearch/obj/r2k/,$(ASTAR_OBJECTS)) $(addprefix algorithm/AStarSearch/obj/ixiy/,$(ASTAR_OBJECTS))  $(addprefix algorithm/AStarSearch/obj/z80n/,$(ASTAR_OBJECTS)) 


OBJS += $(ASTAR_OBJS) 
CLEAN += algorithm-astar-clean

algorithm-astar: $(ASTAR_OBJS) $(ASTAR_NEWLIB_TARGETS)

.PHONY: algorithm-start algorithm-astar-clean

$(eval $(call buildbit,algorithm/AStarSearch,z80,test))
$(eval $(call buildbit,algorithm/AStarSearch,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,algorithm/AStarSearch,r2k,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,algorithm/AStarSearch,z80n,test,-clib=z80n,-mz80n))


algorithm/AStarSearch/obj/%:
	@mkdir -p $@

algorithm-astar-clean:
	$(RM) -fr algorithm/AStarSearch/obj
