`fitdeltabs` <-
function(alpha=1.0,col=2)
{
constant<-((4*((11*(alpha^2))+6)*((alpha^2)+2))/(((5*(alpha^2))+4)^2))
abline(0,constant,col=col,lwd=2.0)
}

