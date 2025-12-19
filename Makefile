NAME = libasm.a
CC = gcc
CFLAGS = -Wall -Wextra -Werror -g
AR = ar rcs

# assembler (nasm for intel syntax)
NA = nasm
NA_FLAGS = -f elf64

MANDATORY_SRC = ft_strlen.s\
				ft_strcpy.s\
				ft_strcmp.s\
				ft_write.s\
				ft_read.s\
				ft_strdup.s

MANDATORY_PATH = ./src/

MANDATORY_OBJ	=	$(MANDATORY_SRC:%.s=$(MANDATORY_PATH)%.o)

BONUS_SRC = ft_atoi_base_bonus.s\
			ft_list_push_front_bonus.s\
			ft_list_size_bonus.s\
			ft_list_sort_bonus.s\
			ft_list_remove_if_bonus.s

BONUS_PATH = ./src_bonus/

BONUS_OBJ	=	$(BONUS_SRC:%.s=$(BONUS_PATH)%.o)

all: $(NAME)

show:
	echo $(OBJS_FILES)

$(NAME): $(MANDATORY_OBJ)
	$(AR) $(NAME) $(MANDATORY_OBJ)

bonus: $(MANDATORY_OBJ) $(BONUS_OBJ) 
	$(AR) $(NAME) $(MANDATORY_OBJ) $(BONUS_OBJ)

%.o: %.s
	$(NA) $(NA_FLAGS) $< -o $@

clean:
	rm -rf $(MANDATORY_OBJ) $(BONUS_OBJ)

fclean: clean
	rm -rf $(NAME)

re:
	$(MAKE) fclean
	$(MAKE) all

.PHONY: all clean fclean re