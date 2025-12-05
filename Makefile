NAME = libasm.a
NA = nasm
NA_FLAGS = -f macho64
FLAGS	= -Wall -Werror -Wextra -g #-fsanitize=address

MANDATORY_SRC = ft_strlen.s\
				ft_strcpy.s\
				ft_strcmp.s\
				ft_write.s\
				ft_read.s\
				ft_strdup.s\

MANDATORY_PATH = src/

MANDATORY_OBJ	=	$(MANDATORY_SRC:%.s=$(MANDATORY_PATH)%.o)

BONUS_SRC = ft_atoi_base_bonus.s\
			ft_list_push_front_bonus.s\
			ft_list_size_bonus.s\
			ft_list_sort_bonus.s\
			ft_list_remove_if_bonus.s\

BONUS_PATH = src_bonus/

BONUS_OBJ	=	$(BONUS_SRC:%.s=$(BONUS_PATH)%.o)

all: $(NAME)

show:
	echo $(OBJS_FILES)

$(NAME): $(MANDATORY_OBJ)
	ar rcs $(NAME) $(MANDATORY_OBJ)
	ranlib $(NAME)

bonus: $(MANDATORY_OBJ) $(BONUS_OBJ) 
	ar rcs $(NAME) $(MANDATORY_OBJ) $(BONUS_OBJ)
	ranlib $(NAME)

%.o: %.s
	$(NA) $(NA_FLAGS) $< -o $@

clean:
	rm -rf $(MANDATORY_OBJ) $(BONUS_OBJ)

fclean: clean
	rm -rf $(NAME)

re:
	$(MAKE) fclean
	$(MAKE) all

.PHONY: all bonus clean fclean re