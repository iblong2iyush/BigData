# setwd("~/Online Courses/Coursera/Web Inteligence and Big Data/Assingment3")
# require("ProjectTemplate")
# create.project()

require("ProjectTemplate")
wd <- setwd("~/Online Courses/Coursera/Web Inteligence and Big Data/Assingment3/Genomic Data Analysis")

#initial data uploading
DTB <- read.table(file=paste0(wd,'/data/', 'genestrain.tab'),header=FALSE,skip=3,sep='\t',stringsAsFactors=TRUE)

#caching the stuff
save(DTB, file=paste0(wd,'/cache/', 'DTB.RData'))
load(file=paste0(wd,'/cache/', 'DTB.RData') )


# decide how to deal with missing observations
# may consider them to be another factor

# create binary feature for each class

# separate dtb into train and test of mine
# probablity need stratified sample because of class sparsities

# for each possible class
  # build the classification tree

  # test each of this tree on test dataset of mine
  # validate the tree

#combine 5 algorithms in single
  #each tree returns probability
  #ultimate prediction is argmax

#show missclassification error both for train and test set of mine

# serialize the model

#apply the prediction mechanism for new data
     
#make submission






