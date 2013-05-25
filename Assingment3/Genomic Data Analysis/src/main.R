# setwd("~/Online Courses/Coursera/Web Inteligence and Big Data/Assingment3")
# require("ProjectTemplate")
# create.project()

setwd("~/Online Courses/Coursera/Web Inteligence and Big Data/Assingment3/Genomic Data Analysis")
require("ProjectTemplate")
wd <- getwd()

#initial data uploading
DTB <- read.table(file=paste0(wd,'/data/', 'genestrain.tab'),header=FALSE,skip=3,sep='\t',stringsAsFactors=TRUE)

#given that initial data uploading takes eternity, i need to save my time here
#caching the stuff, i do it from time to time when i munge data becauseprocedures are very time-consuming
save(list=ls(pattern='DTB'), file=paste0(wd,'/cache/', 'DTB.RData'))
load(file=paste0(wd,'/cache/', 'DTB.RData') )

save(list=ls(pattern='model'), file=paste0(wd,'/cache/', 'Models.RData'))
load(file=paste0(wd,'/cache/', 'Models.RData') )
?ls


#get acquantied

str(DTB[,1:10])

#already done
colnames(DTB)[1] <-'race'

# cast every column in single format 

#already done
DTB[,1]<-factor( x=as.character( DTB[,1] ) , levels=c('CEU','GIH','JPT','ASW','YRI'), labels=c(0,1,2,3,4) )

# decide how to deal with missing observations
# may consider them to be another factor

#done
for (i in 2:204356 ){
  DTB[,i] <- factor( x=as.character( DTB[,i] ),levels=c("?","0","1")   )
}

#done
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
# did not use subset eventually

# for each possible class
  # build the classification tree
  
  

  model0<-rpart(DTB$race0 ~., data=DTB[,2:1000],xval=2, maxsurrogate=0)
  model1<-rpart(DTB$race1 ~., data=DTB[,2:1000],xval=2, maxsurrogate=0)
  model2<-rpart(DTB$race2 ~., data=DTB[,2:1000],xval=2, maxsurrogate=0)
  model3<-rpart(DTB$race3 ~., data=DTB[,2:1000],xval=2, maxsurrogate=0)
  model4<-rpart(DTB$race4 ~., data=DTB[,2:1000],xval=2, maxsurrogate=0)


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
# it was observed that this variable makes the whole prediction
for ( i in 1:dim(DTB)[1]  ){
  # need to weight a little bit
  DTB$pred[i] <- which.max( c(DTB$race0pred[i],DTB$race1pred[i],DTB$race2pred[i],DTB$race3pred[i],DTB$race4pred[i] ) ) -1  
}


DTB$pred

#show missclassification error both for train and test set of mine
sum(DTB$race != DTB$pred)
# 100% works

# serialize the model
# decide to not automatize this stuff


#apply the prediction mechanism for new data
DTB_test <- read.table(file=paste0(wd,'/data/', 'genesblind.tab'),header=FALSE,skip=3,sep='\t',stringsAsFactors=TRUE)


#below you literally see copy_past of chunks above
#never heard of DRY principal )

#just cheack what have I uploaded
str(DTB_test[,1:10])

colnames(DTB_test)[204356]
colnames(DTB)[204356]

# first column is empty as expected,
# factors already done so probably do not need next step
# however once i run prediction, i got error about factors, therefore converting is neceessary

# use only  1st thousand as during modeling
for (i in 2:1000 ){
  DTB_test[,i] <- factor( x=as.character( DTB_test[,i] ),levels=c("?","0","1")   )
}

# run prediction


DTB_test$race0pred <- predict( model0, newdata=DTB_test[,2:1000])
DTB_test$race1pred <- predict( model1, newdata=DTB_test[,2:1000])
DTB_test$race2pred <- predict( model2, newdata=DTB_test[,2:1000])
DTB_test$race3pred <- predict( model3, newdata=DTB_test[,2:1000])
DTB_test$race4pred <- predict( model4, newdata=DTB_test[,2:1000])

#> traceback()
# #4: stop(gettextf("variables %s were specified with different types from the fit", 
#                  paste(sQuote(names(old)[wrong]), collapse = ", ")), call. = FALSE, 
#         domain = NA)
# 3: .checkMFClasses(cl, newdata, TRUE)
# 2: predict.rpart(model0, newdata = DTB_test[, 2:1000])
# 1: predict(model0, newdata = DTB_test[, 2:1000])


# i do not know how to fix this bug, therfore it would takes time
# however given the fact i have 11 observetion and models with single variable
# i can compute prediction manually

pred_for_submission <- mat.or.vec(nc=11,nr=1)
pred_for_submission <- rep(-1, times=11)
pred_for_submission

# for ( i in 1:dim(DTB_test)[1]  ){
#   # need to weight a little bit
#   DTB_test$pred[i] <- which.max( c(DTB_test$race0pred[i],DTB_test$race1pred[i],DTB_test$race2pred[i],DTB_test$race3pred[i],DTB_test$race4pred[i] ) ) -1  
# }


#make submission

summary(model0)

DTB_test$V10
DTB_test$V26

pred_for_submission[c(1:4,8)] <- 0

summary(model1)
DTB_test$V155

pred_for_submission[c(10)] <- 1

summary(model2)

DTB_test$V412
DTB_test$V425

pred_for_submission[c(9)] <- 2

summary(model3)

# actually no single variable with 100 % prediction,
# probablit there exists, but i used onlt 1st thousan variable
# skip for a while

summary(model4)

DTB_test$V145

pred_for_submission[c(6,7)] <- 4

# everythin else would be predicted as 3
pred_for_submission[pred_for_submission == -1] <- 3


pred_for_submission
write.table(x=pred_for_submission, quote = FALSE, row.names = FALSE, col.names = FALSE ,eol=' ',sep=' ',file=paste0(wd,'/reports/', 'result.txt') )


# submitted rsults, got 10 out of 10.

