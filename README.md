# super small toy tpu

I don't know real tpu inside.

But, I read this article

https://medium.com/@antonpaquin/whats-inside-a-tpu-c013eb51973e

So, I made small module like below.

![architecture](./image/simple_architecture.png)

if i can afford, i will improve thi code

## Preparations

icarus verilog

## Run Command

```bash
iverilog -o out.vvp -f file_list.f
vvp out.vvp
gtkwave tpu_top_result.vcd
```


