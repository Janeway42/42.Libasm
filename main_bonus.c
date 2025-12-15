#include <string.h>
#include <fcntl.h>
#include <stdlib.h>
#include "libasm.h"
#include "libasm_bonus.h"

int compare(void *a, void *b)
{
    return strcmp((char *)a, (char *)b);
}

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

    if (temp_node == NULL)
    {
        printf("|NULL|\n");
    }
}

int main()
{
    printf("\n-------------- FT_ATOI_BASE --------------\n");

    printf("\n-------------- FT_LIST_PUSH_FRONT --------------\n");

    t_list *node = NULL;

    printf("List before: ");
    print_list(node);

    ft_list_push_front(&node, "A");
    ft_list_push_front(&node, "D");
    ft_list_push_front(&node, "Z");
    ft_list_push_front(&node, "M");

    printf("\n");
    printf("List after: ");
    print_list(node);

    printf("\n-------------- FT_LIST_SIZE --------------\n");

    int size = ft_list_size(node);
    printf("List size: %d\n", size);

    printf("\n-------------- FT_LIST_SORT --------------\n");

    ft_list_sort(&node, &compare);
    printf("\n");

    printf("List after sort: ");
    print_list(node);

    // printf("\n-------------- FT_LIST_REMOVE_IF --------------\n");

    // ft_list_remove_if(&node, "20", &strcmp, &free);

    // printf("List after remove: "); 
    // print_list(node);

}