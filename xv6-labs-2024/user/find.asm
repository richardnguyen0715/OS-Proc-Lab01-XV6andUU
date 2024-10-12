
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <nameComparison>:
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int nameComparison(const char *name1, const char *name2) // Hàm so sánh 2 chuỗi có giống nhau hay không 
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
	if (strcmp(name1, name2) == 0)
   8:	20c000ef          	jal	214 <strcmp>
	{
		return 1;
	}
	return 0;
}
   c:	00153513          	seqz	a0,a0
  10:	60a2                	ld	ra,8(sp)
  12:	6402                	ld	s0,0(sp)
  14:	0141                	addi	sp,sp,16
  16:	8082                	ret

0000000000000018 <find>:

void
find(char *fileName, char* currentDir) // currentDir lưu tên của thư mục cha trong khi đệ quy
{
  18:	d8010113          	addi	sp,sp,-640
  1c:	26113c23          	sd	ra,632(sp)
  20:	26813823          	sd	s0,624(sp)
  24:	27213023          	sd	s2,608(sp)
  28:	25313c23          	sd	s3,600(sp)
  2c:	0500                	addi	s0,sp,640
  2e:	89aa                	mv	s3,a0
  30:	892e                	mv	s2,a1
	char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;
	
	if((fd = open(currentDir, O_RDONLY)) < 0)
  32:	4581                	li	a1,0
  34:	854a                	mv	a0,s2
  36:	45a000ef          	jal	490 <open>
  3a:	0e054463          	bltz	a0,122 <find+0x10a>
  3e:	26913423          	sd	s1,616(sp)
  42:	84aa                	mv	s1,a0
	{
		fprintf(2, "ls: cannot open %s\n", fileName);
		return;
	}

	if(fstat(fd, &st) < 0)
  44:	d8840593          	addi	a1,s0,-632
  48:	460000ef          	jal	4a8 <fstat>
  4c:	0e054463          	bltz	a0,134 <find+0x11c>
		fprintf(2, "ls: cannot stat %s\n", fileName);
		close(fd);
		return;
    }

	if(strlen(currentDir) + 1 + DIRSIZ + 1 > sizeof buf)
  50:	854a                	mv	a0,s2
  52:	1ee000ef          	jal	240 <strlen>
  56:	2541                	addiw	a0,a0,16
  58:	20000793          	li	a5,512
  5c:	0ea7ea63          	bltu	a5,a0,150 <find+0x138>
  60:	25413823          	sd	s4,592(sp)
  64:	25513423          	sd	s5,584(sp)
  68:	25613023          	sd	s6,576(sp)
  6c:	23713c23          	sd	s7,568(sp)
	{
		printf("ls: path too long\n");
		return;
	}

    strcpy(buf, currentDir);
  70:	85ca                	mv	a1,s2
  72:	db040513          	addi	a0,s0,-592
  76:	182000ef          	jal	1f8 <strcpy>
    p = buf+strlen(buf);
  7a:	db040513          	addi	a0,s0,-592
  7e:	1c2000ef          	jal	240 <strlen>
  82:	1502                	slli	a0,a0,0x20
  84:	9101                	srli	a0,a0,0x20
  86:	db040793          	addi	a5,s0,-592
  8a:	00a78933          	add	s2,a5,a0
    *p++ = '/';
  8e:	00190b93          	addi	s7,s2,1
  92:	02f00793          	li	a5,47
  96:	00f90023          	sb	a5,0(s2)
    	if(de.inum == 0)
		{
        	continue;
		}

		if(nameComparison(de.name, ".") == 1 || nameComparison(de.name, "..") == 1)
  9a:	00001a97          	auipc	s5,0x1
  9e:	9cea8a93          	addi	s5,s5,-1586 # a68 <malloc+0x14c>
  a2:	4a05                	li	s4,1
  a4:	00001b17          	auipc	s6,0x1
  a8:	9ccb0b13          	addi	s6,s6,-1588 # a70 <malloc+0x154>
    while(read(fd, &de, sizeof(de)) == sizeof(de))
  ac:	4641                	li	a2,16
  ae:	da040593          	addi	a1,s0,-608
  b2:	8526                	mv	a0,s1
  b4:	3b4000ef          	jal	468 <read>
  b8:	47c1                	li	a5,16
  ba:	0cf51663          	bne	a0,a5,186 <find+0x16e>
    	if(de.inum == 0)
  be:	da045783          	lhu	a5,-608(s0)
  c2:	d7ed                	beqz	a5,ac <find+0x94>
		if(nameComparison(de.name, ".") == 1 || nameComparison(de.name, "..") == 1)
  c4:	85d6                	mv	a1,s5
  c6:	da240513          	addi	a0,s0,-606
  ca:	f37ff0ef          	jal	0 <nameComparison>
  ce:	fd450fe3          	beq	a0,s4,ac <find+0x94>
  d2:	85da                	mv	a1,s6
  d4:	da240513          	addi	a0,s0,-606
  d8:	f29ff0ef          	jal	0 <nameComparison>
  dc:	fd4508e3          	beq	a0,s4,ac <find+0x94>
		{
			continue;
		}

		memmove(p, de.name, DIRSIZ);
  e0:	4639                	li	a2,14
  e2:	da240593          	addi	a1,s0,-606
  e6:	855e                	mv	a0,s7
  e8:	2ba000ef          	jal	3a2 <memmove>
    	p[DIRSIZ] = 0; // Cập nhật đường dẫn mới tới thư mục con (buf)
  ec:	000907a3          	sb	zero,15(s2)

    	if(stat(buf, &st) < 0)
  f0:	d8840593          	addi	a1,s0,-632
  f4:	db040513          	addi	a0,s0,-592
  f8:	228000ef          	jal	320 <stat>
  fc:	06054363          	bltz	a0,162 <find+0x14a>
		{
       		printf("ls: cannot stat %s\n", buf);
        	continue;
        }

		if(nameComparison(fileName, de.name) == 1)
 100:	da240593          	addi	a1,s0,-606
 104:	854e                	mv	a0,s3
 106:	efbff0ef          	jal	0 <nameComparison>
 10a:	07450563          	beq	a0,s4,174 <find+0x15c>
		{
			printf("%s\n", buf);
		}

		if(st.type == T_DIR)
 10e:	d9041783          	lh	a5,-624(s0)
 112:	f9479de3          	bne	a5,s4,ac <find+0x94>
		{
			find(fileName, buf); // currentDir đã được thay đổi thành buf
 116:	db040593          	addi	a1,s0,-592
 11a:	854e                	mv	a0,s3
 11c:	efdff0ef          	jal	18 <find>
 120:	b771                	j	ac <find+0x94>
		fprintf(2, "ls: cannot open %s\n", fileName);
 122:	864e                	mv	a2,s3
 124:	00001597          	auipc	a1,0x1
 128:	8fc58593          	addi	a1,a1,-1796 # a20 <malloc+0x104>
 12c:	4509                	li	a0,2
 12e:	710000ef          	jal	83e <fprintf>
		return;
 132:	a0bd                	j	1a0 <find+0x188>
		fprintf(2, "ls: cannot stat %s\n", fileName);
 134:	864e                	mv	a2,s3
 136:	00001597          	auipc	a1,0x1
 13a:	90258593          	addi	a1,a1,-1790 # a38 <malloc+0x11c>
 13e:	4509                	li	a0,2
 140:	6fe000ef          	jal	83e <fprintf>
		close(fd);
 144:	8526                	mv	a0,s1
 146:	332000ef          	jal	478 <close>
		return;
 14a:	26813483          	ld	s1,616(sp)
 14e:	a889                	j	1a0 <find+0x188>
		printf("ls: path too long\n");
 150:	00001517          	auipc	a0,0x1
 154:	90050513          	addi	a0,a0,-1792 # a50 <malloc+0x134>
 158:	710000ef          	jal	868 <printf>
		return;
 15c:	26813483          	ld	s1,616(sp)
 160:	a081                	j	1a0 <find+0x188>
       		printf("ls: cannot stat %s\n", buf);
 162:	db040593          	addi	a1,s0,-592
 166:	00001517          	auipc	a0,0x1
 16a:	8d250513          	addi	a0,a0,-1838 # a38 <malloc+0x11c>
 16e:	6fa000ef          	jal	868 <printf>
        	continue;
 172:	bf2d                	j	ac <find+0x94>
			printf("%s\n", buf);
 174:	db040593          	addi	a1,s0,-592
 178:	00001517          	auipc	a0,0x1
 17c:	8b850513          	addi	a0,a0,-1864 # a30 <malloc+0x114>
 180:	6e8000ef          	jal	868 <printf>
 184:	b769                	j	10e <find+0xf6>
		}
  	}
    close(fd);
 186:	8526                	mv	a0,s1
 188:	2f0000ef          	jal	478 <close>
 18c:	26813483          	ld	s1,616(sp)
 190:	25013a03          	ld	s4,592(sp)
 194:	24813a83          	ld	s5,584(sp)
 198:	24013b03          	ld	s6,576(sp)
 19c:	23813b83          	ld	s7,568(sp)
}
 1a0:	27813083          	ld	ra,632(sp)
 1a4:	27013403          	ld	s0,624(sp)
 1a8:	26013903          	ld	s2,608(sp)
 1ac:	25813983          	ld	s3,600(sp)
 1b0:	28010113          	addi	sp,sp,640
 1b4:	8082                	ret

00000000000001b6 <main>:

int
main(int argc, char *argv[])
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e406                	sd	ra,8(sp)
 1ba:	e022                	sd	s0,0(sp)
 1bc:	0800                	addi	s0,sp,16
	if (argc != 3)
 1be:	470d                	li	a4,3
 1c0:	00e50b63          	beq	a0,a4,1d6 <main+0x20>
	{
		printf("Error: Arguments do not fit the command parameter(s).\n");
 1c4:	00001517          	auipc	a0,0x1
 1c8:	8b450513          	addi	a0,a0,-1868 # a78 <malloc+0x15c>
 1cc:	69c000ef          	jal	868 <printf>
		exit(0);
 1d0:	4501                	li	a0,0
 1d2:	27e000ef          	jal	450 <exit>
 1d6:	87ae                	mv	a5,a1
	}

	find(argv[2], argv[1]);
 1d8:	658c                	ld	a1,8(a1)
 1da:	6b88                	ld	a0,16(a5)
 1dc:	e3dff0ef          	jal	18 <find>
	exit(0);	
 1e0:	4501                	li	a0,0
 1e2:	26e000ef          	jal	450 <exit>

00000000000001e6 <start>:
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e406                	sd	ra,8(sp)
 1ea:	e022                	sd	s0,0(sp)
 1ec:	0800                	addi	s0,sp,16
 1ee:	fc9ff0ef          	jal	1b6 <main>
 1f2:	4501                	li	a0,0
 1f4:	25c000ef          	jal	450 <exit>

00000000000001f8 <strcpy>:
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e422                	sd	s0,8(sp)
 1fc:	0800                	addi	s0,sp,16
 1fe:	87aa                	mv	a5,a0
 200:	0585                	addi	a1,a1,1
 202:	0785                	addi	a5,a5,1
 204:	fff5c703          	lbu	a4,-1(a1)
 208:	fee78fa3          	sb	a4,-1(a5)
 20c:	fb75                	bnez	a4,200 <strcpy+0x8>
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret

0000000000000214 <strcmp>:
 214:	1141                	addi	sp,sp,-16
 216:	e422                	sd	s0,8(sp)
 218:	0800                	addi	s0,sp,16
 21a:	00054783          	lbu	a5,0(a0)
 21e:	cb91                	beqz	a5,232 <strcmp+0x1e>
 220:	0005c703          	lbu	a4,0(a1)
 224:	00f71763          	bne	a4,a5,232 <strcmp+0x1e>
 228:	0505                	addi	a0,a0,1
 22a:	0585                	addi	a1,a1,1
 22c:	00054783          	lbu	a5,0(a0)
 230:	fbe5                	bnez	a5,220 <strcmp+0xc>
 232:	0005c503          	lbu	a0,0(a1)
 236:	40a7853b          	subw	a0,a5,a0
 23a:	6422                	ld	s0,8(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret

0000000000000240 <strlen>:
 240:	1141                	addi	sp,sp,-16
 242:	e422                	sd	s0,8(sp)
 244:	0800                	addi	s0,sp,16
 246:	00054783          	lbu	a5,0(a0)
 24a:	cf91                	beqz	a5,266 <strlen+0x26>
 24c:	0505                	addi	a0,a0,1
 24e:	87aa                	mv	a5,a0
 250:	86be                	mv	a3,a5
 252:	0785                	addi	a5,a5,1
 254:	fff7c703          	lbu	a4,-1(a5)
 258:	ff65                	bnez	a4,250 <strlen+0x10>
 25a:	40a6853b          	subw	a0,a3,a0
 25e:	2505                	addiw	a0,a0,1
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
 266:	4501                	li	a0,0
 268:	bfe5                	j	260 <strlen+0x20>

000000000000026a <memset>:
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
 270:	ca19                	beqz	a2,286 <memset+0x1c>
 272:	87aa                	mv	a5,a0
 274:	1602                	slli	a2,a2,0x20
 276:	9201                	srli	a2,a2,0x20
 278:	00a60733          	add	a4,a2,a0
 27c:	00b78023          	sb	a1,0(a5)
 280:	0785                	addi	a5,a5,1
 282:	fee79de3          	bne	a5,a4,27c <memset+0x12>
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret

000000000000028c <strchr>:
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
 292:	00054783          	lbu	a5,0(a0)
 296:	cb99                	beqz	a5,2ac <strchr+0x20>
 298:	00f58763          	beq	a1,a5,2a6 <strchr+0x1a>
 29c:	0505                	addi	a0,a0,1
 29e:	00054783          	lbu	a5,0(a0)
 2a2:	fbfd                	bnez	a5,298 <strchr+0xc>
 2a4:	4501                	li	a0,0
 2a6:	6422                	ld	s0,8(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret
 2ac:	4501                	li	a0,0
 2ae:	bfe5                	j	2a6 <strchr+0x1a>

00000000000002b0 <gets>:
 2b0:	711d                	addi	sp,sp,-96
 2b2:	ec86                	sd	ra,88(sp)
 2b4:	e8a2                	sd	s0,80(sp)
 2b6:	e4a6                	sd	s1,72(sp)
 2b8:	e0ca                	sd	s2,64(sp)
 2ba:	fc4e                	sd	s3,56(sp)
 2bc:	f852                	sd	s4,48(sp)
 2be:	f456                	sd	s5,40(sp)
 2c0:	f05a                	sd	s6,32(sp)
 2c2:	ec5e                	sd	s7,24(sp)
 2c4:	1080                	addi	s0,sp,96
 2c6:	8baa                	mv	s7,a0
 2c8:	8a2e                	mv	s4,a1
 2ca:	892a                	mv	s2,a0
 2cc:	4481                	li	s1,0
 2ce:	4aa9                	li	s5,10
 2d0:	4b35                	li	s6,13
 2d2:	89a6                	mv	s3,s1
 2d4:	2485                	addiw	s1,s1,1
 2d6:	0344d663          	bge	s1,s4,302 <gets+0x52>
 2da:	4605                	li	a2,1
 2dc:	faf40593          	addi	a1,s0,-81
 2e0:	4501                	li	a0,0
 2e2:	186000ef          	jal	468 <read>
 2e6:	00a05e63          	blez	a0,302 <gets+0x52>
 2ea:	faf44783          	lbu	a5,-81(s0)
 2ee:	00f90023          	sb	a5,0(s2)
 2f2:	01578763          	beq	a5,s5,300 <gets+0x50>
 2f6:	0905                	addi	s2,s2,1
 2f8:	fd679de3          	bne	a5,s6,2d2 <gets+0x22>
 2fc:	89a6                	mv	s3,s1
 2fe:	a011                	j	302 <gets+0x52>
 300:	89a6                	mv	s3,s1
 302:	99de                	add	s3,s3,s7
 304:	00098023          	sb	zero,0(s3)
 308:	855e                	mv	a0,s7
 30a:	60e6                	ld	ra,88(sp)
 30c:	6446                	ld	s0,80(sp)
 30e:	64a6                	ld	s1,72(sp)
 310:	6906                	ld	s2,64(sp)
 312:	79e2                	ld	s3,56(sp)
 314:	7a42                	ld	s4,48(sp)
 316:	7aa2                	ld	s5,40(sp)
 318:	7b02                	ld	s6,32(sp)
 31a:	6be2                	ld	s7,24(sp)
 31c:	6125                	addi	sp,sp,96
 31e:	8082                	ret

0000000000000320 <stat>:
 320:	1101                	addi	sp,sp,-32
 322:	ec06                	sd	ra,24(sp)
 324:	e822                	sd	s0,16(sp)
 326:	e04a                	sd	s2,0(sp)
 328:	1000                	addi	s0,sp,32
 32a:	892e                	mv	s2,a1
 32c:	4581                	li	a1,0
 32e:	162000ef          	jal	490 <open>
 332:	02054263          	bltz	a0,356 <stat+0x36>
 336:	e426                	sd	s1,8(sp)
 338:	84aa                	mv	s1,a0
 33a:	85ca                	mv	a1,s2
 33c:	16c000ef          	jal	4a8 <fstat>
 340:	892a                	mv	s2,a0
 342:	8526                	mv	a0,s1
 344:	134000ef          	jal	478 <close>
 348:	64a2                	ld	s1,8(sp)
 34a:	854a                	mv	a0,s2
 34c:	60e2                	ld	ra,24(sp)
 34e:	6442                	ld	s0,16(sp)
 350:	6902                	ld	s2,0(sp)
 352:	6105                	addi	sp,sp,32
 354:	8082                	ret
 356:	597d                	li	s2,-1
 358:	bfcd                	j	34a <stat+0x2a>

000000000000035a <atoi>:
 35a:	1141                	addi	sp,sp,-16
 35c:	e422                	sd	s0,8(sp)
 35e:	0800                	addi	s0,sp,16
 360:	00054683          	lbu	a3,0(a0)
 364:	fd06879b          	addiw	a5,a3,-48
 368:	0ff7f793          	zext.b	a5,a5
 36c:	4625                	li	a2,9
 36e:	02f66863          	bltu	a2,a5,39e <atoi+0x44>
 372:	872a                	mv	a4,a0
 374:	4501                	li	a0,0
 376:	0705                	addi	a4,a4,1
 378:	0025179b          	slliw	a5,a0,0x2
 37c:	9fa9                	addw	a5,a5,a0
 37e:	0017979b          	slliw	a5,a5,0x1
 382:	9fb5                	addw	a5,a5,a3
 384:	fd07851b          	addiw	a0,a5,-48
 388:	00074683          	lbu	a3,0(a4)
 38c:	fd06879b          	addiw	a5,a3,-48
 390:	0ff7f793          	zext.b	a5,a5
 394:	fef671e3          	bgeu	a2,a5,376 <atoi+0x1c>
 398:	6422                	ld	s0,8(sp)
 39a:	0141                	addi	sp,sp,16
 39c:	8082                	ret
 39e:	4501                	li	a0,0
 3a0:	bfe5                	j	398 <atoi+0x3e>

00000000000003a2 <memmove>:
 3a2:	1141                	addi	sp,sp,-16
 3a4:	e422                	sd	s0,8(sp)
 3a6:	0800                	addi	s0,sp,16
 3a8:	02b57463          	bgeu	a0,a1,3d0 <memmove+0x2e>
 3ac:	00c05f63          	blez	a2,3ca <memmove+0x28>
 3b0:	1602                	slli	a2,a2,0x20
 3b2:	9201                	srli	a2,a2,0x20
 3b4:	00c507b3          	add	a5,a0,a2
 3b8:	872a                	mv	a4,a0
 3ba:	0585                	addi	a1,a1,1
 3bc:	0705                	addi	a4,a4,1
 3be:	fff5c683          	lbu	a3,-1(a1)
 3c2:	fed70fa3          	sb	a3,-1(a4)
 3c6:	fef71ae3          	bne	a4,a5,3ba <memmove+0x18>
 3ca:	6422                	ld	s0,8(sp)
 3cc:	0141                	addi	sp,sp,16
 3ce:	8082                	ret
 3d0:	00c50733          	add	a4,a0,a2
 3d4:	95b2                	add	a1,a1,a2
 3d6:	fec05ae3          	blez	a2,3ca <memmove+0x28>
 3da:	fff6079b          	addiw	a5,a2,-1
 3de:	1782                	slli	a5,a5,0x20
 3e0:	9381                	srli	a5,a5,0x20
 3e2:	fff7c793          	not	a5,a5
 3e6:	97ba                	add	a5,a5,a4
 3e8:	15fd                	addi	a1,a1,-1
 3ea:	177d                	addi	a4,a4,-1
 3ec:	0005c683          	lbu	a3,0(a1)
 3f0:	00d70023          	sb	a3,0(a4)
 3f4:	fee79ae3          	bne	a5,a4,3e8 <memmove+0x46>
 3f8:	bfc9                	j	3ca <memmove+0x28>

00000000000003fa <memcmp>:
 3fa:	1141                	addi	sp,sp,-16
 3fc:	e422                	sd	s0,8(sp)
 3fe:	0800                	addi	s0,sp,16
 400:	ca05                	beqz	a2,430 <memcmp+0x36>
 402:	fff6069b          	addiw	a3,a2,-1
 406:	1682                	slli	a3,a3,0x20
 408:	9281                	srli	a3,a3,0x20
 40a:	0685                	addi	a3,a3,1
 40c:	96aa                	add	a3,a3,a0
 40e:	00054783          	lbu	a5,0(a0)
 412:	0005c703          	lbu	a4,0(a1)
 416:	00e79863          	bne	a5,a4,426 <memcmp+0x2c>
 41a:	0505                	addi	a0,a0,1
 41c:	0585                	addi	a1,a1,1
 41e:	fed518e3          	bne	a0,a3,40e <memcmp+0x14>
 422:	4501                	li	a0,0
 424:	a019                	j	42a <memcmp+0x30>
 426:	40e7853b          	subw	a0,a5,a4
 42a:	6422                	ld	s0,8(sp)
 42c:	0141                	addi	sp,sp,16
 42e:	8082                	ret
 430:	4501                	li	a0,0
 432:	bfe5                	j	42a <memcmp+0x30>

0000000000000434 <memcpy>:
 434:	1141                	addi	sp,sp,-16
 436:	e406                	sd	ra,8(sp)
 438:	e022                	sd	s0,0(sp)
 43a:	0800                	addi	s0,sp,16
 43c:	f67ff0ef          	jal	3a2 <memmove>
 440:	60a2                	ld	ra,8(sp)
 442:	6402                	ld	s0,0(sp)
 444:	0141                	addi	sp,sp,16
 446:	8082                	ret

0000000000000448 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 448:	4885                	li	a7,1
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <exit>:
.global exit
exit:
 li a7, SYS_exit
 450:	4889                	li	a7,2
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <wait>:
.global wait
wait:
 li a7, SYS_wait
 458:	488d                	li	a7,3
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 460:	4891                	li	a7,4
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <read>:
.global read
read:
 li a7, SYS_read
 468:	4895                	li	a7,5
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <write>:
.global write
write:
 li a7, SYS_write
 470:	48c1                	li	a7,16
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <close>:
.global close
close:
 li a7, SYS_close
 478:	48d5                	li	a7,21
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <kill>:
.global kill
kill:
 li a7, SYS_kill
 480:	4899                	li	a7,6
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <exec>:
.global exec
exec:
 li a7, SYS_exec
 488:	489d                	li	a7,7
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <open>:
.global open
open:
 li a7, SYS_open
 490:	48bd                	li	a7,15
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 498:	48c5                	li	a7,17
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4a0:	48c9                	li	a7,18
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4a8:	48a1                	li	a7,8
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <link>:
.global link
link:
 li a7, SYS_link
 4b0:	48cd                	li	a7,19
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4b8:	48d1                	li	a7,20
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4c0:	48a5                	li	a7,9
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4c8:	48a9                	li	a7,10
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4d0:	48ad                	li	a7,11
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4d8:	48b1                	li	a7,12
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4e0:	48b5                	li	a7,13
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4e8:	48b9                	li	a7,14
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4f0:	1101                	addi	sp,sp,-32
 4f2:	ec06                	sd	ra,24(sp)
 4f4:	e822                	sd	s0,16(sp)
 4f6:	1000                	addi	s0,sp,32
 4f8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4fc:	4605                	li	a2,1
 4fe:	fef40593          	addi	a1,s0,-17
 502:	f6fff0ef          	jal	470 <write>
}
 506:	60e2                	ld	ra,24(sp)
 508:	6442                	ld	s0,16(sp)
 50a:	6105                	addi	sp,sp,32
 50c:	8082                	ret

000000000000050e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 50e:	7139                	addi	sp,sp,-64
 510:	fc06                	sd	ra,56(sp)
 512:	f822                	sd	s0,48(sp)
 514:	f426                	sd	s1,40(sp)
 516:	0080                	addi	s0,sp,64
 518:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 51a:	c299                	beqz	a3,520 <printint+0x12>
 51c:	0805c963          	bltz	a1,5ae <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 520:	2581                	sext.w	a1,a1
  neg = 0;
 522:	4881                	li	a7,0
 524:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 528:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 52a:	2601                	sext.w	a2,a2
 52c:	00000517          	auipc	a0,0x0
 530:	58c50513          	addi	a0,a0,1420 # ab8 <digits>
 534:	883a                	mv	a6,a4
 536:	2705                	addiw	a4,a4,1
 538:	02c5f7bb          	remuw	a5,a1,a2
 53c:	1782                	slli	a5,a5,0x20
 53e:	9381                	srli	a5,a5,0x20
 540:	97aa                	add	a5,a5,a0
 542:	0007c783          	lbu	a5,0(a5)
 546:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 54a:	0005879b          	sext.w	a5,a1
 54e:	02c5d5bb          	divuw	a1,a1,a2
 552:	0685                	addi	a3,a3,1
 554:	fec7f0e3          	bgeu	a5,a2,534 <printint+0x26>
  if(neg)
 558:	00088c63          	beqz	a7,570 <printint+0x62>
    buf[i++] = '-';
 55c:	fd070793          	addi	a5,a4,-48
 560:	00878733          	add	a4,a5,s0
 564:	02d00793          	li	a5,45
 568:	fef70823          	sb	a5,-16(a4)
 56c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 570:	02e05a63          	blez	a4,5a4 <printint+0x96>
 574:	f04a                	sd	s2,32(sp)
 576:	ec4e                	sd	s3,24(sp)
 578:	fc040793          	addi	a5,s0,-64
 57c:	00e78933          	add	s2,a5,a4
 580:	fff78993          	addi	s3,a5,-1
 584:	99ba                	add	s3,s3,a4
 586:	377d                	addiw	a4,a4,-1
 588:	1702                	slli	a4,a4,0x20
 58a:	9301                	srli	a4,a4,0x20
 58c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 590:	fff94583          	lbu	a1,-1(s2)
 594:	8526                	mv	a0,s1
 596:	f5bff0ef          	jal	4f0 <putc>
  while(--i >= 0)
 59a:	197d                	addi	s2,s2,-1
 59c:	ff391ae3          	bne	s2,s3,590 <printint+0x82>
 5a0:	7902                	ld	s2,32(sp)
 5a2:	69e2                	ld	s3,24(sp)
}
 5a4:	70e2                	ld	ra,56(sp)
 5a6:	7442                	ld	s0,48(sp)
 5a8:	74a2                	ld	s1,40(sp)
 5aa:	6121                	addi	sp,sp,64
 5ac:	8082                	ret
    x = -xx;
 5ae:	40b005bb          	negw	a1,a1
    neg = 1;
 5b2:	4885                	li	a7,1
    x = -xx;
 5b4:	bf85                	j	524 <printint+0x16>

00000000000005b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5b6:	711d                	addi	sp,sp,-96
 5b8:	ec86                	sd	ra,88(sp)
 5ba:	e8a2                	sd	s0,80(sp)
 5bc:	e0ca                	sd	s2,64(sp)
 5be:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5c0:	0005c903          	lbu	s2,0(a1)
 5c4:	26090863          	beqz	s2,834 <vprintf+0x27e>
 5c8:	e4a6                	sd	s1,72(sp)
 5ca:	fc4e                	sd	s3,56(sp)
 5cc:	f852                	sd	s4,48(sp)
 5ce:	f456                	sd	s5,40(sp)
 5d0:	f05a                	sd	s6,32(sp)
 5d2:	ec5e                	sd	s7,24(sp)
 5d4:	e862                	sd	s8,16(sp)
 5d6:	e466                	sd	s9,8(sp)
 5d8:	8b2a                	mv	s6,a0
 5da:	8a2e                	mv	s4,a1
 5dc:	8bb2                	mv	s7,a2
  state = 0;
 5de:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5e0:	4481                	li	s1,0
 5e2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5e4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5e8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5ec:	06c00c93          	li	s9,108
 5f0:	a005                	j	610 <vprintf+0x5a>
        putc(fd, c0);
 5f2:	85ca                	mv	a1,s2
 5f4:	855a                	mv	a0,s6
 5f6:	efbff0ef          	jal	4f0 <putc>
 5fa:	a019                	j	600 <vprintf+0x4a>
    } else if(state == '%'){
 5fc:	03598263          	beq	s3,s5,620 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 600:	2485                	addiw	s1,s1,1
 602:	8726                	mv	a4,s1
 604:	009a07b3          	add	a5,s4,s1
 608:	0007c903          	lbu	s2,0(a5)
 60c:	20090c63          	beqz	s2,824 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 610:	0009079b          	sext.w	a5,s2
    if(state == 0){
 614:	fe0994e3          	bnez	s3,5fc <vprintf+0x46>
      if(c0 == '%'){
 618:	fd579de3          	bne	a5,s5,5f2 <vprintf+0x3c>
        state = '%';
 61c:	89be                	mv	s3,a5
 61e:	b7cd                	j	600 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 620:	00ea06b3          	add	a3,s4,a4
 624:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 628:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 62a:	c681                	beqz	a3,632 <vprintf+0x7c>
 62c:	9752                	add	a4,a4,s4
 62e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 632:	03878f63          	beq	a5,s8,670 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 636:	05978963          	beq	a5,s9,688 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 63a:	07500713          	li	a4,117
 63e:	0ee78363          	beq	a5,a4,724 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 642:	07800713          	li	a4,120
 646:	12e78563          	beq	a5,a4,770 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 64a:	07000713          	li	a4,112
 64e:	14e78a63          	beq	a5,a4,7a2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 652:	07300713          	li	a4,115
 656:	18e78a63          	beq	a5,a4,7ea <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 65a:	02500713          	li	a4,37
 65e:	04e79563          	bne	a5,a4,6a8 <vprintf+0xf2>
        putc(fd, '%');
 662:	02500593          	li	a1,37
 666:	855a                	mv	a0,s6
 668:	e89ff0ef          	jal	4f0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 66c:	4981                	li	s3,0
 66e:	bf49                	j	600 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 670:	008b8913          	addi	s2,s7,8
 674:	4685                	li	a3,1
 676:	4629                	li	a2,10
 678:	000ba583          	lw	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	e91ff0ef          	jal	50e <printint>
 682:	8bca                	mv	s7,s2
      state = 0;
 684:	4981                	li	s3,0
 686:	bfad                	j	600 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 688:	06400793          	li	a5,100
 68c:	02f68963          	beq	a3,a5,6be <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 690:	06c00793          	li	a5,108
 694:	04f68263          	beq	a3,a5,6d8 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 698:	07500793          	li	a5,117
 69c:	0af68063          	beq	a3,a5,73c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6a0:	07800793          	li	a5,120
 6a4:	0ef68263          	beq	a3,a5,788 <vprintf+0x1d2>
        putc(fd, '%');
 6a8:	02500593          	li	a1,37
 6ac:	855a                	mv	a0,s6
 6ae:	e43ff0ef          	jal	4f0 <putc>
        putc(fd, c0);
 6b2:	85ca                	mv	a1,s2
 6b4:	855a                	mv	a0,s6
 6b6:	e3bff0ef          	jal	4f0 <putc>
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	b791                	j	600 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6be:	008b8913          	addi	s2,s7,8
 6c2:	4685                	li	a3,1
 6c4:	4629                	li	a2,10
 6c6:	000ba583          	lw	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	e43ff0ef          	jal	50e <printint>
        i += 1;
 6d0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d2:	8bca                	mv	s7,s2
      state = 0;
 6d4:	4981                	li	s3,0
        i += 1;
 6d6:	b72d                	j	600 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6d8:	06400793          	li	a5,100
 6dc:	02f60763          	beq	a2,a5,70a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6e0:	07500793          	li	a5,117
 6e4:	06f60963          	beq	a2,a5,756 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6e8:	07800793          	li	a5,120
 6ec:	faf61ee3          	bne	a2,a5,6a8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f0:	008b8913          	addi	s2,s7,8
 6f4:	4681                	li	a3,0
 6f6:	4641                	li	a2,16
 6f8:	000ba583          	lw	a1,0(s7)
 6fc:	855a                	mv	a0,s6
 6fe:	e11ff0ef          	jal	50e <printint>
        i += 2;
 702:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 704:	8bca                	mv	s7,s2
      state = 0;
 706:	4981                	li	s3,0
        i += 2;
 708:	bde5                	j	600 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 70a:	008b8913          	addi	s2,s7,8
 70e:	4685                	li	a3,1
 710:	4629                	li	a2,10
 712:	000ba583          	lw	a1,0(s7)
 716:	855a                	mv	a0,s6
 718:	df7ff0ef          	jal	50e <printint>
        i += 2;
 71c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 71e:	8bca                	mv	s7,s2
      state = 0;
 720:	4981                	li	s3,0
        i += 2;
 722:	bdf9                	j	600 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 724:	008b8913          	addi	s2,s7,8
 728:	4681                	li	a3,0
 72a:	4629                	li	a2,10
 72c:	000ba583          	lw	a1,0(s7)
 730:	855a                	mv	a0,s6
 732:	dddff0ef          	jal	50e <printint>
 736:	8bca                	mv	s7,s2
      state = 0;
 738:	4981                	li	s3,0
 73a:	b5d9                	j	600 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 73c:	008b8913          	addi	s2,s7,8
 740:	4681                	li	a3,0
 742:	4629                	li	a2,10
 744:	000ba583          	lw	a1,0(s7)
 748:	855a                	mv	a0,s6
 74a:	dc5ff0ef          	jal	50e <printint>
        i += 1;
 74e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 750:	8bca                	mv	s7,s2
      state = 0;
 752:	4981                	li	s3,0
        i += 1;
 754:	b575                	j	600 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 756:	008b8913          	addi	s2,s7,8
 75a:	4681                	li	a3,0
 75c:	4629                	li	a2,10
 75e:	000ba583          	lw	a1,0(s7)
 762:	855a                	mv	a0,s6
 764:	dabff0ef          	jal	50e <printint>
        i += 2;
 768:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 76a:	8bca                	mv	s7,s2
      state = 0;
 76c:	4981                	li	s3,0
        i += 2;
 76e:	bd49                	j	600 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 770:	008b8913          	addi	s2,s7,8
 774:	4681                	li	a3,0
 776:	4641                	li	a2,16
 778:	000ba583          	lw	a1,0(s7)
 77c:	855a                	mv	a0,s6
 77e:	d91ff0ef          	jal	50e <printint>
 782:	8bca                	mv	s7,s2
      state = 0;
 784:	4981                	li	s3,0
 786:	bdad                	j	600 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 788:	008b8913          	addi	s2,s7,8
 78c:	4681                	li	a3,0
 78e:	4641                	li	a2,16
 790:	000ba583          	lw	a1,0(s7)
 794:	855a                	mv	a0,s6
 796:	d79ff0ef          	jal	50e <printint>
        i += 1;
 79a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 79c:	8bca                	mv	s7,s2
      state = 0;
 79e:	4981                	li	s3,0
        i += 1;
 7a0:	b585                	j	600 <vprintf+0x4a>
 7a2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7a4:	008b8d13          	addi	s10,s7,8
 7a8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7ac:	03000593          	li	a1,48
 7b0:	855a                	mv	a0,s6
 7b2:	d3fff0ef          	jal	4f0 <putc>
  putc(fd, 'x');
 7b6:	07800593          	li	a1,120
 7ba:	855a                	mv	a0,s6
 7bc:	d35ff0ef          	jal	4f0 <putc>
 7c0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7c2:	00000b97          	auipc	s7,0x0
 7c6:	2f6b8b93          	addi	s7,s7,758 # ab8 <digits>
 7ca:	03c9d793          	srli	a5,s3,0x3c
 7ce:	97de                	add	a5,a5,s7
 7d0:	0007c583          	lbu	a1,0(a5)
 7d4:	855a                	mv	a0,s6
 7d6:	d1bff0ef          	jal	4f0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7da:	0992                	slli	s3,s3,0x4
 7dc:	397d                	addiw	s2,s2,-1
 7de:	fe0916e3          	bnez	s2,7ca <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7e2:	8bea                	mv	s7,s10
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	6d02                	ld	s10,0(sp)
 7e8:	bd21                	j	600 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7ea:	008b8993          	addi	s3,s7,8
 7ee:	000bb903          	ld	s2,0(s7)
 7f2:	00090f63          	beqz	s2,810 <vprintf+0x25a>
        for(; *s; s++)
 7f6:	00094583          	lbu	a1,0(s2)
 7fa:	c195                	beqz	a1,81e <vprintf+0x268>
          putc(fd, *s);
 7fc:	855a                	mv	a0,s6
 7fe:	cf3ff0ef          	jal	4f0 <putc>
        for(; *s; s++)
 802:	0905                	addi	s2,s2,1
 804:	00094583          	lbu	a1,0(s2)
 808:	f9f5                	bnez	a1,7fc <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 80a:	8bce                	mv	s7,s3
      state = 0;
 80c:	4981                	li	s3,0
 80e:	bbcd                	j	600 <vprintf+0x4a>
          s = "(null)";
 810:	00000917          	auipc	s2,0x0
 814:	2a090913          	addi	s2,s2,672 # ab0 <malloc+0x194>
        for(; *s; s++)
 818:	02800593          	li	a1,40
 81c:	b7c5                	j	7fc <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 81e:	8bce                	mv	s7,s3
      state = 0;
 820:	4981                	li	s3,0
 822:	bbf9                	j	600 <vprintf+0x4a>
 824:	64a6                	ld	s1,72(sp)
 826:	79e2                	ld	s3,56(sp)
 828:	7a42                	ld	s4,48(sp)
 82a:	7aa2                	ld	s5,40(sp)
 82c:	7b02                	ld	s6,32(sp)
 82e:	6be2                	ld	s7,24(sp)
 830:	6c42                	ld	s8,16(sp)
 832:	6ca2                	ld	s9,8(sp)
    }
  }
}
 834:	60e6                	ld	ra,88(sp)
 836:	6446                	ld	s0,80(sp)
 838:	6906                	ld	s2,64(sp)
 83a:	6125                	addi	sp,sp,96
 83c:	8082                	ret

000000000000083e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 83e:	715d                	addi	sp,sp,-80
 840:	ec06                	sd	ra,24(sp)
 842:	e822                	sd	s0,16(sp)
 844:	1000                	addi	s0,sp,32
 846:	e010                	sd	a2,0(s0)
 848:	e414                	sd	a3,8(s0)
 84a:	e818                	sd	a4,16(s0)
 84c:	ec1c                	sd	a5,24(s0)
 84e:	03043023          	sd	a6,32(s0)
 852:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 856:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 85a:	8622                	mv	a2,s0
 85c:	d5bff0ef          	jal	5b6 <vprintf>
}
 860:	60e2                	ld	ra,24(sp)
 862:	6442                	ld	s0,16(sp)
 864:	6161                	addi	sp,sp,80
 866:	8082                	ret

0000000000000868 <printf>:

void
printf(const char *fmt, ...)
{
 868:	711d                	addi	sp,sp,-96
 86a:	ec06                	sd	ra,24(sp)
 86c:	e822                	sd	s0,16(sp)
 86e:	1000                	addi	s0,sp,32
 870:	e40c                	sd	a1,8(s0)
 872:	e810                	sd	a2,16(s0)
 874:	ec14                	sd	a3,24(s0)
 876:	f018                	sd	a4,32(s0)
 878:	f41c                	sd	a5,40(s0)
 87a:	03043823          	sd	a6,48(s0)
 87e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 882:	00840613          	addi	a2,s0,8
 886:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 88a:	85aa                	mv	a1,a0
 88c:	4505                	li	a0,1
 88e:	d29ff0ef          	jal	5b6 <vprintf>
}
 892:	60e2                	ld	ra,24(sp)
 894:	6442                	ld	s0,16(sp)
 896:	6125                	addi	sp,sp,96
 898:	8082                	ret

000000000000089a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 89a:	1141                	addi	sp,sp,-16
 89c:	e422                	sd	s0,8(sp)
 89e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8a0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a4:	00000797          	auipc	a5,0x0
 8a8:	75c7b783          	ld	a5,1884(a5) # 1000 <freep>
 8ac:	a02d                	j	8d6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8ae:	4618                	lw	a4,8(a2)
 8b0:	9f2d                	addw	a4,a4,a1
 8b2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b6:	6398                	ld	a4,0(a5)
 8b8:	6310                	ld	a2,0(a4)
 8ba:	a83d                	j	8f8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8bc:	ff852703          	lw	a4,-8(a0)
 8c0:	9f31                	addw	a4,a4,a2
 8c2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8c4:	ff053683          	ld	a3,-16(a0)
 8c8:	a091                	j	90c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ca:	6398                	ld	a4,0(a5)
 8cc:	00e7e463          	bltu	a5,a4,8d4 <free+0x3a>
 8d0:	00e6ea63          	bltu	a3,a4,8e4 <free+0x4a>
{
 8d4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d6:	fed7fae3          	bgeu	a5,a3,8ca <free+0x30>
 8da:	6398                	ld	a4,0(a5)
 8dc:	00e6e463          	bltu	a3,a4,8e4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e0:	fee7eae3          	bltu	a5,a4,8d4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8e4:	ff852583          	lw	a1,-8(a0)
 8e8:	6390                	ld	a2,0(a5)
 8ea:	02059813          	slli	a6,a1,0x20
 8ee:	01c85713          	srli	a4,a6,0x1c
 8f2:	9736                	add	a4,a4,a3
 8f4:	fae60de3          	beq	a2,a4,8ae <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8f8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8fc:	4790                	lw	a2,8(a5)
 8fe:	02061593          	slli	a1,a2,0x20
 902:	01c5d713          	srli	a4,a1,0x1c
 906:	973e                	add	a4,a4,a5
 908:	fae68ae3          	beq	a3,a4,8bc <free+0x22>
    p->s.ptr = bp->s.ptr;
 90c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 90e:	00000717          	auipc	a4,0x0
 912:	6ef73923          	sd	a5,1778(a4) # 1000 <freep>
}
 916:	6422                	ld	s0,8(sp)
 918:	0141                	addi	sp,sp,16
 91a:	8082                	ret

000000000000091c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 91c:	7139                	addi	sp,sp,-64
 91e:	fc06                	sd	ra,56(sp)
 920:	f822                	sd	s0,48(sp)
 922:	f426                	sd	s1,40(sp)
 924:	ec4e                	sd	s3,24(sp)
 926:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 928:	02051493          	slli	s1,a0,0x20
 92c:	9081                	srli	s1,s1,0x20
 92e:	04bd                	addi	s1,s1,15
 930:	8091                	srli	s1,s1,0x4
 932:	0014899b          	addiw	s3,s1,1
 936:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 938:	00000517          	auipc	a0,0x0
 93c:	6c853503          	ld	a0,1736(a0) # 1000 <freep>
 940:	c915                	beqz	a0,974 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 942:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 944:	4798                	lw	a4,8(a5)
 946:	08977a63          	bgeu	a4,s1,9da <malloc+0xbe>
 94a:	f04a                	sd	s2,32(sp)
 94c:	e852                	sd	s4,16(sp)
 94e:	e456                	sd	s5,8(sp)
 950:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 952:	8a4e                	mv	s4,s3
 954:	0009871b          	sext.w	a4,s3
 958:	6685                	lui	a3,0x1
 95a:	00d77363          	bgeu	a4,a3,960 <malloc+0x44>
 95e:	6a05                	lui	s4,0x1
 960:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 964:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 968:	00000917          	auipc	s2,0x0
 96c:	69890913          	addi	s2,s2,1688 # 1000 <freep>
  if(p == (char*)-1)
 970:	5afd                	li	s5,-1
 972:	a081                	j	9b2 <malloc+0x96>
 974:	f04a                	sd	s2,32(sp)
 976:	e852                	sd	s4,16(sp)
 978:	e456                	sd	s5,8(sp)
 97a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 97c:	00000797          	auipc	a5,0x0
 980:	69478793          	addi	a5,a5,1684 # 1010 <base>
 984:	00000717          	auipc	a4,0x0
 988:	66f73e23          	sd	a5,1660(a4) # 1000 <freep>
 98c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 98e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 992:	b7c1                	j	952 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 994:	6398                	ld	a4,0(a5)
 996:	e118                	sd	a4,0(a0)
 998:	a8a9                	j	9f2 <malloc+0xd6>
  hp->s.size = nu;
 99a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 99e:	0541                	addi	a0,a0,16
 9a0:	efbff0ef          	jal	89a <free>
  return freep;
 9a4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9a8:	c12d                	beqz	a0,a0a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ac:	4798                	lw	a4,8(a5)
 9ae:	02977263          	bgeu	a4,s1,9d2 <malloc+0xb6>
    if(p == freep)
 9b2:	00093703          	ld	a4,0(s2)
 9b6:	853e                	mv	a0,a5
 9b8:	fef719e3          	bne	a4,a5,9aa <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9bc:	8552                	mv	a0,s4
 9be:	b1bff0ef          	jal	4d8 <sbrk>
  if(p == (char*)-1)
 9c2:	fd551ce3          	bne	a0,s5,99a <malloc+0x7e>
        return 0;
 9c6:	4501                	li	a0,0
 9c8:	7902                	ld	s2,32(sp)
 9ca:	6a42                	ld	s4,16(sp)
 9cc:	6aa2                	ld	s5,8(sp)
 9ce:	6b02                	ld	s6,0(sp)
 9d0:	a03d                	j	9fe <malloc+0xe2>
 9d2:	7902                	ld	s2,32(sp)
 9d4:	6a42                	ld	s4,16(sp)
 9d6:	6aa2                	ld	s5,8(sp)
 9d8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9da:	fae48de3          	beq	s1,a4,994 <malloc+0x78>
        p->s.size -= nunits;
 9de:	4137073b          	subw	a4,a4,s3
 9e2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9e4:	02071693          	slli	a3,a4,0x20
 9e8:	01c6d713          	srli	a4,a3,0x1c
 9ec:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ee:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9f2:	00000717          	auipc	a4,0x0
 9f6:	60a73723          	sd	a0,1550(a4) # 1000 <freep>
      return (void*)(p + 1);
 9fa:	01078513          	addi	a0,a5,16
  }
}
 9fe:	70e2                	ld	ra,56(sp)
 a00:	7442                	ld	s0,48(sp)
 a02:	74a2                	ld	s1,40(sp)
 a04:	69e2                	ld	s3,24(sp)
 a06:	6121                	addi	sp,sp,64
 a08:	8082                	ret
 a0a:	7902                	ld	s2,32(sp)
 a0c:	6a42                	ld	s4,16(sp)
 a0e:	6aa2                	ld	s5,8(sp)
 a10:	6b02                	ld	s6,0(sp)
 a12:	b7f5                	j	9fe <malloc+0xe2>
