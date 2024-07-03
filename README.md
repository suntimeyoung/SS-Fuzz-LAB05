# 软件安全 LAB-05 并发测试

> 利用 pthread 多线程库，编写3个简易代码，包含数据竞争和原子性违反等并发缺陷，且这些缺陷的触发具有不确定性（不会每次执行都触发）  

编写了三个包含并发漏洞的简易代码，漏洞内容分别为数据竞争，原子性违反以及多写者（数据竞争），分别包含于三个文件，使用 `run_test.sh` 将每个文件分别运行 **20** 次，结果如下：

- `data_race_example.cpp`: 

  - 代码对全局变量`counter`自增然后自减相同次数，理应结果为 0，但是实际结果如下：![image-20240613185252760](./assets/image-20240613185252760.png)

  - 漏洞原因：counter没有充分被锁保护

    ![image-20240613184631123](./assets/image-20240613184631123.png)

- `atomicity_violation_example.cpp`:

  - 代码通过中间变量对全局变量`value` 进行操作，输出结果理应为0，但是实际测试如下：![image-20240613185343743](./assets/image-20240613185343743.png)
  - 漏洞原因：没有考虑操作的原子性![image-20240613185608240](./assets/image-20240613185608240.png)

- `shared_array_example.cpp`:

  - 代码对全局数组`shared_array`进行赋值，理应数组的内容全部为相同值，但是实际结果如下：![image-20240613185822575](./assets/image-20240613185822575.png)
  - 漏洞原因：多个进程写，但是没有写保护措施![image-20240613185909780](./assets/image-20240613185909780.png)

> 设计和实现动态测试方法，分析线程执行和同步原语情况，完成对 个简易代码中的并发缺陷检测 

本方案使用锁集分析，原理为：

- 对每个变量v，初始化锁集LS(v)为被测程序中所有的锁，初始化锁集HLS(v)为空
- 分析每个线程的执行日志：
  1. 对于加锁操作lock(l)，令HLS(v) = HLS(v)∪ {l}
  2. 对于解锁操作unlock(l)，令HLS(v) = HLS(v) – {l}
  3. 对于变量v的访问操作，令LS(v) = LS(v) ∩ HLS(v)，如果LS(v)为空，则报出数据竞争  

`src`目录中各文件的意义如下：

![image-20240613190405734](./assets/image-20240613190405734.png)

`lock_set.cpp`对局部变量进行过滤，剩余变量以及锁操作通过调用外部函数(`func.cpp`)并储存在`log/log.txt`文件中，以供后续`check_lock.cpp`分析。

![image-20240613190719757](./assets/image-20240613190719757.png)

## 测试结果

运行`run.sh`，结果如下：

![image-20240613191046292](./assets/image-20240613191046292.png)

![image-20240613191122067](./assets/image-20240613191122067.png)![image-20240613191219122](./assets/image-20240613191219122.png)![image-20240613191253807](./assets/image-20240613191253807.png)

可以看出实现的锁集分析的确找出了问题，但是也存在一部分的误报情况。
