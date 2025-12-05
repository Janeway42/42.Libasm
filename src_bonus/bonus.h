#ifndef BONUS_H
#define BONUS_H

typedef struct  s_list
{
    void *data;
    struct s_list *next;
}               t_list;

/* Export offsets for assembly */
#define NODE_DATA 0
#define NODE_NEXT 8
#define NODE_SIZE (8 x 2)

#endif

/* 
In C the compiler handles the structs. Assembly has no struct word. It only sees memory. 
So instead of saying "this is a struct" by defining a struct you say:
at offset 0 -> the "data" field lives here
at offest 8 (on a 64 bit) -> the "next" field lives here
The Makefile rule "bonus.inc: bonus.h" runs the preprocessor on list.h and extracts the LIST_ macros into bonus.inc. 
The preprocessor calculates sizeof(void *) correctly for your platform. 
This ensures that the assembly code always has the correct offsets. 
main.o depends on bonus.h
ft_list_size.o depends on conus.inc
If bonush is changed then bonus.inc is regenerated. 
*/