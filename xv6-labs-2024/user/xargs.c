#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"
#include "kernel/fcntl.h"

// Hàm để đọc lệnh từ stdin
int getcmd(char* buf, int nbuf) {
  memset(buf, 0, nbuf);// Xóa bộ nhớ đệm
  if (read(0, buf, nbuf) <= 0) 
  {  // Đọc từ stdin
    return -1;
  }
  return 0;
}

// Mảng chứa các kí tự trắng như dấu cách, tab, xuống dòng
char whitespace[] = " \t\r\n\v";

// Hàm để tách các đối số từ chuỗi
int gettoken(char** ps, char* es, char** q, char** eq) {
  char* s; //
  int ret; 
  s = *ps; //*ps dùng để giữ vị trí đang xét của chuỗi đầu vào, gán cho s để xử lý tiếp 

  while (s < es && strchr(whitespace, *s))//Bỏ qua các kí tự trắng
    s++;
  
  if (q)
    *q = s; // Lưu vị trí bắt đầu của đối số vào con trỏ q

  ret = *s; 
  switch (*s) {
    case 0: // Nếu là ký tự NULL (hết chuỗi)
      break;
      
    default:// Nếu không phải kí tự trắng
      ret = 'a';

      while (s < es && !strchr(whitespace, *s)) // Đọc đến khi gặp kí tự trắng
        s++; 

      break; // Kết thúc
  }
  if (eq)
    *eq = s; // Lưu vị trí kết thúc của đối số vào con trỏ eq

  while (s < es && strchr(whitespace, *s)) // Bỏ qua các kí tự trắng
    s++;

  *ps = s; // Cập nhật vị trí của con trỏ ps
  return ret;
}

//
int main(int argc, char* argv[]) {
  char* xargs[MAXARG]; // Mảng chứa các đối số
  int n=0;
  int flag = 0;
  int argstart = 0;

  // Xử lý tùy chọn `-n`
  for (int i = 1; i < argc; i++) {
    if (strcmp(argv[i], "-n") == 0 && i + 1 < argc) 
    {
      n = atoi(argv[i + 1]);  // Lấy giá trị sau `-n`
      flag = 1;
      i++;  // Bỏ qua giá trị sau `-n`
    } 
    else 
    {
      xargs[argstart++] = argv[i];  // Thêm đối số khác vào xargs
    }
  }

  static char buf[MAXARG][512];
  char* q, *eq;
  int j = argstart;  // Chỉ số bắt đầu để lưu đối số từ input
  int count = 0;  // Đếm số đối số hiện tại
  int i = 0;
  // Đọc input từ stdin
  while (getcmd(buf[i], sizeof(buf[i])) >= 0) {
    char* s = buf[i];
    //print buf[i]

    char* es = s + strlen(s);
    while (gettoken(&s, es, &q, &eq) != 0) {
      *eq = 0;  // Kết thúc chuỗi
      xargs[j++] = q;  // Lưu đối số vào xargs
      count++;
      i++;

      // Khi đủ số đối số bằng với giá trị `-n`
      if (flag==1 && count == n) {
        xargs[j] = 0;  // Thiết lập kết thúc mảng đối số

        // Tạo tiến trình con để thực thi lệnh
        int pid = fork();
        if (pid == 0) 
        {
          exec(xargs[0], xargs);  // Thực thi lệnh với các đối số
          exit(0);  // Thoát khi kết thúc
        } 
        wait(0);  // Chờ tiến trình con
        // Đặt lại chỉ số `j` và đếm lại số đối số
        j = argstart;
        count = 0;
      }
    }
  }

  // Xử lý các đối số còn lại chưa đủ `-n` để thực thi
  if (count > 0) 
  {
    xargs[j] = 0;  // Thiết lập kết thúc mảng đối số
    int pid = fork();
    if (pid == 0) 
    {
      exec(xargs[0], xargs);  // Thực thi lệnh với các đối số còn lại
      exit(0);  // Thoát khi kết thúc
    } 
    wait(0);  // Chờ tiến trình con
  }
  exit(0);
}