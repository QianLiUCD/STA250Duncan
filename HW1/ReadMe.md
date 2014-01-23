#Preparation

Save all data files and R workspace are in the same directory. In R, use setwd(dir) to set the working directory to dir.

For me, 

```
setwd ("/Users/Qian/Documents/STA_250Duncan/Data")
```

Extract a "tar.bz2" file to the current active folder

```
system ("tar -zxvf try.tar.bz2", intern = TRUE )
```

To avoid error message about illegal byte, in shell use 
```
LC_ALL=C
```
 Or in R use 
```
Sys.setlocale(locale="C")
```
It forces applications to use the default language for output, and forces sorting to be bytewise.


Syetem information

```
$systemsysname "Darwin" release "12.5.0"  nodename "moobilenet-109-43.ucdavis.edu" machine "x86_64"  login "Qian" user "Qian" effective_user  "Qian" $sessionR version 2.15.2 (2012-10-26)Platform: x86_64-apple-darwin9.8.0/x86_64 (64-bit)locale:[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8attached base packages:[1] stats     graphics  grDevices utils     datasets  methods   base     other attached packages:[1] plyr_1.8            FastCSVSample_0.1-0loaded via a namespace (and not attached):[1] tools_2.15.2
```

```
```
