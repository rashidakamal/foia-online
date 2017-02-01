library(rpart)
library(caTools)
library(tm)

raw = read.csv('~/Desktop/FOIA/rich_foia_master_filtered3.csv', header = TRUE, as.is = T)

# Take equally-sized samples from each agency.
EPA_sample = raw[sample(which(raw$X_agency=='EPA'), 258), ]
DOC_sample = raw[sample(which(raw$X_agency=='DOC'), 258), ]
CBP_sample = raw[sample(which(raw$X_agency=='CBP'), 258), ]
DON_sample = raw[sample(which(raw$X_agency=='DON'), 258), ]
NARA_sample = raw[sample(which(raw$X_agency=='NARA'), 258), ]

# Bind the samples into a dataframe.
data = rbind.data.frame(EPA_sample, DOC_sample, CBP_sample, DON_sample, NARA_sample)

# Select the columns we're interested in.
derived_df = data[,c(16:19, 22:24, 26:33, 35, 37)]

# Find what words appear in requests
corpus = Corpus(VectorSource(data$lemmatized_body))
#Create a matrix showing how often each word appeared in each request.
control = list(weighting = function(x) weightBin(x), stopwords = TRUE)
dtm = DocumentTermMatrix(corpus, control = control)
# Clean up the matrix, removing empty cells.
dtm = removeSparseTerms(dtm, 0.95)
# Convert matrix into a dataframe.
dtm_df = as.data.frame(as.matrix(dtm))

# Make sure the dataframes look like they should.
head(derived_df)
tail(derived_df)
head(dtm_df)
tail(dtm_df)

# Combine dataframe of derived variables with document-term matrix.
df_all = cbind.data.frame(derived_df, dtm_df)

# Fit a decision tree.
fit_all = rpart(bi_strict ~.-duration, data = df_all, method = "class", control = rpart.control(cp = 0.005))

# Plot the tree.
plot(fit_all)
text(fit_all, use.n=T, cex = 0.5)
# Get summary information.
summary(fit_all)