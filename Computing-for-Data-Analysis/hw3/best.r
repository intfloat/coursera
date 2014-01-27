best <- function(state, outcome) {
    
    ## Read outcome data
    data <- read.csv('outcome-of-care-measures.csv', colClasses='character')
    ## Check that state and outcome are valid
    reason <- c('heart attack', 'heart failure', 'pneumonia')
    index <- c(11, 17, 23)
    data[, 11] <- as.numeric(data[, 11])
    data[, 17] <- as.numeric(data[, 17])
    data[, 23] <- as.numeric(data[, 23])
    ## Return hospital name in that state with lowest 30-day death    
    ## rate
    if(!state %in% data$State){
        stop('invalid state')
    }
    else if(!outcome %in% reason){
        stop('invalid outcome')
    }
    else{
        result <- ''
        # index start from 1
        for(i in 1:3){
            if(outcome == reason[i]){
                sel <- data[data$State == state, ]
                attack <- sel[, index[i]]
                min <- min(attack, na.rm = T)
                pos <- which(attack==min)
                result <- sel[, 2][pos]
            } # end if clause
        } # end for loop
        #if(outcome == reason[1]){
        #}
        #if(outcome == reason[])
        return(result)
    } # end else clause

} # end function best
