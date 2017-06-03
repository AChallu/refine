
# Basic Data Manupulation

# Step-1 Loading the csv file to dataframe

#suppressMessages(library(tidyverse))
#suppressMessages(library(stringdist))
setwd("~/SpringBoard/Data Wrangling Exercise 1 - Basic Data Manipulation")
library(tidyverse)
library(stringdist)

refinecsv <- read.csv("refine_original.csv", , stringsAsFactors = FALSE)
refine <- tbl_df(refinecsv)

# Step-2 Scrubbing the company name

Company_Name <- function(x,y) {
  for (i in 1:length(y)){
    if (stringdist(x,y[i]) < 5)
      y[i] = x
  }
  return(y)
}

refine$company = Company_Name("philips",refine$company)
refine$company = Company_Name("akzo",refine$company)
refine$company = Company_Name("van houten",refine$company)
refine$company = Company_Name("unilever",refine$company)

# Step-3 Splitting Product code and product number

refine <- separate(refine,"Product.code...number",into = c("product_code","product_number"),sep="-")


# Step-4 Adding Product Category

refine <-mutate(refine,product_cat = ifelse(product_code == "p","smartphone",ifelse(product_code == "x","laptop",ifelse(product_code == "v","tv","tablet"))))

# Step-5 Getting geocode address

refine <- mutate(refine,full_address=paste(address, city, country, sep = ","))

# Step-6 Setting Dummy Variables

refine <- mutate(refine,company_philips = as.numeric((company == "philips")))
refine <- mutate(refine,company_akzo = as.numeric((company == "akzo")))
refine <- mutate(refine,company_van = as.numeric((company == "van houten")))
refine <- mutate(refine,company_unilever = as.numeric((company == "unilever")))
refine <- mutate(refine,product_smartphone = as.numeric((product_code == "p")))
refine <- mutate(refine,product_tv = as.numeric((product_code == "v")))
refine <- mutate(refine,product_laptop = as.numeric((product_code == "x")))
refine <- mutate(refine,product_tablet = as.numeric((product_code == "q")))

# Creating scrubbed csv file

write.csv(refine,file = "refine_clean.csv")
View(refine)
