# Setup project
source("setup.R")
library(ggforce)

#### Data Import #####

#import data as lazy data.table, with "N/A" as NA
cfpb.df <- lazy_dt(read_csv(list.files(rawdata.path,full.names = TRUE)[1],
                            na = c("","NA","N/A")))



#### Initial Data Exploration ####
cfpb.df %>% glimpse

## Missing data

# Count missing data and save NA column names
naCols <- cfpb.df %>% summarise(across(.fns=~sum(is.na(.x)))) %T>% 
  glimpse %>% as.data.frame %>% select(where(~sum(.x)>0)) %>%
  names


#Plot percent missing data by month  
cfpb.df %<>%
  mutate(Month_received = round_date(`Date received`,unit="month"))

cfpb.df %>% 
  select(all_of(naCols),
         Month_received) %>%
  pivot_longer(cols=!Month_received,names_to="column") %>%
  group_by(column,Month_received) %>%
  summarise(countNA = sum(is.na(value)),
            total = n()) %>%
  mutate(`Percent NA` = round(countNA/total*100,0)) %>%
  as_tibble %>%
  ggplot(aes(x=Month_received,y=`Percent NA`)) + 
  geom_step() + facet_wrap(vars(column),
                           ncol=2,
                           scales="free_y") +
  scale_x_date(labels=date_format("%b %y"),date_breaks="1 year") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) 

## Companies ##


#Distribution of # of complaints by company
compl_by_comp.df <- cfpb.df %>%
  count(Company,sort=TRUE) %>% rename(`# complaints` = n) %>%
  as_tibble 

comp_fig <- compl_by_comp.df %T>% 
  print %>% ggplot(aes(x=`# complaints`)) + geom_rug() + geom_histogram() +
  scale_x_continuous(labels=label_number(scale_cut=cut_short_scale())) +
  ylab("count of companies")

plot(comp_fig)

#Count of complaints per company - quantiles
company_quants <- sort(c(seq(0.1,0.9,0.1),c(0.95,0.99)))

compl_by_comp.df %>%
  summarise(`# complaints` = quantile(`# complaints`,company_quants),
                            quantile=company_quants) %>%
  kbl() %>% kable_paper(full_width=F)


# 10 most frequent # of complaints per company
compl_by_comp.df %>% 
  group_by(`# complaints`) %>%
  summarize(`count companies` = n()) %>%
  mutate(`percent companies` = `count companies`/sum(`count companies`),
         `percent companies` = 
           label_percent(accuracy = 0.1)(`percent companies`)) %>%
  arrange(desc(`count companies`)) %>%
  slice_head(n=10) %>%
  kbl() %>% kable_paper(full_width=F)
 

# Truncated histogram of # of complaints per company

compl_by_comp.df %>% 
  filter(`# complaints` < 200 ) %>%
  ggplot(aes(x=`# complaints`)) + geom_rug() + geom_histogram() +
  scale_x_continuous(labels=label_number(scale_cut=cut_short_scale())) +
  ylab("count of companies")



