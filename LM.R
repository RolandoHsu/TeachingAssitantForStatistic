library(tidyverse)
library(dplyr)
library(readxl)

##### 設定相對位置 ##### 
# File -> 右邊三個點 -> 找到你的資料夾 -> More -> Set As Working Directory 
# (可以把 Console 的程式碼複製下來，方便下次使用)

setwd("C:/Users/USER/Desktop/NCU_FIN/碩二下/統計助教/Stat")

# 輸入的位置就可以從 "C:/Users/USER/Desktop/IPOFirms.xlsx" 改成 "IPOFirms.xlsx"

# 可以藉由 getwd() 查找目前設定的相對位置
getwd()

##### 作業 #####
IPOFirms_xlsx <- read_xlsx("IPOFirms.xlsx")

MyFunction <- function(DataName, EleOrNot){
  
  FilterEle <- filter(DataName, ElectricOrNot == EleOrNot)
  
  AgeVariable <- pull(FilterEle, "FirmAgeBeforeIPO")
  
  MeanAge <- mean(AgeVariable)
  
  return(MeanAge)
  
}
MyFunction(IPOFirms_xlsx, 1)

MyFunction(IPOFirms_xlsx, 0)

## 改成以 PipeLine 實作 ##

MyFunction_Pipe <- function(DataName, EleOrNot){
  
  MeanAge <- DataName %>% 
    filter(ElectricOrNot == EleOrNot) %>% 
    pull("FirmAgeBeforeIPO") %>% 
    mean()
  
  return(MeanAge)
  
}

MyFunction(IPOFirms_xlsx, 1)

MyFunction(IPOFirms_xlsx, 0)

##### 迴歸分析 ##### 
MyData <- mtcars

class(MyData)
str(MyData)

#install.packages("corrplot")
library("corrplot")

# 相關係數矩陣 ------------------------------------------------------------------

cor(MyData)
cor(MyData)[1, ] #其他變數與依變數mpg間的相關係數
cor(MyData[, -1]) #找出兩兩的變數關係

corrplot(cor(MyData[, -1]), 
         method = "number", # 透過 method 來改變顯示圖示
         type = "lower", # 透過 type 調整相關係數圖的輸出
         tl.col = "black") # 透過 tl.col 改變變數名字的顏色

#調整欄位值
MyData_Adj <- MyData %>% 
  mutate(am = ifelse(am == 0, "automatic", "manual"))

# lm和glm使用虛擬變數，當有類別變數如am時，會自動轉換虛擬變數 ------------------------------------------------
# 也可以使用 as.factor 調整成類別變數
str(MyData)
MyData_Adj2 <- MyData %>% 
  mutate(am = as.factor(am))
str(MyData_Adj2)

## 建立迴歸模型
Model1 <- lm(mpg ~ wt + cyl + drat + am, 
            data = MyData_Adj)
Model2 <- lm(mpg ~ wt + cyl + drat + am, 
             data = MyData_Adj2)
summary(Model1)
summary(Model2)

# install.packages("car")
library(car)
vif(Model1) #如果超過5的話代表自變數間存在共線性

# 視覺化觀察殘差
par(mfrow=c(2,2)) #畫2X2的圖
plot(Model1) # 檢定假設視覺化
## 圖片代表的意義 : 
# 右上: 殘差是否符合常態
# 左下: 殘差是否具同質變異數，如果較為水平則可能為同質變異數
# 右下: 檢驗是否有離群值

Model1$residual # 殘差資料

# 常態性假設檢測
shapiro.test(Model1$residual)# 因為p-value > 0.05，代表不會拒絕H0,符合常態假設

# 獨立性假設 (補充 : p-value > 0.05 代表 do not reject H0 表殘差沒有自我相關(殘差間相互獨立))
# 因為這個函式會自動去抓模型中的殘差，故這裡放的是模型，而不是殘差的值
car::durbinWatsonTest(Model1) 

# 變異數同質性假設 (補充: H0 : 殘差變異數同質 ; H1 : 殘差變異數異質)
# 因為這個函式會自動去抓模型中的殘差，故這裡放的是模型，而不是殘差的值
car::ncvTest(Model1)

# predict 預測
new.car <- data.frame(cyl = 6,
                      drat = 4.0,
                      wt = 3,
                      am="automatic") # wt+cyl+drat+am
result <- predict(Model1, newdata = new.car) 
result # 20.90833

##### lm 使用小技巧 ##### 

## 可以利用 . 代表除了 y 以外的所有變數 
SelectVars <- MyData_Adj %>% 
  select(mpg, wt, cyl, drat, am)

Model3 <- lm(mpg ~ ., data = SelectVars)

summary(Model3)

##### 輸出表格 #####
library(stargazer)
Model1Summary <- summary(Model1)

## 叫出敘述統計表的係數與t、p等資訊
Model1Summary$coefficients

## 輸出統計表格
stargazer(Model1Summary$coefficients,
          type = 'text',
          align = T, # 對齊
          column.sep.width = "15pt",
          out = "RegressionSummary.html", # 輸出檔案
          title = "Regression Result", # Title 
          style = "qje") # 輸出的形式

write.csv(lmtest::coeftest(Model1), file = "ModelCoef.csv")

##### t.test ##### 
t.test(Model1$residuals, mu = 0)





