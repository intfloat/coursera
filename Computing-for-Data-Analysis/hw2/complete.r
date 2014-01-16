
complete <- function(directory, id = 1:332) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'id' is an integer vector indicating the monitor ID numbers
        ## to be used
        
        ## Return a data frame of the form:
        ## id nobs
        ## 1  117
        ## 2  1041
        ## ...
        ## where 'id' is the monitor ID number and 'nobs' is the
        ## number of complete cases
        nobs <- c()
        for(i in id){
            if(nchar(i)==1)
                i <- paste('00', i, sep='')
            else if(nchar(i)==2)
                i <- paste('0', i, sep='')
            # get the full name of csv file
            name <- paste(directory, '/', i, '.csv', sep='')
            counter <- 0
            data <- read.csv(name)
            row <- nrow(data)
            # use logical and operation on vectors
            t1 <- !is.na(data[, 'sulfate']) & !is.na(data[,'nitrate'])
            counter <- sum(t1)
            nobs <- c(nobs, counter)
        } # end for loop

        # generate a data frame as final result
        res <- data.frame(id=id, nobs=nobs)
        return(res)
} # end complete function

