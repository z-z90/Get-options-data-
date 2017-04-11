library(rjson)
# setwd("~/Documents/Projects /Implied Volatility/optionsdata_4:21:2017")

# Define function for formating/retrieving options data from json obj 
get.options = function(symbols, date){
  options = matrix(ncol = 11, nrow = length(symbols))
  colnames(options) = c('Cl_price', "call_strike", "call_lastPrice","call_vol","call_openInt", "call_ImpVoli", "put_strike","put_lastPrice", 'put_vol',"put_openInt", 'put_ImpVoli')
  rownames(options) = symbols
  for(u in 1:length(symbols)){
    s = symbols[u]
    d = as.numeric(as.POSIXct(date, origin = '1970-01-01', tz = 'GMT'))
    json_file <- sprintf('https://query2.finance.yahoo.com/v7/finance/options/%s?date=%d&formatted=true&crumb=UNus6VhY1bn&lang=en-US&region=US&corsDomain=finance.yahoo.com',s,d)
    json_data <- suppressWarnings(fromJSON(paste(readLines(json_file), collapse = "")))
      # CALLS
        n = length(json_data$optionChain$result[[1]]$options[[1]]$calls)
        if (n < 1) next
        calls = matrix(ncol = 6, nrow = n)
        for(i in 1:n) calls[,2][i] = json_data$optionChain$result[[1]]$options[[1]]$calls[[i]]$strike$raw
        Cl.price = json_data$optionChain$result[[1]]$quote$regularMarketPrice
        x <- which.min(abs((calls[,2]/Cl.price) -1))
        calls = calls[x,]
        calls[1]  = Cl.price
        calls[3]  = json_data$optionChain$result[[1]]$options[[1]]$calls[[x]]$lastPrice$raw
        calls[4]  = json_data$optionChain$result[[1]]$options[[1]]$calls[[x]]$volume$raw
        calls[5]  = json_data$optionChain$result[[1]]$options[[1]]$calls[[x]]$openInterest$raw
        calls[6]  = json_data$optionChain$result[[1]]$options[[1]]$calls[[x]]$impliedVolatility$raw
    # PUTS
        n = length(json_data$optionChain$result[[1]]$options[[1]]$puts)
        if(n < 1) next
        puts = matrix(ncol = 5, nrow = n)
        for(i in 1:n) puts[,1][i]    =  json_data$optionChain$result[[1]]$options[[1]]$puts[[i]]$strike$raw
        x <- which.min(abs((puts[,1]/Cl.price) - 0.95))
        puts = puts[x,]
        puts[2]     =  json_data$optionChain$result[[1]]$options[[1]]$puts[[x]]$lastPrice$raw
        puts[3]     =  json_data$optionChain$result[[1]]$options[[1]]$puts[[x]]$volume$raw
        puts[4]     =  json_data$optionChain$result[[1]]$options[[1]]$puts[[x]]$openInterest$raw
        puts[5]     =  json_data$optionChain$result[[1]]$options[[1]]$puts[[x]]$impliedVolatility$raw
        options[u,] = c(calls, puts)
  }
  return(options)
}

# Define stocks and gather options data
date = '2017-04-21'
symbols <- c('DIS','CAT','TSLA')

daily.options = as.data.frame(get.options(symbols, date))
which(is.na(daily.options))
skew.raw = daily.options$put_ImpVoli - daily.options$call_ImpVoli # SKEW(i,t)

options[i,] <- skew.raw

write.table(options, 'DISCATTSLA', sep = ",")
options = read.table('DISCATTSLA', sep = ",")

# Simulate 7 trading days, sort stocks based on average skew measure over that 7 days (least to greatest)
sim <- sort(skew.raw)
mean(sim)
sds <- apply(pick, 2, sd)

weekly.skew <- matrix(nrow = 5, ncol = ncol(pick))
for(i in 1:ncol(pick)) weekly.skew[,i] <- rnorm(5, mean = means[i], sd = sds[i])
colnames(weekly.skew) <- names(pick)

# weekly.skew is 5 trading days of SKEW measure. Now average weekly skew and sort in increasing order
avg.skew <- apply(weekly.skew, 2, mean)
quantiles <- quantile(avg.skew, c(0.01,0.05,0.25,0.50,0.75,0.95,0.99))

hist(avg.skew, prob = TRUE, col = 3)
lines(density(avg.skew, bw = 'SJ'), col = 2, lwd = 2)

# Quantiles. Short assets in bottom quantile, long assets in top quantile
Q1 <- which(avg.skew < quantiles[1])
assets.1 <- avg.skew[Q1]

Q5 <- which( avg.skew > quantiles[2] & avg.skew > quantiles[3])
assets.5 <- avg.skew[Q5]

Q25 <- which( avg.skew > quantiles[3] & avg.skew < quantiles[4])
assets.25 <- avg.skew[Q25]

Q50 <- which( avg.skew > quantiles[4] & avg.skew < quantiles[5])
assets.50 <- avg.skew[Q50]

Q75 <- which(avg.skew > quantiles[5] & avg.skew < quantiles[6])
assets.75 <- avg.skew[Q75]

Q95 <- which(avg.skew > quantiles[6] & avg.skew < quantiles[7])
assets.95 <- avg.skew[Q95]

Q99 <- which(avg.skew > quantiles[7])
assets.99 <- avg.skew[Q99]



