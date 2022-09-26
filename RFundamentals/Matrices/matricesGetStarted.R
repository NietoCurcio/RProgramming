Salary

A[3,4]
A[1,]
A[,1]

Salary[2,]
Salary[,2]
Salary[2,2]

matrix(data=1:12, nrow=3, ncol=4) # not used often
rbind(0:3, 3:6, 6:9)
cbind(0:3, 3:6, 6:9)

c1 <- 1:5
c2 <- -1:-5
D <- cbind(c1, c2)
D

v <- rep(27,5)
v[4] <- 0
A <- rbind(rep(27,5), rep(27,5), v)
A[3,4]
rownames(A) <- c("r1", "r2", "r3")
A
colnames(A) <- c("c1", "c2", "c3", "c4", "c5")
A
A[3,4]
A["r3","c4"]
A["r3",4]

v <- c(27,27,27,0,27)
names(v)
names(v) <- c("c1", "c2", "c3", "c4", "c5")
v["c2"] == v[2]
names(v) <- NULL
