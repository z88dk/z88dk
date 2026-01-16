
ASTAR_CFILES := $(notdir $(wildcard classic/algorithm/AStarSearch/*.c))
ASTAR_AFILES := $(notdir $(wildcard classic/algorithm/AStarSearch/*.asm))


ASTAR_OBJECTS := $(ASTAR_CFILES:.c=.o) $(ASTAR_AFILES:.asm=.o)

ASTAR_OBJS := $(addprefix classic/algorithm/AStarSearch/obj/z80/, $(ASTAR_OBJECTS)) \
	$(addprefix classic/algorithm/AStarSearch/obj/r2ka/,$(ASTAR_OBJECTS)) \
	$(addprefix classic/algorithm/AStarSearch/obj/r4k/,$(ASTAR_OBJECTS)) \
	$(addprefix classic/algorithm/AStarSearch/obj/ixiy/,$(ASTAR_OBJECTS)) \
	$(addprefix classic/algorithm/AStarSearch/obj/z80n/,$(ASTAR_OBJECTS)) \
	$(addprefix classic/algorithm/AStarSearch/obj/z180/,$(ASTAR_OBJECTS)) \
	$(addprefix classic/algorithm/AStarSearch/obj/ez80_z80/,$(ASTAR_OBJECTS))  \
	$(addprefix classic/algorithm/AStarSearch/obj/kc160/,$(ASTAR_OBJECTS)) 


OBJS += $(ASTAR_OBJS) 
CLEAN += classic-algorithm-astar-clean

classic-algorithm-astar: $(ASTAR_OBJS) $(ASTAR_NEWLIB_TARGETS)

.PHONY: classic-algorithm-start classic-algorithm-astar-clean

$(eval $(call buildbit,classic/algorithm/AStarSearch,z80,test))
$(eval $(call buildbit,classic/algorithm/AStarSearch,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/algorithm/AStarSearch,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,classic/algorithm/AStarSearch,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,classic/algorithm/AStarSearch,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/algorithm/AStarSearch,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/algorithm/AStarSearch,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,classic/algorithm/AStarSearch,kc160,test,-clib=kc160,-mkc160))


classic/algorithm/AStarSearch/obj/%:
	@mkdir -p $@

classic-algorithm-astar-clean:
	$(RM) -fr classic/algorithm/AStarSearch/obj classic/algorithm/AStarSearch/*.o
