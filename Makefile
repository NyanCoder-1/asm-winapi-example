CC=nasm
CFLAGS=-f win64
LD=golink
LDFLAGS=/entry:_start /console kernel32.dll user32.dll
SOURCES=strings.asm main.asm mainwindow.asm mainloop.asm utils.asm
OBJECTS=$(SOURCES:.asm=.obj)
EXECUTABLE=asm-winapi-example.exe

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(LD) $(LDFLAGS) $(OBJECTS) /fo $@

.asm.obj:
	$(CC) $(CFLAGS) $< -o $@
