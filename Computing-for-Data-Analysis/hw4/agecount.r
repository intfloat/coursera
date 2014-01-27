
agecount <- function(age = NULL) {
    ## Check that 'age' is non-NULL; else throw error
    if(is.null(age)){
        stop('age should not be NULL value')
    }
    ## Read 'homicides.txt' data file
    data <- readLines('homicides.txt') 
    ## Extract ages of victims
    p <- paste(' ', age, ' years old</dd>', sep='')
    ## Return integer containing count of homicides for that age
    res <- length(grep(p, data))
    return(res)

} ## end function agecount
