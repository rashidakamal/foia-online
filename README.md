# Analysis related to FOIA Online Database. 

[CJR - What makes a good FOIA request? We studied 33,000 to find out.](http://www.cjr.org/analysis/foia-request-how-to-study.php)

+ Code by Nic & Rashida

**1/31/2017**: We're hoping to have all of our code up tonight. Important note: the current "analysis" notebook is not what the conclusions of our article are based on, but rather, simpler "gut-checks" to poke through the data, guided by some of the terms that came up in our text analysis and decision tree analysis. That code will be posted shortly! 

---

We scraped all requests for years 2011 through 2016 available at [https://foiaonline.regulations.gov/](https://foiaonline.regulations.gov/) and filtered out requests that were still under agency review.

Two categories of features were considered: ones we derived ourselves and others indicating the presence of specific word in a request. We stemmed words using a lemmatizer before generating a document-term matrix. Below is a complete list of our derived features:

+ Character count
+ Word count
+ Sentence count
+ Average sentence length
+ Whether the request mentioned the Freedom of Information Act
+ Whether the request mentioned fulfillment fees
+ Whether the request included a phone number
+ Whether the request included a hyperlink
+ Whether the request included an email address
+ Whether the request included a date
+ Whether the request made a reference to place
+ A readability score derived from character, word and sentence counts
+ Whether the request mentioned strings associated with data, like data formats
+ A specificity score, which amounts to the number of groups of nouns
+ Whether the request included an EPA identification number

We used decision trees as a first step in our search for important features. 

Two methods of classifying requests were used. One limited our definition of a successful request to full grants. Another additionally considered partial grants to be successes. We did not observe a significant difference in our decision trees when switching our method of classification. This is likely because the number of partial requests was low. In light of this lack of difference, we used our stricter definition of success.

When trying to draw conclusions about FOIA requests in general--that is, across all agencies--we had to account for the fact that the FOIAOnline database had more requests from some agencies. We did this by repeatedly (1,000 times) taking equally-sized samples from each agency. A more detailed description of how we did this can be found in the comments of our R scripts.


