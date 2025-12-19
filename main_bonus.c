#include <string.h>
#include <fcntl.h>
#include <stdlib.h>
#include "libasm.h"
#include "libasm_bonus.h"

int compare(void *a, void *b)
{
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

    printf("\n-------------- FT_ATOI_BASE --------------\n\n");

    // correct string && correct base 
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "123", "0123456789", ft_atoi_base("123", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "-123", "0123456789", ft_atoi_base("-123", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", " \t -123", "0123456789", ft_atoi_base(" \t -123", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "0", "0123456789", ft_atoi_base("0", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "-0", "0123456789", ft_atoi_base("-0", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "42", "25ad7", ft_atoi_base("42", "25ad7"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "-42", "25ad7", ft_atoi_base("-42", "25ad7"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "2147483647", "0123456789", ft_atoi_base("2147483647", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "2147483648", "0123456789", ft_atoi_base("2147483648", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "-2147483648", "0123456789", ft_atoi_base("-2147483648", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "2a", "0123456789", ft_atoi_base("2a", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "2a", "0123456789abcdefg", ft_atoi_base("2a", "0123456789abcdefg"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", " \\n\\t\\v\\f\\r 25", "0123456789", ft_atoi_base(" \n\t\v\f\r 25", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", " \\n\\t\\v\\f\\r -25", "0123456789", ft_atoi_base(" \n\t\v\f\r -25", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", " \\n\\t\\v\\f\\r 25 34", "0123456789", ft_atoi_base(" \n\t\v\f\r 25 34", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", " \\n\\t\\v\\f\\r 25ab", "0123456789", ft_atoi_base(" \n\t\v\f\r 25ab", "0123456789"));
    printf("\n");

    // invalid string && correct base 
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "", "0123456789", ft_atoi_base("", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "\\v\\t ", "0123456789", ft_atoi_base("\v\t ", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "\\vabc34j\\t ", "0123456789", ft_atoi_base("\vabc34j\t ", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "+-+-+123", "0123456789", ft_atoi_base("+-+-+123123", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", " \t - 123", "0123456789", ft_atoi_base(" \t - 123", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "some text", "0123456789", ft_atoi_base("some text", "0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "text", "0123456789", ft_atoi_base("text", "0123456789"));
    printf("\n");
    
    //invalid base 
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "42", "", ft_atoi_base("42", ""));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "42", "0101", ft_atoi_base("42", "0101"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "-42", "abcdabcd", ft_atoi_base("-42", "abcdabcd"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "42", "-0123456789", ft_atoi_base("42", "-0123456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "42", "0123456+789", ft_atoi_base("42", "0123456+789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "42", "25 7", ft_atoi_base("42", "25 7"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "12345", "0123\\t456789", ft_atoi_base("12345", "0123\t456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "12345", "0123\\v456789", ft_atoi_base("12345", "0123\v456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "12345", "0123\\f456789", ft_atoi_base("12345", "0123\f456789"));
    printf("ATOI str: \"%s\", base: \"%s\", atoi = %d\n", "12345", "\\r0123456789", ft_atoi_base("12345", "\r0123456789"));

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
    printf("List after remove empty pointer data:    "); 
    print_list(node);

    ft_list_remove_if(&node, "", &compare, &free_fct);
    printf("List after remove empty string:          "); 
    print_list(node);

    ft_list_remove_if(&node, "8", &compare, &free_fct);
    printf("List after removing element not in list: "); 
    print_list(node);

    ft_list_remove_if(&node, "A", &compare, &free_fct);
    printf("List after removing first node:          "); 
    print_list(node);

    ft_list_push_front(&node, "A");
    printf("List after re-adding A upfront:          "); 
    print_list(node);

    ft_list_remove_if(&node, "M", &compare, &free_fct);
    printf("List after removing middle node:         "); 
    print_list(node);

    ft_list_remove_if(&node, "Z", &compare, &free_fct);
    printf("List after removing last node:           "); 
    print_list(node);

    free_list(&node);
}