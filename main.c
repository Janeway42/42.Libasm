#include <string.h>
#include <fcntl.h>
#include <stdlib.h>
#include "libasm.h"

void ft_strdup_test(const char *str)
{
	char *dup = ft_strdup(str);
	
	if (dup){
        printf("\n");
        printf("STRDUP O:|%s|\n", str);
        printf("STRDUP D:|%s|\n", dup);
        free(dup);
	} else {
		printf("\nSTRDUP - NULL return - failed strdup\n");
	}
}

int main()
{
	printf("\n-------------- FT_STRLEN --------------\n\n");
	
	const char *len0 = "Let's count this!";
    const char *len1 = "Let's count this!\n with a new line";
	const char *len2 = "";
    const char *len3 = "\0";
	
	printf("STRLEN - The line \"%s\" has %ld characters.\n", len0, ft_strlen(len0));
    printf("STRLEN - The line \"%s\" has %ld characters.\n", len1, ft_strlen(len1));
	printf("STRLEN - The line \"%s\" has %ld characters.\n", len2, ft_strlen(len2));
	printf("STRLEN - The line \"%s\" has %ld characters.\n", len3, ft_strlen(len3));
	
	printf("\n-------------- FT_STRCMP --------------\n\n");
	
	// const char *cmp1 = "Let's compare this!\n";
	// const char *cmp2 = "Let's divert from it\n";
    // const char *cmp3 = "";

    const char *cmp1 = "1";
	const char *cmp2 = "20";
    const char *cmp3 = "8";
	
	printf("STRCMP - Comparying different strings outputs: %d\n",ft_strcmp(cmp1, cmp2));
	printf("STRCMP - Comparying identical strings outputs: %d\n",ft_strcmp(cmp1, cmp1));
	printf("STRCMP - Comparying different strings outputs: %d\n",ft_strcmp(cmp3, cmp2));
    printf("STRCMP - Comparying different strings outputs: %d\n",ft_strcmp(cmp2, cmp3));
	
	printf("\n-------------- FT_STRCPY --------------\n");
	
    char *str;
    str = malloc(sizeof(char *) * 20);
	char *cpy1 = "Let's compare this!";
	char *cpy2 = "ABCDE FGHIJKL?";
	char *cpy3 = "";
	
    bzero(str, 19);
    printf("\n");
    printf("\nSTRCPY - O: |%s|\n", cpy1);
    printf("STRCPY - C: |%s|\n", ft_strcpy(str, cpy1));

    bzero(str, 19);
    printf("\n");
    printf("STRCPY - O: |%s|\n", cpy2);
    printf("STRCPY - C: |%s|\n", ft_strcpy(str, cpy2));

    bzero(str, 19);
    printf("\n");
    printf("STRCPY - O: |%s|\n", cpy3);
    printf("STRCPY - C: |%s|\n", ft_strcpy(str, cpy3));

    free(str);
	
	printf("\n-------------- FT_WRITE --------------\n");

	const char *msg4 = "Something to print!\n";
	size_t len = strlen(msg4);
    
	// WRITE - control test with a good file descriptor 
	errno = 0; // errno is reset only on failure, so a successful write can display a previously failed errno. 
	printf("\nWRITE - good file descriptor - success\n");
	ssize_t ret_write = ft_write(1, msg4, len);
	printf("ft_write printed %ld characters and errno is set to %d [%s]\n", ret_write, errno, strerror(errno)); 

	// WRITE - test with an invalid file descriptor
    errno = 0; // errno is reset only on failure, so a successful write can display a previously failed errno. 
	printf("\nWRITE - invalid file descriptor - failure\n");
	ret_write = ft_write(-1, msg4, len);
	printf("ft_write printed %ld characters and errno is set to %d [%s]\n", ret_write, errno, strerror(errno));
	
	// WRITE test with a read only file 
    errno = 0; // errno is reset only on failure, so a successful write can display a previously failed errno. 
	printf("\nWRITE - write to a read only file - failure\n");
	int fd_write = open("readonly.txt", O_RDONLY | O_CREAT, 0444);
	ret_write = ft_write(fd_write, msg4, len);
	printf("ft_write printed %ld characters and errno is set to %d [%s]\n", ret_write, errno, strerror(errno));
	close(fd_write);

	printf("\n-------------- FT_READ --------------\n");

	char buf[32];
    size_t buff_size = sizeof(buf) - 1;
	
	// // READ - control test with standard output read
	// errno = 0; // errno is reset only on failure, so a successful write can display a previously failed errno. 
	// printf("READ - read from standard outpout - success\nWRITE to stdout: ");
	// printf("There's lots of text to read here!\n");
	// ssize_t ret_read = ft_read(STDIN_FILENO, buf, buff_size);
    // if (ret_read > 0)
    // {
    //     buf[ret_read] = '\0';
    // }
	// printf("READ - ft_read read %ld characters and errno is set to %d [%s]\n", ret_read, errno, strerror(errno)); 
	
	// READ - test with an invalid file descriptor
    errno = 0; // errno is reset only on failure, so a successful write can display a previously failed errno. 
	printf("\nREAD - invalid file descriptor - failure\n");
	ssize_t ret_read = ft_read(-1, buf, buff_size);
	printf("ft_read read %ld characters and errno is set to %d [%s]\n", ret_read, errno, strerror(errno));

	// READ - create file, add text, read from it
    errno = 0; // errno is reset only on failure, so a successful write can display a previously failed errno. 
	printf("\nREAD - create file, write to it and read from - success\n");
	FILE *fptr;
	fptr = fopen("testfiletoread.txt", "w+");	// create file 
    const char *text_to_add = "Some text to be written here to use as test!";
	fprintf(fptr, "%s\n", text_to_add);	// write text to it 
	fclose(fptr);	// close file
	
	int fd_read = open("testfiletoread.txt", O_RDONLY, 0444);
	ret_read = ft_read(fd_read, buf, buff_size);
	printf("ft_read read %ld characters and errno is set to %d [%s]\n", ret_read, errno, strerror(errno)); 
    close(fd_read);

	// READ - test with a read only file
    errno = 0; // errno is reset only on failure, so a successful write can display a previously failed errno. 
	printf("\nREAD - read from a write only open file - failure\n");
	fd_read = open("writeonly.txt", O_WRONLY | O_CREAT, 0444);
	ret_read = ft_read(fd_read, buf, buff_size);
	printf("ft_read read %ld characters and errno is set to %d [%s]\n", ret_read, errno, strerror(errno));
	close(fd_read );
	
	printf("\n-------------- FT_STRDUP --------------\n");
	
	ft_strdup_test("something to \n copy");
	ft_strdup_test("");
	ft_strdup_test("Something much longer here to see if all goes well or the code decides it has had enough of thid!");
	ft_strdup_test("And one more test \t, because why not!");
	
	return 0;
}