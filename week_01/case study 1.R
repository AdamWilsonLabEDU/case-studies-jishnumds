data("iris")
mean(iris$Petal.Length)
petal_length_mean <- mean(iris$Petal.Length) 
hist(iris$Petal.Length,  xlab = 'Petal length', ylab = 'Frequency'  )

install.packages('ggplot2')
library(ggplot2)
                 
ggplot(iris, aes(x = Petal.Length)) + 
  geom_histogram(binwidth = 0.1, fill = '#aba300', color = "black") + 
  labs(title = "Histogram of Petal Length", x = "Petal Length", y = "Frequency")
                
summary(iris$Petal.Length)