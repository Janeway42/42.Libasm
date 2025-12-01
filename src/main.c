#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

//declare assembly functions and errno
extern size_t ft_strlen(const char *s);
extern int ft_strcmp(const char *s1, const char *s2);
extern char *ft_strcpy(char *dest, const char *src);
extern ssize_t ft_write(int fd, const void *buf, size_t count);
extern ssize_t ft_read(int fd, void *buf, size_t count);
extern char * ft_strdup(const char *str1);
extern int errno;

void ft_strdup_test(const char *str)
{
	char *dup = ft_strdup(str);
	
	if (dup){
		printf("STRDUP - original str: \"%s\", copy str: \"%s\"\n", str, dup);
	} else {
		printf("STRDUP - NULL return - failed strdup\n")
	}
}

int main()
{
	printf("-------------- FT_STRLEN --------------");
	
	const char *len1 = "Let's count this!\n";
	const char *len2 = "";
	
	printf("STRLEN - The line \"%s\" has %d characters.\n", len1, ft_strlen(len1));
	printf("STRLEN - The line \"%s\" has %d characters.\n", len2, ft_strlen(len2));
	
	printf("-------------- FT_STRCMP --------------");
	
	const char *cmp1 = "Let's compare this!\n";
	const char *cmp2 = "Let's divert from it\n";
	
	printf("STRCMP - Comparying different strings outputs: %d\n", len1, ft_strcmp(cmp1, cmp2));
	printf("STRCMP - Comparying identical strings outputs: %d\n", len2, ft_strcmp(cmp1, cmp1));
	
	printf("-------------- FT_STRCPY --------------");
	
	char cpy1 = "Let's compare this!\n";
	char cpy2[15] = "ABCDE FGHIJKL?\n";
	char cpy3[20];
	
	printf("STRCPY - Source: \"%s\", destination: \"%s\", output: \"%s\"\n", cpy1, cpy2, ft_strcpy(cpy1, cpy2));
	printf("STRCPY - Source: \"%s\", destination: \"%s\", output: \"%s\"\n", cpy1, cpy3, ft_strcpy(cpy1, cpy3));
	
	printf("-------------- FT_WRITE --------------");

	const char *msg4 = “Something o print!\n”;
	len = strlen(msg4);
	errno = 0; // errno is reset only on failure, so a successful write can display a previously failed errno. 

	// WRITE - control test with a good file descriptor 
	printf(“WRITE – good file descriptor – success\nWRITE OUTPUT: ”);
	ssize_t ret = ft_write(1, msg4, len);
	printf(“WRITE – ft_write printed %ld characters and errno is set to %d [%s]\n”, ret, errno, strerror(error)); 

	// WRITE - test with an invalid file descriptor
	printf(“WRITE – invalid file descriptor – failure\nWRITE OUTPUT: ”);
	ssize_t ret = ft_write(-1, msg4, len);
	printf(“WRITE - ft_write printed %ld characters and errno is set to %d [%s]\n”, ret, errno, strerror(error));
	
	// WRITE test with a read only file 
	printf(“WRITE – write to a read only file – failure\nWRITE OUTPUT: ”);
	int fd = open(“readonly.txt, O_RDONLY | O_CEAT, 0444);
	ssize_t ret = ft_write(fd, msg4, len);
	printf(“WRITE - ft_write printed %ld characters and errno is set to %d [%s]\n”, ret, errno, strerror(error));
	close(fd);

	printf("-------------- FT_READ --------------");

	char buf[32];
	errno = 0; // errno is reset only on failure, so a successful write can display a previously failed errno. 
	
	// READ - control test with standard output read
	printf(“READ – read from standard outpout – success\nWRITE to stdout: ”);
	printf("There's lots of text to read here!\n");
	ssize_t ret = ft_read(0, buf, sizeof(buf));
	printf(“READ - ft_read read %ld characters and errno is set to %d [%s]\n”, ret, errno, strerror(error)); 
	
	// READ - test with an invalid file descriptor
	printf(“READ – invalid file descriptor – failure\n”);
	ssize_t ret = ft_read(-1, buf, sizeof(buf));
	printf(“READ - ft_read read %ld characters and errno is set to %d [%s]\n”, ret, errno, strerror(error));

	// READ - create file, add text, read from it
	FILE *fptr;
	fptr = fopen("testfiletoread.txt", "w");	// create file 
	fptr = fopen("filename.txt", "w");	// open file in writing mode 
	fprintf(fptr, "Some text to be written here to use as test!");	// write text to it 
	fclose(fptr);	// close file
	
	printf(“READ – create file, write to it and read from – success\n”);
	int fd = open(“testfiletoread.txt, O_RDONLY, 0444);
	ssize_t ret = ft_read(0, buf, sizeof(buf));
	printf(“READ - ft_read read %ld characters and errno is set to %d [%s]\n”, ret, errno, strerror(error)); 


	// READ - test with a read only file
	printf(“READ – read from a write only open file – failure\n”)
	int fd = open(“writeonly.txt, O_WRDONLY | O_CEAT, 0444);
	ssize_t ret = ft_read(fd, buf, sizeof(buf));
	printf(“READ - ft_read read %ld characters and errno is set to %d [%S]\n”, ret, errno, strerror(error));
	close(fd);
	
	printf("-------------- FT_STRDUP --------------");
	
	ft_strdup_test("something to copy\n");
	ft_strdup_test("");
	ft_strdup_test("Something much longer here to see if all goes well or the code decides it has had enough of thid!\n");
	ft_strdup_test("And one more test \t, because why not!");
	
	return 0;
}