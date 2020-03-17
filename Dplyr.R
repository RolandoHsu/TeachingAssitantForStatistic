##### dplyr #####
# install.packages("dplyr")
library(dplyr)

## 導入data
IPOFirms_xlsx <- read_xlsx("/Users/xubodun/Desktop/IPOFirms.xlsx")

##### 小提醒 #####
# 1. 此套件主要提供好用的資料處理函式，能幫助我們在面對煩雜的資料時，能迅速釐清並且清理出我們需要的資訊。
# 2. 此套件內的函式，第一個引數通常都是data，後面的引數才是放我們需要設定的條件。
# 3. 通常此套件輸出的結果都會是另一個資料集 (data.frame)

### 主要的幾種函式
##### select：篩選需要的欄位 #####

IPO_Select <- select(IPOFirms_xlsx, c("公司簡稱", "會計師事務所", "TSE新產業名",  
                                      "FirmAgeBeforeIPO", "上市櫃日期", "下市日期", 
                                      "Market", "ElectricOrNot", "IPOFail"))
IPO_Select2 <- select(IPOFirms_xlsx, 1:3, 5, 7, 11, 13, 15, 16)

# 可以透過 select 對column位置進行調整，且利用 everything() 選擇沒有被選中的其他欄位。
IPO_SelectAndArrangeColumn <- select(IPO_Select, 
                                     "公司簡稱", "TSE新產業名", "會計師事務所", "IPOFail", everything())


##### filter：利用條件設定篩選需要的列 #####

# 利用 『 > 』、『 >= 』、『 < 』...等做條件篩選
# 條件表達式：『 | 』表示為『 或 』、『 & 』表示為『 且 』
IPO_Filter <- filter(IPO_Select, TSE新產業名 == "M2700 觀光事業" & IPOFail == 1)
IPO_Filter2 <- filter(IPO_Select, TSE新產業名 == "M2700 觀光事業" | IPOFail == 1)
# 以 %in% 多個項目的篩選 
IndustryIWant <- c("M1400 紡織纖維", "M2326 光電業", "M2324 半導體")
IPO_Filter3 <- filter(IPO_Select, TSE新產業名 %in% IndustryIWant)
unique(IPO_Filter3$TSE新產業名)
# 用『 ! 』來執行 排除 功能
IPO_Filter4 <- filter(IPO_Select, !(TSE新產業名 %in% IndustryIWant))
unique(IPO_Filter4$TSE新產業名)
# 用『 is.na() 』挑選出 NA 值
IPO_Filter5 <- filter(IPO_Select, is.na(下市日期) == TRUE)


##### arrange：以特定欄位排序 #####

# 以 desc() 進行由大到小倒序
IPO_Filter6 <- arrange(IPO_Select, `TSE新產業名`, desc(FirmAgeBeforeIPO))


##### mutate：建立新的變數 #####

# 以 『 ifelse 』建立條件
IPO_Filter8 <- mutate(IPO_Select, 
                      Delist = ifelse(is.na(下市日期) == T, 1, 0), 
                      Sign = 1:nrow(IPO_Select))


##### transmute：建立新的變數並且使資料剩下組別變數以及新生成變數 #####

IPO_Filter9 <- transmute(IPO_Select, Delist = ifelse(is.na(下市日期) == T, 1, 0))


##### group_by：為特定欄位進行分組 #####

IPO_Group <- group_by(IPO_Select, TSE新產業名)
groups(IPO_Group)

# 可以利用 『 ungroup 』將群組條件解除，通常有設定群組會使得資料跑得比較慢，故若是不需要群組時，可考慮以ungroup刪掉群組設定。
IPO_Ungroup <- ungroup(IPO_Group)
groups(IPO_Ungroup)

##### summarise：將資料進行summary，通常會與group_by 做搭配使用 #####

IPO_Summarize <- summarise(IPO_Group, 
                           MeanFirmAge = mean(FirmAgeBeforeIPO), 
                           SDFirmAge = sd(FirmAgeBeforeIPO))

# 若想要 summarise 但又想要保留原本欄位，可以使用『 mutate 』
IPO_MutateByGroup <- mutate(IPO_Group, 
                            MeanFirmAge = mean(FirmAgeBeforeIPO), 
                            SDFirmAge = sd(FirmAgeBeforeIPO))

##### 作業 ##### 
# 1. 建立一個function，function可以做到挑選電子產業或不是電子產業，計算每一個產業的平均FirmAgeBeforeIPO
# 2. function 的引數需包括data 與 是否為電子產業
# 3. 可以研究 Pipe (%>%) https://reurl.cc/0ooajb 希望大家可以利用pipe來使程式更加簡潔。

                
        



