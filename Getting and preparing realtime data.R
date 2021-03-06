# ------------------------------------------------------------------------
# Starting values (do not comment) ---------------------------------------------------------
# ------------------------------------------------------------------------
# wd='H:/Fred'
wd='C:/Users/Dirk/Documents/GitHub/bubblesbreakdowns'
wd='h:/git/bubblesbreakdowns'
setwd(wd)
dir.rt=paste(wd,'/data',sep='')
#
# # ------------------------------------------------------------------------
# # Downloading and storing Data ---------------------------------------------------------
# # ------------------------------------------------------------------------
#
# library("XLConnect")
# library("xlsx")
#
# dir.create(dir.rt)
#
#
# # searching the index page of data base -----------------------------------
#
# startaddress='http://www.philadelphiafed.org/research-and-data/real-time-center/real-time-data/data-files/'
# fileaddress=paste(startaddress,'files/',sep='')
# starthtml=readLines(startaddress)
# # write.csv(starthtml,'starthtml.txt') # for inspection of starthtml only
#
# variable_index=regexec(paste('\\(','([A-Z]+)','\\)',sep=''),starthtml)
# variable_vector=regmatches(starthtml,variable_index)#[[1]][2]
#
# for (i in length(variable_vector):1){
# if (length(variable_vector[[i]])==0){variable_vector[[i]]=NULL}
# }
# rm(i)
# variables=sapply(variable_vector,function(x) x[[2]])
# rm(variable_index,variable_vector,starthtml)
# variables=unique(variables)
# nvar=length(variables)
#
#
# # downloads all files -----------------------------------------------------
#
# for (j in 1:nvar){
# dir.var=paste(dir.rt,'/',variables[j],sep='')
# dir.create(dir.var)
#
# varaddress=paste(startaddress,variables[j],sep='')
# varhtml=readLines(varaddress)
# # write.csv(varhtml,'varthtml.txt')
#
# zip_index=regexec(paste('/','(.*)','.zip',sep=''),varhtml)
# zip_index=regexec(paste('([A-Za-z0-9\\_]{1,}\\.zip[x]?)',sep=''),varhtml)
#
# zip_vector=regmatches(varhtml,zip_index)#[[1]][2]
# nonzeros=sapply(zip_vector, function(x)length(x)!=0)
# zip=zip_vector[nonzeros]
# zip=sapply(zip,function(x) x[[1]])
#
# if (length(zip)!=0){
# download.file(paste(fileaddress,zip,sep='')
# , paste(dir.var,'/',zip,sep='')
# ,mode='wb')
# unzip(paste(dir.var,'/',zip,sep=''),exdir=dir.var)
# }else{
# xls_index=regexec(paste('/','(.*)','.xl',sep=''),varhtml)
# xls_index=regexec(paste('([A-Za-z0-9\\_]{1,}\\.xls[x]?)',sep=''),varhtml)
#
# xls_vector=regmatches(varhtml,xls_index)#[[1]][2]
# nuller=sapply(xls_vector, function(x)length(x)==0)
# xls=xls_vector[nuller!=T]
# xls=sapply(xls,function(x) x[[1]])
# # grep(,xls)
# # write.csv(xls_vector,'varhtml.txt')
# for (i in 1:length(xls)){
# download.file(paste(fileaddress,xls[i],sep='')
# , paste(dir.var,'/',xls[i],sep='')
# ,mode='wb')
# }
# }
# }
#
# # Failed download? --------------------------------------------------------
#
# variables_downloaded=list.files(paste(dir.rt))
# not_downl=match(variables,variables_downloaded)
# variables[which(is.na(not_downl)==T)]
#
# # Reading files, binding files of each variable together ------------------
# no_mth_variables=character(0)
# for (j in 1:nvar){
# # if (variables[j]=="EMPLOY"){next}
# dir.var=paste(dir.rt,'/',variables[j],sep='')
# files=list.files(dir.var)
# # restricting the process on monthly variables
# mfiles=files[grep('MvMd',files)]
# # taking care of zip files
# if (length(grep('zip',mfiles))!=0){
# mfiles=mfiles[-grep('zip',mfiles)]
# }
# if (length(mfiles)==0){
# no_mth_variables=c(no_mth_variables,variables[j])
# warning(paste('no monthly data available for ',variables[j],sep=''))
# next
# }
# cleanmfiles=gsub('[0-9]','',mfiles)
# varname=unique(cleanmfiles)
# # taking care of zip files
# if (length(grep('zip',varname))!=0){
# varname=varname[-grep('zip',varname)]
# }
# if (length(mfiles)==1){
# # only one file
# df=read.xlsx2(paste(dir.var,'/',varname,sep=''),sheetIndex=1,row.names=1)
# eval(parse(text=paste(variables[j],'=df',sep='')))
# }else{
# # more than one file
#
# if(length(varname)>1){warning('not only one variable')}
#
# varname=gsub('\\.xls','',varname)
# numfiles=gsub(varname,'',mfiles)
# numfiles=gsub('\\.xls','',numfiles)
# numfiles=max(as.numeric(numfiles))
#
# for (i in 1:numfiles){
# df_add=read.xlsx2(paste(dir.var,'/',varname,i,'.xls',sep=''),sheetIndex=1,row.names=1)
# if (i==1){
# df=df_add
# }else{
# if (nrow(df)!=nrow(df_add)){
# df_dates=row.names(df)
# df_add_dates=row.names(df_add)
# matchdates=match(df_add_dates,df_dates)
# add_dates=df_add_dates[which(is.na(matchdates)==T)]
# add_lines=df[1:length(add_dates),]
# add_lines[1:length(add_dates),]=NA
# row.names(add_lines)=add_dates
# df=rbind(df,add_lines)
# }
# df=cbind(df,df_add)
# }
# if (i==numfiles){
# eval(parse(text=paste(variables[j],'=df',sep='')))
# }
# }
# }
# }
# # Needed repairs: EMPLOY 4 and CUM 2, zipped versions were all right.
#
#
# # Writes the compounded files to disk -------------------------------------
# list.compounded.variables=ls()
# list.compounded.variables=list.compounded.variables[grep('[A-Z]',list.compounded.variables)]
#
# list.compounded.variables=list.compounded.variables[-c(grep('wd',list.compounded.variables),grep('list.compounded.variables',list.compounded.variables))]
# for (variable in list.compounded.variables){
# cat(paste('write.csv(',variable,',\'',wd,'/',variable,'.csv\')',sep=''),file='out')
# # test=paste(wd,'/',variable,'.csv',sep='')
# eval(parse(file='out'))
# }
#
# eliminating non-numeric elements ----------------------------------------
# for (variable in variables){
#         aux=eval(parse(text=variable))
#         aux[aux=='#N/A']=NA
#         write.csv(aux,'test.csv')
#         aux=read.csv('test.csv',row.names=1)
#         eval(parse(text=paste(variable,'=aux',sep='')))
# }
# save.image(paste(wd,"/data/realtime.RData",sep=''))
#
# ------------------------------------------------------------------------
# Processing Data ---------------------------------------------------------
# ------------------------------------------------------------------------
load(paste(wd,"/data/realtime.RData",sep=''))
# checking availability of each variable ----------------------------------
# overview is a dataframe helping here
# variables=ls()
# variables=variables[grep('[A-Z]',variables)]
# overview=data.frame('nrows'=rep(NA,length(variables)),row.names=variables)
# startaddress='http://www.philadelphiafed.org/research-and-data/real-time-center/real-time-data/data-files/'
# for (variable in variables){
#         aux=eval(parse(text=variable))
#         overview[variable,'nrows']=nrow(aux)
#         overview[variable,'ncols']=ncol(aux)
#         overview[variable,'first obs']=row.names(aux)[1]
#         overview[variable,'first obs year']=as.numeric(strsplit(overview[variable,'first obs'],':')[[1]][1])
#         overview[variable,'first obs month']=as.numeric(strsplit(overview[variable,'first obs'],':')[[1]][2])
#         overview[variable,'last obs']=row.names(aux)[nrow(aux)]
#         overview[variable,'last obs year']=as.numeric(strsplit(overview[variable,'last obs'],':')[[1]][1])
#         overview[variable,'last obs month']=as.numeric(strsplit(overview[variable,'last obs'],':')[[1]][2])
#         overview[variable,'first vintage']=colnames(aux)[1]
#         overview[variable,'first vintage']=gsub(variable,'',overview[variable,'first vintage'])
#         overview[variable, 'first vintage year']=as.numeric(strsplit(overview[variable, 'first vintage'],'M')[[1]][1])
#         if (overview[variable, 'first vintage year']<=14){
#                 overview[variable, 'first vintage year']=overview[variable, 'first vintage year']+2000}else{
#                         overview[variable, 'first vintage year']=overview[variable, 'first vintage year']+1900}
#         overview[variable, 'first vintage month']=as.numeric(strsplit(overview[variable, 'first vintage'],'M')[[1]][2])
#         overview[variable,'last vintage']=colnames(aux)[ncol(aux)]
#         overview[variable,'last vintage']=gsub(variable,'',overview[variable,'last vintage'])
#         overview[variable, 'last vintage year']=as.numeric(strsplit(overview[variable, 'last vintage'],'M')[[1]][1])
#         if (overview[variable, 'last vintage year']<=14){
#                 overview[variable, 'last vintage year']=overview[variable, 'last vintage year']+2000}else{
#                         overview[variable, 'last vintage year']=overview[variable, 'last vintage year']+1900}
#         overview[variable, 'last vintage month']=as.numeric(strsplit(overview[variable, 'last vintage'],'M')[[1]][2])
#         varaddress=paste(startaddress,variable,sep='')
#         varhtml=readLines(varaddress)
#         name=varhtml[grep('title',varhtml)]
#         overview[variable,'description']=gsub('<title>||</title>||- historical real-time data - Philadelphia Fed','',name)
#         rm(name,varaddress,varhtml,aux)
# }
# rm(startaddress)


# some of the realtime data have not changed further back, say before 1998. 
# Thus, realtime data can be produced after this is checked for, adding more
# distant vintages using data, that has not changed over the existing vintages.
# didn't work out
# source('earliest.chg.R')
# for (variable in variables){
#         aux=earliest.chg(variable)
#         overview$first.lastunrevised[grep(variable,row.names(overview))]=aux[1]
#         overview$first.complete[grep(variable,row.names(overview))]=aux[2]
#         overview$first.change[grep(variable,row.names(overview))]=aux[3]
# }


# Getting rid of all variables that start in 1998 or later -------------
# (mainly household spending variables)
overview.complete=overview
overview=overview[overview$'first vintage year'<1998,]
variables=row.names(overview)
variables.rm=row.names(overview.complete[overview.complete$ncols<=64,])
rm(list=variables.rm)
overview=overview[order(overview$'first vintage year'),]

# resizing variables to the smallest common (vintage) sample --------------

# defining variable name and variable with smallest set of vintages
variable.smallest.name=row.names(overview)[which.min(overview$ncols)]
variable.smallest=eval(parse(text=variable.smallest.name))
vintages=colnames(variable.smallest)
vintages=gsub(variable.smallest.name,'',vintages)
for (variable in variables){
        colselection=paste(variable,vintages,sep='')
        comm=paste(variable,'=',variable,'[,colselection]',sep='')
        eval(parse(text=comm))
}

# creating specimen of nobs=maximum observations in a variable, and resizing dataframes -------------------------------------------------------
specimen.nrow=max(overview$nrows)
specimen.ncol=min(overview$ncol)
specimen=data.frame(matrix(NA,nrow=specimen.nrow,ncol=specimen.ncol))
colnames(specimen)=colnames(variable.smallest)
# attaching row.names of the variable with most observations
variable.obsmax.name=row.names(overview)[which.max(overview$nrows)]
variable.obsmax=eval(parse(text=variable.obsmax.name))
row.names(specimen)=row.names(variable.obsmax)
for (variable in variables){
        aux=eval(parse(text=variable))
        aux.specimen=specimen
        colnames(aux.specimen)=colnames(aux)
        aux.specimen[row.names(aux),colnames(aux)]=aux
        aux=aux.specimen
        eval(parse(text=paste(variable,'=aux',sep='')))
}


# Creating sets of vintages -----------------------------------------------
# vintage=vintages[10] # for testing purposes

vintage.extractor=function(variable,vintage){
        # extracts one specific vintage of a variable
        vintage.column=grep(vintage,colnames(specimen))
        aux=eval(parse(text=variable))[vintage.column]
        colnames(aux)=variable
        return(aux)
}
set.maker=function(vintage){
        # puts corresponding vintages of all variables together in one set
        aux=data.frame(matrix(NA,nrow=nrow(specimen),ncol=length(variables)))
        colnames(aux)=variables
        row.names(aux)=row.names(specimen)
        for (variable in variables){
                aux[,variable]=vintage.extractor(variable,vintage)
        }
        return(aux)
}

# creating a list containing all vintage sets -----------------------------
sets=vector('list',length=ncol(specimen))
names(sets)=vintages
for (vintage in vintages){
        sets[[vintage]]=set.maker(vintage)
}
write.csv(overview,'overview.csv')
# save(sets, file = "data/sets.RData")