MATIOROOT = /usr/local/Cellar/libmatio/1.5.2
PROG = read_mat_data
FILE = ~/Desktop/data.mat
CC = gcc
EXT = c
CFLAGS = -Wall -pedantic -I$(MATIOROOT)/include -L$(MATIOROOT)/lib -lmatio

all:
	@$(CC) $(CFLAGS) $(PROG).$(EXT) -o $(PROG)

run:
	@make all
	@./$(PROG) $(FILE)