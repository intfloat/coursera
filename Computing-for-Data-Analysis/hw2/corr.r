corr <- function(directory, threshold = 0) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'threshold' is a numeric vector of length 1 indicating the
        ## number of completely observed observations (on all
        ## variables) required to compute the correlation between
        ## nitrate and sulfate; the default is 0

        ## Return a numeric vector of correlations

        # get all file name in given directory
        files <- list.files(directory)
        result <- c()

        # iterate over every file
        for(f in files){
            name <- paste(directory, '/', f, sep='')
            data <- read.csv(name)
            pos <- ((!is.na(data[, 'sulfate'])) & (!is.na(data[, 'nitrate'])))
            data <- data[pos, ]
            if(nrow(data) <= threshold)
                next
            result <- c(result, cor(data[,'sulfate'], data[, 'nitrate']))
        } # end for loop

        return(result)
} # end function corr

