
InstallPackages <- function(...) {
  # Load each page in the list below, installing if required
  libs <- unlist(list(...))
  req <- unlist(lapply(libs, require, character.only=TRUE))
  need <-libs[req==FALSE]
  if(length(need)>0){ 
    install.packages(need)
    lapply(need, require, character.only=TRUE)
  }
}

InstallPackages("tidyverse", "readxl")

url1 <- "https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&nhs17-18%20testfile.zip&4324.0.55.001&Data%20Cubes&38209B3978C90FB1CA2583EB0021E7E5&0&2017-18&30.04.2019&Latest"
name_f1 <- "nhs17-18 testfile.zip"


url2 <-"https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&4324055001dl001.xls&4324.0.55.001&Data%20Cubes&ED90787D533A648ECA2583EB0021E797&0&2017-18&30.04.2019&Latest"
name_f2 <- "4324055001dl001.xls"

# Download file 1
download.file(url,name_f1, mode="wb")
f1 <- unzip(name_f1)
nhs <- read.csv(f1[grep("[.]csv", f1, ignore.case=TRUE)][1])
sort(colnames(nhs))

# Download file 2
download.file(url2,name_f2, mode="wb")

# check number of sheets in the xls file
if length(excel_sheets(name_f2))>1 then {"automate here"}

excel_sheets(name_f2)


# main df values
df1 <- data.frame(stringsAsFactors=FALSE)

# for (i in c("Administrative","Household Level")){
for (i in excel_sheets(name_f2)){

  data <- as.data.frame(read_xls(name_f2, sheet=i))[-1:-8,]
  # remove meta data: rows from 1 to 8 (same across all sheets)
  
  # remove 3rd column Population for now
  noemptyrows <- data[rowSums(is.na(data)) != ncol(data),1:2]

  # main df
  df1_temp <- noemptyrows[rowSums(is.na(noemptyrows[,])) == 0,]
  df1 <- rbind(df1, df1_temp)
}

arrange(df1,var)[1:10,1]
colnames(df1) <- c("var", "desc")



