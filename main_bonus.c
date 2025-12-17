#include <string.h>
#include <fcntl.h>
#include <stdlib.h>
#include "libasm.h"
#include "libasm_bonus.h"

int compare(void *a, void *b)
{
    // printf("compare: %s, %s\n", (char *)a, (char *)b); 
    return strcmp((char *)a, (char *)b);
}

void free_fct(void *data)
{
    free((t_list *)data); 
}

void free_list(t_list **list)
{
    t_list *temp_list;

    while (*list != NULL)
    {
        temp_list = *list;
        *list = (*list)->next;
        free(temp_list);
        temp_list = NULL;  
    }
}

void print_list(t_list *list)
{
    t_list *temp_list;
    temp_list = list;

    while(temp_list != NULL)
    {
        printf("|%s| ", (char *)temp_list->data);
        temp_list = temp_list->next;
    }

    if (temp_list == NULL)
    {
        printf("|NULL|\n");
    }
}

int main()
{
    t_list *node = NULL;
    t_list *empty_node = NULL;

    printf("\n-------------- FT_ATOI_BASE --------------\n");

    printf("\n-------------- FT_LIST_PUSH_FRONT --------------\n\n");


    printf("List before: ");
    print_list(node);

    ft_list_push_front(&node, "A");
    ft_list_push_front(&node, "D");
    ft_list_push_front(&node, "Z");
    ft_list_push_front(&node, "K");
    ft_list_push_front(&node, "M");

    printf("List after:  ");
    print_list(node);

    printf("\n-------------- FT_LIST_SIZE --------------\n\n");

    int size = ft_list_size(empty_node);
    printf("Size empty list: %d\n", size);

    size = ft_list_size(node);
    printf("Size non empty list: %d\n", size);

    printf("\n-------------- FT_LIST_SORT --------------\n\n");

    ft_list_sort(&empty_node, &compare);
    printf("List after empty list sort:     ");
    print_list(empty_node);

    ft_list_sort(&node, &compare);
    printf("List after non empty list sort: ");
    print_list(node);

    printf("\n-------------- FT_LIST_REMOVE_IF --------------\n\n");

    char *check;

    ft_list_remove_if(&node, &check, &compare, &free_fct);
    printf("List after remove empty pointer data: "); 
    print_list(node);

    ft_list_remove_if(&node, "A", &compare, &free_fct);
    printf("List after removing first node:       "); 
    print_list(node);

    ft_list_push_front(&node, "A");
    ft_list_remove_if(&node, "M", &compare, &free_fct);
    printf("List after removing middle node:      "); 
    print_list(node);

    ft_list_remove_if(&node, "Z", &compare, &free_fct);
    printf("List after removing last node:        "); 
    print_list(node);

    free_list(&node);
}