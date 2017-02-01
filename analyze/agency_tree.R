library(rpart)
library(caTools)
library(tm)

raw = read.csv('~/Desktop/FOIA/rich_foia_master_filtered3.csv', header = TRUE, as.is = T)

# Filter out requests made to other agencies.
data = raw[raw$X_agency == 'EPA',]

# Select the columns we're interested in.
derived = data[c(16:19, 22:24, 26:33, 35, 37)]

# Find what words appear in requests
corpus = Corpus(VectorSource(data$lemmatized_body))
#Create a matrix showing how often each word appeared in each request.
control = list(weighting = function(x) weightBin(x), stopwords = TRUE)
dtm = DocumentTermMatrix(corpus, control = control)
# Clean up the matrix, removing empty cells.
dtm = removeSparseTerms(dtm, 0.95)
# Convert matrix into a dataframe.
dtm_df = as.data.frame(as.matrix(dtm))

# Combine dataframe of derived variables with document-term matrix.
df_all = cbind.data.frame(derived_df, dtm_df)

# Fit a decision tree.
fit_all = rpart(bi_strict ~.-duration, data = df_all, method = "class", control = rpart.control(cp = 0.005))

# Plot the tree.
plot(fit_all)
text(fit_all, use.n=T, cex = 0.5)
# Get summary information.
summary(fit_all)