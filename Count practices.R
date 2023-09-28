
#BNF code and name are exactly identical in number

#b <-bnfSQL
#all.equal(b$c,b$n)
#rm(b)

bnfSQL <- dbGetQuery(con, 'select count (bnfcode) c, 
                            count (bnfname) n from gp_data_up_to_2015 
                            group by practiceid
                      ')

# Actcost is the amount spent per prescription
# For ex, using Olanzapine_Oral Lyophilisate Tab 5mg
# Actcost/quatity is constant
#44.2705/28
#88.5506/56

#-------------------------------------------------------------------------------------------------
Q1 <- dbGetQuery(con, 'select ad.practiceid, gp.period, sum (gp.actcost) avg_spend_per_month,
                        count (gp.bnfname) medication_data
                        from address ad
                        left join gp_data_up_to_2015 gp on
                        ad.practiceid = gp.practiceid
                        group by gp.period, ad.practiceid, ad.county, ad.posttown
                ')

names(Q1)
Q1 <- Q1 %>%
          mutate(avg_spend_per_month= round(avg_spend_per_month))%>%
          rename(practiceID=practiceid)

A <- left_join(Address,Q1, by='practiceID')

A <- A %>% 
          mutate(medication_data=ifelse(medication_data <1,0,1))
#----------------------------------------------------------------------------------------------------
A1<- A %>%
          group_by(County) %>%
          summarise(no_of_practices=n_distinct(practiceID),
          avg_spend_per_month= sum(avg_spend_per_month,na.rm = T)/n_distinct(period,na.rm = T))

#----------------------------------------------------------------------------------------------------
# Extract practice medication data details

Am <- A %>% 
          select(practiceID,County,medication_data) %>%
          mutate(Med_data=ifelse(medication_data>0,'Available','Unavailable'))%>%
          distinct()

A2<- Am %>% 
          group_by(County) %>%
          summarise(medic_ava=sum(medication_data))
#----------------------------------------------------------------------------------------------------

# Practices with qof data available and number of patients. The denominator of each qof indicator is used
# This assumes that each patient is at risk for only a single condition (e.g patients with cases coded AST002
# are not found in any other cases)

q <- paste('select ad.practiceid prac_w_qof_data, ad.street GP_practice, sum(qof.numerator) total_pat_no 
            from address ad
            right join qof_achievement qof on ad.practiceid = qof.orgcode
            where ad.practiceid like \'W%\'
            group by ad.practiceid, ad.street
            ')

Q2 <- dbGetQuery(con,q) %>%
          mutate(qof_data=ifelse(is.na(prac_w_qof_data),'Not available','Available'))

B <- full_join(Address,Q2, by=c('practiceID'='prac_w_qof_data')) %>%
          mutate(qof_data=ifelse(is.na(qof_data),'Unavailable',qof_data))

B1 <- B %>% 
          group_by(County) %>%
          summarise(prac_w_qof_data=n_distinct(practiceID, na.rm = T), 
          total_no_pat=sum(total_pat_no, na.rm = T))
  

Wales <- full_join(A1,A2, by= "County",na.rm = T)
Wales <- full_join(Wales,B1, by= "County",na.rm = T)

# Remove missing data row from table (5 pracites... 4 from England and 1 unidentified)

Wales <- Wales %>% 
          slice_head(n=8)

Wales2 <- full_join(A,B, by= c('practiceID','County'),na.rm = T) %>%
          select(practiceID,County,medication_data,gp_practice,total_pat_no) %>%
          group_by(practiceID) %>%
          distinct() %>%
          mutate(medication_data=ifelse(medication_data==1,'available','unavailable'))
                 

#----------------------------------------------------------------------------------------------------
Qofmed <- full_join(Am,B,by=c('practiceID' ,'County')) %>%
          select(practiceID,County,Med_data,qof_data)

