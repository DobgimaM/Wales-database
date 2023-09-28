view(My_county)

CountyName <-My_county[2,2]

Select.practice <- function(){

  practice <- readline(prompt = cat('Please enter a', CountyName ,
                                    'practiceID (WXXXXX) that has qof data', ':\n'))
    
  if(!(toupper(practice) %in% toupper(My_county$practiceID)))
  {
    cat(practice,'is not on the', CountyName, 'table!','\n', 
        'Check spelling!\n')
    return(Select.practice())
  }else if(My_county[My_county$practiceID==toupper(practice),]$qof_data == 'Unavailable'){
    #view(My_county[toupper(My_county$practiceID)==toupper(practice),])
    cat(practice,'has no qof data!')
    return(Select.practice()) & view(Wales)
  }else{
    view(My_county[toupper(My_county$practiceID)==toupper(practice),])
  }
}  

My_practice <- Select.practice()

cat(My_practice[1,1], 'has qof data! Please return to the Main file and continue.')
