## Chapter Four: Compute Architecture and Scheduling

The chapter essentially went over how blocks are scheduled to SMs, what warps are and some basic math to calculate maximum usage for a given GPU. For this chapter, I decided I'd just make some basic kernels and try to track my SM utilization and occupancy to see how close I can get it to 100%. Running this on a GTX 3090 FE if anyone wants to recreate.

**NOTE** I'm tracking SM utilization with `nvidia-smi dmon`, not sure if there's a better way

### Results
It worked out great. Using a simple vector addition kernel kernel I was able to hit 100% SM utilizaiton on my GPU.

`nvidia-smi dmon --select u`
```
# gpu     sm    mem    enc    dec    jpg    ofa 
# Idx      %      %      %      %      %      % 
    0      0      1      0      0      0      0 
    0      3      2      0      0      0      0 
    0      0      1      0      0      0      0 
    0      3      2      0      0      0      0 
    0      4      2      0      0      0      0 
    0    100      0      0      0      0      0 
    0      0      0      0      0      0      0 
    0      0      0      0      0      0      0 
    0      2      1      0      0      0      0 
    0      4      3      0      0      0      0 
```

The jump up to 100% sm usage was the program starting up. The nvidia-smi process would freeze when my kernel was running (probably because I was using up all the GPUs resources) so I think that's why it didn't capture memory usage or anything else. Need to see if there's a way to measure these metric using some other tool. Kinda hard to measure if all the resources are used for the kernel. Would be nice if there was a debug mode that saved some compute for this, need too look into that.
