
# Import county from Posttown cty_pt and County from county cty_cy

Counties_SQL <- dbGetQuery(con, 'select practiceid, 
                           area, posttown cty_pt,county cty_cy 
                           from address 
                           where practiceid like \'W%\'')

#-------------------------------------------------------------------------------
# Rename Clwyd, Dyfed, Gwent, Gwynedd, Mid Glamorgan,South Glamorgan,
# West Glamorgan from the Posttown column and remove any names that do not match;
# Put these in a new column, PT

Address <- Counties_SQL %>%
 mutate(PT=
  ifelse(grepl('ABERTILLERY|ABERTILLERY GWENT|BLACKWOOD|BRYNMAWR|
    CAERLEON NEWPORT|NEWPORT|Caerphilly|CAERPHILLY MID GLAMORGAN|
    CWMBRAN|Gwent|GWENT|MONMOUTHSHIRE|NEW TREDEGAR|NEWPORT
    |PONTYPOOL|PONTYPOOL GWENT|PONTYPOOL TORFAEN|RHYMNEY|
    TREDEGAR|YSTRAD MYNACH|CHEPSTOW|TEMPEST WAY CHEPSTOW|ABERCARN NEWBRIDGE
    NEWBRIDGE| CRUMLIN|GELLIGAER|CAERPHILLY',cty_pt),'Gwent', 
     ifelse(grepl('ABERYSTWYTH|CEREDIGION|BORTH|CARMARTHEN|CARMARTHENSHIRE
       |CEREDIGION|CRYMYCH|Dyfed|DYFED|FISHGUARD ROAD  HAVERFORDWEST|
       HAVERFORDWEST|HAVERFORDWEST PEMBROKESHIRE|LAMPETER|Llanelli|
       LLANELLI|LLWYNHENDY ROAD LLANELLI|PEMBROKE DOCK|PEMBROKESHIRE|
       PEMBROKESHIRE DYFED|WHITLAND CARMARTHENSHIRE|LLANYBYDDER',cty_pt),'Dyfed',
        ifelse(grepl('ABERGELE|BUCKLEY FLINTSHIRE|CLWYD|COLWYN BAY|CONWAY|
          CONWY|DEESIDE|DENBIGH|DENBIGHSHIRE|Flintshire|FLINTSHIRE|LLANDUDNO 
          CONWY|LLANGOLLEN|LLAY WREXHAM|MOLD|MOLD FLINTSHIRE|PRESTATYN|RHYL|
          SHOTTON FLINTSHIRE|WREXHAM|WREXHAM CLWYD',cty_pt),'Clwyd',
           ifelse(grepl('ABERCONWY|ANGLESEY|BANGOR  GWYNEDD|GWYNEDD|
             HOLYHEAD|YNYS MON',cty_pt),'Gwynedd',
              ifelse(grepl('Mid Glamorgan|MID GLAMORGAN|ABERFAN|Bridgend|
                Rhondda CHURCH VILLAGE|FERNDALE MID GLAMORGAN|MAESTEG|MERTHYR 
                TYDFIL|MID GLAMORGAN|PENCOED|PONTYPRIDD|RHONDDA CYNON TAFF|
                BRIDGEND|RHONDDA MID GLAMORGAN',cty_pt),'Mid Glamorgan',
                 ifelse(grepl('NEATH|BRITON FERRY|GORSEINON SWANSEA|NEATH|NEATH
                 PORT TALBOT|PORT TALBOT|Swansea|SWANSEA|SWANSEA WEST GLAMORGAN|
                 WEST GLAMORGAN|GWAUN CAE GURWEN',cty_pt),'West Glamorgan',
                  ifelse(grepl('CARDIFF|ANGLESEY|BARRY|BUTE TERRACE  CARDIFF|
                    BUTETOWN  CARDIFF|ROATH CARDIFF|SOUTH GLAMORGAN|SULLY|
                    VALE OF GLAMORGAN|PENARTH',cty_pt),'South Glamorgan',
                      ifelse(grepl('BRECON POWYS|NEWTOWN POWYS|POWYS', cty_pt),
                                    'Powys',NA))))))))) 
                
# Compare what is left with the address county column and get the remaining names.
# Store these names from the county column in names_CY and generate a table of 
# the cleaned data
  
Address <- Address%>%
            #select(-cty_pt) %>%
            mutate(
            names_CY=ifelse(grepl('Clwyd|Dyfed|Gwent|Gwynedd|Mid Glamorgan|
                                  South Glamorgan|West Glamorgan',PT),NA,cty_cy)) %>%
            select(practiceid,area,PT,names_CY)

Address <- Address %>%
            mutate(County=
             ifelse(grepl('WREXHAM|WREXHAM CLWYD|WREXHAM|HANMER WHITCHURCH|SHOTTON
              FLINTSHIRE|RHYL|DEESIDE|Flintshire|PRESTATYN|MOLD FLINTSHIRE|MOLD|
              MOLD HAVEN|LLAY WREXHAM|LLANDUDNO CONWY|FLINTSHIRE|DENBIGHSHIRE|
              DEESIDE|CONWY|CLWYD|BUCKLEY FLINTSHIRE|ABERGELE|LLANGOLLEN|
              Flintshire',names_CY),'Clwyd',
               ifelse(grepl('WHITLAND CARMARTHENSHIRE|PEMBROKESHIRE DYFED|PEMBROKESHIRE|
                PEMBROKE DOCK|MILFORD HAVEN|LLWYNHENDY ROAD LLANELLI|LLANELLI|Llanelli|
                LAMPETER|HAVERFORDWEST.|HAVERFORDWEST PEMBROKESHIRE|HAVERFORDWEST|
                FISHGUARD ROAD HAVERFORDWEST|DYFED|DENBIGH|CRYMYCH|CEREDIGION|
                CARMARTHENSHIRE DYFED|CARMARTHEN|Dyfed|LAMPETER|PEMBROKE DOCK|
                CARMARTHENSHIRE|CARMARTHEN|BORTH|ABERYSTWYTH CEREDIGION.',names_CY),
                'Dyfed',
                 ifelse(grepl('GWENT|YNYS MON|RHYMNEY|PONTYPOOL TORFAEN|PONTYPOOL|
                 NEWPORT GWENT|NEWPORT|NEWBRIDGE|NEW TREDEGAR|MONMOUTHSHIRE|Gwent|
                 CHEPSTOW GWENT|CHEPSTOW|CAERLEON NEWPORT|BRYNMAWR|CWMBRAN|
                 ABERTILLERY GWENT|ABERTILLERY|NEW TREDEGAR',names_CY),'Gwent',
                  ifelse(grepl('YSTRAD MYNACH|HOLYHEAD|GWYNEDD|BANGOR GWYNEDD|
                  ABERCONWY|ANGLESEY',names_CY),'Gwynedd',
                    ifelse(grepl('RHONDDA MID GLAMORGAN|RHONDDA CYNON TAFF|
                     PENCOED|MID GLAMORGAN|MERTHYR TYDFIL|MAESTEG|FERNDALE MID
                     GLAMORGAN|CHURCH VILLAGE|CAERPHILLY MID GLAMORGAN|Caerphilly|
                      ABERFAN|PONTYPRIDD|PENCOED|ABERFAN|BRIDGEND',names_CY),'Mid Glamorgan', 
                     ifelse(grepl('SULLY|SOUTH GLAMORGAN|ROATH CARDIFF|CARDIFF|
                      BUTETOWN  CARDIFF|BUTE TERRACE  CARDIFF|BARRY VALE OF 
                      GLAMORGAN|BARRY - VALE OF GLAMORGAN|BARRY|VALE OF GLAMORGAN|
                      CARDIFF',names_CY),'South Glamorgan',
                       ifelse(grepl('WEST GLAMORGAN|SWANSEA WEST GLAMORGAN|SWANSEA|
                        Swansea|PORT TALBOT|NEATH PORT TALBOT|NEATH|GORSEINON 
                        SWANSEA|BRITON FERRY',names_CY),'West Glamorgan', 
                         ifelse(grepl('POWYS|NEWTOWN POWYS|BRECON POWYS',
                          names_CY),'Powys',PT)))))))))

Address <- Address %>%
            mutate(names_area=
             ifelse(grepl('BRIDGEND|THE BROADWAY',area),'Mid Glamorgan',
              ifelse(grepl('SWANSEA|Helens Road',area),'West Glamorgan',
               ifelse(grepl('CARDIFF',area),'South Glamorgan',
               ifelse(grepl('WREXHAM',area),'Clwyd',NA)))))%>%
                mutate(County= ifelse(!is.na(County),County,names_area))
 
#view(Address %>% arrange(County))           
           
# Select relevant columns

Address <- Address %>% 
            select(practiceid,County)%>%
            rename(practiceID=practiceid)

rm(Counties_SQL)

view(Address %>% arrange(County))

cat(sum(is.na(Address$County)),'practices from the database do not have adequate',
    'address information or are not in Wales')

