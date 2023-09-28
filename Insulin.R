
#                                    Total insulin prescriptions, i1 
# Rate of insulin prescription =   ________________________________

#                                       Total prescriptions, i2

# Get the above variables from the database

i1 <-  paste('select practiceid, sum (quantity) ins_qty
		                            from gp_data_up_to_2015 
		                            where bnfname like \'%Ins %\' --Insulin prescriptions
		                            group by practiceid ')

i2 <-  paste('select practiceid, sum (quantity) drug_qty
		                            from gp_data_up_to_2015 
		                            group by practiceid ')

Ins <- dbGetQuery(con,i1) 
Ins2 <- dbGetQuery(con,i2) 

# Join the tables, compute and extract the required columns

Insulin_prop <- full_join(Ins,Ins2, by='practiceid') %>%
  mutate(Ins_rate= ins_qty/drug_qty)%>%
  mutate(Ins_rate= round(Ins_rate,6)) %>%
  rename(practiceID = practiceid)

test_data <- left_join(Hypertension,Insulin_prop, by='practiceID') %>%
              select(-drug_qty,-ins_qty)


Check.CLT<- function(){
                 if(nrow(test_data)>30){
                   cat(note('Sample size is large enough to use parametric test.'))
                 }else{
                   cat(note('Test for normality.'))
                 }
} 

x <- t.test(test_data$hyp_rate,test_data$Ins_rate)

test.x<- function(){
            if(x$p.value < 0.05){
              print(x)
              cat(note('\nThere is statistical evidence of a relationship between Insulin\n',
              'prescription and hypertension rates in Wales ','(95% CI= ',
              round(x$conf.int[1],5),' : ',round(x$conf.int[2],5),').',sep=''))
            }else{
              print(note('no difference'))
            }
}

