PROGRAM = shef_decode
XDIR = /usr/lib/X11
XLIBDIR = $(XDIR)
CFLAGS = -I$(XDIR)/include  
HEADERS1 = shef.h
LOCAL_LIB = ./lib/shef.lib.a
#CC = cc -c -Aa
CC = gcc -c -g

LINK = gcc -o 

#LIBS = $(XLIBDIR)/Xm3r.lib $(XLIBDIR)/Xt3r.lib $(XLIBDIR)/X113r.lib
#LIBFILES = larrow.xbm qmark.xbm quit.xbm rarrow.xbm xcalendar.hlp
#XCALENDAR_LIBDIR = $(XLIBDIR)/X11/$(PROGRAM)
#INSTALLDIR = $(XDIR)

SRC =  parshef.c shef_decode.c shefpass.c  \
       ouptime.c shefopen.c

OBJ =  parshef.o  shef_decode.o shefpass.o  \
       ouptime.o shefopen.o 

all::$(PROGRAM)

parshef.o:		parshef.c
			$(CC) parshef.c

shef_decode.o:		shef_decode.c
			$(CC) shef_decode.c

shefpass.o:		shefpass.c
			$(CC) shefpass.c

ouptime.o:		ouptime.c
			$(CC) ouptime.c

shefopen.o:		shefopen.c
			$(CC) shefopen.c


$(PROGRAM): $(OBJ)
	$(LINK) $(PROGRAM) $(OBJ) $(LOCAL_LIB) 


clean:
	rm $(OBJ) $(PROGRAM)
