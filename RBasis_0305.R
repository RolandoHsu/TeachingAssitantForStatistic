##### 小小技巧 #####

# 利用 "?" or "F1" 查找函數或內建資料的相關資訊 
?iris
?mean

# 利用 "rm" 刪除存在Global Environment (GE) 不要的雜物
test <- 1
test2 <- 2
rm(test2)

##### 利用iris 來了解資料結構吧 ######

# 建立新資料
iris_Practice <- iris

# 利用 "head"(前X筆) "tail"(最後X筆) 查看資料
head(iris_Practice) 
tail(iris_Practice, 6)

# 檢查資料型態
class(iris_Practice)
str(iris_Practice)

# 查看data中個別資訊
nrow(iris_Practice) # 列數
ncol(iris_Practice) # 欄數
dim(iris_Practice) # 列欄數

# 利用 names 叫出所有欄位名稱
ColNamesInIris <- names(iris_Practice)

### 利用 [列, 欄] 查找data內資訊
# 叫出第一列資訊
iris_Row1 <- iris_Practice[1, ]

# 叫出第五個欄位
iris_Col5 <- iris_Practice[, 5]

# 叫出某特定格
iris_Value1 <- iris_Practice[1, 1]
iris_Value2 <- iris_Practice[1, 5]

# 叫出第一欄到第四欄
iris_Col1To4 <- iris_Practice[, 1:4]

# 叫出第一欄與第三欄
iris_Col1And3 <- iris_Practice[, c(1, 3)]

# 利用 " $ " 查找並擷取出想要的欄位，
# 另外，data$Column 即可被列為一個vector，可將其投入其他函式中，且不會額外生成變數在GE中。
iris_Sepal.Length <- iris_Practice$Sepal.Length

mean(iris_Sepal.Length)

mean(iris_Practice$Petal.Length)

class(iris_Practice$Sepal.Length)

# 利用 "pull" 拉出我想要的欄位
# install.packages("dplyr")
library(dplyr)

pull(iris_Practice, "Species")

##### 一些我覺得很棒，用來觀察資料的工具 #####

# 利用 "unique" 查找某欄位中有多少個種類
unique(iris_Practice$Species)

# 利用 "length()" 計算個數，可與 "unique"做搭配
length(unique(iris$Species))

# 利用 "table()" 計算某欄位內涵種類的個數
table(iris_Practice$Species)

##### 稍微複習一下function 吧 #####
CheckColumnClass <- function(Data, Variable){
  
  ColumnIWant <- pull(Data, Variable)
  
  ColumnMean <- mean(ColumnIWant)
  
  CreateSentence <- paste0(Variable, "'s mean is ", ColumnMean)
  
  return(CreateSentence)
}

CheckColumnClass(iris, "Species")
