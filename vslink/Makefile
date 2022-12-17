CC=nasm
CFLAGS=-f win64
LD=link
LDFLAGS=/SUBSYSTEM:CONSOLE /NOLOGO /NODEFAULTLIB /ENTRY:"_start" /DYNAMICBASE "kernel32.lib" "user32.lib" /LARGEADDRESSAWARE:NO
SOURCES=main.asm strings.asm utils.asm mainwindow.asm mainloop.asm
OBJECTS=$(SOURCES:.asm=.obj)
EXECUTABLE=asm-winapi-example.exe

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(LD) /OUT:$@ $(LDFLAGS) $(OBJECTS)

.asm.obj:
	$(CC) $(CFLAGS) $< -o $@
