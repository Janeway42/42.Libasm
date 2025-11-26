NAME = libasm
CFLAGS	= -Wall -Werror -Wextra -g #-fsanitize=address

MANDATORY_SRC = 

MANDATORY_PATH = src/

MANDATORY_OBJ	=	$(MANDATORY_SRC:%.c=$(MANDATORY_PATH)%.o)

BONUS_SRC = 

BONUS_PATH = src_bonus/

BONUS_OBJ	=	$(BONUS_SRC:%.c=$(BONUS_PATH)%.o)


all: $(NAME)

$(NAME): $(MANDATORY_OBJ)
	ar -rcs $@ $^

bonus: $(MANDATORY_OBJ) $(BONUS_OBJ)
	ar -rcs $(NAME) $(MANDATORY_OBJ) $(BONUS_OBJ)

%.o: %.c $(HEADER_FILES)
	$(CC) -c $(CFLAGS) -o $@ $< -fPIC

so : $(MANDATORY_OBJ)
	$(CC) $(MANDATORY_OBJ) $(BONUS_OBJ) -shared -o libasm.so

clean:
	$(RM) $(MANDATORY_OBJ) $(BONUS_OBJ)

fclean: clean
	$(RM) $(NAME)

re:
	$(MAKE) fclean
	$(MAKE) all

.PHONY: all clean fclean re