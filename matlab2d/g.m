function [ gi, c ] = g( uk, ul, nkl )
% Rusanov St Venant

gr = 9.81;

h1 = uk(1);
h2 = ul(1);
        
[fu1x, fu1y] = f(uk);
[fu2x, fu2y] = f(ul);

if(nkl == 1)
    fu1 = fu1x;
    fu2 = fu2x;
else
    fu1 = fu1y;
    fu2 = fu2y;
end


% Compute the c for the current interface
v1 = uk(2)/uk(1);
v2 = ul(2)/ul(1);

l1 = abs( v1 - sqrt(gr*h1));
l2 = abs( v1 + sqrt(gr*h1));
l3 = abs( v2 - sqrt(gr*h2));
l4 = abs( v2 + sqrt(gr*h2));
c = max([l1 l2 l3 l4]);
gi = 0.5*(fu1 + fu2) - c*(ul - uk)/2;


end

