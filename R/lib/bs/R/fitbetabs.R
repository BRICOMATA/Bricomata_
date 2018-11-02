`fitbetabs` <-
function(alpha=1.0,col=2)
{
constant<-(3*((93*(alpha^2))+40)*((5*(alpha^2))+4))/(8*(((11*(alpha^2))+6)^2))
abline(3,constant,col=col,lwd=2.0)
}

