function [ gi, c ] = g( u1, u2 )
% Rusanov St Venant

gr = 9.81;

h1 = u1(1);
h2 = u2(1);

v1 = u1(2)/u1(1);
v2 = u2(2)/u2(1);

l1 = abs( v1 - sqrt(gr*h1));
l2 = abs( v1 + sqrt(gr*h1));
l3 = abs( v2 - sqrt(gr*h2));
l4 = abs( v2 + sqrt(gr*h2));
        
fu1 = f(u1);
fu2 = f(u2);
% Compute the c for the current interface
c = max([l1 l2 l3 l4]);
gi = 0.5*(fu1 + fu2) - c*(u2 - u1)/2;


end

