
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <primes>:
#include "kernel/stat.h"
#include "user/user.h"

void primes(int cur_pipe)__attribute__((noreturn));

void primes(int cur_pipe) {
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
   a:	84aa                	mv	s1,a0
    int prime;
    if (read(cur_pipe, &prime, sizeof(prime)) == 0) {
   c:	4611                	li	a2,4
   e:	fdc40593          	addi	a1,s0,-36
  12:	3d8000ef          	jal	3ea <read>
  16:	e519                	bnez	a0,24 <primes+0x24>
        close(cur_pipe);
  18:	8526                	mv	a0,s1
  1a:	3e0000ef          	jal	3fa <close>
        exit(0);
  1e:	4501                	li	a0,0
  20:	3b2000ef          	jal	3d2 <exit>
    }

    // Print the prime number
    printf("prime %d\n", prime);
  24:	fdc42583          	lw	a1,-36(s0)
  28:	00001517          	auipc	a0,0x1
  2c:	97850513          	addi	a0,a0,-1672 # 9a0 <malloc+0x102>
  30:	7ba000ef          	jal	7ea <printf>

    int fd[2];
    if (pipe(fd) < 0) {
  34:	fd040513          	addi	a0,s0,-48
  38:	3aa000ef          	jal	3e2 <pipe>
  3c:	02054063          	bltz	a0,5c <primes+0x5c>
        close(cur_pipe);
        exit(1);
    }

    int num;
    int pid = fork();
  40:	38a000ef          	jal	3ca <fork>
    if (pid == 0) {
  44:	e905                	bnez	a0,74 <primes+0x74>
        // Child process to handle next prime filtering
        close(fd[1]);  // Close write end in child
  46:	fd442503          	lw	a0,-44(s0)
  4a:	3b0000ef          	jal	3fa <close>
        close(cur_pipe);  // Close current pipe in child, You got a buffer overflow if you not close this pip
  4e:	8526                	mv	a0,s1
  50:	3aa000ef          	jal	3fa <close>
        primes(fd[0]); // Recursive call
  54:	fd042503          	lw	a0,-48(s0)
  58:	fa9ff0ef          	jal	0 <primes>
        printf("Error creating pipe\n");
  5c:	00001517          	auipc	a0,0x1
  60:	95450513          	addi	a0,a0,-1708 # 9b0 <malloc+0x112>
  64:	786000ef          	jal	7ea <printf>
        close(cur_pipe);
  68:	8526                	mv	a0,s1
  6a:	390000ef          	jal	3fa <close>
        exit(1);
  6e:	4505                	li	a0,1
  70:	362000ef          	jal	3d2 <exit>
    } else {
        // Parent process filters numbers
        close(fd[0]);  // Close read end in parent
  74:	fd042503          	lw	a0,-48(s0)
  78:	382000ef          	jal	3fa <close>

        while (read(cur_pipe, &num, sizeof(num)) > 0) {
  7c:	4611                	li	a2,4
  7e:	fcc40593          	addi	a1,s0,-52
  82:	8526                	mv	a0,s1
  84:	366000ef          	jal	3ea <read>
  88:	02a05863          	blez	a0,b8 <primes+0xb8>
            // Only pass numbers that are not divisible by the current prime
            if (num % prime != 0) {
  8c:	fcc42783          	lw	a5,-52(s0)
  90:	fdc42703          	lw	a4,-36(s0)
  94:	02e7e7bb          	remw	a5,a5,a4
  98:	d3f5                	beqz	a5,7c <primes+0x7c>
                if (write(fd[1], &num, sizeof(num)) < 0) {
  9a:	4611                	li	a2,4
  9c:	fcc40593          	addi	a1,s0,-52
  a0:	fd442503          	lw	a0,-44(s0)
  a4:	34e000ef          	jal	3f2 <write>
  a8:	fc055ae3          	bgez	a0,7c <primes+0x7c>
                    printf("Error writing to pipe\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	91c50513          	addi	a0,a0,-1764 # 9c8 <malloc+0x12a>
  b4:	736000ef          	jal	7ea <printf>
                }
            }
        }

        // Close pipes
        close(fd[1]);
  b8:	fd442503          	lw	a0,-44(s0)
  bc:	33e000ef          	jal	3fa <close>
        close(cur_pipe);
  c0:	8526                	mv	a0,s1
  c2:	338000ef          	jal	3fa <close>
        wait(0);  // Wait for child process
  c6:	4501                	li	a0,0
  c8:	312000ef          	jal	3da <wait>
        exit(0);  // Exit after child finishes
  cc:	4501                	li	a0,0
  ce:	304000ef          	jal	3d2 <exit>

00000000000000d2 <main>:
    }
}

int main() {
  d2:	7179                	addi	sp,sp,-48
  d4:	f406                	sd	ra,40(sp)
  d6:	f022                	sd	s0,32(sp)
  d8:	ec26                	sd	s1,24(sp)
  da:	1800                	addi	s0,sp,48
    int fd[2];
    if (pipe(fd) < 0) {
  dc:	fd840513          	addi	a0,s0,-40
  e0:	302000ef          	jal	3e2 <pipe>
  e4:	00054d63          	bltz	a0,fe <main+0x2c>
        printf("Error creating initial pipe\n");
        exit(1);
    }

    int pid = fork();
  e8:	2e2000ef          	jal	3ca <fork>
    if (pid == 0) {
  ec:	e115                	bnez	a0,110 <main+0x3e>
        // Child process to handle prime numbers
        close(fd[1]);  // Close write end of the pipe in child
  ee:	fdc42503          	lw	a0,-36(s0)
  f2:	308000ef          	jal	3fa <close>
        primes(fd[0]); // Start the prime number filtering
  f6:	fd842503          	lw	a0,-40(s0)
  fa:	f07ff0ef          	jal	0 <primes>
        printf("Error creating initial pipe\n");
  fe:	00001517          	auipc	a0,0x1
 102:	8e250513          	addi	a0,a0,-1822 # 9e0 <malloc+0x142>
 106:	6e4000ef          	jal	7ea <printf>
        exit(1);
 10a:	4505                	li	a0,1
 10c:	2c6000ef          	jal	3d2 <exit>
    } else {
        // Parent process generates numbers and writes them to the pipe
        close(fd[0]);  // Close read end of the pipe in parent
 110:	fd842503          	lw	a0,-40(s0)
 114:	2e6000ef          	jal	3fa <close>

        for (int i = 2; i <= 280; i++) {
 118:	4789                	li	a5,2
 11a:	fcf42a23          	sw	a5,-44(s0)
 11e:	11800493          	li	s1,280
            if (write(fd[1], &i, sizeof(i)) < 0) {
 122:	4611                	li	a2,4
 124:	fd440593          	addi	a1,s0,-44
 128:	fdc42503          	lw	a0,-36(s0)
 12c:	2c6000ef          	jal	3f2 <write>
 130:	00054c63          	bltz	a0,148 <main+0x76>
        for (int i = 2; i <= 280; i++) {
 134:	fd442783          	lw	a5,-44(s0)
 138:	2785                	addiw	a5,a5,1
 13a:	0007871b          	sext.w	a4,a5
 13e:	fcf42a23          	sw	a5,-44(s0)
 142:	fee4d0e3          	bge	s1,a4,122 <main+0x50>
 146:	a039                	j	154 <main+0x82>
                printf("Error writing to pipe\n");
 148:	00001517          	auipc	a0,0x1
 14c:	88050513          	addi	a0,a0,-1920 # 9c8 <malloc+0x12a>
 150:	69a000ef          	jal	7ea <printf>
                break;
            }
        }

        close(fd[1]);  // Close write end after sending all numbers
 154:	fdc42503          	lw	a0,-36(s0)
 158:	2a2000ef          	jal	3fa <close>
        wait(0);       // Wait for child process to finish
 15c:	4501                	li	a0,0
 15e:	27c000ef          	jal	3da <wait>
    }

    exit(0);
 162:	4501                	li	a0,0
 164:	26e000ef          	jal	3d2 <exit>

0000000000000168 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 168:	1141                	addi	sp,sp,-16
 16a:	e406                	sd	ra,8(sp)
 16c:	e022                	sd	s0,0(sp)
 16e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 170:	f63ff0ef          	jal	d2 <main>
  exit(0);
 174:	4501                	li	a0,0
 176:	25c000ef          	jal	3d2 <exit>

000000000000017a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 17a:	1141                	addi	sp,sp,-16
 17c:	e422                	sd	s0,8(sp)
 17e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 180:	87aa                	mv	a5,a0
 182:	0585                	addi	a1,a1,1
 184:	0785                	addi	a5,a5,1
 186:	fff5c703          	lbu	a4,-1(a1)
 18a:	fee78fa3          	sb	a4,-1(a5)
 18e:	fb75                	bnez	a4,182 <strcpy+0x8>
    ;
  return os;
}
 190:	6422                	ld	s0,8(sp)
 192:	0141                	addi	sp,sp,16
 194:	8082                	ret

0000000000000196 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 19c:	00054783          	lbu	a5,0(a0)
 1a0:	cb91                	beqz	a5,1b4 <strcmp+0x1e>
 1a2:	0005c703          	lbu	a4,0(a1)
 1a6:	00f71763          	bne	a4,a5,1b4 <strcmp+0x1e>
    p++, q++;
 1aa:	0505                	addi	a0,a0,1
 1ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	fbe5                	bnez	a5,1a2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1b4:	0005c503          	lbu	a0,0(a1)
}
 1b8:	40a7853b          	subw	a0,a5,a0
 1bc:	6422                	ld	s0,8(sp)
 1be:	0141                	addi	sp,sp,16
 1c0:	8082                	ret

00000000000001c2 <strlen>:

uint
strlen(const char *s)
{
 1c2:	1141                	addi	sp,sp,-16
 1c4:	e422                	sd	s0,8(sp)
 1c6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c8:	00054783          	lbu	a5,0(a0)
 1cc:	cf91                	beqz	a5,1e8 <strlen+0x26>
 1ce:	0505                	addi	a0,a0,1
 1d0:	87aa                	mv	a5,a0
 1d2:	86be                	mv	a3,a5
 1d4:	0785                	addi	a5,a5,1
 1d6:	fff7c703          	lbu	a4,-1(a5)
 1da:	ff65                	bnez	a4,1d2 <strlen+0x10>
 1dc:	40a6853b          	subw	a0,a3,a0
 1e0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1e2:	6422                	ld	s0,8(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret
  for(n = 0; s[n]; n++)
 1e8:	4501                	li	a0,0
 1ea:	bfe5                	j	1e2 <strlen+0x20>

00000000000001ec <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1f2:	ca19                	beqz	a2,208 <memset+0x1c>
 1f4:	87aa                	mv	a5,a0
 1f6:	1602                	slli	a2,a2,0x20
 1f8:	9201                	srli	a2,a2,0x20
 1fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 202:	0785                	addi	a5,a5,1
 204:	fee79de3          	bne	a5,a4,1fe <memset+0x12>
  }
  return dst;
}
 208:	6422                	ld	s0,8(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret

000000000000020e <strchr>:

char*
strchr(const char *s, char c)
{
 20e:	1141                	addi	sp,sp,-16
 210:	e422                	sd	s0,8(sp)
 212:	0800                	addi	s0,sp,16
  for(; *s; s++)
 214:	00054783          	lbu	a5,0(a0)
 218:	cb99                	beqz	a5,22e <strchr+0x20>
    if(*s == c)
 21a:	00f58763          	beq	a1,a5,228 <strchr+0x1a>
  for(; *s; s++)
 21e:	0505                	addi	a0,a0,1
 220:	00054783          	lbu	a5,0(a0)
 224:	fbfd                	bnez	a5,21a <strchr+0xc>
      return (char*)s;
  return 0;
 226:	4501                	li	a0,0
}
 228:	6422                	ld	s0,8(sp)
 22a:	0141                	addi	sp,sp,16
 22c:	8082                	ret
  return 0;
 22e:	4501                	li	a0,0
 230:	bfe5                	j	228 <strchr+0x1a>

0000000000000232 <gets>:

char*
gets(char *buf, int max)
{
 232:	711d                	addi	sp,sp,-96
 234:	ec86                	sd	ra,88(sp)
 236:	e8a2                	sd	s0,80(sp)
 238:	e4a6                	sd	s1,72(sp)
 23a:	e0ca                	sd	s2,64(sp)
 23c:	fc4e                	sd	s3,56(sp)
 23e:	f852                	sd	s4,48(sp)
 240:	f456                	sd	s5,40(sp)
 242:	f05a                	sd	s6,32(sp)
 244:	ec5e                	sd	s7,24(sp)
 246:	1080                	addi	s0,sp,96
 248:	8baa                	mv	s7,a0
 24a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24c:	892a                	mv	s2,a0
 24e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 250:	4aa9                	li	s5,10
 252:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 254:	89a6                	mv	s3,s1
 256:	2485                	addiw	s1,s1,1
 258:	0344d663          	bge	s1,s4,284 <gets+0x52>
    cc = read(0, &c, 1);
 25c:	4605                	li	a2,1
 25e:	faf40593          	addi	a1,s0,-81
 262:	4501                	li	a0,0
 264:	186000ef          	jal	3ea <read>
    if(cc < 1)
 268:	00a05e63          	blez	a0,284 <gets+0x52>
    buf[i++] = c;
 26c:	faf44783          	lbu	a5,-81(s0)
 270:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 274:	01578763          	beq	a5,s5,282 <gets+0x50>
 278:	0905                	addi	s2,s2,1
 27a:	fd679de3          	bne	a5,s6,254 <gets+0x22>
    buf[i++] = c;
 27e:	89a6                	mv	s3,s1
 280:	a011                	j	284 <gets+0x52>
 282:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 284:	99de                	add	s3,s3,s7
 286:	00098023          	sb	zero,0(s3)
  return buf;
}
 28a:	855e                	mv	a0,s7
 28c:	60e6                	ld	ra,88(sp)
 28e:	6446                	ld	s0,80(sp)
 290:	64a6                	ld	s1,72(sp)
 292:	6906                	ld	s2,64(sp)
 294:	79e2                	ld	s3,56(sp)
 296:	7a42                	ld	s4,48(sp)
 298:	7aa2                	ld	s5,40(sp)
 29a:	7b02                	ld	s6,32(sp)
 29c:	6be2                	ld	s7,24(sp)
 29e:	6125                	addi	sp,sp,96
 2a0:	8082                	ret

00000000000002a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a2:	1101                	addi	sp,sp,-32
 2a4:	ec06                	sd	ra,24(sp)
 2a6:	e822                	sd	s0,16(sp)
 2a8:	e04a                	sd	s2,0(sp)
 2aa:	1000                	addi	s0,sp,32
 2ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ae:	4581                	li	a1,0
 2b0:	162000ef          	jal	412 <open>
  if(fd < 0)
 2b4:	02054263          	bltz	a0,2d8 <stat+0x36>
 2b8:	e426                	sd	s1,8(sp)
 2ba:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2bc:	85ca                	mv	a1,s2
 2be:	16c000ef          	jal	42a <fstat>
 2c2:	892a                	mv	s2,a0
  close(fd);
 2c4:	8526                	mv	a0,s1
 2c6:	134000ef          	jal	3fa <close>
  return r;
 2ca:	64a2                	ld	s1,8(sp)
}
 2cc:	854a                	mv	a0,s2
 2ce:	60e2                	ld	ra,24(sp)
 2d0:	6442                	ld	s0,16(sp)
 2d2:	6902                	ld	s2,0(sp)
 2d4:	6105                	addi	sp,sp,32
 2d6:	8082                	ret
    return -1;
 2d8:	597d                	li	s2,-1
 2da:	bfcd                	j	2cc <stat+0x2a>

00000000000002dc <atoi>:

int
atoi(const char *s)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e2:	00054683          	lbu	a3,0(a0)
 2e6:	fd06879b          	addiw	a5,a3,-48
 2ea:	0ff7f793          	zext.b	a5,a5
 2ee:	4625                	li	a2,9
 2f0:	02f66863          	bltu	a2,a5,320 <atoi+0x44>
 2f4:	872a                	mv	a4,a0
  n = 0;
 2f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2f8:	0705                	addi	a4,a4,1
 2fa:	0025179b          	slliw	a5,a0,0x2
 2fe:	9fa9                	addw	a5,a5,a0
 300:	0017979b          	slliw	a5,a5,0x1
 304:	9fb5                	addw	a5,a5,a3
 306:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 30a:	00074683          	lbu	a3,0(a4)
 30e:	fd06879b          	addiw	a5,a3,-48
 312:	0ff7f793          	zext.b	a5,a5
 316:	fef671e3          	bgeu	a2,a5,2f8 <atoi+0x1c>
  return n;
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
  n = 0;
 320:	4501                	li	a0,0
 322:	bfe5                	j	31a <atoi+0x3e>

0000000000000324 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 32a:	02b57463          	bgeu	a0,a1,352 <memmove+0x2e>
    while(n-- > 0)
 32e:	00c05f63          	blez	a2,34c <memmove+0x28>
 332:	1602                	slli	a2,a2,0x20
 334:	9201                	srli	a2,a2,0x20
 336:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 33a:	872a                	mv	a4,a0
      *dst++ = *src++;
 33c:	0585                	addi	a1,a1,1
 33e:	0705                	addi	a4,a4,1
 340:	fff5c683          	lbu	a3,-1(a1)
 344:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 348:	fef71ae3          	bne	a4,a5,33c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
    dst += n;
 352:	00c50733          	add	a4,a0,a2
    src += n;
 356:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 358:	fec05ae3          	blez	a2,34c <memmove+0x28>
 35c:	fff6079b          	addiw	a5,a2,-1
 360:	1782                	slli	a5,a5,0x20
 362:	9381                	srli	a5,a5,0x20
 364:	fff7c793          	not	a5,a5
 368:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 36a:	15fd                	addi	a1,a1,-1
 36c:	177d                	addi	a4,a4,-1
 36e:	0005c683          	lbu	a3,0(a1)
 372:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 376:	fee79ae3          	bne	a5,a4,36a <memmove+0x46>
 37a:	bfc9                	j	34c <memmove+0x28>

000000000000037c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e422                	sd	s0,8(sp)
 380:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 382:	ca05                	beqz	a2,3b2 <memcmp+0x36>
 384:	fff6069b          	addiw	a3,a2,-1
 388:	1682                	slli	a3,a3,0x20
 38a:	9281                	srli	a3,a3,0x20
 38c:	0685                	addi	a3,a3,1
 38e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 390:	00054783          	lbu	a5,0(a0)
 394:	0005c703          	lbu	a4,0(a1)
 398:	00e79863          	bne	a5,a4,3a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 39c:	0505                	addi	a0,a0,1
    p2++;
 39e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3a0:	fed518e3          	bne	a0,a3,390 <memcmp+0x14>
  }
  return 0;
 3a4:	4501                	li	a0,0
 3a6:	a019                	j	3ac <memcmp+0x30>
      return *p1 - *p2;
 3a8:	40e7853b          	subw	a0,a5,a4
}
 3ac:	6422                	ld	s0,8(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret
  return 0;
 3b2:	4501                	li	a0,0
 3b4:	bfe5                	j	3ac <memcmp+0x30>

00000000000003b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e406                	sd	ra,8(sp)
 3ba:	e022                	sd	s0,0(sp)
 3bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3be:	f67ff0ef          	jal	324 <memmove>
}
 3c2:	60a2                	ld	ra,8(sp)
 3c4:	6402                	ld	s0,0(sp)
 3c6:	0141                	addi	sp,sp,16
 3c8:	8082                	ret

00000000000003ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ca:	4885                	li	a7,1
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d2:	4889                	li	a7,2
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <wait>:
.global wait
wait:
 li a7, SYS_wait
 3da:	488d                	li	a7,3
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e2:	4891                	li	a7,4
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <read>:
.global read
read:
 li a7, SYS_read
 3ea:	4895                	li	a7,5
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <write>:
.global write
write:
 li a7, SYS_write
 3f2:	48c1                	li	a7,16
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <close>:
.global close
close:
 li a7, SYS_close
 3fa:	48d5                	li	a7,21
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <kill>:
.global kill
kill:
 li a7, SYS_kill
 402:	4899                	li	a7,6
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <exec>:
.global exec
exec:
 li a7, SYS_exec
 40a:	489d                	li	a7,7
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <open>:
.global open
open:
 li a7, SYS_open
 412:	48bd                	li	a7,15
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 41a:	48c5                	li	a7,17
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 422:	48c9                	li	a7,18
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 42a:	48a1                	li	a7,8
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <link>:
.global link
link:
 li a7, SYS_link
 432:	48cd                	li	a7,19
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 43a:	48d1                	li	a7,20
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 442:	48a5                	li	a7,9
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <dup>:
.global dup
dup:
 li a7, SYS_dup
 44a:	48a9                	li	a7,10
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 452:	48ad                	li	a7,11
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 45a:	48b1                	li	a7,12
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 462:	48b5                	li	a7,13
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 46a:	48b9                	li	a7,14
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 472:	1101                	addi	sp,sp,-32
 474:	ec06                	sd	ra,24(sp)
 476:	e822                	sd	s0,16(sp)
 478:	1000                	addi	s0,sp,32
 47a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47e:	4605                	li	a2,1
 480:	fef40593          	addi	a1,s0,-17
 484:	f6fff0ef          	jal	3f2 <write>
}
 488:	60e2                	ld	ra,24(sp)
 48a:	6442                	ld	s0,16(sp)
 48c:	6105                	addi	sp,sp,32
 48e:	8082                	ret

0000000000000490 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 490:	7139                	addi	sp,sp,-64
 492:	fc06                	sd	ra,56(sp)
 494:	f822                	sd	s0,48(sp)
 496:	f426                	sd	s1,40(sp)
 498:	0080                	addi	s0,sp,64
 49a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 49c:	c299                	beqz	a3,4a2 <printint+0x12>
 49e:	0805c963          	bltz	a1,530 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4a2:	2581                	sext.w	a1,a1
  neg = 0;
 4a4:	4881                	li	a7,0
 4a6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4aa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ac:	2601                	sext.w	a2,a2
 4ae:	00000517          	auipc	a0,0x0
 4b2:	55a50513          	addi	a0,a0,1370 # a08 <digits>
 4b6:	883a                	mv	a6,a4
 4b8:	2705                	addiw	a4,a4,1
 4ba:	02c5f7bb          	remuw	a5,a1,a2
 4be:	1782                	slli	a5,a5,0x20
 4c0:	9381                	srli	a5,a5,0x20
 4c2:	97aa                	add	a5,a5,a0
 4c4:	0007c783          	lbu	a5,0(a5)
 4c8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4cc:	0005879b          	sext.w	a5,a1
 4d0:	02c5d5bb          	divuw	a1,a1,a2
 4d4:	0685                	addi	a3,a3,1
 4d6:	fec7f0e3          	bgeu	a5,a2,4b6 <printint+0x26>
  if(neg)
 4da:	00088c63          	beqz	a7,4f2 <printint+0x62>
    buf[i++] = '-';
 4de:	fd070793          	addi	a5,a4,-48
 4e2:	00878733          	add	a4,a5,s0
 4e6:	02d00793          	li	a5,45
 4ea:	fef70823          	sb	a5,-16(a4)
 4ee:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4f2:	02e05a63          	blez	a4,526 <printint+0x96>
 4f6:	f04a                	sd	s2,32(sp)
 4f8:	ec4e                	sd	s3,24(sp)
 4fa:	fc040793          	addi	a5,s0,-64
 4fe:	00e78933          	add	s2,a5,a4
 502:	fff78993          	addi	s3,a5,-1
 506:	99ba                	add	s3,s3,a4
 508:	377d                	addiw	a4,a4,-1
 50a:	1702                	slli	a4,a4,0x20
 50c:	9301                	srli	a4,a4,0x20
 50e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 512:	fff94583          	lbu	a1,-1(s2)
 516:	8526                	mv	a0,s1
 518:	f5bff0ef          	jal	472 <putc>
  while(--i >= 0)
 51c:	197d                	addi	s2,s2,-1
 51e:	ff391ae3          	bne	s2,s3,512 <printint+0x82>
 522:	7902                	ld	s2,32(sp)
 524:	69e2                	ld	s3,24(sp)
}
 526:	70e2                	ld	ra,56(sp)
 528:	7442                	ld	s0,48(sp)
 52a:	74a2                	ld	s1,40(sp)
 52c:	6121                	addi	sp,sp,64
 52e:	8082                	ret
    x = -xx;
 530:	40b005bb          	negw	a1,a1
    neg = 1;
 534:	4885                	li	a7,1
    x = -xx;
 536:	bf85                	j	4a6 <printint+0x16>

0000000000000538 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 538:	711d                	addi	sp,sp,-96
 53a:	ec86                	sd	ra,88(sp)
 53c:	e8a2                	sd	s0,80(sp)
 53e:	e0ca                	sd	s2,64(sp)
 540:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 542:	0005c903          	lbu	s2,0(a1)
 546:	26090863          	beqz	s2,7b6 <vprintf+0x27e>
 54a:	e4a6                	sd	s1,72(sp)
 54c:	fc4e                	sd	s3,56(sp)
 54e:	f852                	sd	s4,48(sp)
 550:	f456                	sd	s5,40(sp)
 552:	f05a                	sd	s6,32(sp)
 554:	ec5e                	sd	s7,24(sp)
 556:	e862                	sd	s8,16(sp)
 558:	e466                	sd	s9,8(sp)
 55a:	8b2a                	mv	s6,a0
 55c:	8a2e                	mv	s4,a1
 55e:	8bb2                	mv	s7,a2
  state = 0;
 560:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 562:	4481                	li	s1,0
 564:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 566:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 56a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 56e:	06c00c93          	li	s9,108
 572:	a005                	j	592 <vprintf+0x5a>
        putc(fd, c0);
 574:	85ca                	mv	a1,s2
 576:	855a                	mv	a0,s6
 578:	efbff0ef          	jal	472 <putc>
 57c:	a019                	j	582 <vprintf+0x4a>
    } else if(state == '%'){
 57e:	03598263          	beq	s3,s5,5a2 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 582:	2485                	addiw	s1,s1,1
 584:	8726                	mv	a4,s1
 586:	009a07b3          	add	a5,s4,s1
 58a:	0007c903          	lbu	s2,0(a5)
 58e:	20090c63          	beqz	s2,7a6 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 592:	0009079b          	sext.w	a5,s2
    if(state == 0){
 596:	fe0994e3          	bnez	s3,57e <vprintf+0x46>
      if(c0 == '%'){
 59a:	fd579de3          	bne	a5,s5,574 <vprintf+0x3c>
        state = '%';
 59e:	89be                	mv	s3,a5
 5a0:	b7cd                	j	582 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5a2:	00ea06b3          	add	a3,s4,a4
 5a6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5aa:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5ac:	c681                	beqz	a3,5b4 <vprintf+0x7c>
 5ae:	9752                	add	a4,a4,s4
 5b0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5b4:	03878f63          	beq	a5,s8,5f2 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5b8:	05978963          	beq	a5,s9,60a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5bc:	07500713          	li	a4,117
 5c0:	0ee78363          	beq	a5,a4,6a6 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5c4:	07800713          	li	a4,120
 5c8:	12e78563          	beq	a5,a4,6f2 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5cc:	07000713          	li	a4,112
 5d0:	14e78a63          	beq	a5,a4,724 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5d4:	07300713          	li	a4,115
 5d8:	18e78a63          	beq	a5,a4,76c <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5dc:	02500713          	li	a4,37
 5e0:	04e79563          	bne	a5,a4,62a <vprintf+0xf2>
        putc(fd, '%');
 5e4:	02500593          	li	a1,37
 5e8:	855a                	mv	a0,s6
 5ea:	e89ff0ef          	jal	472 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	bf49                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5f2:	008b8913          	addi	s2,s7,8
 5f6:	4685                	li	a3,1
 5f8:	4629                	li	a2,10
 5fa:	000ba583          	lw	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	e91ff0ef          	jal	490 <printint>
 604:	8bca                	mv	s7,s2
      state = 0;
 606:	4981                	li	s3,0
 608:	bfad                	j	582 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 60a:	06400793          	li	a5,100
 60e:	02f68963          	beq	a3,a5,640 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 612:	06c00793          	li	a5,108
 616:	04f68263          	beq	a3,a5,65a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 61a:	07500793          	li	a5,117
 61e:	0af68063          	beq	a3,a5,6be <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 622:	07800793          	li	a5,120
 626:	0ef68263          	beq	a3,a5,70a <vprintf+0x1d2>
        putc(fd, '%');
 62a:	02500593          	li	a1,37
 62e:	855a                	mv	a0,s6
 630:	e43ff0ef          	jal	472 <putc>
        putc(fd, c0);
 634:	85ca                	mv	a1,s2
 636:	855a                	mv	a0,s6
 638:	e3bff0ef          	jal	472 <putc>
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b791                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 640:	008b8913          	addi	s2,s7,8
 644:	4685                	li	a3,1
 646:	4629                	li	a2,10
 648:	000ba583          	lw	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	e43ff0ef          	jal	490 <printint>
        i += 1;
 652:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 654:	8bca                	mv	s7,s2
      state = 0;
 656:	4981                	li	s3,0
        i += 1;
 658:	b72d                	j	582 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 65a:	06400793          	li	a5,100
 65e:	02f60763          	beq	a2,a5,68c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 662:	07500793          	li	a5,117
 666:	06f60963          	beq	a2,a5,6d8 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 66a:	07800793          	li	a5,120
 66e:	faf61ee3          	bne	a2,a5,62a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 672:	008b8913          	addi	s2,s7,8
 676:	4681                	li	a3,0
 678:	4641                	li	a2,16
 67a:	000ba583          	lw	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	e11ff0ef          	jal	490 <printint>
        i += 2;
 684:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 686:	8bca                	mv	s7,s2
      state = 0;
 688:	4981                	li	s3,0
        i += 2;
 68a:	bde5                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 68c:	008b8913          	addi	s2,s7,8
 690:	4685                	li	a3,1
 692:	4629                	li	a2,10
 694:	000ba583          	lw	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	df7ff0ef          	jal	490 <printint>
        i += 2;
 69e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
        i += 2;
 6a4:	bdf9                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6a6:	008b8913          	addi	s2,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4629                	li	a2,10
 6ae:	000ba583          	lw	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	dddff0ef          	jal	490 <printint>
 6b8:	8bca                	mv	s7,s2
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	b5d9                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6be:	008b8913          	addi	s2,s7,8
 6c2:	4681                	li	a3,0
 6c4:	4629                	li	a2,10
 6c6:	000ba583          	lw	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	dc5ff0ef          	jal	490 <printint>
        i += 1;
 6d0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d2:	8bca                	mv	s7,s2
      state = 0;
 6d4:	4981                	li	s3,0
        i += 1;
 6d6:	b575                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d8:	008b8913          	addi	s2,s7,8
 6dc:	4681                	li	a3,0
 6de:	4629                	li	a2,10
 6e0:	000ba583          	lw	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	dabff0ef          	jal	490 <printint>
        i += 2;
 6ea:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
        i += 2;
 6f0:	bd49                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6f2:	008b8913          	addi	s2,s7,8
 6f6:	4681                	li	a3,0
 6f8:	4641                	li	a2,16
 6fa:	000ba583          	lw	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	d91ff0ef          	jal	490 <printint>
 704:	8bca                	mv	s7,s2
      state = 0;
 706:	4981                	li	s3,0
 708:	bdad                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 70a:	008b8913          	addi	s2,s7,8
 70e:	4681                	li	a3,0
 710:	4641                	li	a2,16
 712:	000ba583          	lw	a1,0(s7)
 716:	855a                	mv	a0,s6
 718:	d79ff0ef          	jal	490 <printint>
        i += 1;
 71c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 71e:	8bca                	mv	s7,s2
      state = 0;
 720:	4981                	li	s3,0
        i += 1;
 722:	b585                	j	582 <vprintf+0x4a>
 724:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 726:	008b8d13          	addi	s10,s7,8
 72a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 72e:	03000593          	li	a1,48
 732:	855a                	mv	a0,s6
 734:	d3fff0ef          	jal	472 <putc>
  putc(fd, 'x');
 738:	07800593          	li	a1,120
 73c:	855a                	mv	a0,s6
 73e:	d35ff0ef          	jal	472 <putc>
 742:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 744:	00000b97          	auipc	s7,0x0
 748:	2c4b8b93          	addi	s7,s7,708 # a08 <digits>
 74c:	03c9d793          	srli	a5,s3,0x3c
 750:	97de                	add	a5,a5,s7
 752:	0007c583          	lbu	a1,0(a5)
 756:	855a                	mv	a0,s6
 758:	d1bff0ef          	jal	472 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 75c:	0992                	slli	s3,s3,0x4
 75e:	397d                	addiw	s2,s2,-1
 760:	fe0916e3          	bnez	s2,74c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 764:	8bea                	mv	s7,s10
      state = 0;
 766:	4981                	li	s3,0
 768:	6d02                	ld	s10,0(sp)
 76a:	bd21                	j	582 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 76c:	008b8993          	addi	s3,s7,8
 770:	000bb903          	ld	s2,0(s7)
 774:	00090f63          	beqz	s2,792 <vprintf+0x25a>
        for(; *s; s++)
 778:	00094583          	lbu	a1,0(s2)
 77c:	c195                	beqz	a1,7a0 <vprintf+0x268>
          putc(fd, *s);
 77e:	855a                	mv	a0,s6
 780:	cf3ff0ef          	jal	472 <putc>
        for(; *s; s++)
 784:	0905                	addi	s2,s2,1
 786:	00094583          	lbu	a1,0(s2)
 78a:	f9f5                	bnez	a1,77e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 78c:	8bce                	mv	s7,s3
      state = 0;
 78e:	4981                	li	s3,0
 790:	bbcd                	j	582 <vprintf+0x4a>
          s = "(null)";
 792:	00000917          	auipc	s2,0x0
 796:	26e90913          	addi	s2,s2,622 # a00 <malloc+0x162>
        for(; *s; s++)
 79a:	02800593          	li	a1,40
 79e:	b7c5                	j	77e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7a0:	8bce                	mv	s7,s3
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	bbf9                	j	582 <vprintf+0x4a>
 7a6:	64a6                	ld	s1,72(sp)
 7a8:	79e2                	ld	s3,56(sp)
 7aa:	7a42                	ld	s4,48(sp)
 7ac:	7aa2                	ld	s5,40(sp)
 7ae:	7b02                	ld	s6,32(sp)
 7b0:	6be2                	ld	s7,24(sp)
 7b2:	6c42                	ld	s8,16(sp)
 7b4:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7b6:	60e6                	ld	ra,88(sp)
 7b8:	6446                	ld	s0,80(sp)
 7ba:	6906                	ld	s2,64(sp)
 7bc:	6125                	addi	sp,sp,96
 7be:	8082                	ret

00000000000007c0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7c0:	715d                	addi	sp,sp,-80
 7c2:	ec06                	sd	ra,24(sp)
 7c4:	e822                	sd	s0,16(sp)
 7c6:	1000                	addi	s0,sp,32
 7c8:	e010                	sd	a2,0(s0)
 7ca:	e414                	sd	a3,8(s0)
 7cc:	e818                	sd	a4,16(s0)
 7ce:	ec1c                	sd	a5,24(s0)
 7d0:	03043023          	sd	a6,32(s0)
 7d4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7dc:	8622                	mv	a2,s0
 7de:	d5bff0ef          	jal	538 <vprintf>
}
 7e2:	60e2                	ld	ra,24(sp)
 7e4:	6442                	ld	s0,16(sp)
 7e6:	6161                	addi	sp,sp,80
 7e8:	8082                	ret

00000000000007ea <printf>:

void
printf(const char *fmt, ...)
{
 7ea:	711d                	addi	sp,sp,-96
 7ec:	ec06                	sd	ra,24(sp)
 7ee:	e822                	sd	s0,16(sp)
 7f0:	1000                	addi	s0,sp,32
 7f2:	e40c                	sd	a1,8(s0)
 7f4:	e810                	sd	a2,16(s0)
 7f6:	ec14                	sd	a3,24(s0)
 7f8:	f018                	sd	a4,32(s0)
 7fa:	f41c                	sd	a5,40(s0)
 7fc:	03043823          	sd	a6,48(s0)
 800:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 804:	00840613          	addi	a2,s0,8
 808:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 80c:	85aa                	mv	a1,a0
 80e:	4505                	li	a0,1
 810:	d29ff0ef          	jal	538 <vprintf>
}
 814:	60e2                	ld	ra,24(sp)
 816:	6442                	ld	s0,16(sp)
 818:	6125                	addi	sp,sp,96
 81a:	8082                	ret

000000000000081c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 81c:	1141                	addi	sp,sp,-16
 81e:	e422                	sd	s0,8(sp)
 820:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 822:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 826:	00000797          	auipc	a5,0x0
 82a:	7da7b783          	ld	a5,2010(a5) # 1000 <freep>
 82e:	a02d                	j	858 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 830:	4618                	lw	a4,8(a2)
 832:	9f2d                	addw	a4,a4,a1
 834:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 838:	6398                	ld	a4,0(a5)
 83a:	6310                	ld	a2,0(a4)
 83c:	a83d                	j	87a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 83e:	ff852703          	lw	a4,-8(a0)
 842:	9f31                	addw	a4,a4,a2
 844:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 846:	ff053683          	ld	a3,-16(a0)
 84a:	a091                	j	88e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84c:	6398                	ld	a4,0(a5)
 84e:	00e7e463          	bltu	a5,a4,856 <free+0x3a>
 852:	00e6ea63          	bltu	a3,a4,866 <free+0x4a>
{
 856:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 858:	fed7fae3          	bgeu	a5,a3,84c <free+0x30>
 85c:	6398                	ld	a4,0(a5)
 85e:	00e6e463          	bltu	a3,a4,866 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 862:	fee7eae3          	bltu	a5,a4,856 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 866:	ff852583          	lw	a1,-8(a0)
 86a:	6390                	ld	a2,0(a5)
 86c:	02059813          	slli	a6,a1,0x20
 870:	01c85713          	srli	a4,a6,0x1c
 874:	9736                	add	a4,a4,a3
 876:	fae60de3          	beq	a2,a4,830 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 87a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 87e:	4790                	lw	a2,8(a5)
 880:	02061593          	slli	a1,a2,0x20
 884:	01c5d713          	srli	a4,a1,0x1c
 888:	973e                	add	a4,a4,a5
 88a:	fae68ae3          	beq	a3,a4,83e <free+0x22>
    p->s.ptr = bp->s.ptr;
 88e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 890:	00000717          	auipc	a4,0x0
 894:	76f73823          	sd	a5,1904(a4) # 1000 <freep>
}
 898:	6422                	ld	s0,8(sp)
 89a:	0141                	addi	sp,sp,16
 89c:	8082                	ret

000000000000089e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 89e:	7139                	addi	sp,sp,-64
 8a0:	fc06                	sd	ra,56(sp)
 8a2:	f822                	sd	s0,48(sp)
 8a4:	f426                	sd	s1,40(sp)
 8a6:	ec4e                	sd	s3,24(sp)
 8a8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8aa:	02051493          	slli	s1,a0,0x20
 8ae:	9081                	srli	s1,s1,0x20
 8b0:	04bd                	addi	s1,s1,15
 8b2:	8091                	srli	s1,s1,0x4
 8b4:	0014899b          	addiw	s3,s1,1
 8b8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8ba:	00000517          	auipc	a0,0x0
 8be:	74653503          	ld	a0,1862(a0) # 1000 <freep>
 8c2:	c915                	beqz	a0,8f6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c6:	4798                	lw	a4,8(a5)
 8c8:	08977a63          	bgeu	a4,s1,95c <malloc+0xbe>
 8cc:	f04a                	sd	s2,32(sp)
 8ce:	e852                	sd	s4,16(sp)
 8d0:	e456                	sd	s5,8(sp)
 8d2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8d4:	8a4e                	mv	s4,s3
 8d6:	0009871b          	sext.w	a4,s3
 8da:	6685                	lui	a3,0x1
 8dc:	00d77363          	bgeu	a4,a3,8e2 <malloc+0x44>
 8e0:	6a05                	lui	s4,0x1
 8e2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ea:	00000917          	auipc	s2,0x0
 8ee:	71690913          	addi	s2,s2,1814 # 1000 <freep>
  if(p == (char*)-1)
 8f2:	5afd                	li	s5,-1
 8f4:	a081                	j	934 <malloc+0x96>
 8f6:	f04a                	sd	s2,32(sp)
 8f8:	e852                	sd	s4,16(sp)
 8fa:	e456                	sd	s5,8(sp)
 8fc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8fe:	00000797          	auipc	a5,0x0
 902:	71278793          	addi	a5,a5,1810 # 1010 <base>
 906:	00000717          	auipc	a4,0x0
 90a:	6ef73d23          	sd	a5,1786(a4) # 1000 <freep>
 90e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 910:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 914:	b7c1                	j	8d4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 916:	6398                	ld	a4,0(a5)
 918:	e118                	sd	a4,0(a0)
 91a:	a8a9                	j	974 <malloc+0xd6>
  hp->s.size = nu;
 91c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 920:	0541                	addi	a0,a0,16
 922:	efbff0ef          	jal	81c <free>
  return freep;
 926:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 92a:	c12d                	beqz	a0,98c <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 92e:	4798                	lw	a4,8(a5)
 930:	02977263          	bgeu	a4,s1,954 <malloc+0xb6>
    if(p == freep)
 934:	00093703          	ld	a4,0(s2)
 938:	853e                	mv	a0,a5
 93a:	fef719e3          	bne	a4,a5,92c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 93e:	8552                	mv	a0,s4
 940:	b1bff0ef          	jal	45a <sbrk>
  if(p == (char*)-1)
 944:	fd551ce3          	bne	a0,s5,91c <malloc+0x7e>
        return 0;
 948:	4501                	li	a0,0
 94a:	7902                	ld	s2,32(sp)
 94c:	6a42                	ld	s4,16(sp)
 94e:	6aa2                	ld	s5,8(sp)
 950:	6b02                	ld	s6,0(sp)
 952:	a03d                	j	980 <malloc+0xe2>
 954:	7902                	ld	s2,32(sp)
 956:	6a42                	ld	s4,16(sp)
 958:	6aa2                	ld	s5,8(sp)
 95a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 95c:	fae48de3          	beq	s1,a4,916 <malloc+0x78>
        p->s.size -= nunits;
 960:	4137073b          	subw	a4,a4,s3
 964:	c798                	sw	a4,8(a5)
        p += p->s.size;
 966:	02071693          	slli	a3,a4,0x20
 96a:	01c6d713          	srli	a4,a3,0x1c
 96e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 970:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 974:	00000717          	auipc	a4,0x0
 978:	68a73623          	sd	a0,1676(a4) # 1000 <freep>
      return (void*)(p + 1);
 97c:	01078513          	addi	a0,a5,16
  }
}
 980:	70e2                	ld	ra,56(sp)
 982:	7442                	ld	s0,48(sp)
 984:	74a2                	ld	s1,40(sp)
 986:	69e2                	ld	s3,24(sp)
 988:	6121                	addi	sp,sp,64
 98a:	8082                	ret
 98c:	7902                	ld	s2,32(sp)
 98e:	6a42                	ld	s4,16(sp)
 990:	6aa2                	ld	s5,8(sp)
 992:	6b02                	ld	s6,0(sp)
 994:	b7f5                	j	980 <malloc+0xe2>
