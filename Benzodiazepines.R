# Benzodiazepines

bz <- dbGetQuery (con, 'select practiceid, count (bnfname) bnz, period/100 as year
                        from gp_data_up_to_2015
                        where bnfname like \'%zepam%\'
                        group by practiceid, year')


bz <- bz %>% rename(practiceID = practiceid) %>%
                inner_join(Address,by= 'practiceID')


# Create categories for number of Benzodiazepine prescriptions
bz <- bz %>%
       mutate(bz_cat= ifelse(bnz<81,'0-80',
                       ifelse(bnz<106,'81-105',
                        ifelse(bnz<126,'106-126','127-214'))))

#-------------------------------------------------------------------------------
# Test for association between number of prescriptions and year prescribed

bz_test <- chisq.test(bz$bz_cat,bz$year)

check.bzyr <- function(){
            if(bz_test$p.value < 0.05){
              print(bz_test)
              cat(note('\nThere is statistical evidence of a relationship between Benzodiazepine \n',
                  'prescription and year of prescription in Wales '))
            }else{
              print('no difference')
            }
}
#-------------------------------------------------------------------------------
# Change year to a categorical variable

bz$year <- as.factor(bz$year)

bz2 <- bz %>% 
        group_by(year) %>%
         summarise(Bnz= sum(bnz))

# Plot data by year

base3 <- ggplot(bz2, aes(x = year, y= Bnz, width=0.55)) 

p3 <- geom_bar(stat = 'identity', fill='#00CDCD') 

l3 <- labs(x = "Year", y = "Benzodiazepine prescriptions",
           title = c('Benzodiazepine prescriptions in Wales by'),
           subtitle = c('year'),
           caption = ("Prescriptions: Clonazepam, Diazepam, Lorazepam, Lormetazepam, Nitrazepam, Oxazepam, Temazepam"))

  
Bnz_plotyr <-base3 + p3  + theme_minimal() + l3 + scale_fill_hue() 

Bnz_plotyr

#-------------------------------------------------------------------------------
# Test for association between number of prescriptions and County

bz_test2 <- chisq.test(bz$bz_cat,bz$County)

check.bzcty<- function(){
            if(bz_test2$p.value < 0.05){
              print(bz_test2)
              cat(note('\nThere is statistical evidence of a relationship between Benzodiazepine \n',
              'prescription and County.'))
            }else{
              print('no difference')
            }
}
#-------------------------------------------------------------------------------

# Aggregate data by county

bz1 <- bz %>% 
  group_by(County) %>%
   summarise(Bnz= sum(bnz)) %>%
    slice_head(n=8)

# Plot data by year

base4 <- ggplot(bz1, aes(x = County, y= Bnz, width= 0.5)) 

p4 <- geom_bar(stat = 'identity', fill='#76EE00') 

l4 <- labs(x = "County", y = "Benzodiazepine prescriptions",
           title = c('Benzodiazepine prescriptions in Wales by'),
           subtitle = c('County'),
           caption = ("Prescriptions: Clonazepam, Diazepam, Lorazepam, Lormetazepam, Nitrazepam, Oxazepam, Temazepam
                      County population estimates indicated above bars"))

ClwydInt <- geom_hline(yintercept=bz1[[1,2]], color="#556B2F", size=0.1)

a2 <- annotate(geom = "text", x = Wales$County, y = 30000, 
              label = Hypertension2$total_no_pat)

Bnz_plotCty <-base4 + p4  + theme_minimal() + l4 + a2 + scale_fill_hue() + 
              ClwydInt + guides(x = guide_axis(n.dodge = 2)) 

Bnz_plotCty
