avg_max = function(x, k){
    mean( head( sort(x, decreasing = TRUE) , k ) )
}

proc_data = function(df, max_sentences=20, max_articles=3){
    df %>% 
        group_by(days_since, date, id) %>% 
        summarize(predict=avg_max(predict, max_sentences)) %>% 
        group_by(days_since, date) %>% 
        summarize(predict=avg_max(predict, max_articles)) %>% 
        arrange(days_since) %>% ungroup()
}

predict_tiananmen_date = function(model, df){
    df$predict_hat = predict(model, df$predict)
    df %>%
        mutate(date_tiananmen = !!as.Date("1989-04-25") + round(predict_hat)) %>%
        rename(date_actual = date)
}

figure_tam = function(tam, max_sentences=20, max_articles=3){
    tam %>%
        proc_data(max_sentences=max_sentences,max_articles=max_articles) %>% 
        ggplot(aes(x=predict, y=days_since)) +
        geom_point() +
        scale_x_continuous(limits=c(-0, 43), breaks = seq(0,40,by=10)) +
        scale_y_continuous(limits=c(-0, 43), breaks = seq(0,40,by=10)) +
        xlab("Fitted time of publication (days since beginning)") +
        ylab("Time of publication (days since beginning)") +
        theme_bw()+
        theme(panel.grid.minor=element_blank(), panel.grid.major=element_blank()) + 
        geom_smooth(method = loess, se = FALSE, color = "black")
}

figure_hk = function(tam, hk, max_sentences=20, max_articles=3,
                     tail_len=30, color_choice="red",
                     hk_first_date, hk_last_date, with_events=FALSE){

    if (with_events==FALSE) {

        tmp_tam = tam %>% proc_data(max_sentences=max_sentences,max_articles=max_articles) 
        tmp_hk = hk %>% proc_data(max_sentences=max_sentences,max_articles=max_articles) 
        
        loess_model = loess(formula = days_since~predict, data=tmp_tam)
        
        data = predict_tiananmen_date(loess_model, tmp_hk) 
        data %>% tail(tail_len) %>% 
            ggplot(aes(x=date_actual, y=date_tiananmen)) +
            geom_point(color = color_choice) +
            geom_line(color = color_choice) +
            scale_x_date(limits = c(hk_first_date,hk_last_date+3),
                         breaks = c(hk_first_date,
                                    seq.Date(hk_first_date, hk_last_date, by=ceiling((hk_last_date-hk_first_date)/6)),
                                    hk_last_date)) +
            scale_y_date(limits =c (as.Date("1989-04-25"), as.Date("1989-06-04")+3),
                         breaks = c(as.Date("1989-04-25"),
                                    seq.Date(as.Date("1989-04-25"), as.Date("1989-06-04"), by="7 days"),
                                    as.Date("1989-06-04"))) +
            geom_hline(yintercept=as.Date("1989-06-04"), linetype = "dashed", col="black", size = 1 ) +
            geom_text(x=hk_first_date, y=as.Date("1989-06-04")+2,
                      label="June 4 crackdown", col="black", size=4, family = "sans", hjust = 0) +
            ylab("Counterfactual timeline (Tiananmen)") + xlab("Actual timeline (Hong Kong)") +
            theme_bw()+
            theme(panel.grid.minor=element_blank(), panel.grid.major=element_blank())

        } else {

        tmp_tam = tam %>% proc_data(max_sentences=max_sentences,max_articles=max_articles) 
        tmp_hk = hk %>% proc_data(max_sentences=max_sentences,max_articles=max_articles) 
        
        loess_model = loess(formula = days_since~predict, data=tmp_tam)
        
        data = predict_tiananmen_date(loess_model, tmp_hk) 
        data %>% tail(tail_len) %>% 
            ggplot(aes(x=date_actual, y=date_tiananmen)) +
            geom_point(color = color_choice) +
            geom_line(color = color_choice) +
            scale_x_date(limits = c(hk_first_date,hk_last_date+3),
                         breaks = c(hk_first_date,
                                    seq.Date(hk_first_date, hk_last_date, by=ceiling((hk_last_date-hk_first_date)/6)),
                                    hk_last_date)) +
            scale_y_date(limits =c (as.Date("1989-04-25"), as.Date("1989-06-04")+3),
                         breaks = c(as.Date("1989-04-25"),
                                    seq.Date(as.Date("1989-04-25"), as.Date("1989-06-04"), by="7 days"),
                                    as.Date("1989-06-04"))) +
            geom_hline(yintercept=as.Date("1989-06-04"), linetype = "dashed", col="black", size = 1 ) +
            geom_text(x=hk_first_date, y=as.Date("1989-06-04")+2,
                      label="June 4 crackdown", col="black", size=4, family = "sans", hjust = 0) +

            geom_vline(xintercept=as.Date("2019-08-05"), linetype = "longdash", col="grey", size = 0.5 ) +
            geom_vline(xintercept=as.Date("2019-08-10"), linetype = "longdash", col="grey", size = 0.5 ) +
            geom_vline(xintercept=as.Date("2019-08-16"), linetype = "longdash", col="grey", size = 0.5 ) +
            geom_vline(xintercept=as.Date("2019-08-29"), linetype = "longdash", col="grey", size = 0.5 ) +
            geom_vline(xintercept=as.Date("2019-10-04"), linetype = "longdash", col="grey", size = 0.5 ) +
            geom_vline(xintercept=as.Date("2019-10-12"), linetype = "longdash", col="grey", size = 0.5 ) +
            geom_vline(xintercept=as.Date("2019-10-16"), linetype = "longdash", col="grey", size = 0.5 ) +
            geom_vline(xintercept=as.Date("2019-11-16"), linetype = "longdash", col="grey", size = 0.5 ) +
            geom_vline(xintercept=as.Date("2019-11-28"), linetype = "longdash", col="grey", size = 0.5 ) +
            geom_vline(xintercept=as.Date("2019-12-14"), linetype = "longdash", col="grey", size = 0.5 ) +
            geom_vline(xintercept=as.Date("2020-05-21"), linetype = "longdash", col="grey", size = 0.5 ) +
            geom_vline(xintercept=as.Date("2020-05-24"), linetype = "longdash", col="grey", size = 0.5 ) +
            geom_vline(xintercept=as.Date("2020-05-28"), linetype = "longdash", col="grey", size = 0.5 ) +
            geom_vline(xintercept=as.Date("2020-06-04"), linetype = "longdash", col="grey", size = 0.5 ) +
            geom_vline(xintercept=as.Date("2020-06-30"), linetype = "longdash", col="grey", size = 0.5 ) +
            geom_vline(xintercept=as.Date("2020-07-14"), linetype = "longdash", col="grey", size = 0.5 ) +
            geom_text(x=as.Date("2019-08-05"), y=as.Date("1989-05-01"),
                      label="1st anti-riot drill near HK border", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2019-08-10"), y=as.Date("1989-05-03"),
                      label="1st troops sighting near HK border", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2019-08-16"), y=as.Date("1989-05-05"),
                      label="\"10 min\" warning from military", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2019-08-29"), y=as.Date("1989-05-07"),
                      label="Garrison rotation", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2019-10-04"), y=as.Date("1989-06-02"),
                      label="Anti-mask law", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2019-10-12"), y=as.Date("1989-05-31"),
                      label="Phase 1 trade deal announced", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2019-10-16"), y=as.Date("1989-05-29"),
                      label="HK Human Rights & Dem. Act", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2019-10-16"), y=as.Date("1989-05-27"),
                      label="passed US House", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2019-11-16"), y=as.Date("1989-04-28"),
                      label="PLA soldiers on street", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2019-11-28"), y=as.Date("1989-04-30"),
                      label="HK Act became US law", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2019-12-14"), y=as.Date("1989-05-04"),
                      label="Phase 1 trade", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2019-12-14"), y=as.Date("1989-05-02"),
                      label="deal reached", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2020-05-21"), y=as.Date("1989-05-02"),
                      label="National security bill proposed", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2020-05-24"), y=as.Date("1989-05-04"),
                      label="1st post-pandemic protest", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2020-05-28"), y=as.Date("1989-05-06"),
                      label="Nat'l security bill approved in Beijing", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2020-06-04"), y=as.Date("1989-05-08"),
                      label="Tiananmen vigil in HK", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2020-06-30"), y=as.Date("1989-05-24"),
                      label="Nat'l security bill became HK law", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2020-07-14"), y=as.Date("1989-05-22"),
                      label="HK Autonomy Act", col="black", size=3, family = "sans", hjust=0) +
            geom_text(x=as.Date("2020-07-14"), y=as.Date("1989-05-20"),
                      label="became US law", col="black", size=3, family = "sans", hjust=0) +

            ylab("Counterfactual timeline (Tiananmen)") + xlab("Actual timeline (Hong Kong)") +
            theme_bw()+
            theme(panel.grid.minor=element_blank(), panel.grid.major=element_blank())

        }



    # print(fig)
    # return(list(df=data,fig=fig))
}

model_MSE = function(df, max_sentences=20, max_articles=3) {
    tmp = df %>% proc_data(max_sentences=max_sentences,max_articles=max_articles) 
    loess_model = loess(formula = days_since~predict, data=tmp)
    MSE = mean(loess_model$residuals^2)
    return(MSE)
}