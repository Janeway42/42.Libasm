NAME = libasm
CFLAGS	= -Wall -Werror -Wextra -g #-fsanitize=address

MANDATORY_SRC = ft_strlen.s\
				ft_strcpy.s\
				ft_strcmp.s\
				ft_write.s\
				ft_read.s\
				ft_strdup.s\

MANDATORY_PATH = src/

MANDATORY_OBJ	=	$(MANDATORY_SRC:%.c=$(MANDATORY_PATH)%.o)

BONUS_SRC = ft_atoi_base.s\
			ft_list-push_front.s\
			ft-list_size.s\
			ft_list_sort.s\
			ft-list_remove.s\

BONUS_PATH = src_bonus/

BONUS_OBJ	=	$(BONUS_SRC:%.c=$(BONUS_PATH)%.o)


all: $(NAME)

# Generate list.inc from list.h
# -dM tells the preprocessor to dump all macros it knows, instead of compiling it just prints out the #define lines 
# -E run only the preprocessor stage (no compiling, no assembling). You get the preprocessor output
# $< = the first prerequisite (here is the input file: list.h)
# > $@ redirects the result into the target file (here list.inc). The filtered macros are written into list.inc
#
list.inc: list.h
	$(CC) -dM -E $< | grep '^#define LIST'_ > $@

$(NAME): $(MANDATORY_OBJ)
	ar -rcs $@ $^

bonus: $(MANDATORY_OBJ) $(BONUS_OBJ)
	ar -rcs $(NAME) $(MANDATORY_OBJ) $(BONUS_OBJ)

%.o: %.c $(HEADER_FILES)
	$(CC) -c $(CFLAGS) -o $@ $< -fPIC

so : $(MANDATORY_OBJ)
	$(CC) $(MANDATORY_OBJ) $(BONUS_OBJ) -shared -o libasm.so

clean:
	$(RM) *.o

fclean: clean
	$(RM) $(NAME) list.inc

re:
	$(MAKE) fclean
	$(MAKE) all

.PHONY: all clean fclean re