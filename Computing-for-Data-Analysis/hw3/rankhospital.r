rankhospital <- function(state, outcome, num = 'best'){
    ## Read outcome data
    data <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')
    reason <- c('heart attack', 'heart failure', 'pneumonia')
    index <- c(11, 17, 23)
    s <- data[data$State==state, ]
    
    ## Check that state and outcome are valid
    if(!state %in% data$State){
        stop('invalid state')
    }
    else if(!outcome %in% reason){
        stop('invalid outcome')
    }
    else{
        if(num=='best'){
            num <- 1
        }
        for(i in 1:3){
            if(reason[i]==outcome){
                sel <- as.numeric(s[, index[i]])
                # number of rows
                len <- dim(s[!is.na(sel), ])[1]
                if(num=='worst'){
                    num <- len
                }
                if(num > len){
                    result <- NA
                }
                else{
                    result <- s[, 2][order(sel, s[, 2])[num]]
                }
                #result <- data[, 2]
            }# end if clause
        } # end for loop
        return(result)
    }

    ## Return hospital name in that state with the given rank
    ## 3-day death rate

} # end fucntion rankhospital
