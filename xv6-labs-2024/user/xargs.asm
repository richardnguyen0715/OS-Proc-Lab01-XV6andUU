
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
#include "user/user.h"
#include "kernel/param.h"
#include "kernel/fcntl.h"

// Hàm để đọc lệnh từ stdin
int getcmd(char* buf, int nbuf) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	892a                	mv	s2,a0
   e:	84ae                	mv	s1,a1
  memset(buf, 0, nbuf);
  10:	862e                	mv	a2,a1
  12:	4581                	li	a1,0
  14:	2de000ef          	jal	2f2 <memset>
  if (read(0, buf, nbuf) <= 0) {  // Đọc từ stdin
  18:	8626                	mv	a2,s1
  1a:	85ca                	mv	a1,s2
  1c:	4501                	li	a0,0
  1e:	4d2000ef          	jal	4f0 <read>
  22:	00152513          	slti	a0,a0,1
  26:	40a0053b          	negw	a0,a0
    return -1;
  }
  return 0;
}
  2a:	2501                	sext.w	a0,a0
  2c:	60e2                	ld	ra,24(sp)
  2e:	6442                	ld	s0,16(sp)
  30:	64a2                	ld	s1,8(sp)
  32:	6902                	ld	s2,0(sp)
  34:	6105                	addi	sp,sp,32
  36:	8082                	ret

0000000000000038 <gettoken>:

char whitespace[] = " \t\r\n\v";

int gettoken(char** ps, char* es, char** q, char** eq) {
  38:	7139                	addi	sp,sp,-64
  3a:	fc06                	sd	ra,56(sp)
  3c:	f822                	sd	s0,48(sp)
  3e:	f426                	sd	s1,40(sp)
  40:	f04a                	sd	s2,32(sp)
  42:	ec4e                	sd	s3,24(sp)
  44:	e852                	sd	s4,16(sp)
  46:	e456                	sd	s5,8(sp)
  48:	e05a                	sd	s6,0(sp)
  4a:	0080                	addi	s0,sp,64
  4c:	8a2a                	mv	s4,a0
  4e:	892e                	mv	s2,a1
  50:	8ab2                	mv	s5,a2
  52:	8b36                	mv	s6,a3
  char* s;
  int ret;
  s = *ps;
  54:	6104                	ld	s1,0(a0)
  while (s < es && strchr(whitespace, *s))
  56:	00001997          	auipc	s3,0x1
  5a:	faa98993          	addi	s3,s3,-86 # 1000 <whitespace>
  5e:	00b4fc63          	bgeu	s1,a1,76 <gettoken+0x3e>
  62:	0004c583          	lbu	a1,0(s1)
  66:	854e                	mv	a0,s3
  68:	2ac000ef          	jal	314 <strchr>
  6c:	c509                	beqz	a0,76 <gettoken+0x3e>
    s++;
  6e:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
  70:	fe9919e3          	bne	s2,s1,62 <gettoken+0x2a>
  74:	84ca                	mv	s1,s2
  if (q)
  76:	000a8463          	beqz	s5,7e <gettoken+0x46>
    *q = s;
  7a:	009ab023          	sd	s1,0(s5)
  ret = *s;
  switch (*s) {
  7e:	0004c783          	lbu	a5,0(s1)
  82:	cb8d                	beqz	a5,b4 <gettoken+0x7c>
    case 0:
      break;
    default:
      ret = 'a';
      while (s < es && !strchr(whitespace, *s))
  84:	00001997          	auipc	s3,0x1
  88:	f7c98993          	addi	s3,s3,-132 # 1000 <whitespace>
  8c:	0724f963          	bgeu	s1,s2,fe <gettoken+0xc6>
  90:	0004c583          	lbu	a1,0(s1)
  94:	854e                	mv	a0,s3
  96:	27e000ef          	jal	314 <strchr>
  9a:	e911                	bnez	a0,ae <gettoken+0x76>
        s++;
  9c:	0485                	addi	s1,s1,1
      while (s < es && !strchr(whitespace, *s))
  9e:	fe9919e3          	bne	s2,s1,90 <gettoken+0x58>
      break;
  }
  if (eq)
  a2:	84ca                	mv	s1,s2
      ret = 'a';
  a4:	06100a93          	li	s5,97
  if (eq)
  a8:	000b1963          	bnez	s6,ba <gettoken+0x82>
  ac:	a825                	j	e4 <gettoken+0xac>
      ret = 'a';
  ae:	06100a93          	li	s5,97
  b2:	a011                	j	b6 <gettoken+0x7e>
  ret = *s;
  b4:	4a81                	li	s5,0
  if (eq)
  b6:	000b0463          	beqz	s6,be <gettoken+0x86>
    *eq = s;
  ba:	009b3023          	sd	s1,0(s6)

  while (s < es && strchr(whitespace, *s))
  be:	00001997          	auipc	s3,0x1
  c2:	f4298993          	addi	s3,s3,-190 # 1000 <whitespace>
  c6:	0124fc63          	bgeu	s1,s2,de <gettoken+0xa6>
  ca:	0004c583          	lbu	a1,0(s1)
  ce:	854e                	mv	a0,s3
  d0:	244000ef          	jal	314 <strchr>
  d4:	c519                	beqz	a0,e2 <gettoken+0xaa>
    s++;
  d6:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
  d8:	fe9919e3          	bne	s2,s1,ca <gettoken+0x92>
  dc:	a021                	j	e4 <gettoken+0xac>
  de:	8926                	mv	s2,s1
  e0:	a011                	j	e4 <gettoken+0xac>
  e2:	8926                	mv	s2,s1
  *ps = s;
  e4:	012a3023          	sd	s2,0(s4)
  return ret;
}
  e8:	8556                	mv	a0,s5
  ea:	70e2                	ld	ra,56(sp)
  ec:	7442                	ld	s0,48(sp)
  ee:	74a2                	ld	s1,40(sp)
  f0:	7902                	ld	s2,32(sp)
  f2:	69e2                	ld	s3,24(sp)
  f4:	6a42                	ld	s4,16(sp)
  f6:	6aa2                	ld	s5,8(sp)
  f8:	6b02                	ld	s6,0(sp)
  fa:	6121                	addi	sp,sp,64
  fc:	8082                	ret
      ret = 'a';
  fe:	06100a93          	li	s5,97
  if (eq)
 102:	fa0b1ce3          	bnez	s6,ba <gettoken+0x82>
 106:	8926                	mv	s2,s1
 108:	bff1                	j	e4 <gettoken+0xac>

000000000000010a <main>:

int main(int argc, char* argv[]) {
 10a:	7165                	addi	sp,sp,-400
 10c:	e706                	sd	ra,392(sp)
 10e:	e322                	sd	s0,384(sp)
 110:	fea6                	sd	s1,376(sp)
 112:	faca                	sd	s2,368(sp)
 114:	f6ce                	sd	s3,360(sp)
 116:	f2d2                	sd	s4,352(sp)
 118:	eed6                	sd	s5,344(sp)
 11a:	eada                	sd	s6,336(sp)
 11c:	e6de                	sd	s7,328(sp)
 11e:	e2e2                	sd	s8,320(sp)
 120:	fe66                	sd	s9,312(sp)
 122:	fa6a                	sd	s10,304(sp)
 124:	f66e                	sd	s11,296(sp)
 126:	0b00                	addi	s0,sp,400
  int n=0;
  int flag = 0;
  int argstart = 0;

  // Xử lý tùy chọn `-n`
  for (int i = 1; i < argc; i++) {
 128:	4785                	li	a5,1
 12a:	06a7d163          	bge	a5,a0,18c <main+0x82>
 12e:	89aa                	mv	s3,a0
 130:	8a2e                	mv	s4,a1
 132:	4485                	li	s1,1
  int argstart = 0;
 134:	4c01                	li	s8,0
  int flag = 0;
 136:	4a81                	li	s5,0
  int n=0;
 138:	4b81                	li	s7,0
    if (strcmp(argv[i], "-n") == 0 && i + 1 < argc) {
 13a:	00001b17          	auipc	s6,0x1
 13e:	966b0b13          	addi	s6,s6,-1690 # aa0 <malloc+0xfc>
      n = atoi(argv[i + 1]);  // Lấy giá trị sau `-n`
      flag = 1;
 142:	4c85                	li	s9,1
 144:	a821                	j	15c <main+0x52>
      i++;  // Bỏ qua giá trị sau `-n`
    } else {
      xargs[argstart++] = argv[i];  // Thêm đối số khác vào xargs
 146:	003c1793          	slli	a5,s8,0x3
 14a:	f9078793          	addi	a5,a5,-112
 14e:	97a2                	add	a5,a5,s0
 150:	f127b023          	sd	s2,-256(a5)
 154:	2c05                	addiw	s8,s8,1
  for (int i = 1; i < argc; i++) {
 156:	2485                	addiw	s1,s1,1
 158:	0334dd63          	bge	s1,s3,192 <main+0x88>
    if (strcmp(argv[i], "-n") == 0 && i + 1 < argc) {
 15c:	00349d13          	slli	s10,s1,0x3
 160:	01aa07b3          	add	a5,s4,s10
 164:	0007b903          	ld	s2,0(a5)
 168:	85da                	mv	a1,s6
 16a:	854a                	mv	a0,s2
 16c:	130000ef          	jal	29c <strcmp>
 170:	f979                	bnez	a0,146 <main+0x3c>
 172:	00148d9b          	addiw	s11,s1,1
 176:	fd3dd8e3          	bge	s11,s3,146 <main+0x3c>
      n = atoi(argv[i + 1]);  // Lấy giá trị sau `-n`
 17a:	9d52                	add	s10,s10,s4
 17c:	008d3503          	ld	a0,8(s10)
 180:	262000ef          	jal	3e2 <atoi>
 184:	8baa                	mv	s7,a0
      i++;  // Bỏ qua giá trị sau `-n`
 186:	84ee                	mv	s1,s11
      flag = 1;
 188:	8ae6                	mv	s5,s9
      i++;  // Bỏ qua giá trị sau `-n`
 18a:	b7f1                	j	156 <main+0x4c>
  int argstart = 0;
 18c:	4c01                	li	s8,0
  int flag = 0;
 18e:	4a81                	li	s5,0
  int n=0;
 190:	4b81                	li	s7,0
    }
  }

  static char buf[MAXARG][512];
  char* q, *eq;
  int j = argstart;  // Chỉ số bắt đầu để lưu đối số từ input
 192:	84e2                	mv	s1,s8
  int count = 0;  // Đếm số đối số hiện tại
  int i = 0;
 194:	4981                	li	s3,0
  int count = 0;  // Đếm số đối số hiện tại
 196:	4901                	li	s2,0
  // Đọc input từ stdin
  // if(flag==0)
  // {

  // }
  while (getcmd(buf[i], sizeof(buf[i])) >= 0) {
 198:	00001c97          	auipc	s9,0x1
 19c:	e88c8c93          	addi	s9,s9,-376 # 1020 <buf.0>
      xargs[j++] = q;  // Lưu đối số vào xargs
      count++;
      i++;

      // Khi đủ số đối số bằng với giá trị `-n`
      if (flag==1 && count == n) {
 1a0:	4b05                	li	s6,1
  while (getcmd(buf[i], sizeof(buf[i])) >= 0) {
 1a2:	00999a13          	slli	s4,s3,0x9
 1a6:	9a66                	add	s4,s4,s9
 1a8:	20000593          	li	a1,512
 1ac:	8552                	mv	a0,s4
 1ae:	e53ff0ef          	jal	0 <getcmd>
 1b2:	08054363          	bltz	a0,238 <main+0x12e>
    char* s = buf[i];
 1b6:	e7443c23          	sd	s4,-392(s0)
    char* es = s + strlen(s);
 1ba:	8552                	mv	a0,s4
 1bc:	10c000ef          	jal	2c8 <strlen>
 1c0:	1502                	slli	a0,a0,0x20
 1c2:	9101                	srli	a0,a0,0x20
 1c4:	9a2a                	add	s4,s4,a0
    while (gettoken(&s, es, &q, &eq) != 0) {
 1c6:	a819                	j	1dc <main+0xd2>
        xargs[j] = 0;  // Thiết lập kết thúc mảng đối số

        // Tạo tiến trình con để thực thi lệnh
        int pid = fork();
        if (pid == 0) {
          exec(xargs[0], xargs);  // Thực thi lệnh với các đối số
 1c8:	e9040593          	addi	a1,s0,-368
 1cc:	e9043503          	ld	a0,-368(s0)
 1d0:	340000ef          	jal	510 <exec>
          exit(0);  // Thoát khi kết thúc
 1d4:	4501                	li	a0,0
 1d6:	302000ef          	jal	4d8 <exit>
          wait(0);  // Chờ tiến trình con
        }

        // Đặt lại chỉ số `j` và đếm lại số đối số
        j = argstart;
        count = 0;
 1da:	84be                	mv	s1,a5
    while (gettoken(&s, es, &q, &eq) != 0) {
 1dc:	e8040693          	addi	a3,s0,-384
 1e0:	e8840613          	addi	a2,s0,-376
 1e4:	85d2                	mv	a1,s4
 1e6:	e7840513          	addi	a0,s0,-392
 1ea:	e4fff0ef          	jal	38 <gettoken>
 1ee:	d955                	beqz	a0,1a2 <main+0x98>
      *eq = 0;  // Kết thúc chuỗi
 1f0:	e8043783          	ld	a5,-384(s0)
 1f4:	00078023          	sb	zero,0(a5)
      xargs[j++] = q;  // Lưu đối số vào xargs
 1f8:	0014879b          	addiw	a5,s1,1
 1fc:	048e                	slli	s1,s1,0x3
 1fe:	f9048713          	addi	a4,s1,-112
 202:	008704b3          	add	s1,a4,s0
 206:	e8843703          	ld	a4,-376(s0)
 20a:	f0e4b023          	sd	a4,-256(s1)
      count++;
 20e:	2905                	addiw	s2,s2,1
      i++;
 210:	2985                	addiw	s3,s3,1
      if (flag==1 && count == n) {
 212:	fd6a94e3          	bne	s5,s6,1da <main+0xd0>
 216:	fd7912e3          	bne	s2,s7,1da <main+0xd0>
        xargs[j] = 0;  // Thiết lập kết thúc mảng đối số
 21a:	078e                	slli	a5,a5,0x3
 21c:	f9078793          	addi	a5,a5,-112
 220:	97a2                	add	a5,a5,s0
 222:	f007b023          	sd	zero,-256(a5)
        int pid = fork();
 226:	2aa000ef          	jal	4d0 <fork>
        if (pid == 0) {
 22a:	dd59                	beqz	a0,1c8 <main+0xbe>
          wait(0);  // Chờ tiến trình con
 22c:	4501                	li	a0,0
 22e:	2b2000ef          	jal	4e0 <wait>
        j = argstart;
 232:	87e2                	mv	a5,s8
        count = 0;
 234:	4901                	li	s2,0
 236:	b755                	j	1da <main+0xd0>
      }
    }
  }

  // Xử lý các đối số còn lại chưa đủ `-n` để thực thi
  if (count > 0) {
 238:	03205863          	blez	s2,268 <main+0x15e>
    xargs[j] = 0;  // Thiết lập kết thúc mảng đối số
 23c:	00349793          	slli	a5,s1,0x3
 240:	f9078793          	addi	a5,a5,-112
 244:	97a2                	add	a5,a5,s0
 246:	f007b023          	sd	zero,-256(a5)
    int pid = fork();
 24a:	286000ef          	jal	4d0 <fork>
    if (pid == 0) {
 24e:	e911                	bnez	a0,262 <main+0x158>
      exec(xargs[0], xargs);  // Thực thi lệnh với các đối số còn lại
 250:	e9040593          	addi	a1,s0,-368
 254:	e9043503          	ld	a0,-368(s0)
 258:	2b8000ef          	jal	510 <exec>
      exit(0);  // Thoát khi kết thúc
 25c:	4501                	li	a0,0
 25e:	27a000ef          	jal	4d8 <exit>
    } 
    wait(0);  // Chờ tiến trình con
 262:	4501                	li	a0,0
 264:	27c000ef          	jal	4e0 <wait>
  }
  exit(0);
 268:	4501                	li	a0,0
 26a:	26e000ef          	jal	4d8 <exit>

00000000000001e4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e406                	sd	ra,8(sp)
 1e8:	e022                	sd	s0,0(sp)
 1ea:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1ec:	f1fff0ef          	jal	10a <main>
  exit(0);
 1f0:	4501                	li	a0,0
 1f2:	25c000ef          	jal	44e <exit>

00000000000001f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e422                	sd	s0,8(sp)
 1fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1fc:	87aa                	mv	a5,a0
 1fe:	0585                	addi	a1,a1,1
 200:	0785                	addi	a5,a5,1
 202:	fff5c703          	lbu	a4,-1(a1)
 206:	fee78fa3          	sb	a4,-1(a5)
 20a:	fb75                	bnez	a4,1fe <strcpy+0x8>
    ;
  return os;
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret

0000000000000212 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 218:	00054783          	lbu	a5,0(a0)
 21c:	cb91                	beqz	a5,230 <strcmp+0x1e>
 21e:	0005c703          	lbu	a4,0(a1)
 222:	00f71763          	bne	a4,a5,230 <strcmp+0x1e>
    p++, q++;
 226:	0505                	addi	a0,a0,1
 228:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 22a:	00054783          	lbu	a5,0(a0)
 22e:	fbe5                	bnez	a5,21e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 230:	0005c503          	lbu	a0,0(a1)
}
 234:	40a7853b          	subw	a0,a5,a0
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret

000000000000023e <strlen>:

uint
strlen(const char *s)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 244:	00054783          	lbu	a5,0(a0)
 248:	cf91                	beqz	a5,264 <strlen+0x26>
 24a:	0505                	addi	a0,a0,1
 24c:	87aa                	mv	a5,a0
 24e:	86be                	mv	a3,a5
 250:	0785                	addi	a5,a5,1
 252:	fff7c703          	lbu	a4,-1(a5)
 256:	ff65                	bnez	a4,24e <strlen+0x10>
 258:	40a6853b          	subw	a0,a3,a0
 25c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
  for(n = 0; s[n]; n++)
 264:	4501                	li	a0,0
 266:	bfe5                	j	25e <strlen+0x20>

0000000000000268 <memset>:

void*
memset(void *dst, int c, uint n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e422                	sd	s0,8(sp)
 26c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 26e:	ca19                	beqz	a2,284 <memset+0x1c>
 270:	87aa                	mv	a5,a0
 272:	1602                	slli	a2,a2,0x20
 274:	9201                	srli	a2,a2,0x20
 276:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 27a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 27e:	0785                	addi	a5,a5,1
 280:	fee79de3          	bne	a5,a4,27a <memset+0x12>
  }
  return dst;
}
 284:	6422                	ld	s0,8(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret

000000000000028a <strchr>:

char*
strchr(const char *s, char c)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e422                	sd	s0,8(sp)
 28e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 290:	00054783          	lbu	a5,0(a0)
 294:	cb99                	beqz	a5,2aa <strchr+0x20>
    if(*s == c)
 296:	00f58763          	beq	a1,a5,2a4 <strchr+0x1a>
  for(; *s; s++)
 29a:	0505                	addi	a0,a0,1
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	fbfd                	bnez	a5,296 <strchr+0xc>
      return (char*)s;
  return 0;
 2a2:	4501                	li	a0,0
}
 2a4:	6422                	ld	s0,8(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret
  return 0;
 2aa:	4501                	li	a0,0
 2ac:	bfe5                	j	2a4 <strchr+0x1a>

00000000000002ae <gets>:

char*
gets(char *buf, int max)
{
 2ae:	711d                	addi	sp,sp,-96
 2b0:	ec86                	sd	ra,88(sp)
 2b2:	e8a2                	sd	s0,80(sp)
 2b4:	e4a6                	sd	s1,72(sp)
 2b6:	e0ca                	sd	s2,64(sp)
 2b8:	fc4e                	sd	s3,56(sp)
 2ba:	f852                	sd	s4,48(sp)
 2bc:	f456                	sd	s5,40(sp)
 2be:	f05a                	sd	s6,32(sp)
 2c0:	ec5e                	sd	s7,24(sp)
 2c2:	1080                	addi	s0,sp,96
 2c4:	8baa                	mv	s7,a0
 2c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c8:	892a                	mv	s2,a0
 2ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2cc:	4aa9                	li	s5,10
 2ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2d0:	89a6                	mv	s3,s1
 2d2:	2485                	addiw	s1,s1,1
 2d4:	0344d663          	bge	s1,s4,300 <gets+0x52>
    cc = read(0, &c, 1);
 2d8:	4605                	li	a2,1
 2da:	faf40593          	addi	a1,s0,-81
 2de:	4501                	li	a0,0
 2e0:	186000ef          	jal	466 <read>
    if(cc < 1)
 2e4:	00a05e63          	blez	a0,300 <gets+0x52>
    buf[i++] = c;
 2e8:	faf44783          	lbu	a5,-81(s0)
 2ec:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2f0:	01578763          	beq	a5,s5,2fe <gets+0x50>
 2f4:	0905                	addi	s2,s2,1
 2f6:	fd679de3          	bne	a5,s6,2d0 <gets+0x22>
    buf[i++] = c;
 2fa:	89a6                	mv	s3,s1
 2fc:	a011                	j	300 <gets+0x52>
 2fe:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 300:	99de                	add	s3,s3,s7
 302:	00098023          	sb	zero,0(s3)
  return buf;
}
 306:	855e                	mv	a0,s7
 308:	60e6                	ld	ra,88(sp)
 30a:	6446                	ld	s0,80(sp)
 30c:	64a6                	ld	s1,72(sp)
 30e:	6906                	ld	s2,64(sp)
 310:	79e2                	ld	s3,56(sp)
 312:	7a42                	ld	s4,48(sp)
 314:	7aa2                	ld	s5,40(sp)
 316:	7b02                	ld	s6,32(sp)
 318:	6be2                	ld	s7,24(sp)
 31a:	6125                	addi	sp,sp,96
 31c:	8082                	ret

000000000000031e <stat>:

int
stat(const char *n, struct stat *st)
{
 31e:	1101                	addi	sp,sp,-32
 320:	ec06                	sd	ra,24(sp)
 322:	e822                	sd	s0,16(sp)
 324:	e04a                	sd	s2,0(sp)
 326:	1000                	addi	s0,sp,32
 328:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 32a:	4581                	li	a1,0
 32c:	162000ef          	jal	48e <open>
  if(fd < 0)
 330:	02054263          	bltz	a0,354 <stat+0x36>
 334:	e426                	sd	s1,8(sp)
 336:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 338:	85ca                	mv	a1,s2
 33a:	16c000ef          	jal	4a6 <fstat>
 33e:	892a                	mv	s2,a0
  close(fd);
 340:	8526                	mv	a0,s1
 342:	134000ef          	jal	476 <close>
  return r;
 346:	64a2                	ld	s1,8(sp)
}
 348:	854a                	mv	a0,s2
 34a:	60e2                	ld	ra,24(sp)
 34c:	6442                	ld	s0,16(sp)
 34e:	6902                	ld	s2,0(sp)
 350:	6105                	addi	sp,sp,32
 352:	8082                	ret
    return -1;
 354:	597d                	li	s2,-1
 356:	bfcd                	j	348 <stat+0x2a>

0000000000000358 <atoi>:

int
atoi(const char *s)
{
 358:	1141                	addi	sp,sp,-16
 35a:	e422                	sd	s0,8(sp)
 35c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 35e:	00054683          	lbu	a3,0(a0)
 362:	fd06879b          	addiw	a5,a3,-48
 366:	0ff7f793          	zext.b	a5,a5
 36a:	4625                	li	a2,9
 36c:	02f66863          	bltu	a2,a5,39c <atoi+0x44>
 370:	872a                	mv	a4,a0
  n = 0;
 372:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 374:	0705                	addi	a4,a4,1
 376:	0025179b          	slliw	a5,a0,0x2
 37a:	9fa9                	addw	a5,a5,a0
 37c:	0017979b          	slliw	a5,a5,0x1
 380:	9fb5                	addw	a5,a5,a3
 382:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 386:	00074683          	lbu	a3,0(a4)
 38a:	fd06879b          	addiw	a5,a3,-48
 38e:	0ff7f793          	zext.b	a5,a5
 392:	fef671e3          	bgeu	a2,a5,374 <atoi+0x1c>
  return n;
}
 396:	6422                	ld	s0,8(sp)
 398:	0141                	addi	sp,sp,16
 39a:	8082                	ret
  n = 0;
 39c:	4501                	li	a0,0
 39e:	bfe5                	j	396 <atoi+0x3e>

00000000000003a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e422                	sd	s0,8(sp)
 3a4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3a6:	02b57463          	bgeu	a0,a1,3ce <memmove+0x2e>
    while(n-- > 0)
 3aa:	00c05f63          	blez	a2,3c8 <memmove+0x28>
 3ae:	1602                	slli	a2,a2,0x20
 3b0:	9201                	srli	a2,a2,0x20
 3b2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3b6:	872a                	mv	a4,a0
      *dst++ = *src++;
 3b8:	0585                	addi	a1,a1,1
 3ba:	0705                	addi	a4,a4,1
 3bc:	fff5c683          	lbu	a3,-1(a1)
 3c0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3c4:	fef71ae3          	bne	a4,a5,3b8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3c8:	6422                	ld	s0,8(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret
    dst += n;
 3ce:	00c50733          	add	a4,a0,a2
    src += n;
 3d2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3d4:	fec05ae3          	blez	a2,3c8 <memmove+0x28>
 3d8:	fff6079b          	addiw	a5,a2,-1
 3dc:	1782                	slli	a5,a5,0x20
 3de:	9381                	srli	a5,a5,0x20
 3e0:	fff7c793          	not	a5,a5
 3e4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3e6:	15fd                	addi	a1,a1,-1
 3e8:	177d                	addi	a4,a4,-1
 3ea:	0005c683          	lbu	a3,0(a1)
 3ee:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3f2:	fee79ae3          	bne	a5,a4,3e6 <memmove+0x46>
 3f6:	bfc9                	j	3c8 <memmove+0x28>

00000000000003f8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3f8:	1141                	addi	sp,sp,-16
 3fa:	e422                	sd	s0,8(sp)
 3fc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3fe:	ca05                	beqz	a2,42e <memcmp+0x36>
 400:	fff6069b          	addiw	a3,a2,-1
 404:	1682                	slli	a3,a3,0x20
 406:	9281                	srli	a3,a3,0x20
 408:	0685                	addi	a3,a3,1
 40a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 40c:	00054783          	lbu	a5,0(a0)
 410:	0005c703          	lbu	a4,0(a1)
 414:	00e79863          	bne	a5,a4,424 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 418:	0505                	addi	a0,a0,1
    p2++;
 41a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 41c:	fed518e3          	bne	a0,a3,40c <memcmp+0x14>
  }
  return 0;
 420:	4501                	li	a0,0
 422:	a019                	j	428 <memcmp+0x30>
      return *p1 - *p2;
 424:	40e7853b          	subw	a0,a5,a4
}
 428:	6422                	ld	s0,8(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret
  return 0;
 42e:	4501                	li	a0,0
 430:	bfe5                	j	428 <memcmp+0x30>

0000000000000432 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 432:	1141                	addi	sp,sp,-16
 434:	e406                	sd	ra,8(sp)
 436:	e022                	sd	s0,0(sp)
 438:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 43a:	f67ff0ef          	jal	3a0 <memmove>
}
 43e:	60a2                	ld	ra,8(sp)
 440:	6402                	ld	s0,0(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret

00000000000004d0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4d0:	4885                	li	a7,1
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d8:	4889                	li	a7,2
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4e0:	488d                	li	a7,3
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e8:	4891                	li	a7,4
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <read>:
.global read
read:
 li a7, SYS_read
 4f0:	4895                	li	a7,5
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <write>:
.global write
write:
 li a7, SYS_write
 4f8:	48c1                	li	a7,16
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <close>:
.global close
close:
 li a7, SYS_close
 500:	48d5                	li	a7,21
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <kill>:
.global kill
kill:
 li a7, SYS_kill
 508:	4899                	li	a7,6
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <exec>:
.global exec
exec:
 li a7, SYS_exec
 510:	489d                	li	a7,7
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <open>:
.global open
open:
 li a7, SYS_open
 518:	48bd                	li	a7,15
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 520:	48c5                	li	a7,17
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 528:	48c9                	li	a7,18
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 530:	48a1                	li	a7,8
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <link>:
.global link
link:
 li a7, SYS_link
 538:	48cd                	li	a7,19
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 540:	48d1                	li	a7,20
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 548:	48a5                	li	a7,9
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <dup>:
.global dup
dup:
 li a7, SYS_dup
 550:	48a9                	li	a7,10
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 558:	48ad                	li	a7,11
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 560:	48b1                	li	a7,12
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 568:	48b5                	li	a7,13
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 570:	48b9                	li	a7,14
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 578:	1101                	addi	sp,sp,-32
 57a:	ec06                	sd	ra,24(sp)
 57c:	e822                	sd	s0,16(sp)
 57e:	1000                	addi	s0,sp,32
 580:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 584:	4605                	li	a2,1
 586:	fef40593          	addi	a1,s0,-17
 58a:	f6fff0ef          	jal	4f8 <write>
}
 58e:	60e2                	ld	ra,24(sp)
 590:	6442                	ld	s0,16(sp)
 592:	6105                	addi	sp,sp,32
 594:	8082                	ret

0000000000000596 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 596:	7139                	addi	sp,sp,-64
 598:	fc06                	sd	ra,56(sp)
 59a:	f822                	sd	s0,48(sp)
 59c:	f426                	sd	s1,40(sp)
 59e:	0080                	addi	s0,sp,64
 5a0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5a2:	c299                	beqz	a3,5a8 <printint+0x12>
 5a4:	0805c963          	bltz	a1,636 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5a8:	2581                	sext.w	a1,a1
  neg = 0;
 5aa:	4881                	li	a7,0
 5ac:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5b0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5b2:	2601                	sext.w	a2,a2
 5b4:	00000517          	auipc	a0,0x0
 5b8:	4fc50513          	addi	a0,a0,1276 # ab0 <digits>
 5bc:	883a                	mv	a6,a4
 5be:	2705                	addiw	a4,a4,1
 5c0:	02c5f7bb          	remuw	a5,a1,a2
 5c4:	1782                	slli	a5,a5,0x20
 5c6:	9381                	srli	a5,a5,0x20
 5c8:	97aa                	add	a5,a5,a0
 5ca:	0007c783          	lbu	a5,0(a5)
 5ce:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5d2:	0005879b          	sext.w	a5,a1
 5d6:	02c5d5bb          	divuw	a1,a1,a2
 5da:	0685                	addi	a3,a3,1
 5dc:	fec7f0e3          	bgeu	a5,a2,5bc <printint+0x26>
  if(neg)
 5e0:	00088c63          	beqz	a7,5f8 <printint+0x62>
    buf[i++] = '-';
 5e4:	fd070793          	addi	a5,a4,-48
 5e8:	00878733          	add	a4,a5,s0
 5ec:	02d00793          	li	a5,45
 5f0:	fef70823          	sb	a5,-16(a4)
 5f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5f8:	02e05a63          	blez	a4,62c <printint+0x96>
 5fc:	f04a                	sd	s2,32(sp)
 5fe:	ec4e                	sd	s3,24(sp)
 600:	fc040793          	addi	a5,s0,-64
 604:	00e78933          	add	s2,a5,a4
 608:	fff78993          	addi	s3,a5,-1
 60c:	99ba                	add	s3,s3,a4
 60e:	377d                	addiw	a4,a4,-1
 610:	1702                	slli	a4,a4,0x20
 612:	9301                	srli	a4,a4,0x20
 614:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 618:	fff94583          	lbu	a1,-1(s2)
 61c:	8526                	mv	a0,s1
 61e:	f5bff0ef          	jal	578 <putc>
  while(--i >= 0)
 622:	197d                	addi	s2,s2,-1
 624:	ff391ae3          	bne	s2,s3,618 <printint+0x82>
 628:	7902                	ld	s2,32(sp)
 62a:	69e2                	ld	s3,24(sp)
}
 62c:	70e2                	ld	ra,56(sp)
 62e:	7442                	ld	s0,48(sp)
 630:	74a2                	ld	s1,40(sp)
 632:	6121                	addi	sp,sp,64
 634:	8082                	ret
    x = -xx;
 636:	40b005bb          	negw	a1,a1
    neg = 1;
 63a:	4885                	li	a7,1
    x = -xx;
 63c:	bf85                	j	5ac <printint+0x16>

000000000000063e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 63e:	711d                	addi	sp,sp,-96
 640:	ec86                	sd	ra,88(sp)
 642:	e8a2                	sd	s0,80(sp)
 644:	e0ca                	sd	s2,64(sp)
 646:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 648:	0005c903          	lbu	s2,0(a1)
 64c:	26090863          	beqz	s2,8bc <vprintf+0x27e>
 650:	e4a6                	sd	s1,72(sp)
 652:	fc4e                	sd	s3,56(sp)
 654:	f852                	sd	s4,48(sp)
 656:	f456                	sd	s5,40(sp)
 658:	f05a                	sd	s6,32(sp)
 65a:	ec5e                	sd	s7,24(sp)
 65c:	e862                	sd	s8,16(sp)
 65e:	e466                	sd	s9,8(sp)
 660:	8b2a                	mv	s6,a0
 662:	8a2e                	mv	s4,a1
 664:	8bb2                	mv	s7,a2
  state = 0;
 666:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 668:	4481                	li	s1,0
 66a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 66c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 670:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 674:	06c00c93          	li	s9,108
 678:	a005                	j	698 <vprintf+0x5a>
        putc(fd, c0);
 67a:	85ca                	mv	a1,s2
 67c:	855a                	mv	a0,s6
 67e:	efbff0ef          	jal	578 <putc>
 682:	a019                	j	688 <vprintf+0x4a>
    } else if(state == '%'){
 684:	03598263          	beq	s3,s5,6a8 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 688:	2485                	addiw	s1,s1,1
 68a:	8726                	mv	a4,s1
 68c:	009a07b3          	add	a5,s4,s1
 690:	0007c903          	lbu	s2,0(a5)
 694:	20090c63          	beqz	s2,8ac <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 698:	0009079b          	sext.w	a5,s2
    if(state == 0){
 69c:	fe0994e3          	bnez	s3,684 <vprintf+0x46>
      if(c0 == '%'){
 6a0:	fd579de3          	bne	a5,s5,67a <vprintf+0x3c>
        state = '%';
 6a4:	89be                	mv	s3,a5
 6a6:	b7cd                	j	688 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6a8:	00ea06b3          	add	a3,s4,a4
 6ac:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6b0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6b2:	c681                	beqz	a3,6ba <vprintf+0x7c>
 6b4:	9752                	add	a4,a4,s4
 6b6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6ba:	03878f63          	beq	a5,s8,6f8 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6be:	05978963          	beq	a5,s9,710 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6c2:	07500713          	li	a4,117
 6c6:	0ee78363          	beq	a5,a4,7ac <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6ca:	07800713          	li	a4,120
 6ce:	12e78563          	beq	a5,a4,7f8 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6d2:	07000713          	li	a4,112
 6d6:	14e78a63          	beq	a5,a4,82a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6da:	07300713          	li	a4,115
 6de:	18e78a63          	beq	a5,a4,872 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6e2:	02500713          	li	a4,37
 6e6:	04e79563          	bne	a5,a4,730 <vprintf+0xf2>
        putc(fd, '%');
 6ea:	02500593          	li	a1,37
 6ee:	855a                	mv	a0,s6
 6f0:	e89ff0ef          	jal	578 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	bf49                	j	688 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6f8:	008b8913          	addi	s2,s7,8
 6fc:	4685                	li	a3,1
 6fe:	4629                	li	a2,10
 700:	000ba583          	lw	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	e91ff0ef          	jal	596 <printint>
 70a:	8bca                	mv	s7,s2
      state = 0;
 70c:	4981                	li	s3,0
 70e:	bfad                	j	688 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 710:	06400793          	li	a5,100
 714:	02f68963          	beq	a3,a5,746 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 718:	06c00793          	li	a5,108
 71c:	04f68263          	beq	a3,a5,760 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 720:	07500793          	li	a5,117
 724:	0af68063          	beq	a3,a5,7c4 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 728:	07800793          	li	a5,120
 72c:	0ef68263          	beq	a3,a5,810 <vprintf+0x1d2>
        putc(fd, '%');
 730:	02500593          	li	a1,37
 734:	855a                	mv	a0,s6
 736:	e43ff0ef          	jal	578 <putc>
        putc(fd, c0);
 73a:	85ca                	mv	a1,s2
 73c:	855a                	mv	a0,s6
 73e:	e3bff0ef          	jal	578 <putc>
      state = 0;
 742:	4981                	li	s3,0
 744:	b791                	j	688 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 746:	008b8913          	addi	s2,s7,8
 74a:	4685                	li	a3,1
 74c:	4629                	li	a2,10
 74e:	000ba583          	lw	a1,0(s7)
 752:	855a                	mv	a0,s6
 754:	e43ff0ef          	jal	596 <printint>
        i += 1;
 758:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 75a:	8bca                	mv	s7,s2
      state = 0;
 75c:	4981                	li	s3,0
        i += 1;
 75e:	b72d                	j	688 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 760:	06400793          	li	a5,100
 764:	02f60763          	beq	a2,a5,792 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 768:	07500793          	li	a5,117
 76c:	06f60963          	beq	a2,a5,7de <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 770:	07800793          	li	a5,120
 774:	faf61ee3          	bne	a2,a5,730 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 778:	008b8913          	addi	s2,s7,8
 77c:	4681                	li	a3,0
 77e:	4641                	li	a2,16
 780:	000ba583          	lw	a1,0(s7)
 784:	855a                	mv	a0,s6
 786:	e11ff0ef          	jal	596 <printint>
        i += 2;
 78a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 78c:	8bca                	mv	s7,s2
      state = 0;
 78e:	4981                	li	s3,0
        i += 2;
 790:	bde5                	j	688 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 792:	008b8913          	addi	s2,s7,8
 796:	4685                	li	a3,1
 798:	4629                	li	a2,10
 79a:	000ba583          	lw	a1,0(s7)
 79e:	855a                	mv	a0,s6
 7a0:	df7ff0ef          	jal	596 <printint>
        i += 2;
 7a4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7a6:	8bca                	mv	s7,s2
      state = 0;
 7a8:	4981                	li	s3,0
        i += 2;
 7aa:	bdf9                	j	688 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7ac:	008b8913          	addi	s2,s7,8
 7b0:	4681                	li	a3,0
 7b2:	4629                	li	a2,10
 7b4:	000ba583          	lw	a1,0(s7)
 7b8:	855a                	mv	a0,s6
 7ba:	dddff0ef          	jal	596 <printint>
 7be:	8bca                	mv	s7,s2
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b5d9                	j	688 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c4:	008b8913          	addi	s2,s7,8
 7c8:	4681                	li	a3,0
 7ca:	4629                	li	a2,10
 7cc:	000ba583          	lw	a1,0(s7)
 7d0:	855a                	mv	a0,s6
 7d2:	dc5ff0ef          	jal	596 <printint>
        i += 1;
 7d6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d8:	8bca                	mv	s7,s2
      state = 0;
 7da:	4981                	li	s3,0
        i += 1;
 7dc:	b575                	j	688 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7de:	008b8913          	addi	s2,s7,8
 7e2:	4681                	li	a3,0
 7e4:	4629                	li	a2,10
 7e6:	000ba583          	lw	a1,0(s7)
 7ea:	855a                	mv	a0,s6
 7ec:	dabff0ef          	jal	596 <printint>
        i += 2;
 7f0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f2:	8bca                	mv	s7,s2
      state = 0;
 7f4:	4981                	li	s3,0
        i += 2;
 7f6:	bd49                	j	688 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7f8:	008b8913          	addi	s2,s7,8
 7fc:	4681                	li	a3,0
 7fe:	4641                	li	a2,16
 800:	000ba583          	lw	a1,0(s7)
 804:	855a                	mv	a0,s6
 806:	d91ff0ef          	jal	596 <printint>
 80a:	8bca                	mv	s7,s2
      state = 0;
 80c:	4981                	li	s3,0
 80e:	bdad                	j	688 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 810:	008b8913          	addi	s2,s7,8
 814:	4681                	li	a3,0
 816:	4641                	li	a2,16
 818:	000ba583          	lw	a1,0(s7)
 81c:	855a                	mv	a0,s6
 81e:	d79ff0ef          	jal	596 <printint>
        i += 1;
 822:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 824:	8bca                	mv	s7,s2
      state = 0;
 826:	4981                	li	s3,0
        i += 1;
 828:	b585                	j	688 <vprintf+0x4a>
 82a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 82c:	008b8d13          	addi	s10,s7,8
 830:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 834:	03000593          	li	a1,48
 838:	855a                	mv	a0,s6
 83a:	d3fff0ef          	jal	578 <putc>
  putc(fd, 'x');
 83e:	07800593          	li	a1,120
 842:	855a                	mv	a0,s6
 844:	d35ff0ef          	jal	578 <putc>
 848:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 84a:	00000b97          	auipc	s7,0x0
 84e:	266b8b93          	addi	s7,s7,614 # ab0 <digits>
 852:	03c9d793          	srli	a5,s3,0x3c
 856:	97de                	add	a5,a5,s7
 858:	0007c583          	lbu	a1,0(a5)
 85c:	855a                	mv	a0,s6
 85e:	d1bff0ef          	jal	578 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 862:	0992                	slli	s3,s3,0x4
 864:	397d                	addiw	s2,s2,-1
 866:	fe0916e3          	bnez	s2,852 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 86a:	8bea                	mv	s7,s10
      state = 0;
 86c:	4981                	li	s3,0
 86e:	6d02                	ld	s10,0(sp)
 870:	bd21                	j	688 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 872:	008b8993          	addi	s3,s7,8
 876:	000bb903          	ld	s2,0(s7)
 87a:	00090f63          	beqz	s2,898 <vprintf+0x25a>
        for(; *s; s++)
 87e:	00094583          	lbu	a1,0(s2)
 882:	c195                	beqz	a1,8a6 <vprintf+0x268>
          putc(fd, *s);
 884:	855a                	mv	a0,s6
 886:	cf3ff0ef          	jal	578 <putc>
        for(; *s; s++)
 88a:	0905                	addi	s2,s2,1
 88c:	00094583          	lbu	a1,0(s2)
 890:	f9f5                	bnez	a1,884 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 892:	8bce                	mv	s7,s3
      state = 0;
 894:	4981                	li	s3,0
 896:	bbcd                	j	688 <vprintf+0x4a>
          s = "(null)";
 898:	00000917          	auipc	s2,0x0
 89c:	21090913          	addi	s2,s2,528 # aa8 <malloc+0x104>
        for(; *s; s++)
 8a0:	02800593          	li	a1,40
 8a4:	b7c5                	j	884 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8a6:	8bce                	mv	s7,s3
      state = 0;
 8a8:	4981                	li	s3,0
 8aa:	bbf9                	j	688 <vprintf+0x4a>
 8ac:	64a6                	ld	s1,72(sp)
 8ae:	79e2                	ld	s3,56(sp)
 8b0:	7a42                	ld	s4,48(sp)
 8b2:	7aa2                	ld	s5,40(sp)
 8b4:	7b02                	ld	s6,32(sp)
 8b6:	6be2                	ld	s7,24(sp)
 8b8:	6c42                	ld	s8,16(sp)
 8ba:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8bc:	60e6                	ld	ra,88(sp)
 8be:	6446                	ld	s0,80(sp)
 8c0:	6906                	ld	s2,64(sp)
 8c2:	6125                	addi	sp,sp,96
 8c4:	8082                	ret

00000000000008c6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8c6:	715d                	addi	sp,sp,-80
 8c8:	ec06                	sd	ra,24(sp)
 8ca:	e822                	sd	s0,16(sp)
 8cc:	1000                	addi	s0,sp,32
 8ce:	e010                	sd	a2,0(s0)
 8d0:	e414                	sd	a3,8(s0)
 8d2:	e818                	sd	a4,16(s0)
 8d4:	ec1c                	sd	a5,24(s0)
 8d6:	03043023          	sd	a6,32(s0)
 8da:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8de:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8e2:	8622                	mv	a2,s0
 8e4:	d5bff0ef          	jal	63e <vprintf>
}
 8e8:	60e2                	ld	ra,24(sp)
 8ea:	6442                	ld	s0,16(sp)
 8ec:	6161                	addi	sp,sp,80
 8ee:	8082                	ret

00000000000008f0 <printf>:

void
printf(const char *fmt, ...)
{
 8f0:	711d                	addi	sp,sp,-96
 8f2:	ec06                	sd	ra,24(sp)
 8f4:	e822                	sd	s0,16(sp)
 8f6:	1000                	addi	s0,sp,32
 8f8:	e40c                	sd	a1,8(s0)
 8fa:	e810                	sd	a2,16(s0)
 8fc:	ec14                	sd	a3,24(s0)
 8fe:	f018                	sd	a4,32(s0)
 900:	f41c                	sd	a5,40(s0)
 902:	03043823          	sd	a6,48(s0)
 906:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 90a:	00840613          	addi	a2,s0,8
 90e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 912:	85aa                	mv	a1,a0
 914:	4505                	li	a0,1
 916:	d29ff0ef          	jal	63e <vprintf>
}
 91a:	60e2                	ld	ra,24(sp)
 91c:	6442                	ld	s0,16(sp)
 91e:	6125                	addi	sp,sp,96
 920:	8082                	ret

0000000000000922 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 922:	1141                	addi	sp,sp,-16
 924:	e422                	sd	s0,8(sp)
 926:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 928:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92c:	00000797          	auipc	a5,0x0
 930:	6e47b783          	ld	a5,1764(a5) # 1010 <freep>
 934:	a02d                	j	95e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 936:	4618                	lw	a4,8(a2)
 938:	9f2d                	addw	a4,a4,a1
 93a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 93e:	6398                	ld	a4,0(a5)
 940:	6310                	ld	a2,0(a4)
 942:	a83d                	j	980 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 944:	ff852703          	lw	a4,-8(a0)
 948:	9f31                	addw	a4,a4,a2
 94a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 94c:	ff053683          	ld	a3,-16(a0)
 950:	a091                	j	994 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 952:	6398                	ld	a4,0(a5)
 954:	00e7e463          	bltu	a5,a4,95c <free+0x3a>
 958:	00e6ea63          	bltu	a3,a4,96c <free+0x4a>
{
 95c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95e:	fed7fae3          	bgeu	a5,a3,952 <free+0x30>
 962:	6398                	ld	a4,0(a5)
 964:	00e6e463          	bltu	a3,a4,96c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 968:	fee7eae3          	bltu	a5,a4,95c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 96c:	ff852583          	lw	a1,-8(a0)
 970:	6390                	ld	a2,0(a5)
 972:	02059813          	slli	a6,a1,0x20
 976:	01c85713          	srli	a4,a6,0x1c
 97a:	9736                	add	a4,a4,a3
 97c:	fae60de3          	beq	a2,a4,936 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 980:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 984:	4790                	lw	a2,8(a5)
 986:	02061593          	slli	a1,a2,0x20
 98a:	01c5d713          	srli	a4,a1,0x1c
 98e:	973e                	add	a4,a4,a5
 990:	fae68ae3          	beq	a3,a4,944 <free+0x22>
    p->s.ptr = bp->s.ptr;
 994:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 996:	00000717          	auipc	a4,0x0
 99a:	66f73d23          	sd	a5,1658(a4) # 1010 <freep>
}
 99e:	6422                	ld	s0,8(sp)
 9a0:	0141                	addi	sp,sp,16
 9a2:	8082                	ret

00000000000009a4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9a4:	7139                	addi	sp,sp,-64
 9a6:	fc06                	sd	ra,56(sp)
 9a8:	f822                	sd	s0,48(sp)
 9aa:	f426                	sd	s1,40(sp)
 9ac:	ec4e                	sd	s3,24(sp)
 9ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b0:	02051493          	slli	s1,a0,0x20
 9b4:	9081                	srli	s1,s1,0x20
 9b6:	04bd                	addi	s1,s1,15
 9b8:	8091                	srli	s1,s1,0x4
 9ba:	0014899b          	addiw	s3,s1,1
 9be:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9c0:	00000517          	auipc	a0,0x0
 9c4:	65053503          	ld	a0,1616(a0) # 1010 <freep>
 9c8:	c915                	beqz	a0,9fc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9cc:	4798                	lw	a4,8(a5)
 9ce:	08977a63          	bgeu	a4,s1,a62 <malloc+0xbe>
 9d2:	f04a                	sd	s2,32(sp)
 9d4:	e852                	sd	s4,16(sp)
 9d6:	e456                	sd	s5,8(sp)
 9d8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9da:	8a4e                	mv	s4,s3
 9dc:	0009871b          	sext.w	a4,s3
 9e0:	6685                	lui	a3,0x1
 9e2:	00d77363          	bgeu	a4,a3,9e8 <malloc+0x44>
 9e6:	6a05                	lui	s4,0x1
 9e8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9ec:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9f0:	00000917          	auipc	s2,0x0
 9f4:	62090913          	addi	s2,s2,1568 # 1010 <freep>
  if(p == (char*)-1)
 9f8:	5afd                	li	s5,-1
 9fa:	a081                	j	a3a <malloc+0x96>
 9fc:	f04a                	sd	s2,32(sp)
 9fe:	e852                	sd	s4,16(sp)
 a00:	e456                	sd	s5,8(sp)
 a02:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a04:	00004797          	auipc	a5,0x4
 a08:	61c78793          	addi	a5,a5,1564 # 5020 <base>
 a0c:	00000717          	auipc	a4,0x0
 a10:	60f73223          	sd	a5,1540(a4) # 1010 <freep>
 a14:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a16:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a1a:	b7c1                	j	9da <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a1c:	6398                	ld	a4,0(a5)
 a1e:	e118                	sd	a4,0(a0)
 a20:	a8a9                	j	a7a <malloc+0xd6>
  hp->s.size = nu;
 a22:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a26:	0541                	addi	a0,a0,16
 a28:	efbff0ef          	jal	922 <free>
  return freep;
 a2c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a30:	c12d                	beqz	a0,a92 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a32:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a34:	4798                	lw	a4,8(a5)
 a36:	02977263          	bgeu	a4,s1,a5a <malloc+0xb6>
    if(p == freep)
 a3a:	00093703          	ld	a4,0(s2)
 a3e:	853e                	mv	a0,a5
 a40:	fef719e3          	bne	a4,a5,a32 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a44:	8552                	mv	a0,s4
 a46:	b1bff0ef          	jal	560 <sbrk>
  if(p == (char*)-1)
 a4a:	fd551ce3          	bne	a0,s5,a22 <malloc+0x7e>
        return 0;
 a4e:	4501                	li	a0,0
 a50:	7902                	ld	s2,32(sp)
 a52:	6a42                	ld	s4,16(sp)
 a54:	6aa2                	ld	s5,8(sp)
 a56:	6b02                	ld	s6,0(sp)
 a58:	a03d                	j	a86 <malloc+0xe2>
 a5a:	7902                	ld	s2,32(sp)
 a5c:	6a42                	ld	s4,16(sp)
 a5e:	6aa2                	ld	s5,8(sp)
 a60:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a62:	fae48de3          	beq	s1,a4,a1c <malloc+0x78>
        p->s.size -= nunits;
 a66:	4137073b          	subw	a4,a4,s3
 a6a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a6c:	02071693          	slli	a3,a4,0x20
 a70:	01c6d713          	srli	a4,a3,0x1c
 a74:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a76:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a7a:	00000717          	auipc	a4,0x0
 a7e:	58a73b23          	sd	a0,1430(a4) # 1010 <freep>
      return (void*)(p + 1);
 a82:	01078513          	addi	a0,a5,16
  }
}
 a86:	70e2                	ld	ra,56(sp)
 a88:	7442                	ld	s0,48(sp)
 a8a:	74a2                	ld	s1,40(sp)
 a8c:	69e2                	ld	s3,24(sp)
 a8e:	6121                	addi	sp,sp,64
 a90:	8082                	ret
 a92:	7902                	ld	s2,32(sp)
 a94:	6a42                	ld	s4,16(sp)
 a96:	6aa2                	ld	s5,8(sp)
 a98:	6b02                	ld	s6,0(sp)
 a9a:	b7f5                	j	a86 <malloc+0xe2>
