view(Wales)

Select.county <- function(){
  county_name <- readline(prompt = 'Please enter a county from the Wales table: \n')
                        
          W <- Wales$County
          if(!(toupper(county_name) %in% toupper(W)))
      {
        cat(county_name,'is not on the Wales table!','\n', 
            'Check spelling!\n')
        return(Select.county())
      }
          
      view(Qofmed[!is.na(Qofmed$County) & toupper (Qofmed$County)==toupper(county_name),])
}

My_county <- Select.county()

cat('The table above shows the availability of Qof and medication data in',
    My_county[1,2])