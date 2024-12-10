CC=gcc

CFLAGS=-Wall -Wextra -g -I./include

SRCDIR=src
OBJDIR=obj
INCLUDEDIR=include

SRC=$(wildcard $(SRCDIR)/*.c)

OBJ=$(SRC:$(SRCDIR)/%.c=$(OBJDIR)/%.o)

TARGET=projetMI4N

$(TARGET): $(OBJ)
	$(CC) $(OBJ) -o $(TARGET)

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(TARGET)

.PHONY: clean