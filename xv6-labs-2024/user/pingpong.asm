
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
   8:	f04a                	sd	s2,32(sp)
   a:	0080                	addi	s0,sp,64
    int proc = fork();
   c:	378000ef          	jal	384 <fork>
  10:	84aa                	mv	s1,a0
    int pipe_one[2];
    int pipe_two[2];  
    
    int check_pipe1 = pipe(pipe_one); // Create a parent-to-child pipe
  12:	fd840513          	addi	a0,s0,-40
  16:	386000ef          	jal	39c <pipe>
  1a:	892a                	mv	s2,a0
    int check_pipe2 = pipe(pipe_two); // Create a child-to-parent pipe
  1c:	fd040513          	addi	a0,s0,-48
  20:	37c000ef          	jal	39c <pipe>

    if (proc < 0) {
  24:	0604c663          	bltz	s1,90 <main+0x90>
        printf("Cannot create a child process! - Error: fork() function failed!");
        return 0;   
    }
    else if (proc == 0) { // Child process
  28:	e0d1                	bnez	s1,ac <main+0xac>
        if (check_pipe1 == -1 || check_pipe2 == -1) {
  2a:	57fd                	li	a5,-1
  2c:	06f90963          	beq	s2,a5,9e <main+0x9e>
  30:	06f50763          	beq	a0,a5,9e <main+0x9e>
            return 0;
        }
        else {
            char mess;

            close(pipe_one[1]); // Close the write end of parent-to-child pipe
  34:	fdc42503          	lw	a0,-36(s0)
  38:	37c000ef          	jal	3b4 <close>
            read(pipe_one[0], &mess, 1); // Read from parent-to-child pipe
  3c:	4605                	li	a2,1
  3e:	fcf40593          	addi	a1,s0,-49
  42:	fd842503          	lw	a0,-40(s0)
  46:	35e000ef          	jal	3a4 <read>

            printf("%d: received ping\n", getpid());
  4a:	3c2000ef          	jal	40c <getpid>
  4e:	85aa                	mv	a1,a0
  50:	00001517          	auipc	a0,0x1
  54:	98050513          	addi	a0,a0,-1664 # 9d0 <malloc+0x178>
  58:	74c000ef          	jal	7a4 <printf>
            
            close(pipe_one[0]); // Close the read end of parent-to-child pipe
  5c:	fd842503          	lw	a0,-40(s0)
  60:	354000ef          	jal	3b4 <close>

            close(pipe_two[0]); // Close the read end of child-to-parent pipe
  64:	fd042503          	lw	a0,-48(s0)
  68:	34c000ef          	jal	3b4 <close>
            write(pipe_two[1], &mess, 1); // Write to child-to-parent pipe
  6c:	4605                	li	a2,1
  6e:	fcf40593          	addi	a1,s0,-49
  72:	fd442503          	lw	a0,-44(s0)
  76:	336000ef          	jal	3ac <write>
            close(pipe_two[1]); // Close the write end of child-to-parent pipe
  7a:	fd442503          	lw	a0,-44(s0)
  7e:	336000ef          	jal	3b4 <close>
        
            wait(0); // Wait for child process to finish
        }
    }
    return 0;
}
  82:	4501                	li	a0,0
  84:	70e2                	ld	ra,56(sp)
  86:	7442                	ld	s0,48(sp)
  88:	74a2                	ld	s1,40(sp)
  8a:	7902                	ld	s2,32(sp)
  8c:	6121                	addi	sp,sp,64
  8e:	8082                	ret
        printf("Cannot create a child process! - Error: fork() function failed!");
  90:	00001517          	auipc	a0,0x1
  94:	8c050513          	addi	a0,a0,-1856 # 950 <malloc+0xf8>
  98:	70c000ef          	jal	7a4 <printf>
        return 0;   
  9c:	b7dd                	j	82 <main+0x82>
            printf("Cannot create pipe! - Error: pipe() function failed!");
  9e:	00001517          	auipc	a0,0x1
  a2:	8f250513          	addi	a0,a0,-1806 # 990 <malloc+0x138>
  a6:	6fe000ef          	jal	7a4 <printf>
            return 0;
  aa:	bfe1                	j	82 <main+0x82>
        if (check_pipe1 == -1 || check_pipe2 == -1) {
  ac:	57fd                	li	a5,-1
  ae:	06f90363          	beq	s2,a5,114 <main+0x114>
  b2:	06f50163          	beq	a0,a5,114 <main+0x114>
            char mess = 'T'; // Correct assignment for char type
  b6:	05400793          	li	a5,84
  ba:	fcf407a3          	sb	a5,-49(s0)
            close(pipe_one[0]); // Close the read end of parent-to-child pipe
  be:	fd842503          	lw	a0,-40(s0)
  c2:	2f2000ef          	jal	3b4 <close>
            write(pipe_one[1], &mess, 1); // Write to parent-to-child pipe
  c6:	4605                	li	a2,1
  c8:	fcf40593          	addi	a1,s0,-49
  cc:	fdc42503          	lw	a0,-36(s0)
  d0:	2dc000ef          	jal	3ac <write>
            close(pipe_one[1]); // Close the write end of parent-to-child pipe
  d4:	fdc42503          	lw	a0,-36(s0)
  d8:	2dc000ef          	jal	3b4 <close>
            close(pipe_two[1]); // Close the write end of child-to-parent pipe
  dc:	fd442503          	lw	a0,-44(s0)
  e0:	2d4000ef          	jal	3b4 <close>
            read(pipe_two[0], &mess, 1); // Read from child-to-parent pipe
  e4:	4605                	li	a2,1
  e6:	fcf40593          	addi	a1,s0,-49
  ea:	fd042503          	lw	a0,-48(s0)
  ee:	2b6000ef          	jal	3a4 <read>
            printf("%d: received pong\n", getpid());
  f2:	31a000ef          	jal	40c <getpid>
  f6:	85aa                	mv	a1,a0
  f8:	00001517          	auipc	a0,0x1
  fc:	8f050513          	addi	a0,a0,-1808 # 9e8 <malloc+0x190>
 100:	6a4000ef          	jal	7a4 <printf>
            close(pipe_two[0]); // Close the read end of child-to-parent pipe
 104:	fd042503          	lw	a0,-48(s0)
 108:	2ac000ef          	jal	3b4 <close>
            wait(0); // Wait for child process to finish
 10c:	4501                	li	a0,0
 10e:	286000ef          	jal	394 <wait>
 112:	bf85                	j	82 <main+0x82>
            printf("Cannot create pipe! - Error: pipe() function failed!");
 114:	00001517          	auipc	a0,0x1
 118:	87c50513          	addi	a0,a0,-1924 # 990 <malloc+0x138>
 11c:	688000ef          	jal	7a4 <printf>
            return 0;
 120:	b78d                	j	82 <main+0x82>

0000000000000122 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 122:	1141                	addi	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	addi	s0,sp,16
  extern int main();
  main();
 12a:	ed7ff0ef          	jal	0 <main>
  exit(0);
 12e:	4501                	li	a0,0
 130:	25c000ef          	jal	38c <exit>

0000000000000134 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 134:	1141                	addi	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13a:	87aa                	mv	a5,a0
 13c:	0585                	addi	a1,a1,1
 13e:	0785                	addi	a5,a5,1
 140:	fff5c703          	lbu	a4,-1(a1)
 144:	fee78fa3          	sb	a4,-1(a5)
 148:	fb75                	bnez	a4,13c <strcpy+0x8>
    ;
  return os;
}
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret

0000000000000150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 150:	1141                	addi	sp,sp,-16
 152:	e422                	sd	s0,8(sp)
 154:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cb91                	beqz	a5,16e <strcmp+0x1e>
 15c:	0005c703          	lbu	a4,0(a1)
 160:	00f71763          	bne	a4,a5,16e <strcmp+0x1e>
    p++, q++;
 164:	0505                	addi	a0,a0,1
 166:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 168:	00054783          	lbu	a5,0(a0)
 16c:	fbe5                	bnez	a5,15c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 16e:	0005c503          	lbu	a0,0(a1)
}
 172:	40a7853b          	subw	a0,a5,a0
 176:	6422                	ld	s0,8(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <strlen>:

uint
strlen(const char *s)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e422                	sd	s0,8(sp)
 180:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 182:	00054783          	lbu	a5,0(a0)
 186:	cf91                	beqz	a5,1a2 <strlen+0x26>
 188:	0505                	addi	a0,a0,1
 18a:	87aa                	mv	a5,a0
 18c:	86be                	mv	a3,a5
 18e:	0785                	addi	a5,a5,1
 190:	fff7c703          	lbu	a4,-1(a5)
 194:	ff65                	bnez	a4,18c <strlen+0x10>
 196:	40a6853b          	subw	a0,a3,a0
 19a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 19c:	6422                	ld	s0,8(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret
  for(n = 0; s[n]; n++)
 1a2:	4501                	li	a0,0
 1a4:	bfe5                	j	19c <strlen+0x20>

00000000000001a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ac:	ca19                	beqz	a2,1c2 <memset+0x1c>
 1ae:	87aa                	mv	a5,a0
 1b0:	1602                	slli	a2,a2,0x20
 1b2:	9201                	srli	a2,a2,0x20
 1b4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1b8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1bc:	0785                	addi	a5,a5,1
 1be:	fee79de3          	bne	a5,a4,1b8 <memset+0x12>
  }
  return dst;
}
 1c2:	6422                	ld	s0,8(sp)
 1c4:	0141                	addi	sp,sp,16
 1c6:	8082                	ret

00000000000001c8 <strchr>:

char*
strchr(const char *s, char c)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1ce:	00054783          	lbu	a5,0(a0)
 1d2:	cb99                	beqz	a5,1e8 <strchr+0x20>
    if(*s == c)
 1d4:	00f58763          	beq	a1,a5,1e2 <strchr+0x1a>
  for(; *s; s++)
 1d8:	0505                	addi	a0,a0,1
 1da:	00054783          	lbu	a5,0(a0)
 1de:	fbfd                	bnez	a5,1d4 <strchr+0xc>
      return (char*)s;
  return 0;
 1e0:	4501                	li	a0,0
}
 1e2:	6422                	ld	s0,8(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret
  return 0;
 1e8:	4501                	li	a0,0
 1ea:	bfe5                	j	1e2 <strchr+0x1a>

00000000000001ec <gets>:

char*
gets(char *buf, int max)
{
 1ec:	711d                	addi	sp,sp,-96
 1ee:	ec86                	sd	ra,88(sp)
 1f0:	e8a2                	sd	s0,80(sp)
 1f2:	e4a6                	sd	s1,72(sp)
 1f4:	e0ca                	sd	s2,64(sp)
 1f6:	fc4e                	sd	s3,56(sp)
 1f8:	f852                	sd	s4,48(sp)
 1fa:	f456                	sd	s5,40(sp)
 1fc:	f05a                	sd	s6,32(sp)
 1fe:	ec5e                	sd	s7,24(sp)
 200:	1080                	addi	s0,sp,96
 202:	8baa                	mv	s7,a0
 204:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 206:	892a                	mv	s2,a0
 208:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 20a:	4aa9                	li	s5,10
 20c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 20e:	89a6                	mv	s3,s1
 210:	2485                	addiw	s1,s1,1
 212:	0344d663          	bge	s1,s4,23e <gets+0x52>
    cc = read(0, &c, 1);
 216:	4605                	li	a2,1
 218:	faf40593          	addi	a1,s0,-81
 21c:	4501                	li	a0,0
 21e:	186000ef          	jal	3a4 <read>
    if(cc < 1)
 222:	00a05e63          	blez	a0,23e <gets+0x52>
    buf[i++] = c;
 226:	faf44783          	lbu	a5,-81(s0)
 22a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 22e:	01578763          	beq	a5,s5,23c <gets+0x50>
 232:	0905                	addi	s2,s2,1
 234:	fd679de3          	bne	a5,s6,20e <gets+0x22>
    buf[i++] = c;
 238:	89a6                	mv	s3,s1
 23a:	a011                	j	23e <gets+0x52>
 23c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 23e:	99de                	add	s3,s3,s7
 240:	00098023          	sb	zero,0(s3)
  return buf;
}
 244:	855e                	mv	a0,s7
 246:	60e6                	ld	ra,88(sp)
 248:	6446                	ld	s0,80(sp)
 24a:	64a6                	ld	s1,72(sp)
 24c:	6906                	ld	s2,64(sp)
 24e:	79e2                	ld	s3,56(sp)
 250:	7a42                	ld	s4,48(sp)
 252:	7aa2                	ld	s5,40(sp)
 254:	7b02                	ld	s6,32(sp)
 256:	6be2                	ld	s7,24(sp)
 258:	6125                	addi	sp,sp,96
 25a:	8082                	ret

000000000000025c <stat>:

int
stat(const char *n, struct stat *st)
{
 25c:	1101                	addi	sp,sp,-32
 25e:	ec06                	sd	ra,24(sp)
 260:	e822                	sd	s0,16(sp)
 262:	e04a                	sd	s2,0(sp)
 264:	1000                	addi	s0,sp,32
 266:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 268:	4581                	li	a1,0
 26a:	162000ef          	jal	3cc <open>
  if(fd < 0)
 26e:	02054263          	bltz	a0,292 <stat+0x36>
 272:	e426                	sd	s1,8(sp)
 274:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 276:	85ca                	mv	a1,s2
 278:	16c000ef          	jal	3e4 <fstat>
 27c:	892a                	mv	s2,a0
  close(fd);
 27e:	8526                	mv	a0,s1
 280:	134000ef          	jal	3b4 <close>
  return r;
 284:	64a2                	ld	s1,8(sp)
}
 286:	854a                	mv	a0,s2
 288:	60e2                	ld	ra,24(sp)
 28a:	6442                	ld	s0,16(sp)
 28c:	6902                	ld	s2,0(sp)
 28e:	6105                	addi	sp,sp,32
 290:	8082                	ret
    return -1;
 292:	597d                	li	s2,-1
 294:	bfcd                	j	286 <stat+0x2a>

0000000000000296 <atoi>:

int
atoi(const char *s)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29c:	00054683          	lbu	a3,0(a0)
 2a0:	fd06879b          	addiw	a5,a3,-48
 2a4:	0ff7f793          	zext.b	a5,a5
 2a8:	4625                	li	a2,9
 2aa:	02f66863          	bltu	a2,a5,2da <atoi+0x44>
 2ae:	872a                	mv	a4,a0
  n = 0;
 2b0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2b2:	0705                	addi	a4,a4,1
 2b4:	0025179b          	slliw	a5,a0,0x2
 2b8:	9fa9                	addw	a5,a5,a0
 2ba:	0017979b          	slliw	a5,a5,0x1
 2be:	9fb5                	addw	a5,a5,a3
 2c0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c4:	00074683          	lbu	a3,0(a4)
 2c8:	fd06879b          	addiw	a5,a3,-48
 2cc:	0ff7f793          	zext.b	a5,a5
 2d0:	fef671e3          	bgeu	a2,a5,2b2 <atoi+0x1c>
  return n;
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  n = 0;
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <atoi+0x3e>

00000000000002de <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e4:	02b57463          	bgeu	a0,a1,30c <memmove+0x2e>
    while(n-- > 0)
 2e8:	00c05f63          	blez	a2,306 <memmove+0x28>
 2ec:	1602                	slli	a2,a2,0x20
 2ee:	9201                	srli	a2,a2,0x20
 2f0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f6:	0585                	addi	a1,a1,1
 2f8:	0705                	addi	a4,a4,1
 2fa:	fff5c683          	lbu	a3,-1(a1)
 2fe:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 302:	fef71ae3          	bne	a4,a5,2f6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
    dst += n;
 30c:	00c50733          	add	a4,a0,a2
    src += n;
 310:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 312:	fec05ae3          	blez	a2,306 <memmove+0x28>
 316:	fff6079b          	addiw	a5,a2,-1
 31a:	1782                	slli	a5,a5,0x20
 31c:	9381                	srli	a5,a5,0x20
 31e:	fff7c793          	not	a5,a5
 322:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 324:	15fd                	addi	a1,a1,-1
 326:	177d                	addi	a4,a4,-1
 328:	0005c683          	lbu	a3,0(a1)
 32c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 330:	fee79ae3          	bne	a5,a4,324 <memmove+0x46>
 334:	bfc9                	j	306 <memmove+0x28>

0000000000000336 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33c:	ca05                	beqz	a2,36c <memcmp+0x36>
 33e:	fff6069b          	addiw	a3,a2,-1
 342:	1682                	slli	a3,a3,0x20
 344:	9281                	srli	a3,a3,0x20
 346:	0685                	addi	a3,a3,1
 348:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 34a:	00054783          	lbu	a5,0(a0)
 34e:	0005c703          	lbu	a4,0(a1)
 352:	00e79863          	bne	a5,a4,362 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 356:	0505                	addi	a0,a0,1
    p2++;
 358:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35a:	fed518e3          	bne	a0,a3,34a <memcmp+0x14>
  }
  return 0;
 35e:	4501                	li	a0,0
 360:	a019                	j	366 <memcmp+0x30>
      return *p1 - *p2;
 362:	40e7853b          	subw	a0,a5,a4
}
 366:	6422                	ld	s0,8(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret
  return 0;
 36c:	4501                	li	a0,0
 36e:	bfe5                	j	366 <memcmp+0x30>

0000000000000370 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 378:	f67ff0ef          	jal	2de <memmove>
}
 37c:	60a2                	ld	ra,8(sp)
 37e:	6402                	ld	s0,0(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret

0000000000000384 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 384:	4885                	li	a7,1
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <exit>:
.global exit
exit:
 li a7, SYS_exit
 38c:	4889                	li	a7,2
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <wait>:
.global wait
wait:
 li a7, SYS_wait
 394:	488d                	li	a7,3
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39c:	4891                	li	a7,4
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <read>:
.global read
read:
 li a7, SYS_read
 3a4:	4895                	li	a7,5
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <write>:
.global write
write:
 li a7, SYS_write
 3ac:	48c1                	li	a7,16
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <close>:
.global close
close:
 li a7, SYS_close
 3b4:	48d5                	li	a7,21
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3bc:	4899                	li	a7,6
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c4:	489d                	li	a7,7
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <open>:
.global open
open:
 li a7, SYS_open
 3cc:	48bd                	li	a7,15
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d4:	48c5                	li	a7,17
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3dc:	48c9                	li	a7,18
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e4:	48a1                	li	a7,8
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <link>:
.global link
link:
 li a7, SYS_link
 3ec:	48cd                	li	a7,19
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f4:	48d1                	li	a7,20
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fc:	48a5                	li	a7,9
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <dup>:
.global dup
dup:
 li a7, SYS_dup
 404:	48a9                	li	a7,10
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40c:	48ad                	li	a7,11
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 414:	48b1                	li	a7,12
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 41c:	48b5                	li	a7,13
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 424:	48b9                	li	a7,14
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 42c:	1101                	addi	sp,sp,-32
 42e:	ec06                	sd	ra,24(sp)
 430:	e822                	sd	s0,16(sp)
 432:	1000                	addi	s0,sp,32
 434:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 438:	4605                	li	a2,1
 43a:	fef40593          	addi	a1,s0,-17
 43e:	f6fff0ef          	jal	3ac <write>
}
 442:	60e2                	ld	ra,24(sp)
 444:	6442                	ld	s0,16(sp)
 446:	6105                	addi	sp,sp,32
 448:	8082                	ret

000000000000044a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44a:	7139                	addi	sp,sp,-64
 44c:	fc06                	sd	ra,56(sp)
 44e:	f822                	sd	s0,48(sp)
 450:	f426                	sd	s1,40(sp)
 452:	0080                	addi	s0,sp,64
 454:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 456:	c299                	beqz	a3,45c <printint+0x12>
 458:	0805c963          	bltz	a1,4ea <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 45c:	2581                	sext.w	a1,a1
  neg = 0;
 45e:	4881                	li	a7,0
 460:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 464:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 466:	2601                	sext.w	a2,a2
 468:	00000517          	auipc	a0,0x0
 46c:	5a050513          	addi	a0,a0,1440 # a08 <digits>
 470:	883a                	mv	a6,a4
 472:	2705                	addiw	a4,a4,1
 474:	02c5f7bb          	remuw	a5,a1,a2
 478:	1782                	slli	a5,a5,0x20
 47a:	9381                	srli	a5,a5,0x20
 47c:	97aa                	add	a5,a5,a0
 47e:	0007c783          	lbu	a5,0(a5)
 482:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 486:	0005879b          	sext.w	a5,a1
 48a:	02c5d5bb          	divuw	a1,a1,a2
 48e:	0685                	addi	a3,a3,1
 490:	fec7f0e3          	bgeu	a5,a2,470 <printint+0x26>
  if(neg)
 494:	00088c63          	beqz	a7,4ac <printint+0x62>
    buf[i++] = '-';
 498:	fd070793          	addi	a5,a4,-48
 49c:	00878733          	add	a4,a5,s0
 4a0:	02d00793          	li	a5,45
 4a4:	fef70823          	sb	a5,-16(a4)
 4a8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4ac:	02e05a63          	blez	a4,4e0 <printint+0x96>
 4b0:	f04a                	sd	s2,32(sp)
 4b2:	ec4e                	sd	s3,24(sp)
 4b4:	fc040793          	addi	a5,s0,-64
 4b8:	00e78933          	add	s2,a5,a4
 4bc:	fff78993          	addi	s3,a5,-1
 4c0:	99ba                	add	s3,s3,a4
 4c2:	377d                	addiw	a4,a4,-1
 4c4:	1702                	slli	a4,a4,0x20
 4c6:	9301                	srli	a4,a4,0x20
 4c8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4cc:	fff94583          	lbu	a1,-1(s2)
 4d0:	8526                	mv	a0,s1
 4d2:	f5bff0ef          	jal	42c <putc>
  while(--i >= 0)
 4d6:	197d                	addi	s2,s2,-1
 4d8:	ff391ae3          	bne	s2,s3,4cc <printint+0x82>
 4dc:	7902                	ld	s2,32(sp)
 4de:	69e2                	ld	s3,24(sp)
}
 4e0:	70e2                	ld	ra,56(sp)
 4e2:	7442                	ld	s0,48(sp)
 4e4:	74a2                	ld	s1,40(sp)
 4e6:	6121                	addi	sp,sp,64
 4e8:	8082                	ret
    x = -xx;
 4ea:	40b005bb          	negw	a1,a1
    neg = 1;
 4ee:	4885                	li	a7,1
    x = -xx;
 4f0:	bf85                	j	460 <printint+0x16>

00000000000004f2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f2:	711d                	addi	sp,sp,-96
 4f4:	ec86                	sd	ra,88(sp)
 4f6:	e8a2                	sd	s0,80(sp)
 4f8:	e0ca                	sd	s2,64(sp)
 4fa:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4fc:	0005c903          	lbu	s2,0(a1)
 500:	26090863          	beqz	s2,770 <vprintf+0x27e>
 504:	e4a6                	sd	s1,72(sp)
 506:	fc4e                	sd	s3,56(sp)
 508:	f852                	sd	s4,48(sp)
 50a:	f456                	sd	s5,40(sp)
 50c:	f05a                	sd	s6,32(sp)
 50e:	ec5e                	sd	s7,24(sp)
 510:	e862                	sd	s8,16(sp)
 512:	e466                	sd	s9,8(sp)
 514:	8b2a                	mv	s6,a0
 516:	8a2e                	mv	s4,a1
 518:	8bb2                	mv	s7,a2
  state = 0;
 51a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 51c:	4481                	li	s1,0
 51e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 520:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 524:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 528:	06c00c93          	li	s9,108
 52c:	a005                	j	54c <vprintf+0x5a>
        putc(fd, c0);
 52e:	85ca                	mv	a1,s2
 530:	855a                	mv	a0,s6
 532:	efbff0ef          	jal	42c <putc>
 536:	a019                	j	53c <vprintf+0x4a>
    } else if(state == '%'){
 538:	03598263          	beq	s3,s5,55c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 53c:	2485                	addiw	s1,s1,1
 53e:	8726                	mv	a4,s1
 540:	009a07b3          	add	a5,s4,s1
 544:	0007c903          	lbu	s2,0(a5)
 548:	20090c63          	beqz	s2,760 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 54c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 550:	fe0994e3          	bnez	s3,538 <vprintf+0x46>
      if(c0 == '%'){
 554:	fd579de3          	bne	a5,s5,52e <vprintf+0x3c>
        state = '%';
 558:	89be                	mv	s3,a5
 55a:	b7cd                	j	53c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 55c:	00ea06b3          	add	a3,s4,a4
 560:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 564:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 566:	c681                	beqz	a3,56e <vprintf+0x7c>
 568:	9752                	add	a4,a4,s4
 56a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 56e:	03878f63          	beq	a5,s8,5ac <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 572:	05978963          	beq	a5,s9,5c4 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 576:	07500713          	li	a4,117
 57a:	0ee78363          	beq	a5,a4,660 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 57e:	07800713          	li	a4,120
 582:	12e78563          	beq	a5,a4,6ac <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 586:	07000713          	li	a4,112
 58a:	14e78a63          	beq	a5,a4,6de <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 58e:	07300713          	li	a4,115
 592:	18e78a63          	beq	a5,a4,726 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 596:	02500713          	li	a4,37
 59a:	04e79563          	bne	a5,a4,5e4 <vprintf+0xf2>
        putc(fd, '%');
 59e:	02500593          	li	a1,37
 5a2:	855a                	mv	a0,s6
 5a4:	e89ff0ef          	jal	42c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	bf49                	j	53c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5ac:	008b8913          	addi	s2,s7,8
 5b0:	4685                	li	a3,1
 5b2:	4629                	li	a2,10
 5b4:	000ba583          	lw	a1,0(s7)
 5b8:	855a                	mv	a0,s6
 5ba:	e91ff0ef          	jal	44a <printint>
 5be:	8bca                	mv	s7,s2
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	bfad                	j	53c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5c4:	06400793          	li	a5,100
 5c8:	02f68963          	beq	a3,a5,5fa <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5cc:	06c00793          	li	a5,108
 5d0:	04f68263          	beq	a3,a5,614 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5d4:	07500793          	li	a5,117
 5d8:	0af68063          	beq	a3,a5,678 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5dc:	07800793          	li	a5,120
 5e0:	0ef68263          	beq	a3,a5,6c4 <vprintf+0x1d2>
        putc(fd, '%');
 5e4:	02500593          	li	a1,37
 5e8:	855a                	mv	a0,s6
 5ea:	e43ff0ef          	jal	42c <putc>
        putc(fd, c0);
 5ee:	85ca                	mv	a1,s2
 5f0:	855a                	mv	a0,s6
 5f2:	e3bff0ef          	jal	42c <putc>
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b791                	j	53c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fa:	008b8913          	addi	s2,s7,8
 5fe:	4685                	li	a3,1
 600:	4629                	li	a2,10
 602:	000ba583          	lw	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	e43ff0ef          	jal	44a <printint>
        i += 1;
 60c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 60e:	8bca                	mv	s7,s2
      state = 0;
 610:	4981                	li	s3,0
        i += 1;
 612:	b72d                	j	53c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 614:	06400793          	li	a5,100
 618:	02f60763          	beq	a2,a5,646 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 61c:	07500793          	li	a5,117
 620:	06f60963          	beq	a2,a5,692 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 624:	07800793          	li	a5,120
 628:	faf61ee3          	bne	a2,a5,5e4 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 62c:	008b8913          	addi	s2,s7,8
 630:	4681                	li	a3,0
 632:	4641                	li	a2,16
 634:	000ba583          	lw	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	e11ff0ef          	jal	44a <printint>
        i += 2;
 63e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 640:	8bca                	mv	s7,s2
      state = 0;
 642:	4981                	li	s3,0
        i += 2;
 644:	bde5                	j	53c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 646:	008b8913          	addi	s2,s7,8
 64a:	4685                	li	a3,1
 64c:	4629                	li	a2,10
 64e:	000ba583          	lw	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	df7ff0ef          	jal	44a <printint>
        i += 2;
 658:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 65a:	8bca                	mv	s7,s2
      state = 0;
 65c:	4981                	li	s3,0
        i += 2;
 65e:	bdf9                	j	53c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 660:	008b8913          	addi	s2,s7,8
 664:	4681                	li	a3,0
 666:	4629                	li	a2,10
 668:	000ba583          	lw	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	dddff0ef          	jal	44a <printint>
 672:	8bca                	mv	s7,s2
      state = 0;
 674:	4981                	li	s3,0
 676:	b5d9                	j	53c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 678:	008b8913          	addi	s2,s7,8
 67c:	4681                	li	a3,0
 67e:	4629                	li	a2,10
 680:	000ba583          	lw	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	dc5ff0ef          	jal	44a <printint>
        i += 1;
 68a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 68c:	8bca                	mv	s7,s2
      state = 0;
 68e:	4981                	li	s3,0
        i += 1;
 690:	b575                	j	53c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 692:	008b8913          	addi	s2,s7,8
 696:	4681                	li	a3,0
 698:	4629                	li	a2,10
 69a:	000ba583          	lw	a1,0(s7)
 69e:	855a                	mv	a0,s6
 6a0:	dabff0ef          	jal	44a <printint>
        i += 2;
 6a4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a6:	8bca                	mv	s7,s2
      state = 0;
 6a8:	4981                	li	s3,0
        i += 2;
 6aa:	bd49                	j	53c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6ac:	008b8913          	addi	s2,s7,8
 6b0:	4681                	li	a3,0
 6b2:	4641                	li	a2,16
 6b4:	000ba583          	lw	a1,0(s7)
 6b8:	855a                	mv	a0,s6
 6ba:	d91ff0ef          	jal	44a <printint>
 6be:	8bca                	mv	s7,s2
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	bdad                	j	53c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c4:	008b8913          	addi	s2,s7,8
 6c8:	4681                	li	a3,0
 6ca:	4641                	li	a2,16
 6cc:	000ba583          	lw	a1,0(s7)
 6d0:	855a                	mv	a0,s6
 6d2:	d79ff0ef          	jal	44a <printint>
        i += 1;
 6d6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d8:	8bca                	mv	s7,s2
      state = 0;
 6da:	4981                	li	s3,0
        i += 1;
 6dc:	b585                	j	53c <vprintf+0x4a>
 6de:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6e0:	008b8d13          	addi	s10,s7,8
 6e4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6e8:	03000593          	li	a1,48
 6ec:	855a                	mv	a0,s6
 6ee:	d3fff0ef          	jal	42c <putc>
  putc(fd, 'x');
 6f2:	07800593          	li	a1,120
 6f6:	855a                	mv	a0,s6
 6f8:	d35ff0ef          	jal	42c <putc>
 6fc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fe:	00000b97          	auipc	s7,0x0
 702:	30ab8b93          	addi	s7,s7,778 # a08 <digits>
 706:	03c9d793          	srli	a5,s3,0x3c
 70a:	97de                	add	a5,a5,s7
 70c:	0007c583          	lbu	a1,0(a5)
 710:	855a                	mv	a0,s6
 712:	d1bff0ef          	jal	42c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 716:	0992                	slli	s3,s3,0x4
 718:	397d                	addiw	s2,s2,-1
 71a:	fe0916e3          	bnez	s2,706 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 71e:	8bea                	mv	s7,s10
      state = 0;
 720:	4981                	li	s3,0
 722:	6d02                	ld	s10,0(sp)
 724:	bd21                	j	53c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 726:	008b8993          	addi	s3,s7,8
 72a:	000bb903          	ld	s2,0(s7)
 72e:	00090f63          	beqz	s2,74c <vprintf+0x25a>
        for(; *s; s++)
 732:	00094583          	lbu	a1,0(s2)
 736:	c195                	beqz	a1,75a <vprintf+0x268>
          putc(fd, *s);
 738:	855a                	mv	a0,s6
 73a:	cf3ff0ef          	jal	42c <putc>
        for(; *s; s++)
 73e:	0905                	addi	s2,s2,1
 740:	00094583          	lbu	a1,0(s2)
 744:	f9f5                	bnez	a1,738 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 746:	8bce                	mv	s7,s3
      state = 0;
 748:	4981                	li	s3,0
 74a:	bbcd                	j	53c <vprintf+0x4a>
          s = "(null)";
 74c:	00000917          	auipc	s2,0x0
 750:	2b490913          	addi	s2,s2,692 # a00 <malloc+0x1a8>
        for(; *s; s++)
 754:	02800593          	li	a1,40
 758:	b7c5                	j	738 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 75a:	8bce                	mv	s7,s3
      state = 0;
 75c:	4981                	li	s3,0
 75e:	bbf9                	j	53c <vprintf+0x4a>
 760:	64a6                	ld	s1,72(sp)
 762:	79e2                	ld	s3,56(sp)
 764:	7a42                	ld	s4,48(sp)
 766:	7aa2                	ld	s5,40(sp)
 768:	7b02                	ld	s6,32(sp)
 76a:	6be2                	ld	s7,24(sp)
 76c:	6c42                	ld	s8,16(sp)
 76e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 770:	60e6                	ld	ra,88(sp)
 772:	6446                	ld	s0,80(sp)
 774:	6906                	ld	s2,64(sp)
 776:	6125                	addi	sp,sp,96
 778:	8082                	ret

000000000000077a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 77a:	715d                	addi	sp,sp,-80
 77c:	ec06                	sd	ra,24(sp)
 77e:	e822                	sd	s0,16(sp)
 780:	1000                	addi	s0,sp,32
 782:	e010                	sd	a2,0(s0)
 784:	e414                	sd	a3,8(s0)
 786:	e818                	sd	a4,16(s0)
 788:	ec1c                	sd	a5,24(s0)
 78a:	03043023          	sd	a6,32(s0)
 78e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 792:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 796:	8622                	mv	a2,s0
 798:	d5bff0ef          	jal	4f2 <vprintf>
}
 79c:	60e2                	ld	ra,24(sp)
 79e:	6442                	ld	s0,16(sp)
 7a0:	6161                	addi	sp,sp,80
 7a2:	8082                	ret

00000000000007a4 <printf>:

void
printf(const char *fmt, ...)
{
 7a4:	711d                	addi	sp,sp,-96
 7a6:	ec06                	sd	ra,24(sp)
 7a8:	e822                	sd	s0,16(sp)
 7aa:	1000                	addi	s0,sp,32
 7ac:	e40c                	sd	a1,8(s0)
 7ae:	e810                	sd	a2,16(s0)
 7b0:	ec14                	sd	a3,24(s0)
 7b2:	f018                	sd	a4,32(s0)
 7b4:	f41c                	sd	a5,40(s0)
 7b6:	03043823          	sd	a6,48(s0)
 7ba:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7be:	00840613          	addi	a2,s0,8
 7c2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c6:	85aa                	mv	a1,a0
 7c8:	4505                	li	a0,1
 7ca:	d29ff0ef          	jal	4f2 <vprintf>
}
 7ce:	60e2                	ld	ra,24(sp)
 7d0:	6442                	ld	s0,16(sp)
 7d2:	6125                	addi	sp,sp,96
 7d4:	8082                	ret

00000000000007d6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d6:	1141                	addi	sp,sp,-16
 7d8:	e422                	sd	s0,8(sp)
 7da:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7dc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e0:	00001797          	auipc	a5,0x1
 7e4:	8207b783          	ld	a5,-2016(a5) # 1000 <freep>
 7e8:	a02d                	j	812 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ea:	4618                	lw	a4,8(a2)
 7ec:	9f2d                	addw	a4,a4,a1
 7ee:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f2:	6398                	ld	a4,0(a5)
 7f4:	6310                	ld	a2,0(a4)
 7f6:	a83d                	j	834 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7f8:	ff852703          	lw	a4,-8(a0)
 7fc:	9f31                	addw	a4,a4,a2
 7fe:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 800:	ff053683          	ld	a3,-16(a0)
 804:	a091                	j	848 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 806:	6398                	ld	a4,0(a5)
 808:	00e7e463          	bltu	a5,a4,810 <free+0x3a>
 80c:	00e6ea63          	bltu	a3,a4,820 <free+0x4a>
{
 810:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 812:	fed7fae3          	bgeu	a5,a3,806 <free+0x30>
 816:	6398                	ld	a4,0(a5)
 818:	00e6e463          	bltu	a3,a4,820 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81c:	fee7eae3          	bltu	a5,a4,810 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 820:	ff852583          	lw	a1,-8(a0)
 824:	6390                	ld	a2,0(a5)
 826:	02059813          	slli	a6,a1,0x20
 82a:	01c85713          	srli	a4,a6,0x1c
 82e:	9736                	add	a4,a4,a3
 830:	fae60de3          	beq	a2,a4,7ea <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 834:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 838:	4790                	lw	a2,8(a5)
 83a:	02061593          	slli	a1,a2,0x20
 83e:	01c5d713          	srli	a4,a1,0x1c
 842:	973e                	add	a4,a4,a5
 844:	fae68ae3          	beq	a3,a4,7f8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 848:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 84a:	00000717          	auipc	a4,0x0
 84e:	7af73b23          	sd	a5,1974(a4) # 1000 <freep>
}
 852:	6422                	ld	s0,8(sp)
 854:	0141                	addi	sp,sp,16
 856:	8082                	ret

0000000000000858 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 858:	7139                	addi	sp,sp,-64
 85a:	fc06                	sd	ra,56(sp)
 85c:	f822                	sd	s0,48(sp)
 85e:	f426                	sd	s1,40(sp)
 860:	ec4e                	sd	s3,24(sp)
 862:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 864:	02051493          	slli	s1,a0,0x20
 868:	9081                	srli	s1,s1,0x20
 86a:	04bd                	addi	s1,s1,15
 86c:	8091                	srli	s1,s1,0x4
 86e:	0014899b          	addiw	s3,s1,1
 872:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 874:	00000517          	auipc	a0,0x0
 878:	78c53503          	ld	a0,1932(a0) # 1000 <freep>
 87c:	c915                	beqz	a0,8b0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 880:	4798                	lw	a4,8(a5)
 882:	08977a63          	bgeu	a4,s1,916 <malloc+0xbe>
 886:	f04a                	sd	s2,32(sp)
 888:	e852                	sd	s4,16(sp)
 88a:	e456                	sd	s5,8(sp)
 88c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 88e:	8a4e                	mv	s4,s3
 890:	0009871b          	sext.w	a4,s3
 894:	6685                	lui	a3,0x1
 896:	00d77363          	bgeu	a4,a3,89c <malloc+0x44>
 89a:	6a05                	lui	s4,0x1
 89c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8a0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a4:	00000917          	auipc	s2,0x0
 8a8:	75c90913          	addi	s2,s2,1884 # 1000 <freep>
  if(p == (char*)-1)
 8ac:	5afd                	li	s5,-1
 8ae:	a081                	j	8ee <malloc+0x96>
 8b0:	f04a                	sd	s2,32(sp)
 8b2:	e852                	sd	s4,16(sp)
 8b4:	e456                	sd	s5,8(sp)
 8b6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8b8:	00000797          	auipc	a5,0x0
 8bc:	75878793          	addi	a5,a5,1880 # 1010 <base>
 8c0:	00000717          	auipc	a4,0x0
 8c4:	74f73023          	sd	a5,1856(a4) # 1000 <freep>
 8c8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ca:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ce:	b7c1                	j	88e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8d0:	6398                	ld	a4,0(a5)
 8d2:	e118                	sd	a4,0(a0)
 8d4:	a8a9                	j	92e <malloc+0xd6>
  hp->s.size = nu;
 8d6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8da:	0541                	addi	a0,a0,16
 8dc:	efbff0ef          	jal	7d6 <free>
  return freep;
 8e0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8e4:	c12d                	beqz	a0,946 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e8:	4798                	lw	a4,8(a5)
 8ea:	02977263          	bgeu	a4,s1,90e <malloc+0xb6>
    if(p == freep)
 8ee:	00093703          	ld	a4,0(s2)
 8f2:	853e                	mv	a0,a5
 8f4:	fef719e3          	bne	a4,a5,8e6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8f8:	8552                	mv	a0,s4
 8fa:	b1bff0ef          	jal	414 <sbrk>
  if(p == (char*)-1)
 8fe:	fd551ce3          	bne	a0,s5,8d6 <malloc+0x7e>
        return 0;
 902:	4501                	li	a0,0
 904:	7902                	ld	s2,32(sp)
 906:	6a42                	ld	s4,16(sp)
 908:	6aa2                	ld	s5,8(sp)
 90a:	6b02                	ld	s6,0(sp)
 90c:	a03d                	j	93a <malloc+0xe2>
 90e:	7902                	ld	s2,32(sp)
 910:	6a42                	ld	s4,16(sp)
 912:	6aa2                	ld	s5,8(sp)
 914:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 916:	fae48de3          	beq	s1,a4,8d0 <malloc+0x78>
        p->s.size -= nunits;
 91a:	4137073b          	subw	a4,a4,s3
 91e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 920:	02071693          	slli	a3,a4,0x20
 924:	01c6d713          	srli	a4,a3,0x1c
 928:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 92a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 92e:	00000717          	auipc	a4,0x0
 932:	6ca73923          	sd	a0,1746(a4) # 1000 <freep>
      return (void*)(p + 1);
 936:	01078513          	addi	a0,a5,16
  }
}
 93a:	70e2                	ld	ra,56(sp)
 93c:	7442                	ld	s0,48(sp)
 93e:	74a2                	ld	s1,40(sp)
 940:	69e2                	ld	s3,24(sp)
 942:	6121                	addi	sp,sp,64
 944:	8082                	ret
 946:	7902                	ld	s2,32(sp)
 948:	6a42                	ld	s4,16(sp)
 94a:	6aa2                	ld	s5,8(sp)
 94c:	6b02                	ld	s6,0(sp)
 94e:	b7f5                	j	93a <malloc+0xe2>
