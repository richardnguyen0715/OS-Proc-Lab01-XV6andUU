
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main()
{   
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64

    int pipe_one[2];
    int pipe_two[2];  
    
    int check_pipe1 = pipe(pipe_one); // Create a parent-to-child pipe
   a:	fd840513          	addi	a0,s0,-40
   e:	372000ef          	jal	380 <pipe>
  12:	84aa                	mv	s1,a0
    int check_pipe2 = pipe(pipe_two); // Create a child-to-parent pipe
  14:	fd040513          	addi	a0,s0,-48
  18:	368000ef          	jal	380 <pipe>

    if (check_pipe1 == -1 || check_pipe2 == -1) {
  1c:	57fd                	li	a5,-1
  1e:	00f48463          	beq	s1,a5,26 <main+0x26>
  22:	00f51b63          	bne	a0,a5,38 <main+0x38>
        printf("Cannot create pipe! - Error: pipe() function failed!");
  26:	00001517          	auipc	a0,0x1
  2a:	91a50513          	addi	a0,a0,-1766 # 940 <malloc+0x104>
  2e:	75a000ef          	jal	788 <printf>
        exit(1);
  32:	4505                	li	a0,1
  34:	33c000ef          	jal	370 <exit>
    }

    int proc = fork();
  38:	330000ef          	jal	368 <fork>
    if (proc < 0) {
  3c:	04054d63          	bltz	a0,96 <main+0x96>
        printf("Cannot create process! - Error: fork() function failed!");
        exit(1);   
    }
    else if (proc == 0) { // Child process
  40:	e525                	bnez	a0,a8 <main+0xa8>
        char mess;

        close(pipe_one[1]); // Close the write end of parent-to-child pipe
  42:	fdc42503          	lw	a0,-36(s0)
  46:	352000ef          	jal	398 <close>
        read(pipe_one[0], &mess, 1); // Read from parent-to-child pipe
  4a:	4605                	li	a2,1
  4c:	fcf40593          	addi	a1,s0,-49
  50:	fd842503          	lw	a0,-40(s0)
  54:	334000ef          	jal	388 <read>

        printf("%d: received ping\n", getpid());
  58:	398000ef          	jal	3f0 <getpid>
  5c:	85aa                	mv	a1,a0
  5e:	00001517          	auipc	a0,0x1
  62:	95a50513          	addi	a0,a0,-1702 # 9b8 <malloc+0x17c>
  66:	722000ef          	jal	788 <printf>
        
        close(pipe_one[0]); // Close the read end of parent-to-child pipe
  6a:	fd842503          	lw	a0,-40(s0)
  6e:	32a000ef          	jal	398 <close>

        close(pipe_two[0]); // Close the read end of child-to-parent pipe
  72:	fd042503          	lw	a0,-48(s0)
  76:	322000ef          	jal	398 <close>
        write(pipe_two[1], &mess, 1); // Write to child-to-parent pipe
  7a:	4605                	li	a2,1
  7c:	fcf40593          	addi	a1,s0,-49
  80:	fd442503          	lw	a0,-44(s0)
  84:	30c000ef          	jal	390 <write>
        close(pipe_two[1]); // Close the write end of child-to-parent pipe
  88:	fd442503          	lw	a0,-44(s0)
  8c:	30c000ef          	jal	398 <close>
        
        close(pipe_two[0]); // Close the read end of child-to-parent pipe
    
        wait(0); // Wait for child process to finish
    }
    exit(0);
  90:	4501                	li	a0,0
  92:	2de000ef          	jal	370 <exit>
        printf("Cannot create process! - Error: fork() function failed!");
  96:	00001517          	auipc	a0,0x1
  9a:	8ea50513          	addi	a0,a0,-1814 # 980 <malloc+0x144>
  9e:	6ea000ef          	jal	788 <printf>
        exit(1);   
  a2:	4505                	li	a0,1
  a4:	2cc000ef          	jal	370 <exit>
        char mess = 'T'; // Correct assignment for char type
  a8:	05400793          	li	a5,84
  ac:	fcf407a3          	sb	a5,-49(s0)
        close(pipe_one[0]); // Close the read end of parent-to-child pipe
  b0:	fd842503          	lw	a0,-40(s0)
  b4:	2e4000ef          	jal	398 <close>
        write(pipe_one[1], &mess, 1); // Write to parent-to-child pipe
  b8:	4605                	li	a2,1
  ba:	fcf40593          	addi	a1,s0,-49
  be:	fdc42503          	lw	a0,-36(s0)
  c2:	2ce000ef          	jal	390 <write>
        close(pipe_one[1]); // Close the write end of parent-to-child pipe
  c6:	fdc42503          	lw	a0,-36(s0)
  ca:	2ce000ef          	jal	398 <close>
        close(pipe_two[1]); // Close the write end of child-to-parent pipe
  ce:	fd442503          	lw	a0,-44(s0)
  d2:	2c6000ef          	jal	398 <close>
        read(pipe_two[0], &mess, 1); // Read from child-to-parent pipe
  d6:	4605                	li	a2,1
  d8:	fcf40593          	addi	a1,s0,-49
  dc:	fd042503          	lw	a0,-48(s0)
  e0:	2a8000ef          	jal	388 <read>
        printf("%d: received pong\n", getpid());
  e4:	30c000ef          	jal	3f0 <getpid>
  e8:	85aa                	mv	a1,a0
  ea:	00001517          	auipc	a0,0x1
  ee:	8e650513          	addi	a0,a0,-1818 # 9d0 <malloc+0x194>
  f2:	696000ef          	jal	788 <printf>
        close(pipe_two[0]); // Close the read end of child-to-parent pipe
  f6:	fd042503          	lw	a0,-48(s0)
  fa:	29e000ef          	jal	398 <close>
        wait(0); // Wait for child process to finish
  fe:	4501                	li	a0,0
 100:	278000ef          	jal	378 <wait>
 104:	b771                	j	90 <main+0x90>

0000000000000106 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 10e:	ef3ff0ef          	jal	0 <main>
  exit(0);
 112:	4501                	li	a0,0
 114:	25c000ef          	jal	370 <exit>

0000000000000118 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e422                	sd	s0,8(sp)
 11c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11e:	87aa                	mv	a5,a0
 120:	0585                	addi	a1,a1,1
 122:	0785                	addi	a5,a5,1
 124:	fff5c703          	lbu	a4,-1(a1)
 128:	fee78fa3          	sb	a4,-1(a5)
 12c:	fb75                	bnez	a4,120 <strcpy+0x8>
    ;
  return os;
}
 12e:	6422                	ld	s0,8(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret

0000000000000134 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 134:	1141                	addi	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cb91                	beqz	a5,152 <strcmp+0x1e>
 140:	0005c703          	lbu	a4,0(a1)
 144:	00f71763          	bne	a4,a5,152 <strcmp+0x1e>
    p++, q++;
 148:	0505                	addi	a0,a0,1
 14a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 14c:	00054783          	lbu	a5,0(a0)
 150:	fbe5                	bnez	a5,140 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 152:	0005c503          	lbu	a0,0(a1)
}
 156:	40a7853b          	subw	a0,a5,a0
 15a:	6422                	ld	s0,8(sp)
 15c:	0141                	addi	sp,sp,16
 15e:	8082                	ret

0000000000000160 <strlen>:

uint
strlen(const char *s)
{
 160:	1141                	addi	sp,sp,-16
 162:	e422                	sd	s0,8(sp)
 164:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 166:	00054783          	lbu	a5,0(a0)
 16a:	cf91                	beqz	a5,186 <strlen+0x26>
 16c:	0505                	addi	a0,a0,1
 16e:	87aa                	mv	a5,a0
 170:	86be                	mv	a3,a5
 172:	0785                	addi	a5,a5,1
 174:	fff7c703          	lbu	a4,-1(a5)
 178:	ff65                	bnez	a4,170 <strlen+0x10>
 17a:	40a6853b          	subw	a0,a3,a0
 17e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 180:	6422                	ld	s0,8(sp)
 182:	0141                	addi	sp,sp,16
 184:	8082                	ret
  for(n = 0; s[n]; n++)
 186:	4501                	li	a0,0
 188:	bfe5                	j	180 <strlen+0x20>

000000000000018a <memset>:

void*
memset(void *dst, int c, uint n)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 190:	ca19                	beqz	a2,1a6 <memset+0x1c>
 192:	87aa                	mv	a5,a0
 194:	1602                	slli	a2,a2,0x20
 196:	9201                	srli	a2,a2,0x20
 198:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 19c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a0:	0785                	addi	a5,a5,1
 1a2:	fee79de3          	bne	a5,a4,19c <memset+0x12>
  }
  return dst;
}
 1a6:	6422                	ld	s0,8(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret

00000000000001ac <strchr>:

char*
strchr(const char *s, char c)
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e422                	sd	s0,8(sp)
 1b0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	cb99                	beqz	a5,1cc <strchr+0x20>
    if(*s == c)
 1b8:	00f58763          	beq	a1,a5,1c6 <strchr+0x1a>
  for(; *s; s++)
 1bc:	0505                	addi	a0,a0,1
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	fbfd                	bnez	a5,1b8 <strchr+0xc>
      return (char*)s;
  return 0;
 1c4:	4501                	li	a0,0
}
 1c6:	6422                	ld	s0,8(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret
  return 0;
 1cc:	4501                	li	a0,0
 1ce:	bfe5                	j	1c6 <strchr+0x1a>

00000000000001d0 <gets>:

char*
gets(char *buf, int max)
{
 1d0:	711d                	addi	sp,sp,-96
 1d2:	ec86                	sd	ra,88(sp)
 1d4:	e8a2                	sd	s0,80(sp)
 1d6:	e4a6                	sd	s1,72(sp)
 1d8:	e0ca                	sd	s2,64(sp)
 1da:	fc4e                	sd	s3,56(sp)
 1dc:	f852                	sd	s4,48(sp)
 1de:	f456                	sd	s5,40(sp)
 1e0:	f05a                	sd	s6,32(sp)
 1e2:	ec5e                	sd	s7,24(sp)
 1e4:	1080                	addi	s0,sp,96
 1e6:	8baa                	mv	s7,a0
 1e8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ea:	892a                	mv	s2,a0
 1ec:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ee:	4aa9                	li	s5,10
 1f0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1f2:	89a6                	mv	s3,s1
 1f4:	2485                	addiw	s1,s1,1
 1f6:	0344d663          	bge	s1,s4,222 <gets+0x52>
    cc = read(0, &c, 1);
 1fa:	4605                	li	a2,1
 1fc:	faf40593          	addi	a1,s0,-81
 200:	4501                	li	a0,0
 202:	186000ef          	jal	388 <read>
    if(cc < 1)
 206:	00a05e63          	blez	a0,222 <gets+0x52>
    buf[i++] = c;
 20a:	faf44783          	lbu	a5,-81(s0)
 20e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 212:	01578763          	beq	a5,s5,220 <gets+0x50>
 216:	0905                	addi	s2,s2,1
 218:	fd679de3          	bne	a5,s6,1f2 <gets+0x22>
    buf[i++] = c;
 21c:	89a6                	mv	s3,s1
 21e:	a011                	j	222 <gets+0x52>
 220:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 222:	99de                	add	s3,s3,s7
 224:	00098023          	sb	zero,0(s3)
  return buf;
}
 228:	855e                	mv	a0,s7
 22a:	60e6                	ld	ra,88(sp)
 22c:	6446                	ld	s0,80(sp)
 22e:	64a6                	ld	s1,72(sp)
 230:	6906                	ld	s2,64(sp)
 232:	79e2                	ld	s3,56(sp)
 234:	7a42                	ld	s4,48(sp)
 236:	7aa2                	ld	s5,40(sp)
 238:	7b02                	ld	s6,32(sp)
 23a:	6be2                	ld	s7,24(sp)
 23c:	6125                	addi	sp,sp,96
 23e:	8082                	ret

0000000000000240 <stat>:

int
stat(const char *n, struct stat *st)
{
 240:	1101                	addi	sp,sp,-32
 242:	ec06                	sd	ra,24(sp)
 244:	e822                	sd	s0,16(sp)
 246:	e04a                	sd	s2,0(sp)
 248:	1000                	addi	s0,sp,32
 24a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24c:	4581                	li	a1,0
 24e:	162000ef          	jal	3b0 <open>
  if(fd < 0)
 252:	02054263          	bltz	a0,276 <stat+0x36>
 256:	e426                	sd	s1,8(sp)
 258:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25a:	85ca                	mv	a1,s2
 25c:	16c000ef          	jal	3c8 <fstat>
 260:	892a                	mv	s2,a0
  close(fd);
 262:	8526                	mv	a0,s1
 264:	134000ef          	jal	398 <close>
  return r;
 268:	64a2                	ld	s1,8(sp)
}
 26a:	854a                	mv	a0,s2
 26c:	60e2                	ld	ra,24(sp)
 26e:	6442                	ld	s0,16(sp)
 270:	6902                	ld	s2,0(sp)
 272:	6105                	addi	sp,sp,32
 274:	8082                	ret
    return -1;
 276:	597d                	li	s2,-1
 278:	bfcd                	j	26a <stat+0x2a>

000000000000027a <atoi>:

int
atoi(const char *s)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 280:	00054683          	lbu	a3,0(a0)
 284:	fd06879b          	addiw	a5,a3,-48
 288:	0ff7f793          	zext.b	a5,a5
 28c:	4625                	li	a2,9
 28e:	02f66863          	bltu	a2,a5,2be <atoi+0x44>
 292:	872a                	mv	a4,a0
  n = 0;
 294:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 296:	0705                	addi	a4,a4,1
 298:	0025179b          	slliw	a5,a0,0x2
 29c:	9fa9                	addw	a5,a5,a0
 29e:	0017979b          	slliw	a5,a5,0x1
 2a2:	9fb5                	addw	a5,a5,a3
 2a4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2a8:	00074683          	lbu	a3,0(a4)
 2ac:	fd06879b          	addiw	a5,a3,-48
 2b0:	0ff7f793          	zext.b	a5,a5
 2b4:	fef671e3          	bgeu	a2,a5,296 <atoi+0x1c>
  return n;
}
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret
  n = 0;
 2be:	4501                	li	a0,0
 2c0:	bfe5                	j	2b8 <atoi+0x3e>

00000000000002c2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c8:	02b57463          	bgeu	a0,a1,2f0 <memmove+0x2e>
    while(n-- > 0)
 2cc:	00c05f63          	blez	a2,2ea <memmove+0x28>
 2d0:	1602                	slli	a2,a2,0x20
 2d2:	9201                	srli	a2,a2,0x20
 2d4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2da:	0585                	addi	a1,a1,1
 2dc:	0705                	addi	a4,a4,1
 2de:	fff5c683          	lbu	a3,-1(a1)
 2e2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2e6:	fef71ae3          	bne	a4,a5,2da <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret
    dst += n;
 2f0:	00c50733          	add	a4,a0,a2
    src += n;
 2f4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2f6:	fec05ae3          	blez	a2,2ea <memmove+0x28>
 2fa:	fff6079b          	addiw	a5,a2,-1
 2fe:	1782                	slli	a5,a5,0x20
 300:	9381                	srli	a5,a5,0x20
 302:	fff7c793          	not	a5,a5
 306:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 308:	15fd                	addi	a1,a1,-1
 30a:	177d                	addi	a4,a4,-1
 30c:	0005c683          	lbu	a3,0(a1)
 310:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 314:	fee79ae3          	bne	a5,a4,308 <memmove+0x46>
 318:	bfc9                	j	2ea <memmove+0x28>

000000000000031a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 31a:	1141                	addi	sp,sp,-16
 31c:	e422                	sd	s0,8(sp)
 31e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 320:	ca05                	beqz	a2,350 <memcmp+0x36>
 322:	fff6069b          	addiw	a3,a2,-1
 326:	1682                	slli	a3,a3,0x20
 328:	9281                	srli	a3,a3,0x20
 32a:	0685                	addi	a3,a3,1
 32c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 32e:	00054783          	lbu	a5,0(a0)
 332:	0005c703          	lbu	a4,0(a1)
 336:	00e79863          	bne	a5,a4,346 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 33a:	0505                	addi	a0,a0,1
    p2++;
 33c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 33e:	fed518e3          	bne	a0,a3,32e <memcmp+0x14>
  }
  return 0;
 342:	4501                	li	a0,0
 344:	a019                	j	34a <memcmp+0x30>
      return *p1 - *p2;
 346:	40e7853b          	subw	a0,a5,a4
}
 34a:	6422                	ld	s0,8(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret
  return 0;
 350:	4501                	li	a0,0
 352:	bfe5                	j	34a <memcmp+0x30>

0000000000000354 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 354:	1141                	addi	sp,sp,-16
 356:	e406                	sd	ra,8(sp)
 358:	e022                	sd	s0,0(sp)
 35a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 35c:	f67ff0ef          	jal	2c2 <memmove>
}
 360:	60a2                	ld	ra,8(sp)
 362:	6402                	ld	s0,0(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret

0000000000000368 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 368:	4885                	li	a7,1
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <exit>:
.global exit
exit:
 li a7, SYS_exit
 370:	4889                	li	a7,2
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <wait>:
.global wait
wait:
 li a7, SYS_wait
 378:	488d                	li	a7,3
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 380:	4891                	li	a7,4
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <read>:
.global read
read:
 li a7, SYS_read
 388:	4895                	li	a7,5
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <write>:
.global write
write:
 li a7, SYS_write
 390:	48c1                	li	a7,16
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <close>:
.global close
close:
 li a7, SYS_close
 398:	48d5                	li	a7,21
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3a0:	4899                	li	a7,6
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3a8:	489d                	li	a7,7
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <open>:
.global open
open:
 li a7, SYS_open
 3b0:	48bd                	li	a7,15
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3b8:	48c5                	li	a7,17
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3c0:	48c9                	li	a7,18
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3c8:	48a1                	li	a7,8
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <link>:
.global link
link:
 li a7, SYS_link
 3d0:	48cd                	li	a7,19
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3d8:	48d1                	li	a7,20
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3e0:	48a5                	li	a7,9
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3e8:	48a9                	li	a7,10
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3f0:	48ad                	li	a7,11
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3f8:	48b1                	li	a7,12
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 400:	48b5                	li	a7,13
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 408:	48b9                	li	a7,14
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 410:	1101                	addi	sp,sp,-32
 412:	ec06                	sd	ra,24(sp)
 414:	e822                	sd	s0,16(sp)
 416:	1000                	addi	s0,sp,32
 418:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 41c:	4605                	li	a2,1
 41e:	fef40593          	addi	a1,s0,-17
 422:	f6fff0ef          	jal	390 <write>
}
 426:	60e2                	ld	ra,24(sp)
 428:	6442                	ld	s0,16(sp)
 42a:	6105                	addi	sp,sp,32
 42c:	8082                	ret

000000000000042e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42e:	7139                	addi	sp,sp,-64
 430:	fc06                	sd	ra,56(sp)
 432:	f822                	sd	s0,48(sp)
 434:	f426                	sd	s1,40(sp)
 436:	0080                	addi	s0,sp,64
 438:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43a:	c299                	beqz	a3,440 <printint+0x12>
 43c:	0805c963          	bltz	a1,4ce <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 440:	2581                	sext.w	a1,a1
  neg = 0;
 442:	4881                	li	a7,0
 444:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 448:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 44a:	2601                	sext.w	a2,a2
 44c:	00000517          	auipc	a0,0x0
 450:	5a450513          	addi	a0,a0,1444 # 9f0 <digits>
 454:	883a                	mv	a6,a4
 456:	2705                	addiw	a4,a4,1
 458:	02c5f7bb          	remuw	a5,a1,a2
 45c:	1782                	slli	a5,a5,0x20
 45e:	9381                	srli	a5,a5,0x20
 460:	97aa                	add	a5,a5,a0
 462:	0007c783          	lbu	a5,0(a5)
 466:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 46a:	0005879b          	sext.w	a5,a1
 46e:	02c5d5bb          	divuw	a1,a1,a2
 472:	0685                	addi	a3,a3,1
 474:	fec7f0e3          	bgeu	a5,a2,454 <printint+0x26>
  if(neg)
 478:	00088c63          	beqz	a7,490 <printint+0x62>
    buf[i++] = '-';
 47c:	fd070793          	addi	a5,a4,-48
 480:	00878733          	add	a4,a5,s0
 484:	02d00793          	li	a5,45
 488:	fef70823          	sb	a5,-16(a4)
 48c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 490:	02e05a63          	blez	a4,4c4 <printint+0x96>
 494:	f04a                	sd	s2,32(sp)
 496:	ec4e                	sd	s3,24(sp)
 498:	fc040793          	addi	a5,s0,-64
 49c:	00e78933          	add	s2,a5,a4
 4a0:	fff78993          	addi	s3,a5,-1
 4a4:	99ba                	add	s3,s3,a4
 4a6:	377d                	addiw	a4,a4,-1
 4a8:	1702                	slli	a4,a4,0x20
 4aa:	9301                	srli	a4,a4,0x20
 4ac:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4b0:	fff94583          	lbu	a1,-1(s2)
 4b4:	8526                	mv	a0,s1
 4b6:	f5bff0ef          	jal	410 <putc>
  while(--i >= 0)
 4ba:	197d                	addi	s2,s2,-1
 4bc:	ff391ae3          	bne	s2,s3,4b0 <printint+0x82>
 4c0:	7902                	ld	s2,32(sp)
 4c2:	69e2                	ld	s3,24(sp)
}
 4c4:	70e2                	ld	ra,56(sp)
 4c6:	7442                	ld	s0,48(sp)
 4c8:	74a2                	ld	s1,40(sp)
 4ca:	6121                	addi	sp,sp,64
 4cc:	8082                	ret
    x = -xx;
 4ce:	40b005bb          	negw	a1,a1
    neg = 1;
 4d2:	4885                	li	a7,1
    x = -xx;
 4d4:	bf85                	j	444 <printint+0x16>

00000000000004d6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d6:	711d                	addi	sp,sp,-96
 4d8:	ec86                	sd	ra,88(sp)
 4da:	e8a2                	sd	s0,80(sp)
 4dc:	e0ca                	sd	s2,64(sp)
 4de:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4e0:	0005c903          	lbu	s2,0(a1)
 4e4:	26090863          	beqz	s2,754 <vprintf+0x27e>
 4e8:	e4a6                	sd	s1,72(sp)
 4ea:	fc4e                	sd	s3,56(sp)
 4ec:	f852                	sd	s4,48(sp)
 4ee:	f456                	sd	s5,40(sp)
 4f0:	f05a                	sd	s6,32(sp)
 4f2:	ec5e                	sd	s7,24(sp)
 4f4:	e862                	sd	s8,16(sp)
 4f6:	e466                	sd	s9,8(sp)
 4f8:	8b2a                	mv	s6,a0
 4fa:	8a2e                	mv	s4,a1
 4fc:	8bb2                	mv	s7,a2
  state = 0;
 4fe:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 500:	4481                	li	s1,0
 502:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 504:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 508:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 50c:	06c00c93          	li	s9,108
 510:	a005                	j	530 <vprintf+0x5a>
        putc(fd, c0);
 512:	85ca                	mv	a1,s2
 514:	855a                	mv	a0,s6
 516:	efbff0ef          	jal	410 <putc>
 51a:	a019                	j	520 <vprintf+0x4a>
    } else if(state == '%'){
 51c:	03598263          	beq	s3,s5,540 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 520:	2485                	addiw	s1,s1,1
 522:	8726                	mv	a4,s1
 524:	009a07b3          	add	a5,s4,s1
 528:	0007c903          	lbu	s2,0(a5)
 52c:	20090c63          	beqz	s2,744 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 530:	0009079b          	sext.w	a5,s2
    if(state == 0){
 534:	fe0994e3          	bnez	s3,51c <vprintf+0x46>
      if(c0 == '%'){
 538:	fd579de3          	bne	a5,s5,512 <vprintf+0x3c>
        state = '%';
 53c:	89be                	mv	s3,a5
 53e:	b7cd                	j	520 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 540:	00ea06b3          	add	a3,s4,a4
 544:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 548:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 54a:	c681                	beqz	a3,552 <vprintf+0x7c>
 54c:	9752                	add	a4,a4,s4
 54e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 552:	03878f63          	beq	a5,s8,590 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 556:	05978963          	beq	a5,s9,5a8 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 55a:	07500713          	li	a4,117
 55e:	0ee78363          	beq	a5,a4,644 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 562:	07800713          	li	a4,120
 566:	12e78563          	beq	a5,a4,690 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 56a:	07000713          	li	a4,112
 56e:	14e78a63          	beq	a5,a4,6c2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 572:	07300713          	li	a4,115
 576:	18e78a63          	beq	a5,a4,70a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 57a:	02500713          	li	a4,37
 57e:	04e79563          	bne	a5,a4,5c8 <vprintf+0xf2>
        putc(fd, '%');
 582:	02500593          	li	a1,37
 586:	855a                	mv	a0,s6
 588:	e89ff0ef          	jal	410 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 58c:	4981                	li	s3,0
 58e:	bf49                	j	520 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 590:	008b8913          	addi	s2,s7,8
 594:	4685                	li	a3,1
 596:	4629                	li	a2,10
 598:	000ba583          	lw	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	e91ff0ef          	jal	42e <printint>
 5a2:	8bca                	mv	s7,s2
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	bfad                	j	520 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5a8:	06400793          	li	a5,100
 5ac:	02f68963          	beq	a3,a5,5de <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b0:	06c00793          	li	a5,108
 5b4:	04f68263          	beq	a3,a5,5f8 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5b8:	07500793          	li	a5,117
 5bc:	0af68063          	beq	a3,a5,65c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5c0:	07800793          	li	a5,120
 5c4:	0ef68263          	beq	a3,a5,6a8 <vprintf+0x1d2>
        putc(fd, '%');
 5c8:	02500593          	li	a1,37
 5cc:	855a                	mv	a0,s6
 5ce:	e43ff0ef          	jal	410 <putc>
        putc(fd, c0);
 5d2:	85ca                	mv	a1,s2
 5d4:	855a                	mv	a0,s6
 5d6:	e3bff0ef          	jal	410 <putc>
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	b791                	j	520 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5de:	008b8913          	addi	s2,s7,8
 5e2:	4685                	li	a3,1
 5e4:	4629                	li	a2,10
 5e6:	000ba583          	lw	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	e43ff0ef          	jal	42e <printint>
        i += 1;
 5f0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f2:	8bca                	mv	s7,s2
      state = 0;
 5f4:	4981                	li	s3,0
        i += 1;
 5f6:	b72d                	j	520 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5f8:	06400793          	li	a5,100
 5fc:	02f60763          	beq	a2,a5,62a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 600:	07500793          	li	a5,117
 604:	06f60963          	beq	a2,a5,676 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 608:	07800793          	li	a5,120
 60c:	faf61ee3          	bne	a2,a5,5c8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 610:	008b8913          	addi	s2,s7,8
 614:	4681                	li	a3,0
 616:	4641                	li	a2,16
 618:	000ba583          	lw	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	e11ff0ef          	jal	42e <printint>
        i += 2;
 622:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 624:	8bca                	mv	s7,s2
      state = 0;
 626:	4981                	li	s3,0
        i += 2;
 628:	bde5                	j	520 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 62a:	008b8913          	addi	s2,s7,8
 62e:	4685                	li	a3,1
 630:	4629                	li	a2,10
 632:	000ba583          	lw	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	df7ff0ef          	jal	42e <printint>
        i += 2;
 63c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
        i += 2;
 642:	bdf9                	j	520 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 644:	008b8913          	addi	s2,s7,8
 648:	4681                	li	a3,0
 64a:	4629                	li	a2,10
 64c:	000ba583          	lw	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	dddff0ef          	jal	42e <printint>
 656:	8bca                	mv	s7,s2
      state = 0;
 658:	4981                	li	s3,0
 65a:	b5d9                	j	520 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65c:	008b8913          	addi	s2,s7,8
 660:	4681                	li	a3,0
 662:	4629                	li	a2,10
 664:	000ba583          	lw	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	dc5ff0ef          	jal	42e <printint>
        i += 1;
 66e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 670:	8bca                	mv	s7,s2
      state = 0;
 672:	4981                	li	s3,0
        i += 1;
 674:	b575                	j	520 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 676:	008b8913          	addi	s2,s7,8
 67a:	4681                	li	a3,0
 67c:	4629                	li	a2,10
 67e:	000ba583          	lw	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	dabff0ef          	jal	42e <printint>
        i += 2;
 688:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 68a:	8bca                	mv	s7,s2
      state = 0;
 68c:	4981                	li	s3,0
        i += 2;
 68e:	bd49                	j	520 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 690:	008b8913          	addi	s2,s7,8
 694:	4681                	li	a3,0
 696:	4641                	li	a2,16
 698:	000ba583          	lw	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	d91ff0ef          	jal	42e <printint>
 6a2:	8bca                	mv	s7,s2
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bdad                	j	520 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a8:	008b8913          	addi	s2,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4641                	li	a2,16
 6b0:	000ba583          	lw	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	d79ff0ef          	jal	42e <printint>
        i += 1;
 6ba:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6bc:	8bca                	mv	s7,s2
      state = 0;
 6be:	4981                	li	s3,0
        i += 1;
 6c0:	b585                	j	520 <vprintf+0x4a>
 6c2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6c4:	008b8d13          	addi	s10,s7,8
 6c8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6cc:	03000593          	li	a1,48
 6d0:	855a                	mv	a0,s6
 6d2:	d3fff0ef          	jal	410 <putc>
  putc(fd, 'x');
 6d6:	07800593          	li	a1,120
 6da:	855a                	mv	a0,s6
 6dc:	d35ff0ef          	jal	410 <putc>
 6e0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e2:	00000b97          	auipc	s7,0x0
 6e6:	30eb8b93          	addi	s7,s7,782 # 9f0 <digits>
 6ea:	03c9d793          	srli	a5,s3,0x3c
 6ee:	97de                	add	a5,a5,s7
 6f0:	0007c583          	lbu	a1,0(a5)
 6f4:	855a                	mv	a0,s6
 6f6:	d1bff0ef          	jal	410 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6fa:	0992                	slli	s3,s3,0x4
 6fc:	397d                	addiw	s2,s2,-1
 6fe:	fe0916e3          	bnez	s2,6ea <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 702:	8bea                	mv	s7,s10
      state = 0;
 704:	4981                	li	s3,0
 706:	6d02                	ld	s10,0(sp)
 708:	bd21                	j	520 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 70a:	008b8993          	addi	s3,s7,8
 70e:	000bb903          	ld	s2,0(s7)
 712:	00090f63          	beqz	s2,730 <vprintf+0x25a>
        for(; *s; s++)
 716:	00094583          	lbu	a1,0(s2)
 71a:	c195                	beqz	a1,73e <vprintf+0x268>
          putc(fd, *s);
 71c:	855a                	mv	a0,s6
 71e:	cf3ff0ef          	jal	410 <putc>
        for(; *s; s++)
 722:	0905                	addi	s2,s2,1
 724:	00094583          	lbu	a1,0(s2)
 728:	f9f5                	bnez	a1,71c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 72a:	8bce                	mv	s7,s3
      state = 0;
 72c:	4981                	li	s3,0
 72e:	bbcd                	j	520 <vprintf+0x4a>
          s = "(null)";
 730:	00000917          	auipc	s2,0x0
 734:	2b890913          	addi	s2,s2,696 # 9e8 <malloc+0x1ac>
        for(; *s; s++)
 738:	02800593          	li	a1,40
 73c:	b7c5                	j	71c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 73e:	8bce                	mv	s7,s3
      state = 0;
 740:	4981                	li	s3,0
 742:	bbf9                	j	520 <vprintf+0x4a>
 744:	64a6                	ld	s1,72(sp)
 746:	79e2                	ld	s3,56(sp)
 748:	7a42                	ld	s4,48(sp)
 74a:	7aa2                	ld	s5,40(sp)
 74c:	7b02                	ld	s6,32(sp)
 74e:	6be2                	ld	s7,24(sp)
 750:	6c42                	ld	s8,16(sp)
 752:	6ca2                	ld	s9,8(sp)
    }
  }
}
 754:	60e6                	ld	ra,88(sp)
 756:	6446                	ld	s0,80(sp)
 758:	6906                	ld	s2,64(sp)
 75a:	6125                	addi	sp,sp,96
 75c:	8082                	ret

000000000000075e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 75e:	715d                	addi	sp,sp,-80
 760:	ec06                	sd	ra,24(sp)
 762:	e822                	sd	s0,16(sp)
 764:	1000                	addi	s0,sp,32
 766:	e010                	sd	a2,0(s0)
 768:	e414                	sd	a3,8(s0)
 76a:	e818                	sd	a4,16(s0)
 76c:	ec1c                	sd	a5,24(s0)
 76e:	03043023          	sd	a6,32(s0)
 772:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 776:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 77a:	8622                	mv	a2,s0
 77c:	d5bff0ef          	jal	4d6 <vprintf>
}
 780:	60e2                	ld	ra,24(sp)
 782:	6442                	ld	s0,16(sp)
 784:	6161                	addi	sp,sp,80
 786:	8082                	ret

0000000000000788 <printf>:

void
printf(const char *fmt, ...)
{
 788:	711d                	addi	sp,sp,-96
 78a:	ec06                	sd	ra,24(sp)
 78c:	e822                	sd	s0,16(sp)
 78e:	1000                	addi	s0,sp,32
 790:	e40c                	sd	a1,8(s0)
 792:	e810                	sd	a2,16(s0)
 794:	ec14                	sd	a3,24(s0)
 796:	f018                	sd	a4,32(s0)
 798:	f41c                	sd	a5,40(s0)
 79a:	03043823          	sd	a6,48(s0)
 79e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a2:	00840613          	addi	a2,s0,8
 7a6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7aa:	85aa                	mv	a1,a0
 7ac:	4505                	li	a0,1
 7ae:	d29ff0ef          	jal	4d6 <vprintf>
}
 7b2:	60e2                	ld	ra,24(sp)
 7b4:	6442                	ld	s0,16(sp)
 7b6:	6125                	addi	sp,sp,96
 7b8:	8082                	ret

00000000000007ba <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ba:	1141                	addi	sp,sp,-16
 7bc:	e422                	sd	s0,8(sp)
 7be:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c4:	00001797          	auipc	a5,0x1
 7c8:	83c7b783          	ld	a5,-1988(a5) # 1000 <freep>
 7cc:	a02d                	j	7f6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ce:	4618                	lw	a4,8(a2)
 7d0:	9f2d                	addw	a4,a4,a1
 7d2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d6:	6398                	ld	a4,0(a5)
 7d8:	6310                	ld	a2,0(a4)
 7da:	a83d                	j	818 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7dc:	ff852703          	lw	a4,-8(a0)
 7e0:	9f31                	addw	a4,a4,a2
 7e2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7e4:	ff053683          	ld	a3,-16(a0)
 7e8:	a091                	j	82c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ea:	6398                	ld	a4,0(a5)
 7ec:	00e7e463          	bltu	a5,a4,7f4 <free+0x3a>
 7f0:	00e6ea63          	bltu	a3,a4,804 <free+0x4a>
{
 7f4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f6:	fed7fae3          	bgeu	a5,a3,7ea <free+0x30>
 7fa:	6398                	ld	a4,0(a5)
 7fc:	00e6e463          	bltu	a3,a4,804 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 800:	fee7eae3          	bltu	a5,a4,7f4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 804:	ff852583          	lw	a1,-8(a0)
 808:	6390                	ld	a2,0(a5)
 80a:	02059813          	slli	a6,a1,0x20
 80e:	01c85713          	srli	a4,a6,0x1c
 812:	9736                	add	a4,a4,a3
 814:	fae60de3          	beq	a2,a4,7ce <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 818:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 81c:	4790                	lw	a2,8(a5)
 81e:	02061593          	slli	a1,a2,0x20
 822:	01c5d713          	srli	a4,a1,0x1c
 826:	973e                	add	a4,a4,a5
 828:	fae68ae3          	beq	a3,a4,7dc <free+0x22>
    p->s.ptr = bp->s.ptr;
 82c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 82e:	00000717          	auipc	a4,0x0
 832:	7cf73923          	sd	a5,2002(a4) # 1000 <freep>
}
 836:	6422                	ld	s0,8(sp)
 838:	0141                	addi	sp,sp,16
 83a:	8082                	ret

000000000000083c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 83c:	7139                	addi	sp,sp,-64
 83e:	fc06                	sd	ra,56(sp)
 840:	f822                	sd	s0,48(sp)
 842:	f426                	sd	s1,40(sp)
 844:	ec4e                	sd	s3,24(sp)
 846:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 848:	02051493          	slli	s1,a0,0x20
 84c:	9081                	srli	s1,s1,0x20
 84e:	04bd                	addi	s1,s1,15
 850:	8091                	srli	s1,s1,0x4
 852:	0014899b          	addiw	s3,s1,1
 856:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 858:	00000517          	auipc	a0,0x0
 85c:	7a853503          	ld	a0,1960(a0) # 1000 <freep>
 860:	c915                	beqz	a0,894 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 862:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 864:	4798                	lw	a4,8(a5)
 866:	08977a63          	bgeu	a4,s1,8fa <malloc+0xbe>
 86a:	f04a                	sd	s2,32(sp)
 86c:	e852                	sd	s4,16(sp)
 86e:	e456                	sd	s5,8(sp)
 870:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 872:	8a4e                	mv	s4,s3
 874:	0009871b          	sext.w	a4,s3
 878:	6685                	lui	a3,0x1
 87a:	00d77363          	bgeu	a4,a3,880 <malloc+0x44>
 87e:	6a05                	lui	s4,0x1
 880:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 884:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 888:	00000917          	auipc	s2,0x0
 88c:	77890913          	addi	s2,s2,1912 # 1000 <freep>
  if(p == (char*)-1)
 890:	5afd                	li	s5,-1
 892:	a081                	j	8d2 <malloc+0x96>
 894:	f04a                	sd	s2,32(sp)
 896:	e852                	sd	s4,16(sp)
 898:	e456                	sd	s5,8(sp)
 89a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 89c:	00000797          	auipc	a5,0x0
 8a0:	77478793          	addi	a5,a5,1908 # 1010 <base>
 8a4:	00000717          	auipc	a4,0x0
 8a8:	74f73e23          	sd	a5,1884(a4) # 1000 <freep>
 8ac:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ae:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8b2:	b7c1                	j	872 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8b4:	6398                	ld	a4,0(a5)
 8b6:	e118                	sd	a4,0(a0)
 8b8:	a8a9                	j	912 <malloc+0xd6>
  hp->s.size = nu;
 8ba:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8be:	0541                	addi	a0,a0,16
 8c0:	efbff0ef          	jal	7ba <free>
  return freep;
 8c4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8c8:	c12d                	beqz	a0,92a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8cc:	4798                	lw	a4,8(a5)
 8ce:	02977263          	bgeu	a4,s1,8f2 <malloc+0xb6>
    if(p == freep)
 8d2:	00093703          	ld	a4,0(s2)
 8d6:	853e                	mv	a0,a5
 8d8:	fef719e3          	bne	a4,a5,8ca <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8dc:	8552                	mv	a0,s4
 8de:	b1bff0ef          	jal	3f8 <sbrk>
  if(p == (char*)-1)
 8e2:	fd551ce3          	bne	a0,s5,8ba <malloc+0x7e>
        return 0;
 8e6:	4501                	li	a0,0
 8e8:	7902                	ld	s2,32(sp)
 8ea:	6a42                	ld	s4,16(sp)
 8ec:	6aa2                	ld	s5,8(sp)
 8ee:	6b02                	ld	s6,0(sp)
 8f0:	a03d                	j	91e <malloc+0xe2>
 8f2:	7902                	ld	s2,32(sp)
 8f4:	6a42                	ld	s4,16(sp)
 8f6:	6aa2                	ld	s5,8(sp)
 8f8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8fa:	fae48de3          	beq	s1,a4,8b4 <malloc+0x78>
        p->s.size -= nunits;
 8fe:	4137073b          	subw	a4,a4,s3
 902:	c798                	sw	a4,8(a5)
        p += p->s.size;
 904:	02071693          	slli	a3,a4,0x20
 908:	01c6d713          	srli	a4,a3,0x1c
 90c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 90e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 912:	00000717          	auipc	a4,0x0
 916:	6ea73723          	sd	a0,1774(a4) # 1000 <freep>
      return (void*)(p + 1);
 91a:	01078513          	addi	a0,a5,16
  }
}
 91e:	70e2                	ld	ra,56(sp)
 920:	7442                	ld	s0,48(sp)
 922:	74a2                	ld	s1,40(sp)
 924:	69e2                	ld	s3,24(sp)
 926:	6121                	addi	sp,sp,64
 928:	8082                	ret
 92a:	7902                	ld	s2,32(sp)
 92c:	6a42                	ld	s4,16(sp)
 92e:	6aa2                	ld	s5,8(sp)
 930:	6b02                	ld	s6,0(sp)
 932:	b7f5                	j	91e <malloc+0xe2>
