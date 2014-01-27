count <- function(cause = NULL) {
    ## Check that 'cause' os non-NULL, else throw an error
    if(is.null(cause)){
        stop('Cause should not be NULL value.')
    }
    ## Check that specific 'cause' is allowed, else throw an error
    r <- '[(shooting)|(blunt force)|(other)|(stabbing)|(unknown)|(shooting)]'
    if(length(grep(r, cause)) == 0){
        stop('Invalid cause.')
    }
    homi <- readLines('homicides.txt')
    homi <- tolower(homi)
    p <- paste('<dd>cause: ', cause, '</dd>', sep='')
    #print(p)
    res <- length(grep(p, homi))
    return(res)

} ## end function count
