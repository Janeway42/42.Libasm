#include <string.h>
#include <fcntl.h>
#include <stdlib.h>
#include "libasm.h"
#include "libasm_bonus.h"

void *free_fct(void *data)
{
    free(data);
}

void print_list(t_list *node)
{
    t_list *temp_node;
    temp_node = node;

    while(temp_node != NULL)
    {
        printf("|%s| ", (char *)temp_node->data);
        temp_node = temp_node->next;
    }
}

int main()
{
    printf("\n-------------- FT_ATOI_BASE --------------\n");

    printf("\n-------------- FT_LIST_PUSH_FRONT --------------\n");

    t_list *node = NULL;

    printf("List before: ");
    print_list(node);

    ft_list_push_front(&node, "Four");
    ft_list_push_front(&node, "Three");
    ft_list_push_front(&node, "Two");
    ft_list_push_front(&node, "One");

    printf("\n");
    printf("List after: ");
    print_list(node);

    printf("\n-------------- FT_LIST_SIZE --------------\n");

    int size = ft_list_size(node);
    printf("List size: %d\n", size);

    printf("\n-------------- FT_LIST_SORT --------------\n");

    ft_list_sort(&node, ft_strcmp);
    printf("\n");
    printf("List after sort: ");
    print_list(node);

    printf("\n-------------- FT_LIST_REMOVE_IF --------------\n");

}