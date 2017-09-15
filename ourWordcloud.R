######## Last update KevCaz 14-09-2017

####----- Packages
library(tm)
library(wordcloud2)
library(magrittr)
library(htmlwidgets)
library(webshot)


###################

####----- Text Mining
# Text mining reference: http://onepager.togaware.com/TextMiningO.pdf
# the bash code below should be executed in your terminal when a new publication
# is added in the dropbox folder:
# for f in ~/Dropbox/LetiR/publi/*.pdf; pdftotext -enc ASCII7 -nopgbrk $f"
docs <- Corpus(
  DirSource(
    directory = "~/Dropbox/LetiR/publi",
    pattern="*.txt")
    )
###################
# inspect(docs[1])
# getTransformations()
stopwords_pers <-  c(
  "hence", "since", "university", "can", "also", "null", "using", "may",
  "first", "will", "one", "two", "three", "fig", "tab", "eqn", "therefore",
  "gravel", "des", "although", "aij", "clearly", "cazelles", "araujo", "lett",
  "res", "thuiller", "biol"
  )
docs %<>% tm_map(content_transformer(tolower))
docs %<>% tm_map(removeNumbers)
docs %<>% tm_map(removePunctuation)
docs %<>% tm_map(removeWords, stopwords("english"))
docs %<>% tm_map(removeWords, stopwords_pers)
substit <- content_transformer(function(x, from, to) gsub(from, to, x))
docs %<>% tm_map(substit, from="species distribution model ", to="sdm ")
docs %<>% tm_map(substit, from="species distribution models ", to="sdm ")
docs %<>% tm_map(substit, from="model ", to="models ")
docs %<>% tm_map(substit, from="probabilities", to="probability")
docs %<>% tm_map(substit, from="probabilistic", to="probability")
docs %<>% tm_map(substit, from="theories", to="theory")
docs %<>% tm_map(substit, from="network ", to="networks ")
docs %<>% tm_map(substit, from="distribution ", to="distributions ")
docs %<>% tm_map(substit, from="ecol ", to="ecology ")
docs %<>% tm_map(substit, from="SDMs", to="SDM")
###################
# cat("*Wourdcloud to be added* <br/><br/>")
dtm <- DocumentTermMatrix(docs)
freq <- colSums(as.matrix(dtm))
datdoc <- data.frame(word = names(freq), freq = freq)
datdoc <- datdoc[rev(order(datdoc$freq)), ]
datext <- data.frame(
  word = c("R", "Open-data", "Open-Science", "Markdown", "Latex", "Python", "C/C++", "Web", "Javascript", "Julia"),
  freq = c(400, 320, 340, 280, 150, 150, 150, 150, 150, 100)
  )
## Combine the dataset / order and keeb the 500 more frequent words
dat <- rbind(datext, datdoc)
dat <- dat[rev(order(dat$freq)),]
dat <- dat[1:1000,]
# print(head(dat))



###################

#####------ Creating the wordcloud

### NB: there is a pb with the use of mask.... you need to refresh a couple
### of time before getting the wordcloud... which prevent webshot from
### working well...
### See https://github.com/Lchiffon/wordcloud2/issues/12
# imgwc <- "assets/img/butterfly.png"
# imgwc <- "assets/img/favicon.png"
imgwc <- paste0(getwd(),"/img/tortue.png")
wc_aut <- wordcloud2(dat, figPath=imgwc, size = 1, color="black", backgroundColor="white")
##
saveWidget(wc_aut, "./ourWordcloud.html", selfcontained = TRUE)
## convert into png
# webshot("ourWordcloud.html", "img/ourWordcloud.png", delay = 10)
