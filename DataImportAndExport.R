##### 導入(出)資料 #####
##### 小小提醒 #####
# 1. 通常會遇到的資料格式不外乎xlsx, csv, txt, RData...等，一定要先確定好自己要導入的資料型態為何，再選擇適合的工具導入。
# 2. 個人認為csv很容易遇到編碼問題，但不用過於擔心，通常是因為mac、windows間的資料轉換，才會因為編碼問題而產生亂碼，此時在導入資料時設定一下encoding即可
# 3. 資料筆數很少時，什麼都是好工具，但資料筆數一多，就要開始找尋更快速的工具。

##### 以拖拉點選方式完成 #####

# 先判讀資料是xlsx, csv or txt -> 右上方 "Import Dataset" -> 依照原本的資料格式選擇工具進行導入
# -> 資料導入設定（是否要讓第一列為欄位名稱、NA值的表示方式、依照何種符號做分隔...等）

##### 以 Code 呈現資料導入 #####
library(readxl)
library(readr)

IPOFirms_excel <- read_excel("/Users/xubodun/Desktop/IPOFirms.xlsx")
IPOFirms_xlsx <- read_xlsx("/Users/xubodun/Desktop/IPOFirms.xlsx")
IPOFirms_csv <- read_csv("/Users/xubodun/Desktop/IPOFirms.csv")

##### 以 Code 呈現資料輸出 : Excel 檔 (https://reurl.cc/Mvv6ek) #####
devtools::install_github("ropensci/writexl")
library(writexl)
iris <- iris
write_xlsx(iris, "/Users/xubodun/Desktop/iris.xlsx")

##### 以 Code 呈現資料輸出 : csv 檔 #####
write.csv(data, "/Users/xubodun/Desktop/IPOFirms.csv")

##### .RData #####
# RData 為 R 裡面一種特殊的資料儲存型態，只可透過R來開啟，優點為導入速度相較excel, csv...等資料來得更快。
# 儲存的資料會以 "檔案名稱.RData" 表示。

# RData 資料儲存 -> save(Data, file = "資料路徑/資料名稱.RData")
save(data_excel, file = "/Users/xubodun/Desktop/IPOFirms.RData")

# RData 資料導入 -> load("資料路徑/資料名稱.RData")
load("/Users/xubodun/Desktop/IPOFirms.RData")

##### 其他資料導入方式比較 #####
# https://steve-chen.tw/?p=555


