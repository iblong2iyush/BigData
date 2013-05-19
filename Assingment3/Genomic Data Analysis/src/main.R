# setwd("~/Online Courses/Coursera/Web Inteligence and Big Data/Assingment3")
# require("ProjectTemplate")
# create.project()

setwd("~/Online Courses/Coursera/Web Inteligence and Big Data/Assingment3/Genomic Data Analysis")
require("ProjectTemplate")
wd <- getwd()

#initial data uploading
DTB <- read.table(file=paste0(wd,'/data/', 'genestrain.tab'),header=FALSE,skip=3,sep='\t',stringsAsFactors=TRUE)

#caching the stuff
save(DTB, file=paste0(wd,'/cache/', 'DTB.RData'))
load(file=paste0(wd,'/cache/', 'DTB.RData') )

save(list=ls(pattern='model'), file=paste0(wd,'/cache/', 'Models.RData'))
load(file=paste0(wd,'/cache/', 'Models.RData') )
?ls


#get acquantied

str(DTB[,1:10])

colnames(DTB)[1] <-'race'

# cast every column in single format 

DTB[,1]<-factor( x=as.character( DTB[,1] ) , levels=c('CEU','GIH','JPT','ASW','YRI'), labels=c(0,1,2,3,4) )

# decide how to deal with missing observations
# may consider them to be another factor

for (i in 2:204356 ){
  DTB[,i] <- factor( x=as.character( DTB[,i] ),levels=c("?","0","1")   )
}


# create binary feature for each class
DTB$race0 <- ( DTB$race==0)
DTB$race1 <- ( DTB$race==1) 
DTB$race2 <- ( DTB$race==2)
DTB$race3 <- ( DTB$race==3)
DTB$race4 <- ( DTB$race==4)

# separate dtb into train and test of mine
# probablity need stratified sample because of class sparsities
set.seed(123234)
ind <- sample.int(n=139, size=100, replace=FALSE)

# for each possible class
  # build the classification tree
  
  

  model0<-rpart(DTB$race0 ~., data=DTB[,2:1000],xval=2, subset=ind,maxsurrogate=0)
  model1<-rpart(DTB$race1 ~., data=DTB[,2:1000],xval=2, subset=ind,maxsurrogate=0)
  model2<-rpart(DTB$race2 ~., data=DTB[,2:1000],xval=2, subset=ind,maxsurrogate=0)
  model3<-rpart(DTB$race3 ~., data=DTB[,2:1000],xval=2, subset=ind,maxsurrogate=0)
  model4<-rpart(DTB$race4 ~., data=DTB[,2:1000],xval=2, subset=ind,maxsurrogate=0)


  # test each of this tree on test dataset of mine
  # validate the tree

#combine 5 algorithms in single
  #each tree returns probability
  DTB$race0pred <- predict( model0, newdata=DTB[,2:1000])
  DTB$race1pred <- predict( model1, newdata=DTB[,2:1000])
  DTB$race2pred <- predict( model2, newdata=DTB[,2:1000])
  DTB$race3pred <- predict( model3, newdata=DTB[,2:1000])
  DTB$race4pred <- predict( model4, newdata=DTB[,2:1000])
  
  #ultimate prediction is argmax
for ( i in 1:dim(DTB)[1]  ){
  DTB$pred[i] <- which.max( c(DTB$race0pred[i],DTB$race1pred[i],DTB$race2pred[i],DTB$race3pred[i],DTB$race4pred[i] ) ) -1  
}

#show missclassification error both for train and test set of mine

# serialize the model

#apply the prediction mechanism for new data
     
#make submission






