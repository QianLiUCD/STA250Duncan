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
$system
```

```
```