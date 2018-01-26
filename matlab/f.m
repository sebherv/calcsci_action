function [ fu ] = f(u)

gr = 9.81;

h = u(1);
hv = u(2);

fu = [hv ; hv*hv/h + gr*h*h/2];

end

