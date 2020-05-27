##### Package/Data ----
library(tidyverse) # pipe %>% 
library(corrplot)
library(car)
library(lmtest)
# install.packages("ggplot2")
library(ggplot2)

setwd("C:/Users/USER/Desktop")

insurance <- read.csv("insurance.csv")

head(insurance, 10)
str(insurance) 
summary(insurance)  
table(insurance$children)

for (i in 1:ncol(insurance)) {
  na_num <- insurance[, i] %>% 
    is.na() %>% 
    sum()
  print(na_num)
}

##### Data Viz ----
qplot(x = age,
      y = charges,
      data = insurance,
      color = smoker)   
qplot(x = age,
      y = charges,
      data = insurance,
      color = sex)  
qplot(x = bmi,
      y = charges,
      data = insurance,
      color = smoker) 


##### Data Pre-processing ----
unique(insurance$sex) 
unique(insurance$smoker)
unique(insurance$region)

insurance$sex <- ifelse(insurance$sex == "male", 1, 0)
insurance$smoker <- ifelse(insurance$smoker == "yes", 1, 0)

insurance$region <- case_when(
  insurance$region == "southwest" ~ 1,
  insurance$region == "southeast" ~ 2,
  insurance$region == "northwest" ~ 3,
  insurance$region == "northeast" ~ 4
)

str(insurance)

cor(insurance[, -7]) 
par(mfrow = c(1,1)) # 設定成 1*1
corrplot(cor(insurance[, -7]), method = c("number"))

##### Model ----
### train/test data ----

# train data 訓練模型
# test data 檢驗模型預測效果

set.seed(123)

insurance <- merTools:::shuffle(insurance) # 隨機排序資料

## 將資料區分為 Train Test Data (train 80% test 20%)
n <- ceiling(nrow(insurance) * 0.2) 
test_index <- sample(1:nrow(insurance), size = n)
test_data <- insurance[test_index, ] 
train_data <- insurance[-test_index,] 
rm(list = c("n", "test_index"))

train_data <- mutate_at(train_data, vars(sex, smoker, region), funs(as.factor(.)))
test_data <- mutate_at(test_data, vars(sex, smoker, region), funs(as.factor(.)))
str(train_data)
str(test_data)

### multiple regression ----
model <- lm(charges ~ ., data = train_data)
summary(model)

test <- summary(model)
test$coefficients

# >5 or >10 代表具有共線性
vif(model) 

# https://data.library.virginia.edu/diagnostic-plots/
par(mfrow = c(2,2))
plot(model) 

# Assumption check ----
residual <- model$residual
head(residual)

shapiro.test(residual) # 常態性
ncvTest(model) # 同質變異數
durbinWatsonTest(model) # 獨立性

# Prediction ----
result <- predict(model, newdata = test_data)
head(result)

### Step-wise ----
# 赤池信息量準則
model_stepwise <- step(model, direction = c("both"))
summary(model_stepwise) 

model_stepwise$anova[, 6]

result_stepwise <- predict(model_stepwise, newdata = test_data)
head(result_stepwise)

test_result <- cbind(test_data, result_stepwise) %>% 
  mutate(diff = round(result_stepwise - charges)) # round 四捨五入

# 使用套件 ggplot2 
ggplot(test_result, aes(x = 1:nrow(test_data), y = diff)) +
  geom_point(shape = 20, colour = "#00aeae", fill = "#00aeae", size = 3, stroke = 1) +
  labs(x = "Index", y = "Diff", title= "Diff Plot") + 
  theme(plot.title = element_text(size = rel(1.5)))

# t.test
t.test(test_result$diff)

##### 以 p - value 踢掉不顯著的變數 #####

Data_WithDummy <- insurance %>% 
  mutate(region_1 = ifelse(region == 1, 1, 0),
         region_2 = ifelse(region == 2, 1, 0),
         region_3 = ifelse(region == 3, 1, 0)) %>% 
  select(-region)

str(Data_WithDummy)

# 想好你的 function 的參數
# 建立迴歸模型
# 找出不顯著的變數 (p value)
# 踢掉p value最大的變數，建出一個新的 data
# 重跑迴歸
Data <- Data_WithDummy
SignificantLevel <- 0.05

SelectVars <- function(Data, SignificantLevel){
  
  repeat{
    
    # Model
    model_PValue <- lm(charges ~ ., data = Data)
    
    # Summary
    Summary <- summary(model_PValue)
    
    # Coefficients
    
    Coe <- Summary$coefficients %>% 
      data.frame() %>%
      .[-1, ] %>% 
      mutate(Variable = row.names(.)) %>% 
      select("Variable", everything())
    
    # 改變欄位名稱
    colnames(Coe)[5] <- c("PValue")
    
    # 找出不顯著的變數，並以 PValue 排序
    VariableWithoutSignificant <- Coe %>% 
      filter(., PValue > SignificantLevel) %>% 
      arrange(-PValue)
    
    # 如果所有變數都顯著，則結束此function
    if(nrow(VariableWithoutSignificant) == 0) break
    
    # 挑選出想要刪除的變數
    VariableToRemove <- VariableWithoutSignificant[1, 1]

    # 從Data中把變數刪掉
    Data <- Data %>% 
      select(-VariableToRemove)
  }
  
  NewModel <- lm(charges ~ ., data = Data)
  
  return(NewModel)
}


FinalModel <- SelectVars(Data_WithDummy, 0.05)

summary(FinalModel)






