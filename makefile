include config.mk

# Compiler : gcc, g++, ...
CC=gdc
# Extension
EXT=.d
# Library flags : -lgl, -lpthread, ...
LDFLAGS=
# Debug flags
DEBUG_FLAGS= -DDEBUG=1 -W -Wall -ansi -pedantic -g
# Other flags
FLAGS= 

INCLUDE_DIR=include
SOURCE_DIR=src


SRCS=\
hibernate.d \
simple_power_manager.d


################################################################
#
################################################################

ifeq (${DEBUG},1)
	FLAGS+=${DEBUG_FLAGS}
endif
FLAGS+= -I ${INCLUDE_DIR}
OBJS=${SRCS:${EXT}=.o}

all: hibernate simple-power-manager

hibernate: hibernate.o
	${CC} -o $@ hibernate.o ${LDFLAGS} ${FLAGS}

simple-power-manager: simple_power_manager.o
	${CC} -o $@ simple_power_manager.o ${LDFLAGS} ${FLAGS}

%.o: ${SOURCE_DIR}/%${EXT}
	${CC} -o $@ -c $< ${FLAGS}

install: hibernate simple-power-manager
	@echo  installing executable file to ${PREFIX}/bin
	@mkdir -p ${PREFIX}/bin
	@cp -f hibernate ${PREFIX}/bin/hibernate
	@chown root:root ${PREFIX}/bin/hibernate
	@chmod 4755 ${PREFIX}/bin/hibernate
	@cp -f simple-power-manager ${PREFIX}/bin/simple-power-manager
	@chmod 755 ${PREFIX}/bin/simple-power-manager

mrproper:
	rm -rf *.o *~ \#*\# hibernate simple-power-manager

clean:
	rm -rf *.o
