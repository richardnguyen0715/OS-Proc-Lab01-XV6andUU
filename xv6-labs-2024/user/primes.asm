
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <primes>:
// #include<string.h>


void primes(int cur_pipe)__attribute__((noreturn));

void primes(int cur_pipe){
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
   a:	84aa                	mv	s1,a0
    int val;
    int c_read = read(cur_pipe, &val, sizeof(val)); // c_read: check_read
   c:	4611                	li	a2,4
   e:	fdc40593          	addi	a1,s0,-36
  12:	3de000ef          	jal	3f0 <read>
    if(c_read == 0){
  16:	e519                	bnez	a0,24 <primes+0x24>
        close(cur_pipe);
  18:	8526                	mv	a0,s1
  1a:	3e6000ef          	jal	400 <close>
        exit(0);
  1e:	4501                	li	a0,0
  20:	3b8000ef          	jal	3d8 <exit>
    }

    printf("prime: %d\n",val);
  24:	fdc42583          	lw	a1,-36(s0)
  28:	00001517          	auipc	a0,0x1
  2c:	97850513          	addi	a0,a0,-1672 # 9a0 <malloc+0xfc>
  30:	7c0000ef          	jal	7f0 <printf>

    int fd[2];
    pipe(fd);
  34:	fd040513          	addi	a0,s0,-48
  38:	3b0000ef          	jal	3e8 <pipe>
    int pid = fork();
  3c:	394000ef          	jal	3d0 <fork>

    if(pid < 0){
  40:	00054b63          	bltz	a0,56 <primes+0x56>
        printf("Cannot create process! - Error: fork() function failed!");
        exit(0);
    }
    else if(pid == 0){
  44:	e115                	bnez	a0,68 <primes+0x68>
        close(fd[1]); // Close write pipe.
  46:	fd442503          	lw	a0,-44(s0)
  4a:	3b6000ef          	jal	400 <close>

        primes(fd[0]);
  4e:	fd042503          	lw	a0,-48(s0)
  52:	fafff0ef          	jal	0 <primes>
        printf("Cannot create process! - Error: fork() function failed!");
  56:	00001517          	auipc	a0,0x1
  5a:	95a50513          	addi	a0,a0,-1702 # 9b0 <malloc+0x10c>
  5e:	792000ef          	jal	7f0 <printf>
        exit(0);
  62:	4501                	li	a0,0
  64:	374000ef          	jal	3d8 <exit>

        close(fd[0]);
    }
    else {
        int check_prime;
        close(fd[0]); // Close read pipe.
  68:	fd042503          	lw	a0,-48(s0)
  6c:	394000ef          	jal	400 <close>
        int c_read;
        while((c_read = read(cur_pipe, &check_prime, sizeof(check_prime))) > 0){
  70:	4611                	li	a2,4
  72:	fcc40593          	addi	a1,s0,-52
  76:	8526                	mv	a0,s1
  78:	378000ef          	jal	3f0 <read>
  7c:	02a05163          	blez	a0,9e <primes+0x9e>
            if(check_prime % val != 0){
  80:	fcc42783          	lw	a5,-52(s0)
  84:	fdc42703          	lw	a4,-36(s0)
  88:	02e7e7bb          	remw	a5,a5,a4
  8c:	d3f5                	beqz	a5,70 <primes+0x70>
                write(fd[1], &check_prime, sizeof(check_prime));
  8e:	4611                	li	a2,4
  90:	fcc40593          	addi	a1,s0,-52
  94:	fd442503          	lw	a0,-44(s0)
  98:	360000ef          	jal	3f8 <write>
  9c:	bfd1                	j	70 <primes+0x70>
            }
        }
        if(c_read == -1){
  9e:	57fd                	li	a5,-1
  a0:	00f50f63          	beq	a0,a5,be <primes+0xbe>
            printf("Error reading from pipe\n");
        }
        close(fd[1]);
  a4:	fd442503          	lw	a0,-44(s0)
  a8:	358000ef          	jal	400 <close>
        close(cur_pipe);
  ac:	8526                	mv	a0,s1
  ae:	352000ef          	jal	400 <close>
        wait(0);
  b2:	4501                	li	a0,0
  b4:	32c000ef          	jal	3e0 <wait>
        exit(0);
  b8:	4501                	li	a0,0
  ba:	31e000ef          	jal	3d8 <exit>
            printf("Error reading from pipe\n");
  be:	00001517          	auipc	a0,0x1
  c2:	92a50513          	addi	a0,a0,-1750 # 9e8 <malloc+0x144>
  c6:	72a000ef          	jal	7f0 <printf>
  ca:	bfe9                	j	a4 <primes+0xa4>

00000000000000cc <main>:
}




int main(){
  cc:	7179                	addi	sp,sp,-48
  ce:	f406                	sd	ra,40(sp)
  d0:	f022                	sd	s0,32(sp)
  d2:	1800                	addi	s0,sp,48
    int fd[2];
    int c_pipe = pipe(fd); //fd[0]: read | fd[1]: write
  d4:	fd840513          	addi	a0,s0,-40
  d8:	310000ef          	jal	3e8 <pipe>
    if(c_pipe == -1){
  dc:	57fd                	li	a5,-1
  de:	02f50063          	beq	a0,a5,fe <main+0x32>
        printf("Cannot create pipe! - Error: pipe() function failed!");
        exit(0);
    }

    int pid = fork();
  e2:	2ee000ef          	jal	3d0 <fork>
    
    if(pid < 0){
  e6:	02054663          	bltz	a0,112 <main+0x46>
        printf("RaiseError: Cannot create process!");
        exit(0);
    }
    else if (pid == 0){
  ea:	ed15                	bnez	a0,126 <main+0x5a>
  ec:	ec26                	sd	s1,24(sp)
        //This is the child process
        close(fd[1]);
  ee:	fdc42503          	lw	a0,-36(s0)
  f2:	30e000ef          	jal	400 <close>
        primes(fd[0]);
  f6:	fd842503          	lw	a0,-40(s0)
  fa:	f07ff0ef          	jal	0 <primes>
  fe:	ec26                	sd	s1,24(sp)
        printf("Cannot create pipe! - Error: pipe() function failed!");
 100:	00001517          	auipc	a0,0x1
 104:	90850513          	addi	a0,a0,-1784 # a08 <malloc+0x164>
 108:	6e8000ef          	jal	7f0 <printf>
        exit(0);
 10c:	4501                	li	a0,0
 10e:	2ca000ef          	jal	3d8 <exit>
 112:	ec26                	sd	s1,24(sp)
        printf("RaiseError: Cannot create process!");
 114:	00001517          	auipc	a0,0x1
 118:	92c50513          	addi	a0,a0,-1748 # a40 <malloc+0x19c>
 11c:	6d4000ef          	jal	7f0 <printf>
        exit(0);
 120:	4501                	li	a0,0
 122:	2b6000ef          	jal	3d8 <exit>
 126:	ec26                	sd	s1,24(sp)

    }
    else{
        //This is the parent process    
        close(fd[0]);
 128:	fd842503          	lw	a0,-40(s0)
 12c:	2d4000ef          	jal	400 <close>

        for( int i = 2; i <= 280; i++){
 130:	4789                	li	a5,2
 132:	fcf42a23          	sw	a5,-44(s0)
 136:	11800493          	li	s1,280
            write(fd[1], &i, sizeof(i));
 13a:	4611                	li	a2,4
 13c:	fd440593          	addi	a1,s0,-44
 140:	fdc42503          	lw	a0,-36(s0)
 144:	2b4000ef          	jal	3f8 <write>
        for( int i = 2; i <= 280; i++){
 148:	fd442783          	lw	a5,-44(s0)
 14c:	2785                	addiw	a5,a5,1
 14e:	0007871b          	sext.w	a4,a5
 152:	fcf42a23          	sw	a5,-44(s0)
 156:	fee4d2e3          	bge	s1,a4,13a <main+0x6e>
        }

        close(fd[1]);
 15a:	fdc42503          	lw	a0,-36(s0)
 15e:	2a2000ef          	jal	400 <close>

        wait(0);
 162:	4501                	li	a0,0
 164:	27c000ef          	jal	3e0 <wait>
    }
    exit(0);
 168:	4501                	li	a0,0
 16a:	26e000ef          	jal	3d8 <exit>

000000000000016e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 16e:	1141                	addi	sp,sp,-16
 170:	e406                	sd	ra,8(sp)
 172:	e022                	sd	s0,0(sp)
 174:	0800                	addi	s0,sp,16
  extern int main();
  main();
 176:	f57ff0ef          	jal	cc <main>
  exit(0);
 17a:	4501                	li	a0,0
 17c:	25c000ef          	jal	3d8 <exit>

0000000000000180 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 180:	1141                	addi	sp,sp,-16
 182:	e422                	sd	s0,8(sp)
 184:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 186:	87aa                	mv	a5,a0
 188:	0585                	addi	a1,a1,1
 18a:	0785                	addi	a5,a5,1
 18c:	fff5c703          	lbu	a4,-1(a1)
 190:	fee78fa3          	sb	a4,-1(a5)
 194:	fb75                	bnez	a4,188 <strcpy+0x8>
    ;
  return os;
}
 196:	6422                	ld	s0,8(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret

000000000000019c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	cb91                	beqz	a5,1ba <strcmp+0x1e>
 1a8:	0005c703          	lbu	a4,0(a1)
 1ac:	00f71763          	bne	a4,a5,1ba <strcmp+0x1e>
    p++, q++;
 1b0:	0505                	addi	a0,a0,1
 1b2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1b4:	00054783          	lbu	a5,0(a0)
 1b8:	fbe5                	bnez	a5,1a8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1ba:	0005c503          	lbu	a0,0(a1)
}
 1be:	40a7853b          	subw	a0,a5,a0
 1c2:	6422                	ld	s0,8(sp)
 1c4:	0141                	addi	sp,sp,16
 1c6:	8082                	ret

00000000000001c8 <strlen>:

uint
strlen(const char *s)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ce:	00054783          	lbu	a5,0(a0)
 1d2:	cf91                	beqz	a5,1ee <strlen+0x26>
 1d4:	0505                	addi	a0,a0,1
 1d6:	87aa                	mv	a5,a0
 1d8:	86be                	mv	a3,a5
 1da:	0785                	addi	a5,a5,1
 1dc:	fff7c703          	lbu	a4,-1(a5)
 1e0:	ff65                	bnez	a4,1d8 <strlen+0x10>
 1e2:	40a6853b          	subw	a0,a3,a0
 1e6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1e8:	6422                	ld	s0,8(sp)
 1ea:	0141                	addi	sp,sp,16
 1ec:	8082                	ret
  for(n = 0; s[n]; n++)
 1ee:	4501                	li	a0,0
 1f0:	bfe5                	j	1e8 <strlen+0x20>

00000000000001f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e422                	sd	s0,8(sp)
 1f6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1f8:	ca19                	beqz	a2,20e <memset+0x1c>
 1fa:	87aa                	mv	a5,a0
 1fc:	1602                	slli	a2,a2,0x20
 1fe:	9201                	srli	a2,a2,0x20
 200:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 204:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 208:	0785                	addi	a5,a5,1
 20a:	fee79de3          	bne	a5,a4,204 <memset+0x12>
  }
  return dst;
}
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret

0000000000000214 <strchr>:

char*
strchr(const char *s, char c)
{
 214:	1141                	addi	sp,sp,-16
 216:	e422                	sd	s0,8(sp)
 218:	0800                	addi	s0,sp,16
  for(; *s; s++)
 21a:	00054783          	lbu	a5,0(a0)
 21e:	cb99                	beqz	a5,234 <strchr+0x20>
    if(*s == c)
 220:	00f58763          	beq	a1,a5,22e <strchr+0x1a>
  for(; *s; s++)
 224:	0505                	addi	a0,a0,1
 226:	00054783          	lbu	a5,0(a0)
 22a:	fbfd                	bnez	a5,220 <strchr+0xc>
      return (char*)s;
  return 0;
 22c:	4501                	li	a0,0
}
 22e:	6422                	ld	s0,8(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
  return 0;
 234:	4501                	li	a0,0
 236:	bfe5                	j	22e <strchr+0x1a>

0000000000000238 <gets>:

char*
gets(char *buf, int max)
{
 238:	711d                	addi	sp,sp,-96
 23a:	ec86                	sd	ra,88(sp)
 23c:	e8a2                	sd	s0,80(sp)
 23e:	e4a6                	sd	s1,72(sp)
 240:	e0ca                	sd	s2,64(sp)
 242:	fc4e                	sd	s3,56(sp)
 244:	f852                	sd	s4,48(sp)
 246:	f456                	sd	s5,40(sp)
 248:	f05a                	sd	s6,32(sp)
 24a:	ec5e                	sd	s7,24(sp)
 24c:	1080                	addi	s0,sp,96
 24e:	8baa                	mv	s7,a0
 250:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 252:	892a                	mv	s2,a0
 254:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 256:	4aa9                	li	s5,10
 258:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 25a:	89a6                	mv	s3,s1
 25c:	2485                	addiw	s1,s1,1
 25e:	0344d663          	bge	s1,s4,28a <gets+0x52>
    cc = read(0, &c, 1);
 262:	4605                	li	a2,1
 264:	faf40593          	addi	a1,s0,-81
 268:	4501                	li	a0,0
 26a:	186000ef          	jal	3f0 <read>
    if(cc < 1)
 26e:	00a05e63          	blez	a0,28a <gets+0x52>
    buf[i++] = c;
 272:	faf44783          	lbu	a5,-81(s0)
 276:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 27a:	01578763          	beq	a5,s5,288 <gets+0x50>
 27e:	0905                	addi	s2,s2,1
 280:	fd679de3          	bne	a5,s6,25a <gets+0x22>
    buf[i++] = c;
 284:	89a6                	mv	s3,s1
 286:	a011                	j	28a <gets+0x52>
 288:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 28a:	99de                	add	s3,s3,s7
 28c:	00098023          	sb	zero,0(s3)
  return buf;
}
 290:	855e                	mv	a0,s7
 292:	60e6                	ld	ra,88(sp)
 294:	6446                	ld	s0,80(sp)
 296:	64a6                	ld	s1,72(sp)
 298:	6906                	ld	s2,64(sp)
 29a:	79e2                	ld	s3,56(sp)
 29c:	7a42                	ld	s4,48(sp)
 29e:	7aa2                	ld	s5,40(sp)
 2a0:	7b02                	ld	s6,32(sp)
 2a2:	6be2                	ld	s7,24(sp)
 2a4:	6125                	addi	sp,sp,96
 2a6:	8082                	ret

00000000000002a8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a8:	1101                	addi	sp,sp,-32
 2aa:	ec06                	sd	ra,24(sp)
 2ac:	e822                	sd	s0,16(sp)
 2ae:	e04a                	sd	s2,0(sp)
 2b0:	1000                	addi	s0,sp,32
 2b2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b4:	4581                	li	a1,0
 2b6:	162000ef          	jal	418 <open>
  if(fd < 0)
 2ba:	02054263          	bltz	a0,2de <stat+0x36>
 2be:	e426                	sd	s1,8(sp)
 2c0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2c2:	85ca                	mv	a1,s2
 2c4:	16c000ef          	jal	430 <fstat>
 2c8:	892a                	mv	s2,a0
  close(fd);
 2ca:	8526                	mv	a0,s1
 2cc:	134000ef          	jal	400 <close>
  return r;
 2d0:	64a2                	ld	s1,8(sp)
}
 2d2:	854a                	mv	a0,s2
 2d4:	60e2                	ld	ra,24(sp)
 2d6:	6442                	ld	s0,16(sp)
 2d8:	6902                	ld	s2,0(sp)
 2da:	6105                	addi	sp,sp,32
 2dc:	8082                	ret
    return -1;
 2de:	597d                	li	s2,-1
 2e0:	bfcd                	j	2d2 <stat+0x2a>

00000000000002e2 <atoi>:

int
atoi(const char *s)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e422                	sd	s0,8(sp)
 2e6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e8:	00054683          	lbu	a3,0(a0)
 2ec:	fd06879b          	addiw	a5,a3,-48
 2f0:	0ff7f793          	zext.b	a5,a5
 2f4:	4625                	li	a2,9
 2f6:	02f66863          	bltu	a2,a5,326 <atoi+0x44>
 2fa:	872a                	mv	a4,a0
  n = 0;
 2fc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2fe:	0705                	addi	a4,a4,1
 300:	0025179b          	slliw	a5,a0,0x2
 304:	9fa9                	addw	a5,a5,a0
 306:	0017979b          	slliw	a5,a5,0x1
 30a:	9fb5                	addw	a5,a5,a3
 30c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 310:	00074683          	lbu	a3,0(a4)
 314:	fd06879b          	addiw	a5,a3,-48
 318:	0ff7f793          	zext.b	a5,a5
 31c:	fef671e3          	bgeu	a2,a5,2fe <atoi+0x1c>
  return n;
}
 320:	6422                	ld	s0,8(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
  n = 0;
 326:	4501                	li	a0,0
 328:	bfe5                	j	320 <atoi+0x3e>

000000000000032a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e422                	sd	s0,8(sp)
 32e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 330:	02b57463          	bgeu	a0,a1,358 <memmove+0x2e>
    while(n-- > 0)
 334:	00c05f63          	blez	a2,352 <memmove+0x28>
 338:	1602                	slli	a2,a2,0x20
 33a:	9201                	srli	a2,a2,0x20
 33c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 340:	872a                	mv	a4,a0
      *dst++ = *src++;
 342:	0585                	addi	a1,a1,1
 344:	0705                	addi	a4,a4,1
 346:	fff5c683          	lbu	a3,-1(a1)
 34a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 34e:	fef71ae3          	bne	a4,a5,342 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 352:	6422                	ld	s0,8(sp)
 354:	0141                	addi	sp,sp,16
 356:	8082                	ret
    dst += n;
 358:	00c50733          	add	a4,a0,a2
    src += n;
 35c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 35e:	fec05ae3          	blez	a2,352 <memmove+0x28>
 362:	fff6079b          	addiw	a5,a2,-1
 366:	1782                	slli	a5,a5,0x20
 368:	9381                	srli	a5,a5,0x20
 36a:	fff7c793          	not	a5,a5
 36e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 370:	15fd                	addi	a1,a1,-1
 372:	177d                	addi	a4,a4,-1
 374:	0005c683          	lbu	a3,0(a1)
 378:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 37c:	fee79ae3          	bne	a5,a4,370 <memmove+0x46>
 380:	bfc9                	j	352 <memmove+0x28>

0000000000000382 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 382:	1141                	addi	sp,sp,-16
 384:	e422                	sd	s0,8(sp)
 386:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 388:	ca05                	beqz	a2,3b8 <memcmp+0x36>
 38a:	fff6069b          	addiw	a3,a2,-1
 38e:	1682                	slli	a3,a3,0x20
 390:	9281                	srli	a3,a3,0x20
 392:	0685                	addi	a3,a3,1
 394:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 396:	00054783          	lbu	a5,0(a0)
 39a:	0005c703          	lbu	a4,0(a1)
 39e:	00e79863          	bne	a5,a4,3ae <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3a2:	0505                	addi	a0,a0,1
    p2++;
 3a4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3a6:	fed518e3          	bne	a0,a3,396 <memcmp+0x14>
  }
  return 0;
 3aa:	4501                	li	a0,0
 3ac:	a019                	j	3b2 <memcmp+0x30>
      return *p1 - *p2;
 3ae:	40e7853b          	subw	a0,a5,a4
}
 3b2:	6422                	ld	s0,8(sp)
 3b4:	0141                	addi	sp,sp,16
 3b6:	8082                	ret
  return 0;
 3b8:	4501                	li	a0,0
 3ba:	bfe5                	j	3b2 <memcmp+0x30>

00000000000003bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3bc:	1141                	addi	sp,sp,-16
 3be:	e406                	sd	ra,8(sp)
 3c0:	e022                	sd	s0,0(sp)
 3c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3c4:	f67ff0ef          	jal	32a <memmove>
}
 3c8:	60a2                	ld	ra,8(sp)
 3ca:	6402                	ld	s0,0(sp)
 3cc:	0141                	addi	sp,sp,16
 3ce:	8082                	ret

00000000000003d0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3d0:	4885                	li	a7,1
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d8:	4889                	li	a7,2
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3e0:	488d                	li	a7,3
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e8:	4891                	li	a7,4
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <read>:
.global read
read:
 li a7, SYS_read
 3f0:	4895                	li	a7,5
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <write>:
.global write
write:
 li a7, SYS_write
 3f8:	48c1                	li	a7,16
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <close>:
.global close
close:
 li a7, SYS_close
 400:	48d5                	li	a7,21
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <kill>:
.global kill
kill:
 li a7, SYS_kill
 408:	4899                	li	a7,6
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <exec>:
.global exec
exec:
 li a7, SYS_exec
 410:	489d                	li	a7,7
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <open>:
.global open
open:
 li a7, SYS_open
 418:	48bd                	li	a7,15
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 420:	48c5                	li	a7,17
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 428:	48c9                	li	a7,18
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 430:	48a1                	li	a7,8
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <link>:
.global link
link:
 li a7, SYS_link
 438:	48cd                	li	a7,19
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 440:	48d1                	li	a7,20
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 448:	48a5                	li	a7,9
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <dup>:
.global dup
dup:
 li a7, SYS_dup
 450:	48a9                	li	a7,10
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 458:	48ad                	li	a7,11
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 460:	48b1                	li	a7,12
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 468:	48b5                	li	a7,13
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 470:	48b9                	li	a7,14
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 478:	1101                	addi	sp,sp,-32
 47a:	ec06                	sd	ra,24(sp)
 47c:	e822                	sd	s0,16(sp)
 47e:	1000                	addi	s0,sp,32
 480:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 484:	4605                	li	a2,1
 486:	fef40593          	addi	a1,s0,-17
 48a:	f6fff0ef          	jal	3f8 <write>
}
 48e:	60e2                	ld	ra,24(sp)
 490:	6442                	ld	s0,16(sp)
 492:	6105                	addi	sp,sp,32
 494:	8082                	ret

0000000000000496 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 496:	7139                	addi	sp,sp,-64
 498:	fc06                	sd	ra,56(sp)
 49a:	f822                	sd	s0,48(sp)
 49c:	f426                	sd	s1,40(sp)
 49e:	0080                	addi	s0,sp,64
 4a0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a2:	c299                	beqz	a3,4a8 <printint+0x12>
 4a4:	0805c963          	bltz	a1,536 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4a8:	2581                	sext.w	a1,a1
  neg = 0;
 4aa:	4881                	li	a7,0
 4ac:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4b0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4b2:	2601                	sext.w	a2,a2
 4b4:	00000517          	auipc	a0,0x0
 4b8:	5bc50513          	addi	a0,a0,1468 # a70 <digits>
 4bc:	883a                	mv	a6,a4
 4be:	2705                	addiw	a4,a4,1
 4c0:	02c5f7bb          	remuw	a5,a1,a2
 4c4:	1782                	slli	a5,a5,0x20
 4c6:	9381                	srli	a5,a5,0x20
 4c8:	97aa                	add	a5,a5,a0
 4ca:	0007c783          	lbu	a5,0(a5)
 4ce:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4d2:	0005879b          	sext.w	a5,a1
 4d6:	02c5d5bb          	divuw	a1,a1,a2
 4da:	0685                	addi	a3,a3,1
 4dc:	fec7f0e3          	bgeu	a5,a2,4bc <printint+0x26>
  if(neg)
 4e0:	00088c63          	beqz	a7,4f8 <printint+0x62>
    buf[i++] = '-';
 4e4:	fd070793          	addi	a5,a4,-48
 4e8:	00878733          	add	a4,a5,s0
 4ec:	02d00793          	li	a5,45
 4f0:	fef70823          	sb	a5,-16(a4)
 4f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4f8:	02e05a63          	blez	a4,52c <printint+0x96>
 4fc:	f04a                	sd	s2,32(sp)
 4fe:	ec4e                	sd	s3,24(sp)
 500:	fc040793          	addi	a5,s0,-64
 504:	00e78933          	add	s2,a5,a4
 508:	fff78993          	addi	s3,a5,-1
 50c:	99ba                	add	s3,s3,a4
 50e:	377d                	addiw	a4,a4,-1
 510:	1702                	slli	a4,a4,0x20
 512:	9301                	srli	a4,a4,0x20
 514:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 518:	fff94583          	lbu	a1,-1(s2)
 51c:	8526                	mv	a0,s1
 51e:	f5bff0ef          	jal	478 <putc>
  while(--i >= 0)
 522:	197d                	addi	s2,s2,-1
 524:	ff391ae3          	bne	s2,s3,518 <printint+0x82>
 528:	7902                	ld	s2,32(sp)
 52a:	69e2                	ld	s3,24(sp)
}
 52c:	70e2                	ld	ra,56(sp)
 52e:	7442                	ld	s0,48(sp)
 530:	74a2                	ld	s1,40(sp)
 532:	6121                	addi	sp,sp,64
 534:	8082                	ret
    x = -xx;
 536:	40b005bb          	negw	a1,a1
    neg = 1;
 53a:	4885                	li	a7,1
    x = -xx;
 53c:	bf85                	j	4ac <printint+0x16>

000000000000053e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 53e:	711d                	addi	sp,sp,-96
 540:	ec86                	sd	ra,88(sp)
 542:	e8a2                	sd	s0,80(sp)
 544:	e0ca                	sd	s2,64(sp)
 546:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 548:	0005c903          	lbu	s2,0(a1)
 54c:	26090863          	beqz	s2,7bc <vprintf+0x27e>
 550:	e4a6                	sd	s1,72(sp)
 552:	fc4e                	sd	s3,56(sp)
 554:	f852                	sd	s4,48(sp)
 556:	f456                	sd	s5,40(sp)
 558:	f05a                	sd	s6,32(sp)
 55a:	ec5e                	sd	s7,24(sp)
 55c:	e862                	sd	s8,16(sp)
 55e:	e466                	sd	s9,8(sp)
 560:	8b2a                	mv	s6,a0
 562:	8a2e                	mv	s4,a1
 564:	8bb2                	mv	s7,a2
  state = 0;
 566:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 568:	4481                	li	s1,0
 56a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 56c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 570:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 574:	06c00c93          	li	s9,108
 578:	a005                	j	598 <vprintf+0x5a>
        putc(fd, c0);
 57a:	85ca                	mv	a1,s2
 57c:	855a                	mv	a0,s6
 57e:	efbff0ef          	jal	478 <putc>
 582:	a019                	j	588 <vprintf+0x4a>
    } else if(state == '%'){
 584:	03598263          	beq	s3,s5,5a8 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 588:	2485                	addiw	s1,s1,1
 58a:	8726                	mv	a4,s1
 58c:	009a07b3          	add	a5,s4,s1
 590:	0007c903          	lbu	s2,0(a5)
 594:	20090c63          	beqz	s2,7ac <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 598:	0009079b          	sext.w	a5,s2
    if(state == 0){
 59c:	fe0994e3          	bnez	s3,584 <vprintf+0x46>
      if(c0 == '%'){
 5a0:	fd579de3          	bne	a5,s5,57a <vprintf+0x3c>
        state = '%';
 5a4:	89be                	mv	s3,a5
 5a6:	b7cd                	j	588 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5a8:	00ea06b3          	add	a3,s4,a4
 5ac:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5b0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5b2:	c681                	beqz	a3,5ba <vprintf+0x7c>
 5b4:	9752                	add	a4,a4,s4
 5b6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5ba:	03878f63          	beq	a5,s8,5f8 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5be:	05978963          	beq	a5,s9,610 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5c2:	07500713          	li	a4,117
 5c6:	0ee78363          	beq	a5,a4,6ac <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5ca:	07800713          	li	a4,120
 5ce:	12e78563          	beq	a5,a4,6f8 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5d2:	07000713          	li	a4,112
 5d6:	14e78a63          	beq	a5,a4,72a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5da:	07300713          	li	a4,115
 5de:	18e78a63          	beq	a5,a4,772 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5e2:	02500713          	li	a4,37
 5e6:	04e79563          	bne	a5,a4,630 <vprintf+0xf2>
        putc(fd, '%');
 5ea:	02500593          	li	a1,37
 5ee:	855a                	mv	a0,s6
 5f0:	e89ff0ef          	jal	478 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	bf49                	j	588 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5f8:	008b8913          	addi	s2,s7,8
 5fc:	4685                	li	a3,1
 5fe:	4629                	li	a2,10
 600:	000ba583          	lw	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	e91ff0ef          	jal	496 <printint>
 60a:	8bca                	mv	s7,s2
      state = 0;
 60c:	4981                	li	s3,0
 60e:	bfad                	j	588 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 610:	06400793          	li	a5,100
 614:	02f68963          	beq	a3,a5,646 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 618:	06c00793          	li	a5,108
 61c:	04f68263          	beq	a3,a5,660 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 620:	07500793          	li	a5,117
 624:	0af68063          	beq	a3,a5,6c4 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 628:	07800793          	li	a5,120
 62c:	0ef68263          	beq	a3,a5,710 <vprintf+0x1d2>
        putc(fd, '%');
 630:	02500593          	li	a1,37
 634:	855a                	mv	a0,s6
 636:	e43ff0ef          	jal	478 <putc>
        putc(fd, c0);
 63a:	85ca                	mv	a1,s2
 63c:	855a                	mv	a0,s6
 63e:	e3bff0ef          	jal	478 <putc>
      state = 0;
 642:	4981                	li	s3,0
 644:	b791                	j	588 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 646:	008b8913          	addi	s2,s7,8
 64a:	4685                	li	a3,1
 64c:	4629                	li	a2,10
 64e:	000ba583          	lw	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	e43ff0ef          	jal	496 <printint>
        i += 1;
 658:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 65a:	8bca                	mv	s7,s2
      state = 0;
 65c:	4981                	li	s3,0
        i += 1;
 65e:	b72d                	j	588 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 660:	06400793          	li	a5,100
 664:	02f60763          	beq	a2,a5,692 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 668:	07500793          	li	a5,117
 66c:	06f60963          	beq	a2,a5,6de <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 670:	07800793          	li	a5,120
 674:	faf61ee3          	bne	a2,a5,630 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 678:	008b8913          	addi	s2,s7,8
 67c:	4681                	li	a3,0
 67e:	4641                	li	a2,16
 680:	000ba583          	lw	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	e11ff0ef          	jal	496 <printint>
        i += 2;
 68a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 68c:	8bca                	mv	s7,s2
      state = 0;
 68e:	4981                	li	s3,0
        i += 2;
 690:	bde5                	j	588 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 692:	008b8913          	addi	s2,s7,8
 696:	4685                	li	a3,1
 698:	4629                	li	a2,10
 69a:	000ba583          	lw	a1,0(s7)
 69e:	855a                	mv	a0,s6
 6a0:	df7ff0ef          	jal	496 <printint>
        i += 2;
 6a4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a6:	8bca                	mv	s7,s2
      state = 0;
 6a8:	4981                	li	s3,0
        i += 2;
 6aa:	bdf9                	j	588 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6ac:	008b8913          	addi	s2,s7,8
 6b0:	4681                	li	a3,0
 6b2:	4629                	li	a2,10
 6b4:	000ba583          	lw	a1,0(s7)
 6b8:	855a                	mv	a0,s6
 6ba:	dddff0ef          	jal	496 <printint>
 6be:	8bca                	mv	s7,s2
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	b5d9                	j	588 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c4:	008b8913          	addi	s2,s7,8
 6c8:	4681                	li	a3,0
 6ca:	4629                	li	a2,10
 6cc:	000ba583          	lw	a1,0(s7)
 6d0:	855a                	mv	a0,s6
 6d2:	dc5ff0ef          	jal	496 <printint>
        i += 1;
 6d6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d8:	8bca                	mv	s7,s2
      state = 0;
 6da:	4981                	li	s3,0
        i += 1;
 6dc:	b575                	j	588 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6de:	008b8913          	addi	s2,s7,8
 6e2:	4681                	li	a3,0
 6e4:	4629                	li	a2,10
 6e6:	000ba583          	lw	a1,0(s7)
 6ea:	855a                	mv	a0,s6
 6ec:	dabff0ef          	jal	496 <printint>
        i += 2;
 6f0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f2:	8bca                	mv	s7,s2
      state = 0;
 6f4:	4981                	li	s3,0
        i += 2;
 6f6:	bd49                	j	588 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6f8:	008b8913          	addi	s2,s7,8
 6fc:	4681                	li	a3,0
 6fe:	4641                	li	a2,16
 700:	000ba583          	lw	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	d91ff0ef          	jal	496 <printint>
 70a:	8bca                	mv	s7,s2
      state = 0;
 70c:	4981                	li	s3,0
 70e:	bdad                	j	588 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 710:	008b8913          	addi	s2,s7,8
 714:	4681                	li	a3,0
 716:	4641                	li	a2,16
 718:	000ba583          	lw	a1,0(s7)
 71c:	855a                	mv	a0,s6
 71e:	d79ff0ef          	jal	496 <printint>
        i += 1;
 722:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 724:	8bca                	mv	s7,s2
      state = 0;
 726:	4981                	li	s3,0
        i += 1;
 728:	b585                	j	588 <vprintf+0x4a>
 72a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 72c:	008b8d13          	addi	s10,s7,8
 730:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 734:	03000593          	li	a1,48
 738:	855a                	mv	a0,s6
 73a:	d3fff0ef          	jal	478 <putc>
  putc(fd, 'x');
 73e:	07800593          	li	a1,120
 742:	855a                	mv	a0,s6
 744:	d35ff0ef          	jal	478 <putc>
 748:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 74a:	00000b97          	auipc	s7,0x0
 74e:	326b8b93          	addi	s7,s7,806 # a70 <digits>
 752:	03c9d793          	srli	a5,s3,0x3c
 756:	97de                	add	a5,a5,s7
 758:	0007c583          	lbu	a1,0(a5)
 75c:	855a                	mv	a0,s6
 75e:	d1bff0ef          	jal	478 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 762:	0992                	slli	s3,s3,0x4
 764:	397d                	addiw	s2,s2,-1
 766:	fe0916e3          	bnez	s2,752 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 76a:	8bea                	mv	s7,s10
      state = 0;
 76c:	4981                	li	s3,0
 76e:	6d02                	ld	s10,0(sp)
 770:	bd21                	j	588 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 772:	008b8993          	addi	s3,s7,8
 776:	000bb903          	ld	s2,0(s7)
 77a:	00090f63          	beqz	s2,798 <vprintf+0x25a>
        for(; *s; s++)
 77e:	00094583          	lbu	a1,0(s2)
 782:	c195                	beqz	a1,7a6 <vprintf+0x268>
          putc(fd, *s);
 784:	855a                	mv	a0,s6
 786:	cf3ff0ef          	jal	478 <putc>
        for(; *s; s++)
 78a:	0905                	addi	s2,s2,1
 78c:	00094583          	lbu	a1,0(s2)
 790:	f9f5                	bnez	a1,784 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 792:	8bce                	mv	s7,s3
      state = 0;
 794:	4981                	li	s3,0
 796:	bbcd                	j	588 <vprintf+0x4a>
          s = "(null)";
 798:	00000917          	auipc	s2,0x0
 79c:	2d090913          	addi	s2,s2,720 # a68 <malloc+0x1c4>
        for(; *s; s++)
 7a0:	02800593          	li	a1,40
 7a4:	b7c5                	j	784 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7a6:	8bce                	mv	s7,s3
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	bbf9                	j	588 <vprintf+0x4a>
 7ac:	64a6                	ld	s1,72(sp)
 7ae:	79e2                	ld	s3,56(sp)
 7b0:	7a42                	ld	s4,48(sp)
 7b2:	7aa2                	ld	s5,40(sp)
 7b4:	7b02                	ld	s6,32(sp)
 7b6:	6be2                	ld	s7,24(sp)
 7b8:	6c42                	ld	s8,16(sp)
 7ba:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7bc:	60e6                	ld	ra,88(sp)
 7be:	6446                	ld	s0,80(sp)
 7c0:	6906                	ld	s2,64(sp)
 7c2:	6125                	addi	sp,sp,96
 7c4:	8082                	ret

00000000000007c6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7c6:	715d                	addi	sp,sp,-80
 7c8:	ec06                	sd	ra,24(sp)
 7ca:	e822                	sd	s0,16(sp)
 7cc:	1000                	addi	s0,sp,32
 7ce:	e010                	sd	a2,0(s0)
 7d0:	e414                	sd	a3,8(s0)
 7d2:	e818                	sd	a4,16(s0)
 7d4:	ec1c                	sd	a5,24(s0)
 7d6:	03043023          	sd	a6,32(s0)
 7da:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7de:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7e2:	8622                	mv	a2,s0
 7e4:	d5bff0ef          	jal	53e <vprintf>
}
 7e8:	60e2                	ld	ra,24(sp)
 7ea:	6442                	ld	s0,16(sp)
 7ec:	6161                	addi	sp,sp,80
 7ee:	8082                	ret

00000000000007f0 <printf>:

void
printf(const char *fmt, ...)
{
 7f0:	711d                	addi	sp,sp,-96
 7f2:	ec06                	sd	ra,24(sp)
 7f4:	e822                	sd	s0,16(sp)
 7f6:	1000                	addi	s0,sp,32
 7f8:	e40c                	sd	a1,8(s0)
 7fa:	e810                	sd	a2,16(s0)
 7fc:	ec14                	sd	a3,24(s0)
 7fe:	f018                	sd	a4,32(s0)
 800:	f41c                	sd	a5,40(s0)
 802:	03043823          	sd	a6,48(s0)
 806:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 80a:	00840613          	addi	a2,s0,8
 80e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 812:	85aa                	mv	a1,a0
 814:	4505                	li	a0,1
 816:	d29ff0ef          	jal	53e <vprintf>
}
 81a:	60e2                	ld	ra,24(sp)
 81c:	6442                	ld	s0,16(sp)
 81e:	6125                	addi	sp,sp,96
 820:	8082                	ret

0000000000000822 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 822:	1141                	addi	sp,sp,-16
 824:	e422                	sd	s0,8(sp)
 826:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 828:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82c:	00000797          	auipc	a5,0x0
 830:	7d47b783          	ld	a5,2004(a5) # 1000 <freep>
 834:	a02d                	j	85e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 836:	4618                	lw	a4,8(a2)
 838:	9f2d                	addw	a4,a4,a1
 83a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 83e:	6398                	ld	a4,0(a5)
 840:	6310                	ld	a2,0(a4)
 842:	a83d                	j	880 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 844:	ff852703          	lw	a4,-8(a0)
 848:	9f31                	addw	a4,a4,a2
 84a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 84c:	ff053683          	ld	a3,-16(a0)
 850:	a091                	j	894 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 852:	6398                	ld	a4,0(a5)
 854:	00e7e463          	bltu	a5,a4,85c <free+0x3a>
 858:	00e6ea63          	bltu	a3,a4,86c <free+0x4a>
{
 85c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85e:	fed7fae3          	bgeu	a5,a3,852 <free+0x30>
 862:	6398                	ld	a4,0(a5)
 864:	00e6e463          	bltu	a3,a4,86c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 868:	fee7eae3          	bltu	a5,a4,85c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 86c:	ff852583          	lw	a1,-8(a0)
 870:	6390                	ld	a2,0(a5)
 872:	02059813          	slli	a6,a1,0x20
 876:	01c85713          	srli	a4,a6,0x1c
 87a:	9736                	add	a4,a4,a3
 87c:	fae60de3          	beq	a2,a4,836 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 880:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 884:	4790                	lw	a2,8(a5)
 886:	02061593          	slli	a1,a2,0x20
 88a:	01c5d713          	srli	a4,a1,0x1c
 88e:	973e                	add	a4,a4,a5
 890:	fae68ae3          	beq	a3,a4,844 <free+0x22>
    p->s.ptr = bp->s.ptr;
 894:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 896:	00000717          	auipc	a4,0x0
 89a:	76f73523          	sd	a5,1898(a4) # 1000 <freep>
}
 89e:	6422                	ld	s0,8(sp)
 8a0:	0141                	addi	sp,sp,16
 8a2:	8082                	ret

00000000000008a4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a4:	7139                	addi	sp,sp,-64
 8a6:	fc06                	sd	ra,56(sp)
 8a8:	f822                	sd	s0,48(sp)
 8aa:	f426                	sd	s1,40(sp)
 8ac:	ec4e                	sd	s3,24(sp)
 8ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b0:	02051493          	slli	s1,a0,0x20
 8b4:	9081                	srli	s1,s1,0x20
 8b6:	04bd                	addi	s1,s1,15
 8b8:	8091                	srli	s1,s1,0x4
 8ba:	0014899b          	addiw	s3,s1,1
 8be:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8c0:	00000517          	auipc	a0,0x0
 8c4:	74053503          	ld	a0,1856(a0) # 1000 <freep>
 8c8:	c915                	beqz	a0,8fc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8cc:	4798                	lw	a4,8(a5)
 8ce:	08977a63          	bgeu	a4,s1,962 <malloc+0xbe>
 8d2:	f04a                	sd	s2,32(sp)
 8d4:	e852                	sd	s4,16(sp)
 8d6:	e456                	sd	s5,8(sp)
 8d8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8da:	8a4e                	mv	s4,s3
 8dc:	0009871b          	sext.w	a4,s3
 8e0:	6685                	lui	a3,0x1
 8e2:	00d77363          	bgeu	a4,a3,8e8 <malloc+0x44>
 8e6:	6a05                	lui	s4,0x1
 8e8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ec:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f0:	00000917          	auipc	s2,0x0
 8f4:	71090913          	addi	s2,s2,1808 # 1000 <freep>
  if(p == (char*)-1)
 8f8:	5afd                	li	s5,-1
 8fa:	a081                	j	93a <malloc+0x96>
 8fc:	f04a                	sd	s2,32(sp)
 8fe:	e852                	sd	s4,16(sp)
 900:	e456                	sd	s5,8(sp)
 902:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 904:	00000797          	auipc	a5,0x0
 908:	70c78793          	addi	a5,a5,1804 # 1010 <base>
 90c:	00000717          	auipc	a4,0x0
 910:	6ef73a23          	sd	a5,1780(a4) # 1000 <freep>
 914:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 916:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 91a:	b7c1                	j	8da <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 91c:	6398                	ld	a4,0(a5)
 91e:	e118                	sd	a4,0(a0)
 920:	a8a9                	j	97a <malloc+0xd6>
  hp->s.size = nu;
 922:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 926:	0541                	addi	a0,a0,16
 928:	efbff0ef          	jal	822 <free>
  return freep;
 92c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 930:	c12d                	beqz	a0,992 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 932:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 934:	4798                	lw	a4,8(a5)
 936:	02977263          	bgeu	a4,s1,95a <malloc+0xb6>
    if(p == freep)
 93a:	00093703          	ld	a4,0(s2)
 93e:	853e                	mv	a0,a5
 940:	fef719e3          	bne	a4,a5,932 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 944:	8552                	mv	a0,s4
 946:	b1bff0ef          	jal	460 <sbrk>
  if(p == (char*)-1)
 94a:	fd551ce3          	bne	a0,s5,922 <malloc+0x7e>
        return 0;
 94e:	4501                	li	a0,0
 950:	7902                	ld	s2,32(sp)
 952:	6a42                	ld	s4,16(sp)
 954:	6aa2                	ld	s5,8(sp)
 956:	6b02                	ld	s6,0(sp)
 958:	a03d                	j	986 <malloc+0xe2>
 95a:	7902                	ld	s2,32(sp)
 95c:	6a42                	ld	s4,16(sp)
 95e:	6aa2                	ld	s5,8(sp)
 960:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 962:	fae48de3          	beq	s1,a4,91c <malloc+0x78>
        p->s.size -= nunits;
 966:	4137073b          	subw	a4,a4,s3
 96a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 96c:	02071693          	slli	a3,a4,0x20
 970:	01c6d713          	srli	a4,a3,0x1c
 974:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 976:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 97a:	00000717          	auipc	a4,0x0
 97e:	68a73323          	sd	a0,1670(a4) # 1000 <freep>
      return (void*)(p + 1);
 982:	01078513          	addi	a0,a5,16
  }
}
 986:	70e2                	ld	ra,56(sp)
 988:	7442                	ld	s0,48(sp)
 98a:	74a2                	ld	s1,40(sp)
 98c:	69e2                	ld	s3,24(sp)
 98e:	6121                	addi	sp,sp,64
 990:	8082                	ret
 992:	7902                	ld	s2,32(sp)
 994:	6a42                	ld	s4,16(sp)
 996:	6aa2                	ld	s5,8(sp)
 998:	6b02                	ld	s6,0(sp)
 99a:	b7f5                	j	986 <malloc+0xe2>
