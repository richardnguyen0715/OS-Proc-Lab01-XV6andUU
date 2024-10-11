
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
#include "kernel/param.h"



//print to announce the command is going to xargs
int getcmd(char* buf, int nbuf) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
   e:	892e                	mv	s2,a1
  memset(buf, 0, nbuf);
  10:	862e                	mv	a2,a1
  12:	4581                	li	a1,0
  14:	2be000ef          	jal	2d2 <memset>
  gets(buf, nbuf);
  18:	85ca                	mv	a1,s2
  1a:	8526                	mv	a0,s1
  1c:	2fc000ef          	jal	318 <gets>
  printf("buf: %s\n", buf);
  20:	85a6                	mv	a1,s1
  22:	00001517          	auipc	a0,0x1
  26:	a5e50513          	addi	a0,a0,-1442 # a80 <malloc+0xfc>
  2a:	0a7000ef          	jal	8d0 <printf>
  if (buf[0] == 0) // EOF*
  2e:	0004c503          	lbu	a0,0(s1)
  32:	00153513          	seqz	a0,a0
  {
    //printf("WOW!\n");*
    return -1;
  }
  return 0;
}
  36:	40a00533          	neg	a0,a0
  3a:	60e2                	ld	ra,24(sp)
  3c:	6442                	ld	s0,16(sp)
  3e:	64a2                	ld	s1,8(sp)
  40:	6902                	ld	s2,0(sp)
  42:	6105                	addi	sp,sp,32
  44:	8082                	ret

0000000000000046 <gettoken>:
char whitespace[] = " \t\r\n\v";

int gettoken(char** ps, char* es, char**
  q, char** eq) {
  46:	7139                	addi	sp,sp,-64
  48:	fc06                	sd	ra,56(sp)
  4a:	f822                	sd	s0,48(sp)
  4c:	f426                	sd	s1,40(sp)
  4e:	f04a                	sd	s2,32(sp)
  50:	ec4e                	sd	s3,24(sp)
  52:	e852                	sd	s4,16(sp)
  54:	e456                	sd	s5,8(sp)
  56:	e05a                	sd	s6,0(sp)
  58:	0080                	addi	s0,sp,64
  5a:	8a2a                	mv	s4,a0
  5c:	892e                	mv	s2,a1
  5e:	8ab2                	mv	s5,a2
  60:	8b36                	mv	s6,a3
  char* s;
  int ret;

  s = *ps;
  62:	6104                	ld	s1,0(a0)
  while (s < es && strchr(whitespace, *s))
  64:	00001997          	auipc	s3,0x1
  68:	f9c98993          	addi	s3,s3,-100 # 1000 <whitespace>
  6c:	00b4fc63          	bgeu	s1,a1,84 <gettoken+0x3e>
  70:	0004c583          	lbu	a1,0(s1)
  74:	854e                	mv	a0,s3
  76:	27e000ef          	jal	2f4 <strchr>
  7a:	c509                	beqz	a0,84 <gettoken+0x3e>
    s++;
  7c:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
  7e:	fe9919e3          	bne	s2,s1,70 <gettoken+0x2a>
  82:	84ca                	mv	s1,s2
  if (q)
  84:	000a8463          	beqz	s5,8c <gettoken+0x46>
    *q = s;
  88:	009ab023          	sd	s1,0(s5)
  ret = *s;
  switch (*s) {
  8c:	0004c783          	lbu	a5,0(s1)
  90:	cb8d                	beqz	a5,c2 <gettoken+0x7c>
  case 0:
    break;
  default:
    ret = 'a';
    while (s < es && !strchr(whitespace, *s))
  92:	00001997          	auipc	s3,0x1
  96:	f6e98993          	addi	s3,s3,-146 # 1000 <whitespace>
  9a:	0724f963          	bgeu	s1,s2,10c <gettoken+0xc6>
  9e:	0004c583          	lbu	a1,0(s1)
  a2:	854e                	mv	a0,s3
  a4:	250000ef          	jal	2f4 <strchr>
  a8:	e911                	bnez	a0,bc <gettoken+0x76>
      s++;
  aa:	0485                	addi	s1,s1,1
    while (s < es && !strchr(whitespace, *s))
  ac:	fe9919e3          	bne	s2,s1,9e <gettoken+0x58>
    break;
  }
  if (eq)
  b0:	84ca                	mv	s1,s2
    ret = 'a';
  b2:	06100a93          	li	s5,97
  if (eq)
  b6:	000b1963          	bnez	s6,c8 <gettoken+0x82>
  ba:	a825                	j	f2 <gettoken+0xac>
    ret = 'a';
  bc:	06100a93          	li	s5,97
  c0:	a011                	j	c4 <gettoken+0x7e>
  ret = *s;
  c2:	4a81                	li	s5,0
  if (eq)
  c4:	000b0463          	beqz	s6,cc <gettoken+0x86>
    *eq = s;
  c8:	009b3023          	sd	s1,0(s6)

  while (s < es && strchr(whitespace, *s))
  cc:	00001997          	auipc	s3,0x1
  d0:	f3498993          	addi	s3,s3,-204 # 1000 <whitespace>
  d4:	0124fc63          	bgeu	s1,s2,ec <gettoken+0xa6>
  d8:	0004c583          	lbu	a1,0(s1)
  dc:	854e                	mv	a0,s3
  de:	216000ef          	jal	2f4 <strchr>
  e2:	c519                	beqz	a0,f0 <gettoken+0xaa>
    s++;
  e4:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
  e6:	fe9919e3          	bne	s2,s1,d8 <gettoken+0x92>
  ea:	a021                	j	f2 <gettoken+0xac>
  ec:	8926                	mv	s2,s1
  ee:	a011                	j	f2 <gettoken+0xac>
  f0:	8926                	mv	s2,s1
  *ps = s;
  f2:	012a3023          	sd	s2,0(s4)
  return ret;
}
  f6:	8556                	mv	a0,s5
  f8:	70e2                	ld	ra,56(sp)
  fa:	7442                	ld	s0,48(sp)
  fc:	74a2                	ld	s1,40(sp)
  fe:	7902                	ld	s2,32(sp)
 100:	69e2                	ld	s3,24(sp)
 102:	6a42                	ld	s4,16(sp)
 104:	6aa2                	ld	s5,8(sp)
 106:	6b02                	ld	s6,0(sp)
 108:	6121                	addi	sp,sp,64
 10a:	8082                	ret
    ret = 'a';
 10c:	06100a93          	li	s5,97
  if (eq)
 110:	fa0b1ce3          	bnez	s6,c8 <gettoken+0x82>
 114:	8926                	mv	s2,s1
 116:	bff1                	j	f2 <gettoken+0xac>

0000000000000118 <main>:

int main(int argc, char* argv[]) {
 118:	7149                	addi	sp,sp,-368
 11a:	f686                	sd	ra,360(sp)
 11c:	f2a2                	sd	s0,352(sp)
 11e:	eea6                	sd	s1,344(sp)
 120:	eaca                	sd	s2,336(sp)
 122:	e6ce                	sd	s3,328(sp)
 124:	e2d2                	sd	s4,320(sp)
 126:	fe56                	sd	s5,312(sp)
 128:	fa5a                	sd	s6,304(sp)
 12a:	f65e                	sd	s7,296(sp)
 12c:	1a80                	addi	s0,sp,368
 12e:	8a2a                	mv	s4,a0
 130:	892e                	mv	s2,a1
  //in dấu xuống dòng
  char* xargs[MAXARG];
  for (int i = 1; i < argc;i++) {
 132:	4785                	li	a5,1
 134:	08a7d063          	bge	a5,a0,1b4 <main+0x9c>
 138:	00858713          	addi	a4,a1,8
 13c:	eb040793          	addi	a5,s0,-336
 140:	ffe5061b          	addiw	a2,a0,-2
 144:	02061693          	slli	a3,a2,0x20
 148:	01d6d613          	srli	a2,a3,0x1d
 14c:	eb840693          	addi	a3,s0,-328
 150:	9636                	add	a2,a2,a3
    // Skip xargs cmd name.*
    xargs[i - 1] = argv[i];
 152:	6314                	ld	a3,0(a4)
 154:	e394                	sd	a3,0(a5)
  for (int i = 1; i < argc;i++) {
 156:	0721                	addi	a4,a4,8
 158:	07a1                	addi	a5,a5,8
 15a:	fec79ce3          	bne	a5,a2,152 <main+0x3a>
  }
  for (int i = 0; i < argc; i++) {
 15e:	4481                	li	s1,0
    printf("argv[%d]: %s\n", i, argv[i]);
 160:	00001a97          	auipc	s5,0x1
 164:	930a8a93          	addi	s5,s5,-1744 # a90 <malloc+0x10c>
 168:	00093603          	ld	a2,0(s2)
 16c:	85a6                	mv	a1,s1
 16e:	8556                	mv	a0,s5
 170:	760000ef          	jal	8d0 <printf>
  for (int i = 0; i < argc; i++) {
 174:	89a6                	mv	s3,s1
 176:	2485                	addiw	s1,s1,1
 178:	0921                	addi	s2,s2,8
 17a:	fe9a17e3          	bne	s4,s1,168 <main+0x50>
  }
  for (int i = 0; i < argc; i++) {
 17e:	eb040913          	addi	s2,s0,-336
 182:	4481                	li	s1,0
    printf("xargs[%d]: %s\n", i, xargs[i]);
 184:	00001a97          	auipc	s5,0x1
 188:	91ca8a93          	addi	s5,s5,-1764 # aa0 <malloc+0x11c>
 18c:	00093603          	ld	a2,0(s2)
 190:	85a6                	mv	a1,s1
 192:	8556                	mv	a0,s5
 194:	73c000ef          	jal	8d0 <printf>
  for (int i = 0; i < argc; i++) {
 198:	87a6                	mv	a5,s1
 19a:	2485                	addiw	s1,s1,1
 19c:	0921                	addi	s2,s2,8
 19e:	fef997e3          	bne	s3,a5,18c <main+0x74>
  }

  static char buf[MAXARG][100];
  char* q, * eq;
  int j = argc - 1;
 1a2:	3a7d                	addiw	s4,s4,-1
  int i = 0;
 1a4:	4a81                	li	s5,0
  // Split each line into array of args.*
  while (getcmd(buf[i], sizeof(buf[i])) >= 0) {
 1a6:	06400b13          	li	s6,100
 1aa:	00001b97          	auipc	s7,0x1
 1ae:	e76b8b93          	addi	s7,s7,-394 # 1020 <buf.0>
 1b2:	a825                	j	1ea <main+0xd2>
  for (int i = 0; i < argc; i++) {
 1b4:	fea057e3          	blez	a0,1a2 <main+0x8a>
 1b8:	b75d                	j	15e <main+0x46>
    char* s = buf[i];
    char* es = s + strlen(s);
    while (gettoken(&s, es, &q, &eq) != 0) {
      // Set end to 0.*
      xargs[j] = q;
 1ba:	ea843783          	ld	a5,-344(s0)
 1be:	e09c                	sd	a5,0(s1)
      *eq = 0;
 1c0:	ea043783          	ld	a5,-352(s0)
 1c4:	00078023          	sb	zero,0(a5)
      j++;
 1c8:	2905                	addiw	s2,s2,1
      i++;
 1ca:	04a1                	addi	s1,s1,8
    while (gettoken(&s, es, &q, &eq) != 0) {
 1cc:	ea040693          	addi	a3,s0,-352
 1d0:	ea840613          	addi	a2,s0,-344
 1d4:	85ce                	mv	a1,s3
 1d6:	e9840513          	addi	a0,s0,-360
 1da:	e6dff0ef          	jal	46 <gettoken>
 1de:	fd71                	bnez	a0,1ba <main+0xa2>
 1e0:	414a8abb          	subw	s5,s5,s4
 1e4:	012a8abb          	addw	s5,s5,s2
 1e8:	8a4a                	mv	s4,s2
  while (getcmd(buf[i], sizeof(buf[i])) >= 0) {
 1ea:	036a89b3          	mul	s3,s5,s6
 1ee:	99de                	add	s3,s3,s7
 1f0:	85da                	mv	a1,s6
 1f2:	854e                	mv	a0,s3
 1f4:	e0dff0ef          	jal	0 <getcmd>
 1f8:	02054163          	bltz	a0,21a <main+0x102>
    char* s = buf[i];
 1fc:	e9343c23          	sd	s3,-360(s0)
    char* es = s + strlen(s);
 200:	854e                	mv	a0,s3
 202:	0a6000ef          	jal	2a8 <strlen>
 206:	1502                	slli	a0,a0,0x20
 208:	9101                	srli	a0,a0,0x20
 20a:	99aa                	add	s3,s3,a0
    while (gettoken(&s, es, &q, &eq) != 0) {
 20c:	003a1493          	slli	s1,s4,0x3
 210:	eb040793          	addi	a5,s0,-336
 214:	94be                	add	s1,s1,a5
 216:	8952                	mv	s2,s4
 218:	bf55                	j	1cc <main+0xb4>
    }
  }

  int pid = fork();
 21a:	296000ef          	jal	4b0 <fork>
  if (pid == 0) {
 21e:	e115                	bnez	a0,242 <main+0x12a>
    printf("xargs[0]: %s\n", xargs[0]);
 220:	eb043583          	ld	a1,-336(s0)
 224:	00001517          	auipc	a0,0x1
 228:	88c50513          	addi	a0,a0,-1908 # ab0 <malloc+0x12c>
 22c:	6a4000ef          	jal	8d0 <printf>
    exec(xargs[0], xargs);
 230:	eb040593          	addi	a1,s0,-336
 234:	eb043503          	ld	a0,-336(s0)
 238:	2b8000ef          	jal	4f0 <exec>
    exit(0);
 23c:	4501                	li	a0,0
 23e:	27a000ef          	jal	4b8 <exit>
  }
  wait(0);
 242:	4501                	li	a0,0
 244:	27c000ef          	jal	4c0 <wait>
  
  exit(0);
 248:	4501                	li	a0,0
 24a:	26e000ef          	jal	4b8 <exit>

000000000000024e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 24e:	1141                	addi	sp,sp,-16
 250:	e406                	sd	ra,8(sp)
 252:	e022                	sd	s0,0(sp)
 254:	0800                	addi	s0,sp,16
  extern int main();
  main();
 256:	ec3ff0ef          	jal	118 <main>
  exit(0);
 25a:	4501                	li	a0,0
 25c:	25c000ef          	jal	4b8 <exit>

0000000000000260 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 260:	1141                	addi	sp,sp,-16
 262:	e422                	sd	s0,8(sp)
 264:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 266:	87aa                	mv	a5,a0
 268:	0585                	addi	a1,a1,1
 26a:	0785                	addi	a5,a5,1
 26c:	fff5c703          	lbu	a4,-1(a1)
 270:	fee78fa3          	sb	a4,-1(a5)
 274:	fb75                	bnez	a4,268 <strcpy+0x8>
    ;
  return os;
}
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret

000000000000027c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 27c:	1141                	addi	sp,sp,-16
 27e:	e422                	sd	s0,8(sp)
 280:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 282:	00054783          	lbu	a5,0(a0)
 286:	cb91                	beqz	a5,29a <strcmp+0x1e>
 288:	0005c703          	lbu	a4,0(a1)
 28c:	00f71763          	bne	a4,a5,29a <strcmp+0x1e>
    p++, q++;
 290:	0505                	addi	a0,a0,1
 292:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 294:	00054783          	lbu	a5,0(a0)
 298:	fbe5                	bnez	a5,288 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 29a:	0005c503          	lbu	a0,0(a1)
}
 29e:	40a7853b          	subw	a0,a5,a0
 2a2:	6422                	ld	s0,8(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <strlen>:

uint
strlen(const char *s)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	cf91                	beqz	a5,2ce <strlen+0x26>
 2b4:	0505                	addi	a0,a0,1
 2b6:	87aa                	mv	a5,a0
 2b8:	86be                	mv	a3,a5
 2ba:	0785                	addi	a5,a5,1
 2bc:	fff7c703          	lbu	a4,-1(a5)
 2c0:	ff65                	bnez	a4,2b8 <strlen+0x10>
 2c2:	40a6853b          	subw	a0,a3,a0
 2c6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2c8:	6422                	ld	s0,8(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret
  for(n = 0; s[n]; n++)
 2ce:	4501                	li	a0,0
 2d0:	bfe5                	j	2c8 <strlen+0x20>

00000000000002d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e422                	sd	s0,8(sp)
 2d6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2d8:	ca19                	beqz	a2,2ee <memset+0x1c>
 2da:	87aa                	mv	a5,a0
 2dc:	1602                	slli	a2,a2,0x20
 2de:	9201                	srli	a2,a2,0x20
 2e0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2e8:	0785                	addi	a5,a5,1
 2ea:	fee79de3          	bne	a5,a4,2e4 <memset+0x12>
  }
  return dst;
}
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret

00000000000002f4 <strchr>:

char*
strchr(const char *s, char c)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e422                	sd	s0,8(sp)
 2f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2fa:	00054783          	lbu	a5,0(a0)
 2fe:	cb99                	beqz	a5,314 <strchr+0x20>
    if(*s == c)
 300:	00f58763          	beq	a1,a5,30e <strchr+0x1a>
  for(; *s; s++)
 304:	0505                	addi	a0,a0,1
 306:	00054783          	lbu	a5,0(a0)
 30a:	fbfd                	bnez	a5,300 <strchr+0xc>
      return (char*)s;
  return 0;
 30c:	4501                	li	a0,0
}
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  return 0;
 314:	4501                	li	a0,0
 316:	bfe5                	j	30e <strchr+0x1a>

0000000000000318 <gets>:

char*
gets(char *buf, int max)
{
 318:	711d                	addi	sp,sp,-96
 31a:	ec86                	sd	ra,88(sp)
 31c:	e8a2                	sd	s0,80(sp)
 31e:	e4a6                	sd	s1,72(sp)
 320:	e0ca                	sd	s2,64(sp)
 322:	fc4e                	sd	s3,56(sp)
 324:	f852                	sd	s4,48(sp)
 326:	f456                	sd	s5,40(sp)
 328:	f05a                	sd	s6,32(sp)
 32a:	ec5e                	sd	s7,24(sp)
 32c:	1080                	addi	s0,sp,96
 32e:	8baa                	mv	s7,a0
 330:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 332:	892a                	mv	s2,a0
 334:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 336:	4aa9                	li	s5,10
 338:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 33a:	89a6                	mv	s3,s1
 33c:	2485                	addiw	s1,s1,1
 33e:	0344d663          	bge	s1,s4,36a <gets+0x52>
    cc = read(0, &c, 1);
 342:	4605                	li	a2,1
 344:	faf40593          	addi	a1,s0,-81
 348:	4501                	li	a0,0
 34a:	186000ef          	jal	4d0 <read>
    if(cc < 1)
 34e:	00a05e63          	blez	a0,36a <gets+0x52>
    buf[i++] = c;
 352:	faf44783          	lbu	a5,-81(s0)
 356:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 35a:	01578763          	beq	a5,s5,368 <gets+0x50>
 35e:	0905                	addi	s2,s2,1
 360:	fd679de3          	bne	a5,s6,33a <gets+0x22>
    buf[i++] = c;
 364:	89a6                	mv	s3,s1
 366:	a011                	j	36a <gets+0x52>
 368:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 36a:	99de                	add	s3,s3,s7
 36c:	00098023          	sb	zero,0(s3)
  return buf;
}
 370:	855e                	mv	a0,s7
 372:	60e6                	ld	ra,88(sp)
 374:	6446                	ld	s0,80(sp)
 376:	64a6                	ld	s1,72(sp)
 378:	6906                	ld	s2,64(sp)
 37a:	79e2                	ld	s3,56(sp)
 37c:	7a42                	ld	s4,48(sp)
 37e:	7aa2                	ld	s5,40(sp)
 380:	7b02                	ld	s6,32(sp)
 382:	6be2                	ld	s7,24(sp)
 384:	6125                	addi	sp,sp,96
 386:	8082                	ret

0000000000000388 <stat>:

int
stat(const char *n, struct stat *st)
{
 388:	1101                	addi	sp,sp,-32
 38a:	ec06                	sd	ra,24(sp)
 38c:	e822                	sd	s0,16(sp)
 38e:	e04a                	sd	s2,0(sp)
 390:	1000                	addi	s0,sp,32
 392:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 394:	4581                	li	a1,0
 396:	162000ef          	jal	4f8 <open>
  if(fd < 0)
 39a:	02054263          	bltz	a0,3be <stat+0x36>
 39e:	e426                	sd	s1,8(sp)
 3a0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3a2:	85ca                	mv	a1,s2
 3a4:	16c000ef          	jal	510 <fstat>
 3a8:	892a                	mv	s2,a0
  close(fd);
 3aa:	8526                	mv	a0,s1
 3ac:	134000ef          	jal	4e0 <close>
  return r;
 3b0:	64a2                	ld	s1,8(sp)
}
 3b2:	854a                	mv	a0,s2
 3b4:	60e2                	ld	ra,24(sp)
 3b6:	6442                	ld	s0,16(sp)
 3b8:	6902                	ld	s2,0(sp)
 3ba:	6105                	addi	sp,sp,32
 3bc:	8082                	ret
    return -1;
 3be:	597d                	li	s2,-1
 3c0:	bfcd                	j	3b2 <stat+0x2a>

00000000000003c2 <atoi>:

int
atoi(const char *s)
{
 3c2:	1141                	addi	sp,sp,-16
 3c4:	e422                	sd	s0,8(sp)
 3c6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c8:	00054683          	lbu	a3,0(a0)
 3cc:	fd06879b          	addiw	a5,a3,-48
 3d0:	0ff7f793          	zext.b	a5,a5
 3d4:	4625                	li	a2,9
 3d6:	02f66863          	bltu	a2,a5,406 <atoi+0x44>
 3da:	872a                	mv	a4,a0
  n = 0;
 3dc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3de:	0705                	addi	a4,a4,1
 3e0:	0025179b          	slliw	a5,a0,0x2
 3e4:	9fa9                	addw	a5,a5,a0
 3e6:	0017979b          	slliw	a5,a5,0x1
 3ea:	9fb5                	addw	a5,a5,a3
 3ec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3f0:	00074683          	lbu	a3,0(a4)
 3f4:	fd06879b          	addiw	a5,a3,-48
 3f8:	0ff7f793          	zext.b	a5,a5
 3fc:	fef671e3          	bgeu	a2,a5,3de <atoi+0x1c>
  return n;
}
 400:	6422                	ld	s0,8(sp)
 402:	0141                	addi	sp,sp,16
 404:	8082                	ret
  n = 0;
 406:	4501                	li	a0,0
 408:	bfe5                	j	400 <atoi+0x3e>

000000000000040a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 40a:	1141                	addi	sp,sp,-16
 40c:	e422                	sd	s0,8(sp)
 40e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 410:	02b57463          	bgeu	a0,a1,438 <memmove+0x2e>
    while(n-- > 0)
 414:	00c05f63          	blez	a2,432 <memmove+0x28>
 418:	1602                	slli	a2,a2,0x20
 41a:	9201                	srli	a2,a2,0x20
 41c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 420:	872a                	mv	a4,a0
      *dst++ = *src++;
 422:	0585                	addi	a1,a1,1
 424:	0705                	addi	a4,a4,1
 426:	fff5c683          	lbu	a3,-1(a1)
 42a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 42e:	fef71ae3          	bne	a4,a5,422 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 432:	6422                	ld	s0,8(sp)
 434:	0141                	addi	sp,sp,16
 436:	8082                	ret
    dst += n;
 438:	00c50733          	add	a4,a0,a2
    src += n;
 43c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 43e:	fec05ae3          	blez	a2,432 <memmove+0x28>
 442:	fff6079b          	addiw	a5,a2,-1
 446:	1782                	slli	a5,a5,0x20
 448:	9381                	srli	a5,a5,0x20
 44a:	fff7c793          	not	a5,a5
 44e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 450:	15fd                	addi	a1,a1,-1
 452:	177d                	addi	a4,a4,-1
 454:	0005c683          	lbu	a3,0(a1)
 458:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 45c:	fee79ae3          	bne	a5,a4,450 <memmove+0x46>
 460:	bfc9                	j	432 <memmove+0x28>

0000000000000462 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 462:	1141                	addi	sp,sp,-16
 464:	e422                	sd	s0,8(sp)
 466:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 468:	ca05                	beqz	a2,498 <memcmp+0x36>
 46a:	fff6069b          	addiw	a3,a2,-1
 46e:	1682                	slli	a3,a3,0x20
 470:	9281                	srli	a3,a3,0x20
 472:	0685                	addi	a3,a3,1
 474:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 476:	00054783          	lbu	a5,0(a0)
 47a:	0005c703          	lbu	a4,0(a1)
 47e:	00e79863          	bne	a5,a4,48e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 482:	0505                	addi	a0,a0,1
    p2++;
 484:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 486:	fed518e3          	bne	a0,a3,476 <memcmp+0x14>
  }
  return 0;
 48a:	4501                	li	a0,0
 48c:	a019                	j	492 <memcmp+0x30>
      return *p1 - *p2;
 48e:	40e7853b          	subw	a0,a5,a4
}
 492:	6422                	ld	s0,8(sp)
 494:	0141                	addi	sp,sp,16
 496:	8082                	ret
  return 0;
 498:	4501                	li	a0,0
 49a:	bfe5                	j	492 <memcmp+0x30>

000000000000049c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 49c:	1141                	addi	sp,sp,-16
 49e:	e406                	sd	ra,8(sp)
 4a0:	e022                	sd	s0,0(sp)
 4a2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4a4:	f67ff0ef          	jal	40a <memmove>
}
 4a8:	60a2                	ld	ra,8(sp)
 4aa:	6402                	ld	s0,0(sp)
 4ac:	0141                	addi	sp,sp,16
 4ae:	8082                	ret

00000000000004b0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4b0:	4885                	li	a7,1
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4b8:	4889                	li	a7,2
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4c0:	488d                	li	a7,3
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4c8:	4891                	li	a7,4
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <read>:
.global read
read:
 li a7, SYS_read
 4d0:	4895                	li	a7,5
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <write>:
.global write
write:
 li a7, SYS_write
 4d8:	48c1                	li	a7,16
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <close>:
.global close
close:
 li a7, SYS_close
 4e0:	48d5                	li	a7,21
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4e8:	4899                	li	a7,6
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4f0:	489d                	li	a7,7
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <open>:
.global open
open:
 li a7, SYS_open
 4f8:	48bd                	li	a7,15
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 500:	48c5                	li	a7,17
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 508:	48c9                	li	a7,18
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 510:	48a1                	li	a7,8
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <link>:
.global link
link:
 li a7, SYS_link
 518:	48cd                	li	a7,19
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 520:	48d1                	li	a7,20
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 528:	48a5                	li	a7,9
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <dup>:
.global dup
dup:
 li a7, SYS_dup
 530:	48a9                	li	a7,10
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 538:	48ad                	li	a7,11
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 540:	48b1                	li	a7,12
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 548:	48b5                	li	a7,13
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 550:	48b9                	li	a7,14
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 558:	1101                	addi	sp,sp,-32
 55a:	ec06                	sd	ra,24(sp)
 55c:	e822                	sd	s0,16(sp)
 55e:	1000                	addi	s0,sp,32
 560:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 564:	4605                	li	a2,1
 566:	fef40593          	addi	a1,s0,-17
 56a:	f6fff0ef          	jal	4d8 <write>
}
 56e:	60e2                	ld	ra,24(sp)
 570:	6442                	ld	s0,16(sp)
 572:	6105                	addi	sp,sp,32
 574:	8082                	ret

0000000000000576 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 576:	7139                	addi	sp,sp,-64
 578:	fc06                	sd	ra,56(sp)
 57a:	f822                	sd	s0,48(sp)
 57c:	f426                	sd	s1,40(sp)
 57e:	0080                	addi	s0,sp,64
 580:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 582:	c299                	beqz	a3,588 <printint+0x12>
 584:	0805c963          	bltz	a1,616 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 588:	2581                	sext.w	a1,a1
  neg = 0;
 58a:	4881                	li	a7,0
 58c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 590:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 592:	2601                	sext.w	a2,a2
 594:	00000517          	auipc	a0,0x0
 598:	53450513          	addi	a0,a0,1332 # ac8 <digits>
 59c:	883a                	mv	a6,a4
 59e:	2705                	addiw	a4,a4,1
 5a0:	02c5f7bb          	remuw	a5,a1,a2
 5a4:	1782                	slli	a5,a5,0x20
 5a6:	9381                	srli	a5,a5,0x20
 5a8:	97aa                	add	a5,a5,a0
 5aa:	0007c783          	lbu	a5,0(a5)
 5ae:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5b2:	0005879b          	sext.w	a5,a1
 5b6:	02c5d5bb          	divuw	a1,a1,a2
 5ba:	0685                	addi	a3,a3,1
 5bc:	fec7f0e3          	bgeu	a5,a2,59c <printint+0x26>
  if(neg)
 5c0:	00088c63          	beqz	a7,5d8 <printint+0x62>
    buf[i++] = '-';
 5c4:	fd070793          	addi	a5,a4,-48
 5c8:	00878733          	add	a4,a5,s0
 5cc:	02d00793          	li	a5,45
 5d0:	fef70823          	sb	a5,-16(a4)
 5d4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5d8:	02e05a63          	blez	a4,60c <printint+0x96>
 5dc:	f04a                	sd	s2,32(sp)
 5de:	ec4e                	sd	s3,24(sp)
 5e0:	fc040793          	addi	a5,s0,-64
 5e4:	00e78933          	add	s2,a5,a4
 5e8:	fff78993          	addi	s3,a5,-1
 5ec:	99ba                	add	s3,s3,a4
 5ee:	377d                	addiw	a4,a4,-1
 5f0:	1702                	slli	a4,a4,0x20
 5f2:	9301                	srli	a4,a4,0x20
 5f4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5f8:	fff94583          	lbu	a1,-1(s2)
 5fc:	8526                	mv	a0,s1
 5fe:	f5bff0ef          	jal	558 <putc>
  while(--i >= 0)
 602:	197d                	addi	s2,s2,-1
 604:	ff391ae3          	bne	s2,s3,5f8 <printint+0x82>
 608:	7902                	ld	s2,32(sp)
 60a:	69e2                	ld	s3,24(sp)
}
 60c:	70e2                	ld	ra,56(sp)
 60e:	7442                	ld	s0,48(sp)
 610:	74a2                	ld	s1,40(sp)
 612:	6121                	addi	sp,sp,64
 614:	8082                	ret
    x = -xx;
 616:	40b005bb          	negw	a1,a1
    neg = 1;
 61a:	4885                	li	a7,1
    x = -xx;
 61c:	bf85                	j	58c <printint+0x16>

000000000000061e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 61e:	711d                	addi	sp,sp,-96
 620:	ec86                	sd	ra,88(sp)
 622:	e8a2                	sd	s0,80(sp)
 624:	e0ca                	sd	s2,64(sp)
 626:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 628:	0005c903          	lbu	s2,0(a1)
 62c:	26090863          	beqz	s2,89c <vprintf+0x27e>
 630:	e4a6                	sd	s1,72(sp)
 632:	fc4e                	sd	s3,56(sp)
 634:	f852                	sd	s4,48(sp)
 636:	f456                	sd	s5,40(sp)
 638:	f05a                	sd	s6,32(sp)
 63a:	ec5e                	sd	s7,24(sp)
 63c:	e862                	sd	s8,16(sp)
 63e:	e466                	sd	s9,8(sp)
 640:	8b2a                	mv	s6,a0
 642:	8a2e                	mv	s4,a1
 644:	8bb2                	mv	s7,a2
  state = 0;
 646:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 648:	4481                	li	s1,0
 64a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 64c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 650:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 654:	06c00c93          	li	s9,108
 658:	a005                	j	678 <vprintf+0x5a>
        putc(fd, c0);
 65a:	85ca                	mv	a1,s2
 65c:	855a                	mv	a0,s6
 65e:	efbff0ef          	jal	558 <putc>
 662:	a019                	j	668 <vprintf+0x4a>
    } else if(state == '%'){
 664:	03598263          	beq	s3,s5,688 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 668:	2485                	addiw	s1,s1,1
 66a:	8726                	mv	a4,s1
 66c:	009a07b3          	add	a5,s4,s1
 670:	0007c903          	lbu	s2,0(a5)
 674:	20090c63          	beqz	s2,88c <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 678:	0009079b          	sext.w	a5,s2
    if(state == 0){
 67c:	fe0994e3          	bnez	s3,664 <vprintf+0x46>
      if(c0 == '%'){
 680:	fd579de3          	bne	a5,s5,65a <vprintf+0x3c>
        state = '%';
 684:	89be                	mv	s3,a5
 686:	b7cd                	j	668 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 688:	00ea06b3          	add	a3,s4,a4
 68c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 690:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 692:	c681                	beqz	a3,69a <vprintf+0x7c>
 694:	9752                	add	a4,a4,s4
 696:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 69a:	03878f63          	beq	a5,s8,6d8 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 69e:	05978963          	beq	a5,s9,6f0 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6a2:	07500713          	li	a4,117
 6a6:	0ee78363          	beq	a5,a4,78c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6aa:	07800713          	li	a4,120
 6ae:	12e78563          	beq	a5,a4,7d8 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6b2:	07000713          	li	a4,112
 6b6:	14e78a63          	beq	a5,a4,80a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6ba:	07300713          	li	a4,115
 6be:	18e78a63          	beq	a5,a4,852 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6c2:	02500713          	li	a4,37
 6c6:	04e79563          	bne	a5,a4,710 <vprintf+0xf2>
        putc(fd, '%');
 6ca:	02500593          	li	a1,37
 6ce:	855a                	mv	a0,s6
 6d0:	e89ff0ef          	jal	558 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	bf49                	j	668 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6d8:	008b8913          	addi	s2,s7,8
 6dc:	4685                	li	a3,1
 6de:	4629                	li	a2,10
 6e0:	000ba583          	lw	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	e91ff0ef          	jal	576 <printint>
 6ea:	8bca                	mv	s7,s2
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	bfad                	j	668 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6f0:	06400793          	li	a5,100
 6f4:	02f68963          	beq	a3,a5,726 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6f8:	06c00793          	li	a5,108
 6fc:	04f68263          	beq	a3,a5,740 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 700:	07500793          	li	a5,117
 704:	0af68063          	beq	a3,a5,7a4 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 708:	07800793          	li	a5,120
 70c:	0ef68263          	beq	a3,a5,7f0 <vprintf+0x1d2>
        putc(fd, '%');
 710:	02500593          	li	a1,37
 714:	855a                	mv	a0,s6
 716:	e43ff0ef          	jal	558 <putc>
        putc(fd, c0);
 71a:	85ca                	mv	a1,s2
 71c:	855a                	mv	a0,s6
 71e:	e3bff0ef          	jal	558 <putc>
      state = 0;
 722:	4981                	li	s3,0
 724:	b791                	j	668 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 726:	008b8913          	addi	s2,s7,8
 72a:	4685                	li	a3,1
 72c:	4629                	li	a2,10
 72e:	000ba583          	lw	a1,0(s7)
 732:	855a                	mv	a0,s6
 734:	e43ff0ef          	jal	576 <printint>
        i += 1;
 738:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 73a:	8bca                	mv	s7,s2
      state = 0;
 73c:	4981                	li	s3,0
        i += 1;
 73e:	b72d                	j	668 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 740:	06400793          	li	a5,100
 744:	02f60763          	beq	a2,a5,772 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 748:	07500793          	li	a5,117
 74c:	06f60963          	beq	a2,a5,7be <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 750:	07800793          	li	a5,120
 754:	faf61ee3          	bne	a2,a5,710 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 758:	008b8913          	addi	s2,s7,8
 75c:	4681                	li	a3,0
 75e:	4641                	li	a2,16
 760:	000ba583          	lw	a1,0(s7)
 764:	855a                	mv	a0,s6
 766:	e11ff0ef          	jal	576 <printint>
        i += 2;
 76a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 76c:	8bca                	mv	s7,s2
      state = 0;
 76e:	4981                	li	s3,0
        i += 2;
 770:	bde5                	j	668 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 772:	008b8913          	addi	s2,s7,8
 776:	4685                	li	a3,1
 778:	4629                	li	a2,10
 77a:	000ba583          	lw	a1,0(s7)
 77e:	855a                	mv	a0,s6
 780:	df7ff0ef          	jal	576 <printint>
        i += 2;
 784:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 786:	8bca                	mv	s7,s2
      state = 0;
 788:	4981                	li	s3,0
        i += 2;
 78a:	bdf9                	j	668 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 78c:	008b8913          	addi	s2,s7,8
 790:	4681                	li	a3,0
 792:	4629                	li	a2,10
 794:	000ba583          	lw	a1,0(s7)
 798:	855a                	mv	a0,s6
 79a:	dddff0ef          	jal	576 <printint>
 79e:	8bca                	mv	s7,s2
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	b5d9                	j	668 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a4:	008b8913          	addi	s2,s7,8
 7a8:	4681                	li	a3,0
 7aa:	4629                	li	a2,10
 7ac:	000ba583          	lw	a1,0(s7)
 7b0:	855a                	mv	a0,s6
 7b2:	dc5ff0ef          	jal	576 <printint>
        i += 1;
 7b6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b8:	8bca                	mv	s7,s2
      state = 0;
 7ba:	4981                	li	s3,0
        i += 1;
 7bc:	b575                	j	668 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7be:	008b8913          	addi	s2,s7,8
 7c2:	4681                	li	a3,0
 7c4:	4629                	li	a2,10
 7c6:	000ba583          	lw	a1,0(s7)
 7ca:	855a                	mv	a0,s6
 7cc:	dabff0ef          	jal	576 <printint>
        i += 2;
 7d0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d2:	8bca                	mv	s7,s2
      state = 0;
 7d4:	4981                	li	s3,0
        i += 2;
 7d6:	bd49                	j	668 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7d8:	008b8913          	addi	s2,s7,8
 7dc:	4681                	li	a3,0
 7de:	4641                	li	a2,16
 7e0:	000ba583          	lw	a1,0(s7)
 7e4:	855a                	mv	a0,s6
 7e6:	d91ff0ef          	jal	576 <printint>
 7ea:	8bca                	mv	s7,s2
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	bdad                	j	668 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f0:	008b8913          	addi	s2,s7,8
 7f4:	4681                	li	a3,0
 7f6:	4641                	li	a2,16
 7f8:	000ba583          	lw	a1,0(s7)
 7fc:	855a                	mv	a0,s6
 7fe:	d79ff0ef          	jal	576 <printint>
        i += 1;
 802:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 804:	8bca                	mv	s7,s2
      state = 0;
 806:	4981                	li	s3,0
        i += 1;
 808:	b585                	j	668 <vprintf+0x4a>
 80a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 80c:	008b8d13          	addi	s10,s7,8
 810:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 814:	03000593          	li	a1,48
 818:	855a                	mv	a0,s6
 81a:	d3fff0ef          	jal	558 <putc>
  putc(fd, 'x');
 81e:	07800593          	li	a1,120
 822:	855a                	mv	a0,s6
 824:	d35ff0ef          	jal	558 <putc>
 828:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 82a:	00000b97          	auipc	s7,0x0
 82e:	29eb8b93          	addi	s7,s7,670 # ac8 <digits>
 832:	03c9d793          	srli	a5,s3,0x3c
 836:	97de                	add	a5,a5,s7
 838:	0007c583          	lbu	a1,0(a5)
 83c:	855a                	mv	a0,s6
 83e:	d1bff0ef          	jal	558 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 842:	0992                	slli	s3,s3,0x4
 844:	397d                	addiw	s2,s2,-1
 846:	fe0916e3          	bnez	s2,832 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 84a:	8bea                	mv	s7,s10
      state = 0;
 84c:	4981                	li	s3,0
 84e:	6d02                	ld	s10,0(sp)
 850:	bd21                	j	668 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 852:	008b8993          	addi	s3,s7,8
 856:	000bb903          	ld	s2,0(s7)
 85a:	00090f63          	beqz	s2,878 <vprintf+0x25a>
        for(; *s; s++)
 85e:	00094583          	lbu	a1,0(s2)
 862:	c195                	beqz	a1,886 <vprintf+0x268>
          putc(fd, *s);
 864:	855a                	mv	a0,s6
 866:	cf3ff0ef          	jal	558 <putc>
        for(; *s; s++)
 86a:	0905                	addi	s2,s2,1
 86c:	00094583          	lbu	a1,0(s2)
 870:	f9f5                	bnez	a1,864 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 872:	8bce                	mv	s7,s3
      state = 0;
 874:	4981                	li	s3,0
 876:	bbcd                	j	668 <vprintf+0x4a>
          s = "(null)";
 878:	00000917          	auipc	s2,0x0
 87c:	24890913          	addi	s2,s2,584 # ac0 <malloc+0x13c>
        for(; *s; s++)
 880:	02800593          	li	a1,40
 884:	b7c5                	j	864 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 886:	8bce                	mv	s7,s3
      state = 0;
 888:	4981                	li	s3,0
 88a:	bbf9                	j	668 <vprintf+0x4a>
 88c:	64a6                	ld	s1,72(sp)
 88e:	79e2                	ld	s3,56(sp)
 890:	7a42                	ld	s4,48(sp)
 892:	7aa2                	ld	s5,40(sp)
 894:	7b02                	ld	s6,32(sp)
 896:	6be2                	ld	s7,24(sp)
 898:	6c42                	ld	s8,16(sp)
 89a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 89c:	60e6                	ld	ra,88(sp)
 89e:	6446                	ld	s0,80(sp)
 8a0:	6906                	ld	s2,64(sp)
 8a2:	6125                	addi	sp,sp,96
 8a4:	8082                	ret

00000000000008a6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8a6:	715d                	addi	sp,sp,-80
 8a8:	ec06                	sd	ra,24(sp)
 8aa:	e822                	sd	s0,16(sp)
 8ac:	1000                	addi	s0,sp,32
 8ae:	e010                	sd	a2,0(s0)
 8b0:	e414                	sd	a3,8(s0)
 8b2:	e818                	sd	a4,16(s0)
 8b4:	ec1c                	sd	a5,24(s0)
 8b6:	03043023          	sd	a6,32(s0)
 8ba:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8be:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8c2:	8622                	mv	a2,s0
 8c4:	d5bff0ef          	jal	61e <vprintf>
}
 8c8:	60e2                	ld	ra,24(sp)
 8ca:	6442                	ld	s0,16(sp)
 8cc:	6161                	addi	sp,sp,80
 8ce:	8082                	ret

00000000000008d0 <printf>:

void
printf(const char *fmt, ...)
{
 8d0:	711d                	addi	sp,sp,-96
 8d2:	ec06                	sd	ra,24(sp)
 8d4:	e822                	sd	s0,16(sp)
 8d6:	1000                	addi	s0,sp,32
 8d8:	e40c                	sd	a1,8(s0)
 8da:	e810                	sd	a2,16(s0)
 8dc:	ec14                	sd	a3,24(s0)
 8de:	f018                	sd	a4,32(s0)
 8e0:	f41c                	sd	a5,40(s0)
 8e2:	03043823          	sd	a6,48(s0)
 8e6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ea:	00840613          	addi	a2,s0,8
 8ee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8f2:	85aa                	mv	a1,a0
 8f4:	4505                	li	a0,1
 8f6:	d29ff0ef          	jal	61e <vprintf>
}
 8fa:	60e2                	ld	ra,24(sp)
 8fc:	6442                	ld	s0,16(sp)
 8fe:	6125                	addi	sp,sp,96
 900:	8082                	ret

0000000000000902 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 902:	1141                	addi	sp,sp,-16
 904:	e422                	sd	s0,8(sp)
 906:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 908:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90c:	00000797          	auipc	a5,0x0
 910:	7047b783          	ld	a5,1796(a5) # 1010 <freep>
 914:	a02d                	j	93e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 916:	4618                	lw	a4,8(a2)
 918:	9f2d                	addw	a4,a4,a1
 91a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 91e:	6398                	ld	a4,0(a5)
 920:	6310                	ld	a2,0(a4)
 922:	a83d                	j	960 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 924:	ff852703          	lw	a4,-8(a0)
 928:	9f31                	addw	a4,a4,a2
 92a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 92c:	ff053683          	ld	a3,-16(a0)
 930:	a091                	j	974 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 932:	6398                	ld	a4,0(a5)
 934:	00e7e463          	bltu	a5,a4,93c <free+0x3a>
 938:	00e6ea63          	bltu	a3,a4,94c <free+0x4a>
{
 93c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93e:	fed7fae3          	bgeu	a5,a3,932 <free+0x30>
 942:	6398                	ld	a4,0(a5)
 944:	00e6e463          	bltu	a3,a4,94c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 948:	fee7eae3          	bltu	a5,a4,93c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 94c:	ff852583          	lw	a1,-8(a0)
 950:	6390                	ld	a2,0(a5)
 952:	02059813          	slli	a6,a1,0x20
 956:	01c85713          	srli	a4,a6,0x1c
 95a:	9736                	add	a4,a4,a3
 95c:	fae60de3          	beq	a2,a4,916 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 960:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 964:	4790                	lw	a2,8(a5)
 966:	02061593          	slli	a1,a2,0x20
 96a:	01c5d713          	srli	a4,a1,0x1c
 96e:	973e                	add	a4,a4,a5
 970:	fae68ae3          	beq	a3,a4,924 <free+0x22>
    p->s.ptr = bp->s.ptr;
 974:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 976:	00000717          	auipc	a4,0x0
 97a:	68f73d23          	sd	a5,1690(a4) # 1010 <freep>
}
 97e:	6422                	ld	s0,8(sp)
 980:	0141                	addi	sp,sp,16
 982:	8082                	ret

0000000000000984 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 984:	7139                	addi	sp,sp,-64
 986:	fc06                	sd	ra,56(sp)
 988:	f822                	sd	s0,48(sp)
 98a:	f426                	sd	s1,40(sp)
 98c:	ec4e                	sd	s3,24(sp)
 98e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 990:	02051493          	slli	s1,a0,0x20
 994:	9081                	srli	s1,s1,0x20
 996:	04bd                	addi	s1,s1,15
 998:	8091                	srli	s1,s1,0x4
 99a:	0014899b          	addiw	s3,s1,1
 99e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9a0:	00000517          	auipc	a0,0x0
 9a4:	67053503          	ld	a0,1648(a0) # 1010 <freep>
 9a8:	c915                	beqz	a0,9dc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ac:	4798                	lw	a4,8(a5)
 9ae:	08977a63          	bgeu	a4,s1,a42 <malloc+0xbe>
 9b2:	f04a                	sd	s2,32(sp)
 9b4:	e852                	sd	s4,16(sp)
 9b6:	e456                	sd	s5,8(sp)
 9b8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9ba:	8a4e                	mv	s4,s3
 9bc:	0009871b          	sext.w	a4,s3
 9c0:	6685                	lui	a3,0x1
 9c2:	00d77363          	bgeu	a4,a3,9c8 <malloc+0x44>
 9c6:	6a05                	lui	s4,0x1
 9c8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9cc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d0:	00000917          	auipc	s2,0x0
 9d4:	64090913          	addi	s2,s2,1600 # 1010 <freep>
  if(p == (char*)-1)
 9d8:	5afd                	li	s5,-1
 9da:	a081                	j	a1a <malloc+0x96>
 9dc:	f04a                	sd	s2,32(sp)
 9de:	e852                	sd	s4,16(sp)
 9e0:	e456                	sd	s5,8(sp)
 9e2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9e4:	00001797          	auipc	a5,0x1
 9e8:	2bc78793          	addi	a5,a5,700 # 1ca0 <base>
 9ec:	00000717          	auipc	a4,0x0
 9f0:	62f73223          	sd	a5,1572(a4) # 1010 <freep>
 9f4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9f6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9fa:	b7c1                	j	9ba <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9fc:	6398                	ld	a4,0(a5)
 9fe:	e118                	sd	a4,0(a0)
 a00:	a8a9                	j	a5a <malloc+0xd6>
  hp->s.size = nu;
 a02:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a06:	0541                	addi	a0,a0,16
 a08:	efbff0ef          	jal	902 <free>
  return freep;
 a0c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a10:	c12d                	beqz	a0,a72 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a12:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a14:	4798                	lw	a4,8(a5)
 a16:	02977263          	bgeu	a4,s1,a3a <malloc+0xb6>
    if(p == freep)
 a1a:	00093703          	ld	a4,0(s2)
 a1e:	853e                	mv	a0,a5
 a20:	fef719e3          	bne	a4,a5,a12 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a24:	8552                	mv	a0,s4
 a26:	b1bff0ef          	jal	540 <sbrk>
  if(p == (char*)-1)
 a2a:	fd551ce3          	bne	a0,s5,a02 <malloc+0x7e>
        return 0;
 a2e:	4501                	li	a0,0
 a30:	7902                	ld	s2,32(sp)
 a32:	6a42                	ld	s4,16(sp)
 a34:	6aa2                	ld	s5,8(sp)
 a36:	6b02                	ld	s6,0(sp)
 a38:	a03d                	j	a66 <malloc+0xe2>
 a3a:	7902                	ld	s2,32(sp)
 a3c:	6a42                	ld	s4,16(sp)
 a3e:	6aa2                	ld	s5,8(sp)
 a40:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a42:	fae48de3          	beq	s1,a4,9fc <malloc+0x78>
        p->s.size -= nunits;
 a46:	4137073b          	subw	a4,a4,s3
 a4a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a4c:	02071693          	slli	a3,a4,0x20
 a50:	01c6d713          	srli	a4,a3,0x1c
 a54:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a56:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a5a:	00000717          	auipc	a4,0x0
 a5e:	5aa73b23          	sd	a0,1462(a4) # 1010 <freep>
      return (void*)(p + 1);
 a62:	01078513          	addi	a0,a5,16
  }
}
 a66:	70e2                	ld	ra,56(sp)
 a68:	7442                	ld	s0,48(sp)
 a6a:	74a2                	ld	s1,40(sp)
 a6c:	69e2                	ld	s3,24(sp)
 a6e:	6121                	addi	sp,sp,64
 a70:	8082                	ret
 a72:	7902                	ld	s2,32(sp)
 a74:	6a42                	ld	s4,16(sp)
 a76:	6aa2                	ld	s5,8(sp)
 a78:	6b02                	ld	s6,0(sp)
 a7a:	b7f5                	j	a66 <malloc+0xe2>
