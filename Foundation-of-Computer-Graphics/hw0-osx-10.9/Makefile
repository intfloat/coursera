CC = g++
ifeq ($(shell sw_vers 2>/dev/null | grep Mac | awk '{ print $$2}'),Mac)
	CFLAGS = -g -DGL_GLEXT_PROTOTYPES -I./include/ -I/usr/X11/include -DOSX
	LDFLAGS = -framework GLUT -framework OpenGL -L./lib/mac/ \
    	-L"/System/Library/Frameworks/OpenGL.framework/Libraries" \
    	-lGL -lGLU -lm -lstdc++ -lGLEW -lfreeimage 
else
	CFLAGS = -g -DGL_GLEXT_PROTOTYPES -I./include/ -I/usr/X11R6/include -I/sw/include \
					 -I/usr/sww/include -I/usr/sww/pkg/Mesa/include
	LDFLAGS = -L./lib/nix -L/usr/X11R6/lib -L/sw/lib -L/usr/sww/lib \
						-L/usr/sww/bin -L/usr/sww/pkg/Mesa/lib -lglut -lGLU -lGL -lX11 -lGLEW -lfreeimage
endif
	
RM = /bin/rm -f 

all: mytest3
mytest3: mytest3.o shaders.o shaders.h geometry3.h
	$(CC) $(CFLAGS) -o mytest3 shaders.o mytest3.o $(INCFLAGS) $(LDFLAGS) 
mytest3.o: mytest3.cpp shaders.h geometry3.h
	$(CC) $(CFLAGS) $(INCFLAGS) -c mytest3.cpp
shaders.o: shaders.cpp
	$(CC) $(CFLAGS) $(INCFLAGS) -c shaders.cpp
clean: 
	$(RM) *.o mytest3 *.png


 
