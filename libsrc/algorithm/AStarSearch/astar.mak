
ASTAR_CFILES := $(notdir $(wildcard algorithm/AStarSearch/*.c))
ASTAR_AFILES := $(notdir $(wildcard algorithm/AStarSearch/*.asm))


ASTAR_OBJECTS := $(ASTAR_CFILES:.c=.o) $(ASTAR_AFILES:.asm=.o)

ASTAR_OBJS := $(addprefix algorithm/AStarSearch/obj/z80/, $(ASTAR_OBJECTS)) \
	$(addprefix algorithm/AStarSearch/obj/r2ka/,$(ASTAR_OBJECTS)) \
	$(addprefix algorithm/AStarSearch/obj/r4k/,$(ASTAR_OBJECTS)) \
	$(addprefix algorithm/AStarSearch/obj/ixiy/,$(ASTAR_OBJECTS)) \
	$(addprefix algorithm/AStarSearch/obj/z80n/,$(ASTAR_OBJECTS)) \
	$(addprefix algorithm/AStarSearch/obj/z180/,$(ASTAR_OBJECTS)) \
	$(addprefix algorithm/AStarSearch/obj/ez80_z80/,$(ASTAR_OBJECTS))  \
	$(addprefix algorithm/AStarSearch/obj/kc160/,$(ASTAR_OBJECTS)) 


OBJS += $(ASTAR_OBJS) 
CLEAN += algorithm-astar-clean

algorithm-astar: $(ASTAR_OBJS) $(ASTAR_NEWLIB_TARGETS)

.PHONY: algorithm-start algorithm-astar-clean

$(eval $(call buildbit,algorithm/AStarSearch,z80,test))
$(eval $(call buildbit,algorithm/AStarSearch,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,algorithm/AStarSearch,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,algorithm/AStarSearch,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,algorithm/AStarSearch,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,algorithm/AStarSearch,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,algorithm/AStarSearch,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,algorithm/AStarSearch,kc160,test,-clib=kc160,-mkc160))


algorithm/AStarSearch/obj/%:
	@mkdir -p $@

algorithm-astar-clean:
	$(RM) -fr algorithm/AStarSearch/obj algorithm/AStarSearch/*.o
