# R-implemented algorithm for trading with Volatility Smirks
This algorithm attempts to practically implement the ideas published in Yuhang Xing, Xiaoyan Zhang, and Rui Zhoa's adademic paper titled "What Does Individual Option Volatility Smirk Tell Us About Future Equity Returns?". Full citations and where to find this paper can be found at the end of this document.  

# Concept of Volatility Smirks
Given that the individual assets under observation have open option contracts, we calculate an implied volatility skew measure for asset i and time t defined as SKEW(i,t) = VOL(i,t)<sup>OTMP</sup> - VOL(i,t)<sup>(ATMC)</sup> where the out of the money put (OTMP) contract is further constrainted to the contract with a moneyness closest 0.95, and similarily the at the money call (ATMC) contract is chosen with it's moneyness closest to 1. Daily SKEW measures are then averaged to obtain the assets weekly SKEW(i,t) measure.

Though you must assume a large degree of generalization, empirical evidence suggests that assets with a steep volatility smirk are associated with poor future performance of the asset and visa-versa. Initutively this makes sense, as high demand for long put options signals that investors have a negative view regarding the asset, which in turn causes upward pressure on the option's implied volatility and contract price (also leading to steeper smirks). 

# Useage 
```{Code Chunk}
 x = 12 
 y = 13
```
words 
# Required pacakages / software 





# Resources & Citations 

Retrieves user-specified option pricing data from Yahoo Finance
