library(rpart)
library(caTools)
library(tm)

raw = read.csv('~/Desktop/FOIA/rich_foia_master_filtered3.csv', header = TRUE, as.is = T)


## To calculate statistics for all agencies while accounting for the fact that available data had a different number of
## requests from each, we sampled from our records 1,000 times, calculated the statistic for each sample
## and averaged across those sample statistics.


# To calculate statistics across agencies:

# Instantiate an empty vector.
mean_vector = c()

# Resampling 1,000 times...
for (x in 1:1000){
  # Take equally-sized samples from each agency.
  EPA_sample = raw[sample(which(raw$X_agency=='EPA'), 258), ]
  DOC_sample = raw[sample(which(raw$X_agency=='DOC'), 258), ]
  CBP_sample = raw[sample(which(raw$X_agency=='CBP'), 258), ]
  DON_sample = raw[sample(which(raw$X_agency=='DON'), 258), ]
  NARA_sample = raw[sample(which(raw$X_agency=='NARA'), 258), ]
  
  # Bind the samples into a dataframe.
  data = rbind.data.frame(EPA_sample, DOC_sample, CBP_sample, DON_sample, NARA_sample)
  
  # Calculate the statistic and append to vector.
  mean = cor(data$specificity, data$hyperlink)
  mean_vector = c(mean_vector, mean)
}

# Calculate average of vector.
mean(mean_vector)

################################

# To create a 2x2 table showing what percentage of successes/failures across all agencies exhibited a characteristic:

no_vector = c()
yes_vector = c()
for (x in 1:1000) {
  tbl = table(data$hyperlink == 1, data$bi_strict)
  
  no_zero = tbl[1][1]
  no_total = length(data[data$hyperlink == 0,]$hyperlink)
  no_one = no_total - no_zero
  
  yes_zero = tbl[2][1]
  yes_total = length(data[data$hyperlink == 1,]$hyperlink)
  yes_one = yes_total - yes_zero
  
  no_vector <<- c(no_vector, (no_one / no_total))
  yes_vector <<- c(yes_vector, (yes_one / yes_total))
  
  EPA_sample = raw[sample(which(raw$X_agency=='EPA'), 258), ]
  DOC_sample = raw[sample(which(raw$X_agency=='DOC'), 258), ]
  CBP_sample = raw[sample(which(raw$X_agency=='CBP'), 258), ]
  DON_sample = raw[sample(which(raw$X_agency=='DON'), 258), ]
  NARA_sample = raw[sample(which(raw$X_agency=='NARA'), 258), ]
  data = rbind.data.frame(EPA_sample, DOC_sample, CBP_sample, DON_sample, NARA_sample)
  
  }

mean(no_vector)
mean(yes_vector)

################################

# To create a 2x2 table showing what percentage of successes/failures in a single agency exhibited a characteristic:

EPA_noID = df_all[df_all$id == 0,]

tbl = table(EPA_noID$date == 1, EPA_noID$bi_strict)
  
no_zero = tbl[1][1]
no_total = sum(EPA_noID$date == '0')
no_one = no_total - no_zero
  
yes_zero = tbl[2][1]
yes_total = sum(EPA_noID$date == '1')
yes_one = yes_total - yes_zero
  
no_one / no_total
yes_one / yes_total
