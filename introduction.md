Using Cabbietools
================
Fausto Lopez
January 2, 2018

Cabbietools
===========

Cabbietools is designed to streamline access to RBIN data at tlc, which is data on the shared drive that mirrors the most important trip elements from our sql server. It allows the user to access quicker and daily indexed trip files in order to rapid prototype and experiment with the trip records. In order to use run the code below:

For now the package has two primary functions, get\_trips and get\_trips\_shared. The first is used to pull trip records from any service for any given date range:

``` r
samp = get_trips("fhv",dt_start = "2017-06-01", dt_end = "2017-06-01")

head(samp)
```

    ##    baseDisp baseAffil    hack    plate                pudt
    ## 1:   B01537    B01537  870427 T712923C 2017-06-01 12:15:00
    ## 2:   B01537    B01537 5333553 T498269C 2017-06-01 12:25:00
    ## 3:   B01537    B01537 5405034 T516438C 2017-06-01 12:34:00
    ## 4:   B01537    B01537 5152500 T622046C 2017-06-01 12:46:00
    ## 5:   B01537    B01537 5682255 T516439C 2017-06-01 08:13:00
    ## 6:   B01537    B01537 5445309 T516438C 2017-06-01 08:19:00
    ##                   dodt puLoc puLong puLat doLoc doLong doLat industry
    ## 1: 2017-06-01 12:30:00    NA     NA    NA    NA     NA    NA      fhv
    ## 2: 2017-06-01 12:45:00    NA     NA    NA    NA     NA    NA      fhv
    ## 3: 2017-06-01 12:45:00    NA     NA    NA    NA     NA    NA      fhv
    ## 4: 2017-06-01 12:55:00    NA     NA    NA    NA     NA    NA      fhv
    ## 5: 2017-06-01 08:40:00    NA     NA    NA    NA     NA    NA      fhv
    ## 6: 2017-06-01 08:50:00    NA     NA    NA    NA     NA    NA      fhv

This will pull all the trips between those dates however we can customize the query further by adding which columns we want etc:

``` r
samp = get_trips("fhv",dt_start = "2017-06-01", dt_end = "2017-06-01", features = c("hack","plate","pudt","dodt"))

head(samp)
```

    ##       hack    plate                pudt                dodt industry
    ## 1:  870427 T712923C 2017-06-01 12:15:00 2017-06-01 12:30:00      fhv
    ## 2: 5333553 T498269C 2017-06-01 12:25:00 2017-06-01 12:45:00      fhv
    ## 3: 5405034 T516438C 2017-06-01 12:34:00 2017-06-01 12:45:00      fhv
    ## 4: 5152500 T622046C 2017-06-01 12:46:00 2017-06-01 12:55:00      fhv
    ## 5: 5682255 T516439C 2017-06-01 08:13:00 2017-06-01 08:40:00      fhv
    ## 6: 5445309 T516438C 2017-06-01 08:19:00 2017-06-01 08:50:00      fhv

We can even look at the share table as it stands alone:

``` r
#for more parameters to pass run ?get_trips in your R console
samp = get_trips("share", dt_start = "2017-06-01", dt_end = "2017-06-02")
```

    ##        baseDisp    hack    plate              share_pudt
    ##     1:   B02510 5461634 T668866C 2017-06-01 00:17:30.000
    ##     2:   B02510 5461634 T668866C 2017-06-01 00:17:30.000
    ##     3:   B02510 5538458 T690544C 2017-06-01 00:07:28.000
    ##     4:   B02510 5640455 NOTGULTY 2017-06-01 00:59:49.000
    ##     5:   B02510 5640455 NOTGULTY 2017-06-01 00:59:49.000
    ##    ---                                                  
    ## 39611:   B02617 5526926 T633725C 2017-06-01 23:04:34.000
    ## 39612:   B02617 5508983 T650097C 2017-06-01 23:57:44.000
    ## 39613:   B02617 5501741 T646894C 2017-06-01 23:39:23.000
    ## 39614:   B02617 5517731 T655447C 2017-06-01 23:16:34.000
    ## 39615:   B02617 5594203 T684657C 2017-06-01 23:45:47.000
    ##                     share_dodt
    ##     1: 2017-06-01 00:35:38.000
    ##     2: 2017-06-01 00:35:38.000
    ##     3: 2017-06-01 00:13:37.000
    ##     4: 2017-06-01 01:35:43.000
    ##     5: 2017-06-01 01:35:43.000
    ##    ---                        
    ## 39611: 2017-06-01 23:32:34.000
    ## 39612: 2017-06-02 00:58:51.000
    ## 39613: 2017-06-02 00:14:20.000
    ## 39614: 2017-06-02 00:01:12.000
    ## 39615: 2017-06-02 00:21:48.000
    ##        baseDisp    hack    plate              share_pudt
    ##     1:   B02510 5488282 T705333C 2017-06-02 00:05:36.000
    ##     2:   B02510 5488282 T705333C 2017-06-02 00:05:36.000
    ##     3:   B02510 5494533 T663013C 2017-06-02 00:26:35.000
    ##     4:   B02510 5494533 T663013C 2017-06-02 00:26:35.000
    ##     5:   B02510 5042777 T622143C 2017-06-02 00:17:49.000
    ##    ---                                                  
    ## 46520:   B02682 5394158 T658318C 2017-06-02 23:34:16.000
    ## 46521:   B02617  681970 T442038C 2017-06-02 23:19:09.000
    ## 46522:   B02617 5523155 T651827C 2017-06-02 23:19:14.000
    ## 46523:   B02617 5570509 T652313C 2017-06-02 23:57:19.000
    ## 46524:   B02617 5576938 T648444C 2017-06-02 23:03:04.000
    ##                     share_dodt
    ##     1: 2017-06-02 00:40:34.000
    ##     2: 2017-06-02 00:40:34.000
    ##     3: 2017-06-02 00:42:58.000
    ##     4: 2017-06-02 00:42:58.000
    ##     5: 2017-06-02 00:52:30.000
    ##    ---                        
    ## 46520: 2017-06-03 00:15:13.000
    ## 46521: 2017-06-02 23:50:00.000
    ## 46522: 2017-06-02 23:27:33.000
    ## 46523: 2017-06-03 00:26:14.000
    ## 46524: 2017-06-02 23:31:51.000

``` r
head(samp)
```

    ##    baseDisp    hack    plate          share_pudt          share_dodt
    ## 1:   B02510 5461634 T668866C 2017-06-01 00:17:30 2017-06-01 00:35:38
    ## 2:   B02510 5461634 T668866C 2017-06-01 00:17:30 2017-06-01 00:35:38
    ## 3:   B02510 5538458 T690544C 2017-06-01 00:07:28 2017-06-01 00:13:37
    ## 4:   B02510 5640455 NOTGULTY 2017-06-01 00:59:49 2017-06-01 01:35:43
    ## 5:   B02510 5640455 NOTGULTY 2017-06-01 00:59:49 2017-06-01 01:35:43
    ## 6:   B02510 5640455 NOTGULTY 2017-06-01 00:59:49 2017-06-01 01:35:43

Using get\_trips\_shared
========================

While get\_trips returns raw trip data for you to manipulate, get\_trips\_shared returns trips along with their share status. It does this by running a roll join between the trip data and share trip table in order to mark which trips are part of a share chain and which are not. Below we can see it run:

``` r
samp = get_trips_shared(dt_start = "2017-06-01", dt_end = "2017-06-02")

head(samp)
```

    ##    baseDisp baseAffil    hack    plate                pudt
    ## 1:   B01537    B01537  870427 T712923C 2017-06-01 12:15:00
    ## 2:   B01537    B01537 5333553 T498269C 2017-06-01 12:25:00
    ## 3:   B01537    B01537 5405034 T516438C 2017-06-01 12:34:00
    ## 4:   B01537    B01537 5152500 T622046C 2017-06-01 12:46:00
    ## 5:   B01537    B01537 5682255 T516439C 2017-06-01 08:13:00
    ## 6:   B01537    B01537 5445309 T516438C 2017-06-01 08:19:00
    ##                   dodt puLoc puLong puLat doLoc doLong doLat
    ## 1: 2017-06-01 12:30:00    NA     NA    NA    NA     NA    NA
    ## 2: 2017-06-01 12:45:00    NA     NA    NA    NA     NA    NA
    ## 3: 2017-06-01 12:45:00    NA     NA    NA    NA     NA    NA
    ## 4: 2017-06-01 12:55:00    NA     NA    NA    NA     NA    NA
    ## 5: 2017-06-01 08:40:00    NA     NA    NA    NA     NA    NA
    ## 6: 2017-06-01 08:50:00    NA     NA    NA    NA     NA    NA
    ##         hack_plate industry     shared share_pudt share_dodt
    ## 1:  870427T712923C      fhv not_shared       <NA>       <NA>
    ## 2: 5333553T498269C      fhv not_shared       <NA>       <NA>
    ## 3: 5405034T516438C      fhv not_shared       <NA>       <NA>
    ## 4: 5152500T622046C      fhv not_shared       <NA>       <NA>
    ## 5: 5682255T516439C      fhv not_shared       <NA>       <NA>
    ## 6: 5445309T516438C      fhv not_shared       <NA>       <NA>

You can see that the code returns the trips along with their share status and all the columns in the table. As with the previous funcion we can specify columns we want, however note that you will always need to call hack and plate as columns since they are needed for merging.

Sql Joins: experimental
=======================

Often time we might need to merge trip records against entity or any other tables. Cabbietools implements a beta version of this concept by allowing the user to pass sql queries to their trip record request. In this way, you can extract shared rides while also understanding which companies had shared rides:

``` r
samp = get_trips_shared(dt_start = "2017-06-01"
                     , dt_end = "2017-06-03"
                     , features = c("hack","plate","pudt","dodt", "baseDisp")
                     ,merge_ent = T
                     ,odbc_con = "datawarehouse"
                     ,query = "select ltrim(rtrim(lic_no)) as lic_no,
                                      trade_nam as company
                     from tlc_camis_entity
                     where lic_code like 'BAS'
                     "
                     ,left_key = "baseDisp"
                     ,right_key = "lic_no")
head(samp)  
```

    ##    baseDisp    hack plate                pudt                dodt
    ## 1:   B00001 5421986 LTC32 2017-06-01 05:30:00 2017-06-04 05:57:06
    ## 2:   B00001 5020765 LTC22 2017-06-01 05:30:00 2017-06-14 06:00:09
    ## 3:   B00001  677263 LTC12 2017-06-01 05:30:00 2017-06-16 06:01:20
    ## 4:   B00001  828549  LTC7 2017-06-01 05:30:00 2017-06-21 06:08:13
    ## 5:   B00001 5407228  LTC4 2017-06-01 05:30:00 2017-06-22 06:33:26
    ## 6:   B00001  689942 LTC19 2017-06-01 05:30:00 2017-06-30 06:12:22
    ##      hack_plate industry     shared share_pudt share_dodt company
    ## 1: 5421986LTC32      fhv not_shared       <NA>       <NA>        
    ## 2: 5020765LTC22      fhv not_shared       <NA>       <NA>        
    ## 3:  677263LTC12      fhv not_shared       <NA>       <NA>        
    ## 4:   828549LTC7      fhv not_shared       <NA>       <NA>        
    ## 5:  5407228LTC4      fhv not_shared       <NA>       <NA>        
    ## 6:  689942LTC19      fhv not_shared       <NA>       <NA>

This introduction gives you a feel for how the functions work. For a more detailed vignette of some powerful examples go to the vignettes sections.
