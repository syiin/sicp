; For small numbers, this makes no difference. However, for larger numbers (eg. 1,000,000), you risk
; buffer overflows because you take any number below that number and raise to that number (ie. 9000^1000000).
; The remainder calls in between do the equivalent while keeping the algorithm numerically stable