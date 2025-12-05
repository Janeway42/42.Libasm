#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

//declare assembly functions and errno
extern size_t ft_strlen(const char *s);
extern int ft_strcmp(const char *s1, const char *s2);
extern char *ft_strcpy(char *dest, const char *src);
extern ssize_t ft_write(int fd, const void *buf, size_t count);
extern ssize_t ft_read(int fd, void *buf, size_t count);
extern char * ft_strdup(const char *str1);
extern int errno;

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