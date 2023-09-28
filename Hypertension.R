
# Patients with Hypertension would be obtained from the qof_achievement table

h <- paste('select ad.practiceid, qa.ratio as Hyp_rate from address ad 
           left join qof_achievement qa
           on ad.practiceid= qa.orgcode 
           where qa.indicator like \'%PP PREV%\' ')

Hypertension <- dbGetQuery(con,h) 

Hypertension <- Hypertension %>%
                    mutate(hyp_rate=round(hyp_rate,3)) %>%
                    rename(practiceID = practiceid)

# Practice hypertension data

Hypertension1 <- left_join(My_county,Hypertension,by="practiceID") %>%
                  filter(qof_data=='Available')

My_practice <- left_join(My_practice,Hypertension,by="practiceID")

# Calculate country rate by practice average

WalesAvgP <-left_join(Hypertension,Address,by='practiceID') %>% 
                        summarise(County_rate = mean(hyp_rate))%>%
                        round(3)

# Plot data

  base <- ggplot(data=Hypertension1, stat='bin', aes(x=hyp_rate,y=practiceID))
  
  p <- geom_point( shape=19, col='blue')
  
  l <- labs(x = "Hypertension rate", y = "practiceID",
         title = c('Plot of hypertension rates against practices in'),
         subtitle = CountyName,
         caption = "Green line = Wales average by practice,  Red line = Selected practice")
  
  pract <- geom_point(aes(x=My_practice[1,5],y=My_practice[1,1]),col='red',shape=21)

  Wint <- geom_vline(xintercept=(WalesAvgP[1,1]), color="green3", size=0.1)

  yint <- geom_hline(yintercept=My_practice[1,1], color="firebrick1", size=0.1)
    
  xint <- geom_vline(xintercept=My_practice[1,5], color="firebrick1", size=0.1)
  
  t <- theme_minimal()

Hyp_plot <- base + p + l + pract + Wint + yint + xint + t

Hyp_plot

#----------------------------------Part 2---------------------------------------

# Create a table with hypertension rates categorized as above or below the Wales
# county average
Hypertension2 <- left_join(Hypertension,Address,by="practiceID")%>%
                    group_by(County) %>% 
                      summarise(hyp_rate=sum(hyp_rate)) %>%
                       slice_head(n=8)

# Compute an average by county
WalesAvgC <- mean(Hypertension2$hyp_rate)

# Reclassify the County Hypertension rates as above or below the County mean

Hypertension2 <- Hypertension2 %>%
                      group_by(County)%>%
                       summarise(hyp_rate=sum(hyp_rate))%>%
                        mutate(hyp_class=ifelse(hyp_rate > WalesAvgC,'Above','Below'))%>%
                          left_join(Wales, by= 'County') %>%
                          select(-medic_ava,-prac_w_qof_data)

base2 <- ggplot(data=Hypertension2, aes(x=County, y=hyp_rate, width = 0.5))

p2 <- geom_bar(aes(x=County, y=hyp_rate, fill=hyp_class), stat='identity')

l2 <- labs(x = "County", y = "Hypertension rate",
          title = c('Hypertension rate by Counties in'),
          subtitle = 'Wales',
          caption = "Estimated population indicated ontop each bar")

a <- annotate(geom = "text", x = Hypertension2$County, y = 3.5, 
              label = Hypertension2$total_no_pat)

Hyp_plot2 <- base2 + p2 + l2  + t + a +  guides(x = guide_axis(n.dodge = 2)) 

Hyp_plot2

