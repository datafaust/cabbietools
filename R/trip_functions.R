#Functions below---------------------------
#author: Fausto Lopez
#purpose: to run rbin file processing efficiently in conjunction with popular sql joins
#and to amplify access to shared ride data for ease of use


#' Pull trips from shl, fhv or yellow records for a given date range
#'
#' This function allows you to access rbin files on the shared ride to query quickly trip data from any of our services.
#' @param service the service you want in quotes: 'fhv'.
#' @param dt_start start date of range.
#' @param dt_end end date of range.
#' @param features a character vector of desired variables.
#' @param dt_convert do you want dates to be automatically converted, defaults to T.
#' @param merge_ent if True merges against entity automatically, defaults to FALSE.
#' @param odbc_con for accessing sql tables in function, pass your odbc connection string.
#' @param query a character string encompassing the sql query.
#' @param left_key the left join key in the trip records.
#' @param right_key the right join key in entity.
#' @param join_type the type of join desired, currently experimental, defaults to left.
#' @keywords get
#' @export
#' @examples
#' get_trips("fhv",dt_start = "2017-06-01", dt_end = "2017-06-01", features = c("hack","plate","pudt","dodt"))

get_trips = function(service
                     ,dt_start = NULL
                     ,dt_end =NULL
                     ,features = NULL
                     ,dt_convert = T
                     ,merge_ent = F
                     ,odbc_con = NULL
                     ,query = NULL
                     ,left_key = NULL
                     ,right_key = NULL
                     ,join_type = NULL) {
  
  
  #all possible directories
  fun_dirs = list(
    med = "I:/COF/COF/_M3trics/records/med",
    shl = "I:/COF/COF/_M3trics/records/shl",
    fhv = "I:/COF/COF/_M3trics/records/fhv",
    share = "I:/COF/COF/_M3trics/records/fhv_share"
  )
  
  #check parameters and logic, spit errors
  if(is.null(service)) { stop("please enter a type of service: med,fhv,shl")}
  if(is.null(odbc_con) & merge_ent ==T) { stop("please enter an RODBC connection")}
  if(is.null(query) & merge_ent ==T) { stop("please enter a query")}
  if(is.null(dt_start)) { dt_start = as.Date("2015-01-01")}
  if(is.null(dt_end)) { dt_end = as.Date("2015-01-03")}
  #features are tested later in script 
  
  #create date seq
  dates = seq.Date(as.Date(dt_start), as.Date(dt_end), by = "days", features = T) 
  
  if(merge_ent == T & service != "share") {
    
    #loop
    setwd(fun_dirs[[service]])
    trips = rbindlist(
      pbapply::pblapply(dates,function(x) {
        load(list.files(pattern = as.character(x)))
        #correct pudt and dodt for fhv
        if(service == "fhv") { names(pull)[names(pull) == "pud"] = "pudt"} else {pull}
        pull = if(service == "fhv" & x < as.Date("2017-06-01")) {pull = pull[,dodt:=NA]} else {pull}
        #test feature select
        pull =  if(is.null(features)) { pull } else { pull[,features, with = F]}
        #print(pull)
        pull[,names(pull) := lapply(.SD, function(x) trimws(toupper(x)))]
        #print(pull)
        #test date conversion
        pull = if(dt_convert==F) { pull } else { pull = pull[
          ,':='(pudt = fasttime::fastPOSIXct(pudt,tz = "GMT")
                ,dodt = fasttime::fastPOSIXct(dodt,tz = "GMT")
          )
          ]
        }
      })
    )
    
    
    
    #now query the data base
    #pull entity
    con = RODBC::odbcConnect(odbc_con)
    sqlz = RODBC::sqlQuery(con, query, as.is = T)
    RODBC::odbcCloseAll()
    
    #merge
    trips = merge(trips,sqlz, by.x = left_key, by.y = right_key, all.x = T)[,industry:=service]
    
    
    
  } else if(merge_ent == T & service =='share') {
    
    #pull trips
    setwd(fun_dirs[[service]])
    trips = rbindlist(
      pbapply::pblapply(dates,function(x) {
        load(list.files(pattern = as.character(x)))
        pull =  if(is.null(features)) { pull } else { pull[,features, with = F]}
        #print(pull)
        pull[,names(pull) := lapply(.SD, function(x) trimws(toupper(x)))]
        pull = if(dt_convert==F) { pull } else { pull = pull[
          ,':='(share_pudt = fasttime::fastPOSIXct(share_pudt,tz = "GMT")
                ,share_dodt = fasttime::fastPOSIXct(share_dodt,tz = "GMT")
          )
          ]
        }
        
      })
    )
    
    #now query the data base
    #pull entity
    con = RODBC::odbcConnect(odbc_con)
    sqlz = RODBC::sqlQuery(con, query, as.is = T)
    RODBC::odbcCloseAll()
    
    #merge
    trips = merge(trips,sqlz, by.x = left_key, by.y = right_key, all.x = T)[,industry:=service]
    
    
  } else if (merge_ent != T & service =='share') {
    
    #pull trips
    setwd(fun_dirs[[service]])
    trips = rbindlist(
      pbapply::pblapply(dates,function(x) {
        load(list.files(pattern = as.character(x)))
        pull =  if(is.null(features)) { pull } else { pull[,features, with = F]}
        #print(pull)
        pull[,names(pull) := lapply(.SD, function(x) trimws(toupper(x)))]
        pull = if(dt_convert==F) { pull } else { pull = pull[
          ,':='(share_pudt = fasttime::fastPOSIXct(share_pudt,tz = "GMT")
                ,share_dodt = fasttime::fastPOSIXct(share_dodt,tz = "GMT")
          )
          ]
        }
        
      })
    )[,industry:=service]
    
  } else if(merge_ent !=T & service !='share') {
    
    setwd(fun_dirs[[service]])
    trips = rbindlist(
      pbapply::pblapply(dates,function(x) {
        load(list.files(pattern = as.character(x)))
        #correct pudt and dodt for fhv
        if(service == "fhv") { names(pull)[names(pull) == "pud"] = "pudt"} else {pull}
        pull = if(service == "fhv" & x < as.Date("2017-06-01")) {pull = pull[,dodt:=NA]} else {pull}
        #test feature select
        pull =  if(is.null(features)) { pull } else { pull[,features, with = F]}
        #print(pull)
        pull[,names(pull) := lapply(.SD, function(x) trimws(toupper(x)))]
        #print(pull)
        #test date conversion
        pull = if(dt_convert==F) { pull } else { pull = pull[
          ,':='(pudt = fasttime::fastPOSIXct(pudt,tz = "GMT")
                ,dodt = fasttime::fastPOSIXct(dodt,tz = "GMT")
          )
          ]
        }
      })
    )[,industry:=service]
    
  }
}





#' Access shared trips from fhv records for a given date range
#'
#' This function allows you to access rbin files on the shared drive to query quickly share trip data. It also provides access to quick joins on the share data and sql backend. 
#' @param dt_start start date of range.
#' @param dt_end end date of range.
#' @param features a character vector of desired variables.
#' @param merge_ent if True merges against entity automatically, defaults to FALSE.
#' @param odbc_con for accessing sql tables in function, pass your odbc connection string.
#' @param query a character string encompassing the sql query.
#' @param left_key the left join key in the trip records.
#' @param right_key the right join key in entity.
#' @param join_type the type of join desired, currently experimental, defaults to left.
#' @keywords get
#' @export
#' @examples get_trips_shared(dt_start = "2017-06-01", dt_end = "2017-06-03", features = c("hack","plate","pudt","dodt", "baseDisp"),merge_ent = T,odbc_con = "datawarehouse",query = "select ltrim(rtrim(lic_no)) as lic_no,trade_nam as company from tlc_camis_entity where lic_code like 'BAS'",left_key = "baseDisp",right_key = "lic_no")

get_trips_shared = function(dt_start = NULL
                            ,dt_end =NULL
                            ,features = NULL
                            ,merge_ent = F
                            ,odbc_con = NULL
                            ,query = NULL
                            ,left_key = NULL
                            ,right_key = NULL
                            ,join_type = NULL) {
  
  
  #all possible directories
  fun_dirs = list(
    fhv = "I:/COF/COF/_M3trics/records/fhv",
    share = "I:/COF/COF/_M3trics/records/fhv_share"
  )
  
  #create date seq
  dates = seq.Date(as.Date(dt_start), as.Date(dt_end), by = "days", features = T) 
  
  #check parameters and logic
  if(is.null(dt_start)) { dt_start = "2017-06-01"}
  if(is.null(dt_end)) { dt_end = "2017-06-03" }
  
  
  #logical flow for merging entity follows
  
  if(merge_ent == T) {
    
    fhv = rbindlist(
      pbapply::pblapply(dates,function(x) {
        #pull trip data
        setwd(fun_dirs$fhv)
        load(list.files(pattern = as.character(x)))
        #correct pudt and dodt for fhv
        names(pull)[names(pull) == "pud"] = "pudt"
        #test feature select
        pull =  if(is.null(features)) { pull } else { pull[,features, with = F]}
        pull[,names(pull) := lapply(.SD, function(x) trimws(toupper(x)))]
        #convert date
        pull = pull[,':='(pudt = fasttime::fastPOSIXct(pudt,tz = "GMT")
                          ,dodt = fasttime::fastPOSIXct(dodt,tz = "GMT")
                          ,hack_plate=paste0(hack,plate)
        )
        ]
        fhv = pull[,industry:="fhv"]
        
        
        #pull share data
        setwd(fun_dirs$share)
        load(list.files(pattern = as.character(x)))
        pull[,names(pull) := lapply(.SD, function(x) trimws(toupper(x)))]
        pull = pull[
          ,':='(share_pudt = fasttime::fastPOSIXct(share_pudt,tz = "GMT")
                ,share_dodt = fasttime::fastPOSIXct(share_dodt,tz = "GMT")
                ,hack_plate =paste0(hack,plate)
          )
          ]
        fhv_share = pull
        rm(pull)
        
        
        #run merge
        fhv = fhv[, shared := 'not_shared'][
          fhv_share, on = .(hack_plate, pudt >= share_pudt,
                            pudt <= share_dodt)
          , `:=`(shared = 'shared',
                 share_pudt = i.share_pudt,
                 share_dodt = i.share_dodt)][is.na(share_pudt)
                                             ,shared:="not_shared"][is.na(shared),shared:="shared"]
        
        #pull entity
        con = RODBC::odbcConnect(odbc_con)
        sqlz = RODBC::sqlQuery(con, query, as.is = T)
        RODBC::odbcCloseAll()
        
        #merge
        fhv = merge(fhv,sqlz, by.x = left_key, by.y = right_key, all.x = T)
        
      })
    )
    
    
    
  } else {
    
    
    fhv = rbindlist(
      pbapply::pblapply(dates,function(x) {
        #pull trip data
        setwd(fun_dirs$fhv)
        load(list.files(pattern = as.character(x)))
        #correct pudt and dodt for fhv
        names(pull)[names(pull) == "pud"] = "pudt"
        #test feature select
        pull =  if(is.null(features)) { pull } else { pull[,features, with = F]}
        pull[,names(pull) := lapply(.SD, function(x) trimws(toupper(x)))]
        #convert date
        pull = pull[,':='(pudt = fasttime::fastPOSIXct(pudt,tz = "GMT")
                          ,dodt = fasttime::fastPOSIXct(dodt,tz = "GMT")
                          ,hack_plate=paste0(hack,plate)
        )
        ]
        fhv = pull[,industry:="fhv"]
        
        
        #pull share data
        setwd(fun_dirs$share)
        load(list.files(pattern = as.character(x)))
        pull[,names(pull) := lapply(.SD, function(x) trimws(toupper(x)))]
        pull = pull[
          ,':='(share_pudt = fasttime::fastPOSIXct(share_pudt,tz = "GMT")
                ,share_dodt = fasttime::fastPOSIXct(share_dodt,tz = "GMT")
                ,hack_plate =paste0(hack,plate)
          )
          ]
        fhv_share = pull
        rm(pull)
        
        
        #run merge
        fhv = fhv[, shared := 'not_shared'][
          fhv_share, on = .(hack_plate, pudt >= share_pudt,
                            pudt <= share_dodt)
          , `:=`(shared = 'shared',
                 share_pudt = i.share_pudt,
                 share_dodt = i.share_dodt)][is.na(share_pudt)
                                             ,shared:="not_shared"][is.na(shared),shared:="shared"]
        
      })
    )
    
  }
  
}

