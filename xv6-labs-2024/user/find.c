#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int nameComparison(const char *name1, const char *name2) // Hàm so sánh 2 chuỗi có giống nhau hay không 
{
	if (strcmp(name1, name2) == 0)
	{
		return 1;
	}
	return 0;
}

void
find(char *fileName, char* currentDir) // currentDir lưu tên của thư mục cha trong khi đệ quy
{
	char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;
	
	if((fd = open(currentDir, O_RDONLY)) < 0)
	{
		fprintf(2, "ls: cannot open %s\n", fileName);
		return;
	}

	if(fstat(fd, &st) < 0)
	{
		fprintf(2, "ls: cannot stat %s\n", fileName);
		close(fd);
		return;
    }

	if(strlen(currentDir) + 1 + DIRSIZ + 1 > sizeof buf)
	{
		printf("ls: path too long\n");
		return;
	}

    strcpy(buf, currentDir);
    p = buf+strlen(buf);
    *p++ = '/';

    while(read(fd, &de, sizeof(de)) == sizeof(de))
	{
    	if(de.inum == 0)
		{
        	continue;
		}

		if(nameComparison(de.name, ".") == 1 || nameComparison(de.name, "..") == 1)
		{
			continue;
		}

		memmove(p, de.name, DIRSIZ);
    	p[DIRSIZ] = 0; // Cập nhật đường dẫn mới tới thư mục con (buf)

    	if(stat(buf, &st) < 0)
		{
       		printf("ls: cannot stat %s\n", buf);
        	continue;
        }

		if(nameComparison(fileName, de.name) == 1)
		{
			printf("%s\n", buf);
		}

		if(st.type == T_DIR)
		{
			find(fileName, buf); // currentDir đã được thay đổi thành buf
		}
  	}
    close(fd);
}

int
main(int argc, char *argv[])
{
	if (argc != 3)
	{
		printf("Error: Arguments do not fit the command parameter(s).\n");
		exit(0);
	}

	find(argv[2], argv[1]);
	exit(0);	
}
