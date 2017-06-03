# Step 0: Loading the data into R


setwd("~/SpringBoard/Data Wrangling Exercise 1 - Basic Data Manipulation")
library(tidyverse)
purchases <- read.csv("refine_original.csv",  stringsAsFactors = FALSE)

# Step 1: Cleaning up the brand names

purchases$company <- gsub("^[p|f].*", "philips", purchases$company, ignore.case = TRUE)
purchases$company <- gsub("^a.*", "akzo", purchases$company, ignore.case = TRUE)
purchases$company <- gsub("^v.*", "van houten", purchases$company, ignore.case = TRUE)
purchases$company <- gsub("^u.*", "unilever", purchases$company, ignore.case = TRUE)

# Step 2: Separating product code and product number


purchases <- purchases %>% separate("Product.code...number", 
                                    c("product_code", "product_number"), sep = "-")
# Step 3: Adding product categories


purchases <- purchases %>% mutate(product_category=product_code)
purchases$product_category <- gsub("p", "Smartphone", purchases$product_category)
purchases$product_category <- gsub("v", "TV", purchases$product_category)
purchases$product_category <- gsub("x", "Laptop", purchases$product_category)
purchases$product_category <- gsub("q", "Tablet", purchases$product_category)

# Step 4: Adding full address for geocoding


purchases <- unite(purchases, full_address, address:country, sep = ",", remove = FALSE)

# Step 5: Creating dummy variables for company and product category


dummy_philips <- as.numeric(purchases$company == "philips")
dummy_akzo <- as.numeric(purchases$company == "akzo")
dummy_van_houten <- as.numeric(purchases$company == "van houten")
dummy_unilever <- as.numeric(purchases$company == "unilever")
dummy_smartphone <- as.numeric(purchases$product_category == "Smartphone")
dummy_tv <- as.numeric(purchases$product_category == "TV")
dummy_laptop <- as.numeric(purchases$product_category == "Laptop")
dummy_tablet <- as.numeric(purchases$product_category == "Tablet")
purchases <- mutate(purchases, 
                    company_philips = dummy_philips, 
                    company_akzo = dummy_akzo, 
                    company_van_houten = dummy_van_houten, 
                    company_unilever = dummy_unilever, 
                    product_smartphone = dummy_smartphone, 
                    product_TV = dummy_tv, 
                    product_laptop = dummy_laptop, 
                    product_tablet = dummy_tablet)

# Step 6: Writing the cleaned-up data frame to a new CSV


write.csv(purchases, file = "refine_clean.csv")
