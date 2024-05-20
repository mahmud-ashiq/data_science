install.packages('rvest')
install.packages('dplyr')


library(rvest)
library(dplyr)
library(stringr)

doctor = data.frame()
for (x in 1:14) {
  link = paste("https://www.evercarebd.com/dhaka/find-doctors/?pid=",x,sep = "")
  page = read_html(link)
  name = page %>% html_nodes("h3") %>% html_text()
  designation = page %>% html_nodes(".doc-desc-designation") %>% html_text()
  department = page %>% html_nodes(".doc-desc-dept") %>% html_text()
  doctor = rbind(doctor, data.frame(name, designation,department))

}
doctor  
doctor[c('name', 'degree')] <- str_split_fixed(doctor$name, ',',2)

space <- "^\\s+|\\s+$"
doctor$name <- gsub(space,"", doctor$name)
doctor$designation <- gsub(space,"", doctor$designation)
doctor$degree <- gsub(space,"", doctor$degree)
doctor$department <- gsub("Department: ","", doctor$department)
doctor$department <- gsub(space,"", doctor$department)
write.csv(doctor, "doctor.csv")

 
  





