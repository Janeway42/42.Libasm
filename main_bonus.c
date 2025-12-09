#include <string.h>
#include <fcntl.h>
#include "libasm_bonus.h"

//declare assembly functions and errno
extern int ft_atoi_base(char *str, char *base)
extern void ft_list_push_front(t_list **begin_list, void *data);
extern void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));
extern int ft_list_size(t_list *begin_list);
extern void ft_list_sort(t_list **begin_list, int (*cmp)());
extern int errno;

typedef struct  s_list
{
    void *data;
    struct s_list *next;
}               t_list;

void *free_fct(void *data)
{
    free(data);
}

int main()
{
    printf("-------------- FT_ATOI_BASE --------------");

    printf("-------------- FT_LIST_PUSH_FRONT --------------");

    printf("-------------- FT_LIST_SIZE --------------");

    printf("-------------- FT_LIST_SORT --------------");

    printf("-------------- FT_LIST_REMOVE_IF --------------");

}