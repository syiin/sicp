; (car ''abracadabra) returns quote because this ' is a procedure `quote`. As a result, this really means
; (car (quote (quote (abracadabra)))). The procedure `quote` will convert an expression wrapped in parantheses
; into a list (ie. (quote (a b c)) ;Value: (a b c) ). Ergo, (quote (quote a b c)) ;Value: (quote (a b c))
; The car of the list (quote (abracadabra))) is therefore, quote