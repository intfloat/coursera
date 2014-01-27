rankall <- function(outcome, num='best'){
    ## Read outcome data
    data <- read.csv('outcome-of-care-measures.csv', colClasses='character')
    reason <- c('heart attack', 'heart failure', 'pneumonia')
    index <- c(11, 17, 23)
    ## Check that outcome is valid
    if(!outcome %in% reason){
        stop('invalid outcome')
    }
    states <- sort(unique(data$State))
    num_of_state <- length(states)
    hospitals <- rep('', num_of_state)
    ## For each state, find the hospital of given rank
    
    ## iterate over every state
    for(i in 1:num_of_state){
        ## iterate over everu possible reason
        sel <- data[data$State == states[i], ]
        for(j in 1:3){
            if(reason[j] == outcome){
                attack <- as.numeric(sel[, index[j]])
                len <- dim(sel[!is.na(attack), ])[1]
                if(num=='best'){
                    pos <- 1
                }
                else if(num=='worst'){
                    pos <- len
                }
                else{
                    pos <- num
                }
                if(pos > len){
                    hospitals[i] <- NA
                }
                else{
                    hospitals[i] <- sel[, 2][order(attack, sel[, 2])[pos]]
                }
            }
        }## end internal for loop
    } ## end external for loop
    result <- data.frame(hospital = hospitals, state = states)
    ## Return a data frame with the hospital names and the state name
    return(result)
} ## end function rankall
